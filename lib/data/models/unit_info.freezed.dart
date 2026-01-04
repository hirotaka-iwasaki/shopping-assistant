// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UnitInfo _$UnitInfoFromJson(Map<String, dynamic> json) {
  return _UnitInfo.fromJson(json);
}

/// @nodoc
mixin _$UnitInfo {
  /// Numeric quantity (e.g., 500 for "500g")
  double get quantity => throw _privateConstructorUsedError;

  /// Original unit string (e.g., "g", "ml", "個")
  String get unit => throw _privateConstructorUsedError;

  /// Pack count for compound quantities (e.g., 3 for "500g×3袋")
  int get packCount => throw _privateConstructorUsedError;

  /// Total quantity after multiplication (quantity × packCount)
  double get totalQuantity => throw _privateConstructorUsedError;

  /// Normalized unit for comparison ("g", "ml", or "個")
  String get normalizedUnit => throw _privateConstructorUsedError;

  /// How the unit info was extracted
  ExtractMethod get method => throw _privateConstructorUsedError;

  /// Confidence score (0.0 - 1.0)
  double get confidence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnitInfoCopyWith<UnitInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitInfoCopyWith<$Res> {
  factory $UnitInfoCopyWith(UnitInfo value, $Res Function(UnitInfo) then) =
      _$UnitInfoCopyWithImpl<$Res, UnitInfo>;
  @useResult
  $Res call(
      {double quantity,
      String unit,
      int packCount,
      double totalQuantity,
      String normalizedUnit,
      ExtractMethod method,
      double confidence});
}

/// @nodoc
class _$UnitInfoCopyWithImpl<$Res, $Val extends UnitInfo>
    implements $UnitInfoCopyWith<$Res> {
  _$UnitInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unit = null,
    Object? packCount = null,
    Object? totalQuantity = null,
    Object? normalizedUnit = null,
    Object? method = null,
    Object? confidence = null,
  }) {
    return _then(_value.copyWith(
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      packCount: null == packCount
          ? _value.packCount
          : packCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      normalizedUnit: null == normalizedUnit
          ? _value.normalizedUnit
          : normalizedUnit // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as ExtractMethod,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnitInfoImplCopyWith<$Res>
    implements $UnitInfoCopyWith<$Res> {
  factory _$$UnitInfoImplCopyWith(
          _$UnitInfoImpl value, $Res Function(_$UnitInfoImpl) then) =
      __$$UnitInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double quantity,
      String unit,
      int packCount,
      double totalQuantity,
      String normalizedUnit,
      ExtractMethod method,
      double confidence});
}

/// @nodoc
class __$$UnitInfoImplCopyWithImpl<$Res>
    extends _$UnitInfoCopyWithImpl<$Res, _$UnitInfoImpl>
    implements _$$UnitInfoImplCopyWith<$Res> {
  __$$UnitInfoImplCopyWithImpl(
      _$UnitInfoImpl _value, $Res Function(_$UnitInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unit = null,
    Object? packCount = null,
    Object? totalQuantity = null,
    Object? normalizedUnit = null,
    Object? method = null,
    Object? confidence = null,
  }) {
    return _then(_$UnitInfoImpl(
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      packCount: null == packCount
          ? _value.packCount
          : packCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      normalizedUnit: null == normalizedUnit
          ? _value.normalizedUnit
          : normalizedUnit // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as ExtractMethod,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitInfoImpl extends _UnitInfo {
  const _$UnitInfoImpl(
      {required this.quantity,
      required this.unit,
      this.packCount = 1,
      required this.totalQuantity,
      required this.normalizedUnit,
      required this.method,
      required this.confidence})
      : super._();

  factory _$UnitInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitInfoImplFromJson(json);

  /// Numeric quantity (e.g., 500 for "500g")
  @override
  final double quantity;

  /// Original unit string (e.g., "g", "ml", "個")
  @override
  final String unit;

  /// Pack count for compound quantities (e.g., 3 for "500g×3袋")
  @override
  @JsonKey()
  final int packCount;

  /// Total quantity after multiplication (quantity × packCount)
  @override
  final double totalQuantity;

  /// Normalized unit for comparison ("g", "ml", or "個")
  @override
  final String normalizedUnit;

  /// How the unit info was extracted
  @override
  final ExtractMethod method;

  /// Confidence score (0.0 - 1.0)
  @override
  final double confidence;

  @override
  String toString() {
    return 'UnitInfo(quantity: $quantity, unit: $unit, packCount: $packCount, totalQuantity: $totalQuantity, normalizedUnit: $normalizedUnit, method: $method, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitInfoImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.packCount, packCount) ||
                other.packCount == packCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.normalizedUnit, normalizedUnit) ||
                other.normalizedUnit == normalizedUnit) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, unit, packCount,
      totalQuantity, normalizedUnit, method, confidence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitInfoImplCopyWith<_$UnitInfoImpl> get copyWith =>
      __$$UnitInfoImplCopyWithImpl<_$UnitInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitInfoImplToJson(
      this,
    );
  }
}

abstract class _UnitInfo extends UnitInfo {
  const factory _UnitInfo(
      {required final double quantity,
      required final String unit,
      final int packCount,
      required final double totalQuantity,
      required final String normalizedUnit,
      required final ExtractMethod method,
      required final double confidence}) = _$UnitInfoImpl;
  const _UnitInfo._() : super._();

  factory _UnitInfo.fromJson(Map<String, dynamic> json) =
      _$UnitInfoImpl.fromJson;

  @override

  /// Numeric quantity (e.g., 500 for "500g")
  double get quantity;
  @override

  /// Original unit string (e.g., "g", "ml", "個")
  String get unit;
  @override

  /// Pack count for compound quantities (e.g., 3 for "500g×3袋")
  int get packCount;
  @override

  /// Total quantity after multiplication (quantity × packCount)
  double get totalQuantity;
  @override

  /// Normalized unit for comparison ("g", "ml", or "個")
  String get normalizedUnit;
  @override

  /// How the unit info was extracted
  ExtractMethod get method;
  @override

  /// Confidence score (0.0 - 1.0)
  double get confidence;
  @override
  @JsonKey(ignore: true)
  _$$UnitInfoImplCopyWith<_$UnitInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
