// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoriteItem _$FavoriteItemFromJson(Map<String, dynamic> json) {
  return _FavoriteItem.fromJson(json);
}

/// @nodoc
mixin _$FavoriteItem {
  /// Product ID (ASIN for Amazon, itemCode for Rakuten, code for Yahoo)
  String get productId => throw _privateConstructorUsedError;

  /// Source e-commerce platform
  EcSource get source => throw _privateConstructorUsedError;

  /// When the item was added to favorites
  DateTime get addedAt => throw _privateConstructorUsedError;

  /// Cached product data (stored at the time of adding)
  Product? get cachedProduct => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FavoriteItemCopyWith<FavoriteItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteItemCopyWith<$Res> {
  factory $FavoriteItemCopyWith(
          FavoriteItem value, $Res Function(FavoriteItem) then) =
      _$FavoriteItemCopyWithImpl<$Res, FavoriteItem>;
  @useResult
  $Res call(
      {String productId,
      EcSource source,
      DateTime addedAt,
      Product? cachedProduct});

  $ProductCopyWith<$Res>? get cachedProduct;
}

/// @nodoc
class _$FavoriteItemCopyWithImpl<$Res, $Val extends FavoriteItem>
    implements $FavoriteItemCopyWith<$Res> {
  _$FavoriteItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? source = null,
    Object? addedAt = null,
    Object? cachedProduct = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EcSource,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cachedProduct: freezed == cachedProduct
          ? _value.cachedProduct
          : cachedProduct // ignore: cast_nullable_to_non_nullable
              as Product?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res>? get cachedProduct {
    if (_value.cachedProduct == null) {
      return null;
    }

    return $ProductCopyWith<$Res>(_value.cachedProduct!, (value) {
      return _then(_value.copyWith(cachedProduct: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FavoriteItemImplCopyWith<$Res>
    implements $FavoriteItemCopyWith<$Res> {
  factory _$$FavoriteItemImplCopyWith(
          _$FavoriteItemImpl value, $Res Function(_$FavoriteItemImpl) then) =
      __$$FavoriteItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      EcSource source,
      DateTime addedAt,
      Product? cachedProduct});

  @override
  $ProductCopyWith<$Res>? get cachedProduct;
}

/// @nodoc
class __$$FavoriteItemImplCopyWithImpl<$Res>
    extends _$FavoriteItemCopyWithImpl<$Res, _$FavoriteItemImpl>
    implements _$$FavoriteItemImplCopyWith<$Res> {
  __$$FavoriteItemImplCopyWithImpl(
      _$FavoriteItemImpl _value, $Res Function(_$FavoriteItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? source = null,
    Object? addedAt = null,
    Object? cachedProduct = freezed,
  }) {
    return _then(_$FavoriteItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EcSource,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cachedProduct: freezed == cachedProduct
          ? _value.cachedProduct
          : cachedProduct // ignore: cast_nullable_to_non_nullable
              as Product?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteItemImpl implements _FavoriteItem {
  const _$FavoriteItemImpl(
      {required this.productId,
      required this.source,
      required this.addedAt,
      this.cachedProduct});

  factory _$FavoriteItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteItemImplFromJson(json);

  /// Product ID (ASIN for Amazon, itemCode for Rakuten, code for Yahoo)
  @override
  final String productId;

  /// Source e-commerce platform
  @override
  final EcSource source;

  /// When the item was added to favorites
  @override
  final DateTime addedAt;

  /// Cached product data (stored at the time of adding)
  @override
  final Product? cachedProduct;

  @override
  String toString() {
    return 'FavoriteItem(productId: $productId, source: $source, addedAt: $addedAt, cachedProduct: $cachedProduct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.cachedProduct, cachedProduct) ||
                other.cachedProduct == cachedProduct));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, source, addedAt, cachedProduct);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteItemImplCopyWith<_$FavoriteItemImpl> get copyWith =>
      __$$FavoriteItemImplCopyWithImpl<_$FavoriteItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteItemImplToJson(
      this,
    );
  }
}

abstract class _FavoriteItem implements FavoriteItem {
  const factory _FavoriteItem(
      {required final String productId,
      required final EcSource source,
      required final DateTime addedAt,
      final Product? cachedProduct}) = _$FavoriteItemImpl;

  factory _FavoriteItem.fromJson(Map<String, dynamic> json) =
      _$FavoriteItemImpl.fromJson;

  @override

  /// Product ID (ASIN for Amazon, itemCode for Rakuten, code for Yahoo)
  String get productId;
  @override

  /// Source e-commerce platform
  EcSource get source;
  @override

  /// When the item was added to favorites
  DateTime get addedAt;
  @override

  /// Cached product data (stored at the time of adding)
  Product? get cachedProduct;
  @override
  @JsonKey(ignore: true)
  _$$FavoriteItemImplCopyWith<_$FavoriteItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
