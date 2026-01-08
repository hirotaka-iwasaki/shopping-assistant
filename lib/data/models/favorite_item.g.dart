// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteItemImpl _$$FavoriteItemImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteItemImpl(
      productId: json['productId'] as String,
      source: $enumDecode(_$EcSourceEnumMap, json['source']),
      addedAt: DateTime.parse(json['addedAt'] as String),
      cachedProduct: json['cachedProduct'] == null
          ? null
          : Product.fromJson(json['cachedProduct'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FavoriteItemImplToJson(_$FavoriteItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'source': _$EcSourceEnumMap[instance.source]!,
      'addedAt': instance.addedAt.toIso8601String(),
      'cachedProduct': instance.cachedProduct,
    };

const _$EcSourceEnumMap = {
  EcSource.amazon: 'amazon',
  EcSource.rakuten: 'rakuten',
  EcSource.yahoo: 'yahoo',
  EcSource.qoo10: 'qoo10',
};
