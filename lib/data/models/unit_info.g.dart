// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitInfoImpl _$$UnitInfoImplFromJson(Map<String, dynamic> json) =>
    _$UnitInfoImpl(
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      packCount: (json['packCount'] as num?)?.toInt() ?? 1,
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      normalizedUnit: json['normalizedUnit'] as String,
      method: $enumDecode(_$ExtractMethodEnumMap, json['method']),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$$UnitInfoImplToJson(_$UnitInfoImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'unit': instance.unit,
      'packCount': instance.packCount,
      'totalQuantity': instance.totalQuantity,
      'normalizedUnit': instance.normalizedUnit,
      'method': _$ExtractMethodEnumMap[instance.method]!,
      'confidence': instance.confidence,
    };

const _$ExtractMethodEnumMap = {
  ExtractMethod.regex: 'regex',
  ExtractMethod.llm: 'llm',
  ExtractMethod.userInput: 'userInput',
  ExtractMethod.cached: 'cached',
  ExtractMethod.unknown: 'unknown',
};
