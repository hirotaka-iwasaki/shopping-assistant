import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../core/core.dart';
import '../models/product.dart';
import '../models/search_query.dart';
import 'base_client.dart';

/// Amazon Product Advertising API v5 client.
class AmazonClient implements EcClient {
  AmazonClient({
    String? accessKey,
    String? secretKey,
    String? associateTag,
    String? region,
  })  : _accessKey = accessKey ?? EnvConfig.amazonAccessKey,
        _secretKey = secretKey ?? EnvConfig.amazonSecretKey,
        _associateTag = associateTag ?? EnvConfig.amazonAssociateTag,
        _region = region ?? EnvConfig.amazonRegion {
    _dio = DioClient.create(baseUrl: _getHost());
  }

  final String _accessKey;
  final String _secretKey;
  final String _associateTag;
  final String _region;
  late final Dio _dio;

  static const String _service = 'ProductAdvertisingAPI';
  static const String _marketplace = 'www.amazon.co.jp';

  String _getHost() {
    return 'https://webservices.amazon.co.jp';
  }

  @override
  Future<SearchResult> search(SearchQuery query) async {
    if (!EnvConfig.hasAmazonConfig) {
      return SearchResult.empty(
        EcSource.amazon,
        errorMessage: 'Amazon API is not configured',
      );
    }

    try {
      final payload = _buildSearchPayload(query);
      final response = await _signedRequest('/paapi5/searchitems', payload);

      return _parseSearchResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final error = DioClient.handleError(e, EcSource.amazon.displayName);
      AppLogger.error(
        'Amazon search failed',
        tag: 'AmazonClient',
        error: error,
      );
      return SearchResult.empty(EcSource.amazon, errorMessage: error.message);
    } catch (e) {
      AppLogger.error('Amazon search failed', tag: 'AmazonClient', error: e);
      return SearchResult.empty(
        EcSource.amazon,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<Product?> getProduct(String id) async {
    if (!EnvConfig.hasAmazonConfig) return null;

    try {
      final payload = _buildGetItemPayload(id);
      final response = await _signedRequest('/paapi5/getitems', payload);

      final data = response.data as Map<String, dynamic>;
      final items = data['ItemsResult']?['Items'] as List?;

      if (items == null || items.isEmpty) return null;
      return _parseItem(items.first as Map<String, dynamic>);
    } on DioException catch (e) {
      final error = DioClient.handleError(e, EcSource.amazon.displayName);
      AppLogger.error(
        'Amazon getProduct failed',
        tag: 'AmazonClient',
        error: error,
      );
      return null;
    } catch (e) {
      AppLogger.error(
        'Amazon getProduct failed',
        tag: 'AmazonClient',
        error: e,
      );
      return null;
    }
  }

  Map<String, dynamic> _buildSearchPayload(SearchQuery query) {
    return {
      'Keywords': query.keyword,
      'PartnerTag': _associateTag,
      'PartnerType': 'Associates',
      'Marketplace': _marketplace,
      'Resources': [
        'Images.Primary.Large',
        'ItemInfo.Title',
        'ItemInfo.Features',
        'Offers.Listings.Price',
        'Offers.Listings.DeliveryInfo.IsPrimeEligible',
        'Offers.Listings.MerchantInfo',
        'CustomerReviews.StarRating',
        'CustomerReviews.Count',
      ],
      'ItemCount': query.pageSize.clamp(1, 10),
      'ItemPage': query.page.clamp(1, 10),
      if (query.minPrice != null) 'MinPrice': query.minPrice,
      if (query.maxPrice != null) 'MaxPrice': query.maxPrice,
    };
  }

  Map<String, dynamic> _buildGetItemPayload(String asin) {
    return {
      'ItemIds': [asin],
      'PartnerTag': _associateTag,
      'PartnerType': 'Associates',
      'Marketplace': _marketplace,
      'Resources': [
        'Images.Primary.Large',
        'ItemInfo.Title',
        'ItemInfo.Features',
        'Offers.Listings.Price',
        'Offers.Listings.DeliveryInfo.IsPrimeEligible',
        'Offers.Listings.MerchantInfo',
        'CustomerReviews.StarRating',
        'CustomerReviews.Count',
      ],
    };
  }

  Future<Response> _signedRequest(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final now = DateTime.now().toUtc();
    final amzDate = _formatAmzDate(now);
    final dateStamp = _formatDateStamp(now);
    final payloadJson = jsonEncode(payload);
    final payloadHash = _sha256Hash(payloadJson);

    final headers = {
      'content-encoding': 'amz-1.0',
      'content-type': 'application/json; charset=utf-8',
      'host': 'webservices.amazon.co.jp',
      'x-amz-date': amzDate,
      'x-amz-target': 'com.amazon.paapi5.v1.ProductAdvertisingAPIv1.SearchItems',
    };

    if (path.contains('getitems')) {
      headers['x-amz-target'] =
          'com.amazon.paapi5.v1.ProductAdvertisingAPIv1.GetItems';
    }

    final authorization = _buildAuthorizationHeader(
      method: 'POST',
      path: path,
      headers: headers,
      payloadHash: payloadHash,
      amzDate: amzDate,
      dateStamp: dateStamp,
    );

    return _dio.post(
      path,
      data: payloadJson,
      options: Options(
        headers: {
          ...headers,
          'Authorization': authorization,
        },
      ),
    );
  }

  String _buildAuthorizationHeader({
    required String method,
    required String path,
    required Map<String, String> headers,
    required String payloadHash,
    required String amzDate,
    required String dateStamp,
  }) {
    final sortedHeaders = Map.fromEntries(
      headers.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    final canonicalHeaders = sortedHeaders.entries
        .map((e) => '${e.key.toLowerCase()}:${e.value.trim()}')
        .join('\n');
    final signedHeaders =
        sortedHeaders.keys.map((k) => k.toLowerCase()).join(';');

    final canonicalRequest = [
      method,
      path,
      '', // query string
      '$canonicalHeaders\n',
      signedHeaders,
      payloadHash,
    ].join('\n');

    final credentialScope = '$dateStamp/$_region/$_service/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      _sha256Hash(canonicalRequest),
    ].join('\n');

    final signingKey = _getSignatureKey(dateStamp);
    final signature = _hmacSha256Hex(signingKey, stringToSign);

    return 'AWS4-HMAC-SHA256 '
        'Credential=$_accessKey/$credentialScope, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';
  }

  List<int> _getSignatureKey(String dateStamp) {
    final kDate = _hmacSha256('AWS4$_secretKey'.codeUnits, dateStamp);
    final kRegion = _hmacSha256(kDate, _region);
    final kService = _hmacSha256(kRegion, _service);
    return _hmacSha256(kService, 'aws4_request');
  }

  List<int> _hmacSha256(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).bytes;
  }

  String _hmacSha256Hex(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).toString();
  }

  String _sha256Hash(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  String _formatAmzDate(DateTime date) {
    return '${date.year}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}'
        'T${date.hour.toString().padLeft(2, '0')}'
        '${date.minute.toString().padLeft(2, '0')}'
        '${date.second.toString().padLeft(2, '0')}Z';
  }

  String _formatDateStamp(DateTime date) {
    return '${date.year}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  SearchResult _parseSearchResponse(Map<String, dynamic> data) {
    final searchResult = data['SearchResult'] as Map<String, dynamic>?;

    if (searchResult == null) {
      return SearchResult.empty(
        EcSource.amazon,
        errorMessage: 'No search results',
      );
    }

    final items = searchResult['Items'] as List? ?? [];
    final totalCount = searchResult['TotalResultCount'] as int? ?? 0;

    final products = items
        .map((item) => _parseItem(item as Map<String, dynamic>))
        .whereType<Product>()
        .toList();

    return SearchResult(
      products: products,
      totalCount: totalCount,
      page: 1,
      hasMore: products.length < totalCount,
      source: EcSource.amazon,
    );
  }

  Product? _parseItem(Map<String, dynamic> item) {
    try {
      final asin = item['ASIN'] as String?;
      final itemInfo = item['ItemInfo'] as Map<String, dynamic>?;
      final title = itemInfo?['Title']?['DisplayValue'] as String?;
      final detailPageUrl = item['DetailPageURL'] as String?;

      if (asin == null || title == null || detailPageUrl == null) {
        return null;
      }

      // Image
      final images = item['Images'] as Map<String, dynamic>?;
      final primaryImage = images?['Primary']?['Large'] as Map<String, dynamic>?;
      final imageUrl = primaryImage?['URL'] as String? ?? '';

      // Price
      final offers = item['Offers'] as Map<String, dynamic>?;
      final listings = offers?['Listings'] as List?;
      final listing =
          listings?.isNotEmpty == true ? listings!.first as Map<String, dynamic> : null;
      final priceInfo = listing?['Price'] as Map<String, dynamic>?;
      final price = (priceInfo?['Amount'] as num?)?.toInt() ?? 0;

      // Prime (free shipping)
      final deliveryInfo = listing?['DeliveryInfo'] as Map<String, dynamic>?;
      final isPrime = deliveryInfo?['IsPrimeEligible'] as bool? ?? false;

      // Store
      final merchantInfo = listing?['MerchantInfo'] as Map<String, dynamic>?;
      final storeName = merchantInfo?['Name'] as String?;

      // Reviews
      final customerReviews = item['CustomerReviews'] as Map<String, dynamic>?;
      final starRating = customerReviews?['StarRating']?['Value'] as num?;
      final reviewCount = customerReviews?['Count'] as int?;

      return Product(
        id: asin,
        title: title,
        price: price,
        imageUrl: imageUrl,
        productUrl: detailPageUrl,
        source: EcSource.amazon,
        isFreeShipping: isPrime,
        storeName: storeName,
        reviewScore: starRating?.toDouble(),
        reviewCount: reviewCount,
      );
    } catch (e) {
      AppLogger.warning('Failed to parse Amazon item', error: e);
      return null;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }
}
