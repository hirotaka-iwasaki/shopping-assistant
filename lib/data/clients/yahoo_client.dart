import 'package:dio/dio.dart';

import '../../core/core.dart';
import '../models/product.dart';
import '../models/search_query.dart';
import 'base_client.dart';

/// Yahoo Shopping API client.
class YahooClient implements EcClient {
  YahooClient({
    String? appId,
    String? affiliateId,
  })  : _appId = appId ?? EnvConfig.yahooAppId,
        _affiliateId = affiliateId ?? EnvConfig.yahooAffiliateId {
    _dio = DioClient.create(baseUrl: ApiConfig.yahooBaseUrl);
  }

  final String _appId;
  final String _affiliateId;
  late final Dio _dio;

  @override
  Future<SearchResult> search(SearchQuery query) async {
    if (!EnvConfig.hasYahooConfig) {
      return SearchResult.empty(
        EcSource.yahoo,
        errorMessage: 'Yahoo API is not configured',
      );
    }

    try {
      final response = await _dio.get(
        '',
        queryParameters: _buildSearchParams(query),
      );

      return _parseSearchResponse(
        response.data as Map<String, dynamic>,
        query.page,
      );
    } on DioException catch (e) {
      final error = DioClient.handleError(e, EcSource.yahoo.displayName);
      AppLogger.error(
        'Yahoo search failed',
        tag: 'YahooClient',
        error: error,
      );
      return SearchResult.empty(EcSource.yahoo, errorMessage: error.message);
    } catch (e) {
      AppLogger.error('Yahoo search failed', tag: 'YahooClient', error: e);
      return SearchResult.empty(
        EcSource.yahoo,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Product?> getProduct(String id) async {
    if (!EnvConfig.hasYahooConfig) return null;

    try {
      // Yahoo商品コードで検索
      // queryパラメータで商品コードを検索（item_codeは seller_item形式が必要なため）
      final response = await _dio.get(
        '',
        queryParameters: {
          'appid': _appId,
          if (_affiliateId.isNotEmpty) 'affiliate_id': _affiliateId,
          if (_affiliateId.isNotEmpty) 'affiliate_type': 'vc',
          'query': id,
          'results': 10,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final hits = data['hits'] as List?;

      AppLogger.debug(
        'Yahoo getProduct for id=$id, hits=${hits?.length ?? 0}',
        tag: 'YahooClient',
      );

      if (hits == null || hits.isEmpty) return null;

      // 商品コードが一致するものを探す
      for (final hit in hits) {
        final item = hit as Map<String, dynamic>;
        final code = item['code'] as String?;
        if (code == id) {
          return _parseItem(item);
        }
      }

      // 完全一致がなければ最初の結果を返す（フォールバック）
      AppLogger.warning(
        'Yahoo getProduct: exact match not found for id=$id, using first result',
        tag: 'YahooClient',
      );
      return _parseItem(hits.first as Map<String, dynamic>);
    } on DioException catch (e) {
      final error = DioClient.handleError(e, EcSource.yahoo.displayName);
      AppLogger.error(
        'Yahoo getProduct failed for id=$id',
        tag: 'YahooClient',
        error: error,
      );
      return null;
    } catch (e) {
      AppLogger.error('Yahoo getProduct failed for id=$id', tag: 'YahooClient', error: e);
      return null;
    }
  }

  Map<String, dynamic> _buildSearchParams(SearchQuery query) {
    final params = <String, dynamic>{
      'appid': _appId,
      'query': query.keyword,
      'results': query.pageSize.clamp(1, 50),
      'start': ((query.page - 1) * query.pageSize) + 1,
    };

    if (_affiliateId.isNotEmpty) {
      params['affiliate_id'] = _affiliateId;
      params['affiliate_type'] = 'vc';
    }

    if (query.minPrice != null) {
      params['price_from'] = query.minPrice;
    }

    if (query.maxPrice != null) {
      params['price_to'] = query.maxPrice;
    }

    if (query.freeShippingOnly) {
      params['shipping'] = 'free';
    }

    // Sort mapping
    switch (query.sortBy) {
      case SortOption.priceAsc:
        params['sort'] = '+price';
        break;
      case SortOption.priceDesc:
        params['sort'] = '-price';
        break;
      case SortOption.reviewDesc:
        params['sort'] = '-review_average';
        break;
      case SortOption.reviewCountDesc:
        params['sort'] = '-review_count';
        break;
      case SortOption.relevance:
      case SortOption.unitPriceAsc:
        // Unit price sort is done client-side after fetching
        params['sort'] = '-score';
        break;
    }

    return params;
  }

  SearchResult _parseSearchResponse(Map<String, dynamic> data, int page) {
    final hits = data['hits'] as List? ?? [];
    final totalCount = data['totalResultsAvailable'] as int? ?? 0;
    final resultsReturned = data['totalResultsReturned'] as int? ?? 0;
    final firstResult = data['firstResultsPosition'] as int? ?? 1;

    final products = hits
        .map((item) => _parseItem(item as Map<String, dynamic>))
        .whereType<Product>()
        .toList();

    final hasMore = (firstResult + resultsReturned - 1) < totalCount;

    return SearchResult(
      products: products,
      totalCount: totalCount,
      page: page,
      hasMore: hasMore,
      source: EcSource.yahoo,
    );
  }

  Product? _parseItem(Map<String, dynamic> item) {
    try {
      final code = item['code'] as String?;
      final name = item['name'] as String?;
      final price = item['price'] as int?;
      final url = item['url'] as String?;

      if (code == null || name == null || price == null || url == null) {
        return null;
      }

      // Image
      final image = item['image'] as Map<String, dynamic>?;
      final imageUrl = image?['medium'] as String? ?? image?['small'] as String? ?? '';

      // Shipping
      final shipping = item['shipping'] as Map<String, dynamic>?;
      final shippingCode = shipping?['code'] as int? ?? 0;
      // Code: 1 = 設定なし, 2 = 有料, 3 = 無料, 4 = 条件付き無料
      final isFreeShipping = shippingCode == 3;
      int? shippingCost;
      if (shippingCode == 2) {
        // 送料有料の場合、具体的な金額がないので不明
        shippingCost = null;
      }

      // Points
      final point = item['point'] as Map<String, dynamic>?;
      final premiumPoint = point?['premiumPoint'] as int? ?? 0;
      final bonusPoint = point?['bonusPoint'] as int? ?? 0;
      final pointValue = premiumPoint + bonusPoint;
      final pointRate = price > 0 ? pointValue / price : 0.0;

      // Reviews
      final review = item['review'] as Map<String, dynamic>?;
      final reviewRate = review?['rate'] as num?;
      final reviewCount = review?['count'] as int?;

      // Store
      final seller = item['seller'] as Map<String, dynamic>?;
      final storeName = seller?['name'] as String?;

      // Description
      final description = item['description'] as String?;

      // Original price
      final priceLabel = item['priceLabel'] as Map<String, dynamic>?;
      final originalPrice = priceLabel?['defaultPrice'] as int?;

      // Stock
      final inStock = item['inStock'] as bool? ?? true;

      return Product(
        id: code,
        title: name,
        price: price,
        imageUrl: imageUrl,
        productUrl: url,
        source: EcSource.yahoo,
        shippingCost: shippingCost,
        isFreeShipping: isFreeShipping,
        pointRate: pointRate,
        pointValue: pointValue,
        reviewScore: reviewRate?.toDouble(),
        reviewCount: reviewCount,
        storeName: storeName,
        description: description,
        originalPrice: originalPrice,
        inStock: inStock,
      );
    } catch (e) {
      AppLogger.warning('Failed to parse Yahoo item', error: e);
      return null;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }
}
