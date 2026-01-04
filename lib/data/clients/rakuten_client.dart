import 'package:dio/dio.dart';

import '../../core/core.dart';
import '../models/product.dart';
import '../models/search_query.dart';
import 'base_client.dart';

/// Rakuten Ichiba API client.
class RakutenClient implements EcClient {
  RakutenClient({
    String? appId,
    String? affiliateId,
  })  : _appId = appId ?? EnvConfig.rakutenAppId,
        _affiliateId = affiliateId ?? EnvConfig.rakutenAffiliateId {
    _dio = DioClient.create(baseUrl: ApiConfig.rakutenBaseUrl);
  }

  final String _appId;
  final String _affiliateId;
  late final Dio _dio;

  @override
  Future<SearchResult> search(SearchQuery query) async {
    if (!EnvConfig.hasRakutenConfig) {
      return SearchResult.empty(
        EcSource.rakuten,
        errorMessage: 'Rakuten API is not configured',
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
      final error = DioClient.handleError(e, EcSource.rakuten.displayName);
      AppLogger.error(
        'Rakuten search failed',
        tag: 'RakutenClient',
        error: error,
      );
      return SearchResult.empty(EcSource.rakuten, errorMessage: error.message);
    } catch (e) {
      AppLogger.error('Rakuten search failed', tag: 'RakutenClient', error: e);
      return SearchResult.empty(
        EcSource.rakuten,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Product?> getProduct(String id) async {
    if (!EnvConfig.hasRakutenConfig) return null;

    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'applicationId': _appId,
          if (_affiliateId.isNotEmpty) 'affiliateId': _affiliateId,
          'itemCode': id,
          'hits': 1,
          'formatVersion': 2,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final items = data['Items'] as List?;

      if (items == null || items.isEmpty) return null;

      // formatVersion: 2 returns items directly
      final item = items.first as Map<String, dynamic>;
      return _parseItem(item);
    } on DioException catch (e) {
      final error = DioClient.handleError(e, EcSource.rakuten.displayName);
      AppLogger.error(
        'Rakuten getProduct failed',
        tag: 'RakutenClient',
        error: error,
      );
      return null;
    } catch (e) {
      AppLogger.error(
        'Rakuten getProduct failed',
        tag: 'RakutenClient',
        error: e,
      );
      return null;
    }
  }

  Map<String, dynamic> _buildSearchParams(SearchQuery query) {
    final params = <String, dynamic>{
      'applicationId': _appId,
      'keyword': query.keyword,
      'hits': query.pageSize.clamp(1, 30),
      'page': query.page.clamp(1, 100),
      'formatVersion': 2,
    };

    if (_affiliateId.isNotEmpty) {
      params['affiliateId'] = _affiliateId;
    }

    if (query.minPrice != null) {
      params['minPrice'] = query.minPrice;
    }

    if (query.maxPrice != null) {
      params['maxPrice'] = query.maxPrice;
    }

    if (query.freeShippingOnly) {
      params['postageFlag'] = 1;
    }

    // Sort mapping
    switch (query.sortBy) {
      case SortOption.priceAsc:
        params['sort'] = '+itemPrice';
        break;
      case SortOption.priceDesc:
        params['sort'] = '-itemPrice';
        break;
      case SortOption.reviewDesc:
        params['sort'] = '-reviewAverage';
        break;
      case SortOption.relevance:
      case SortOption.unitPriceAsc:
        // Unit price sort is done client-side after fetching
        params['sort'] = 'standard';
        break;
    }

    return params;
  }

  SearchResult _parseSearchResponse(Map<String, dynamic> data, int page) {
    final items = data['Items'] as List? ?? [];
    final totalCount = data['count'] as int? ?? 0;
    final pageCount = data['pageCount'] as int? ?? 1;

    final products = <Product>[];
    for (final itemData in items) {
      // formatVersion: 2 returns items directly without 'Item' wrapper
      final item = itemData as Map<String, dynamic>;
      final product = _parseItem(item);
      if (product != null) {
        products.add(product);
      }
    }

    return SearchResult(
      products: products,
      totalCount: totalCount,
      page: page,
      hasMore: page < pageCount,
      source: EcSource.rakuten,
    );
  }

  Product? _parseItem(Map<String, dynamic> item) {
    try {
      final itemCode = item['itemCode'] as String?;
      final itemName = item['itemName'] as String?;
      final itemPrice = item['itemPrice'] as int?;
      final itemUrl = item['itemUrl'] as String?;
      final affiliateUrl = item['affiliateUrl'] as String?;

      if (itemCode == null ||
          itemName == null ||
          itemPrice == null ||
          itemUrl == null) {
        return null;
      }

      // Images
      final imageUrls = item['mediumImageUrls'] as List?;
      final smallImageUrls = item['smallImageUrls'] as List?;
      String imageUrl = '';
      if (imageUrls != null && imageUrls.isNotEmpty) {
        imageUrl = imageUrls.first as String;
      } else if (smallImageUrls != null && smallImageUrls.isNotEmpty) {
        imageUrl = smallImageUrls.first as String;
      }

      // Shipping
      final postageFlag = item['postageFlag'] as int? ?? 0;
      final isFreeShipping = postageFlag == 0;

      // Points
      final pointRate = item['pointRate'] as int? ?? 1;
      final pointRateDecimal = pointRate / 100.0;
      final pointValue = (itemPrice * pointRateDecimal).floor();

      // Reviews
      final reviewAverage = item['reviewAverage'] as num?;
      final reviewCount = item['reviewCount'] as int?;

      // Store
      final shopName = item['shopName'] as String?;

      // Description
      final itemCaption = item['itemCaption'] as String?;

      // Stock
      final availability = item['availability'] as int? ?? 1;
      final inStock = availability == 1;

      return Product(
        id: itemCode,
        title: itemName,
        price: itemPrice,
        imageUrl: imageUrl,
        productUrl: (affiliateUrl != null && affiliateUrl.isNotEmpty) ? affiliateUrl : itemUrl,
        source: EcSource.rakuten,
        isFreeShipping: isFreeShipping,
        pointRate: pointRateDecimal,
        pointValue: pointValue,
        reviewScore: reviewAverage?.toDouble(),
        reviewCount: reviewCount,
        storeName: shopName,
        description: itemCaption,
        inStock: inStock,
      );
    } catch (e) {
      AppLogger.warning('Failed to parse Rakuten item', error: e);
      return null;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }
}
