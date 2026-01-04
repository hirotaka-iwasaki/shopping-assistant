// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      productUrl: json['productUrl'] as String,
      source: $enumDecode(_$EcSourceEnumMap, json['source']),
      shippingCost: (json['shippingCost'] as num?)?.toInt(),
      isFreeShipping: json['isFreeShipping'] as bool? ?? false,
      pointRate: (json['pointRate'] as num?)?.toDouble(),
      pointValue: (json['pointValue'] as num?)?.toInt(),
      reviewScore: (json['reviewScore'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      storeName: json['storeName'] as String?,
      description: json['description'] as String?,
      originalPrice: (json['originalPrice'] as num?)?.toInt(),
      inStock: json['inStock'] as bool? ?? true,
      unitInfo: json['unitInfo'] == null
          ? null
          : UnitInfo.fromJson(json['unitInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'productUrl': instance.productUrl,
      'source': _$EcSourceEnumMap[instance.source]!,
      'shippingCost': instance.shippingCost,
      'isFreeShipping': instance.isFreeShipping,
      'pointRate': instance.pointRate,
      'pointValue': instance.pointValue,
      'reviewScore': instance.reviewScore,
      'reviewCount': instance.reviewCount,
      'storeName': instance.storeName,
      'description': instance.description,
      'originalPrice': instance.originalPrice,
      'inStock': instance.inStock,
      'unitInfo': instance.unitInfo,
    };

const _$EcSourceEnumMap = {
  EcSource.amazon: 'amazon',
  EcSource.rakuten: 'rakuten',
  EcSource.yahoo: 'yahoo',
  EcSource.qoo10: 'qoo10',
};

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
      source: $enumDecode(_$EcSourceEnumMap, json['source']),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'products': instance.products,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'hasMore': instance.hasMore,
      'source': _$EcSourceEnumMap[instance.source]!,
      'errorMessage': instance.errorMessage,
    };

_$AggregatedSearchResultImpl _$$AggregatedSearchResultImplFromJson(
        Map<String, dynamic> json) =>
    _$AggregatedSearchResultImpl(
      resultsBySource: (json['resultsBySource'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$EcSourceEnumMap, k),
            SearchResult.fromJson(e as Map<String, dynamic>)),
      ),
      allProducts: (json['allProducts'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$$AggregatedSearchResultImplToJson(
        _$AggregatedSearchResultImpl instance) =>
    <String, dynamic>{
      'resultsBySource': instance.resultsBySource
          .map((k, e) => MapEntry(_$EcSourceEnumMap[k]!, e)),
      'allProducts': instance.allProducts,
      'totalCount': instance.totalCount,
    };
