// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchQueryImpl _$$SearchQueryImplFromJson(Map<String, dynamic> json) =>
    _$SearchQueryImpl(
      keyword: json['keyword'] as String,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$EcSourceEnumMap, e))
              .toList() ??
          const [],
      minPrice: (json['minPrice'] as num?)?.toInt(),
      maxPrice: (json['maxPrice'] as num?)?.toInt(),
      freeShippingOnly: json['freeShippingOnly'] as bool? ?? false,
      sortBy: $enumDecodeNullable(_$SortOptionEnumMap, json['sortBy']) ??
          SortOption.relevance,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$SearchQueryImplToJson(_$SearchQueryImpl instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'sources': instance.sources.map((e) => _$EcSourceEnumMap[e]!).toList(),
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'freeShippingOnly': instance.freeShippingOnly,
      'sortBy': _$SortOptionEnumMap[instance.sortBy]!,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

const _$EcSourceEnumMap = {
  EcSource.amazon: 'amazon',
  EcSource.rakuten: 'rakuten',
  EcSource.yahoo: 'yahoo',
  EcSource.qoo10: 'qoo10',
};

const _$SortOptionEnumMap = {
  SortOption.unitPriceAsc: 'unitPriceAsc',
  SortOption.priceAsc: 'priceAsc',
  SortOption.priceDesc: 'priceDesc',
  SortOption.relevance: 'relevance',
  SortOption.reviewDesc: 'reviewDesc',
  SortOption.reviewCountDesc: 'reviewCountDesc',
};
