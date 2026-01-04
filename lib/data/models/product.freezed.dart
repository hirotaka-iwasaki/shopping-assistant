// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  /// Unique identifier (ASIN for Amazon, itemCode for Rakuten, etc.)
  String get id => throw _privateConstructorUsedError;

  /// Product title/name
  String get title => throw _privateConstructorUsedError;

  /// Base price in JPY
  int get price => throw _privateConstructorUsedError;

  /// Product image URL
  String get imageUrl => throw _privateConstructorUsedError;

  /// URL to the product page (with affiliate link)
  String get productUrl => throw _privateConstructorUsedError;

  /// Source e-commerce platform
  EcSource get source => throw _privateConstructorUsedError;

  /// Shipping cost in JPY (null if unknown)
  int? get shippingCost => throw _privateConstructorUsedError;

  /// Whether shipping is free
  bool get isFreeShipping => throw _privateConstructorUsedError;

  /// Point reward rate (e.g., 0.01 for 1%)
  double? get pointRate => throw _privateConstructorUsedError;

  /// Point reward value in JPY
  int? get pointValue => throw _privateConstructorUsedError;

  /// Review score (0.0 - 5.0)
  double? get reviewScore => throw _privateConstructorUsedError;

  /// Number of reviews
  int? get reviewCount => throw _privateConstructorUsedError;

  /// Store/seller name
  String? get storeName => throw _privateConstructorUsedError;

  /// Additional product description
  String? get description => throw _privateConstructorUsedError;

  /// Original price before discount (if on sale)
  int? get originalPrice => throw _privateConstructorUsedError;

  /// Whether the item is in stock
  bool get inStock => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      String title,
      int price,
      String imageUrl,
      String productUrl,
      EcSource source,
      int? shippingCost,
      bool isFreeShipping,
      double? pointRate,
      int? pointValue,
      double? reviewScore,
      int? reviewCount,
      String? storeName,
      String? description,
      int? originalPrice,
      bool inStock});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? imageUrl = null,
    Object? productUrl = null,
    Object? source = null,
    Object? shippingCost = freezed,
    Object? isFreeShipping = null,
    Object? pointRate = freezed,
    Object? pointValue = freezed,
    Object? reviewScore = freezed,
    Object? reviewCount = freezed,
    Object? storeName = freezed,
    Object? description = freezed,
    Object? originalPrice = freezed,
    Object? inStock = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      productUrl: null == productUrl
          ? _value.productUrl
          : productUrl // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EcSource,
      shippingCost: freezed == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int?,
      isFreeShipping: null == isFreeShipping
          ? _value.isFreeShipping
          : isFreeShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      pointRate: freezed == pointRate
          ? _value.pointRate
          : pointRate // ignore: cast_nullable_to_non_nullable
              as double?,
      pointValue: freezed == pointValue
          ? _value.pointValue
          : pointValue // ignore: cast_nullable_to_non_nullable
              as int?,
      reviewScore: freezed == reviewScore
          ? _value.reviewScore
          : reviewScore // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int price,
      String imageUrl,
      String productUrl,
      EcSource source,
      int? shippingCost,
      bool isFreeShipping,
      double? pointRate,
      int? pointValue,
      double? reviewScore,
      int? reviewCount,
      String? storeName,
      String? description,
      int? originalPrice,
      bool inStock});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? imageUrl = null,
    Object? productUrl = null,
    Object? source = null,
    Object? shippingCost = freezed,
    Object? isFreeShipping = null,
    Object? pointRate = freezed,
    Object? pointValue = freezed,
    Object? reviewScore = freezed,
    Object? reviewCount = freezed,
    Object? storeName = freezed,
    Object? description = freezed,
    Object? originalPrice = freezed,
    Object? inStock = null,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      productUrl: null == productUrl
          ? _value.productUrl
          : productUrl // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EcSource,
      shippingCost: freezed == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int?,
      isFreeShipping: null == isFreeShipping
          ? _value.isFreeShipping
          : isFreeShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      pointRate: freezed == pointRate
          ? _value.pointRate
          : pointRate // ignore: cast_nullable_to_non_nullable
              as double?,
      pointValue: freezed == pointValue
          ? _value.pointValue
          : pointValue // ignore: cast_nullable_to_non_nullable
              as int?,
      reviewScore: freezed == reviewScore
          ? _value.reviewScore
          : reviewScore // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl extends _Product {
  const _$ProductImpl(
      {required this.id,
      required this.title,
      required this.price,
      required this.imageUrl,
      required this.productUrl,
      required this.source,
      this.shippingCost,
      this.isFreeShipping = false,
      this.pointRate,
      this.pointValue,
      this.reviewScore,
      this.reviewCount,
      this.storeName,
      this.description,
      this.originalPrice,
      this.inStock = true})
      : super._();

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  /// Unique identifier (ASIN for Amazon, itemCode for Rakuten, etc.)
  @override
  final String id;

  /// Product title/name
  @override
  final String title;

  /// Base price in JPY
  @override
  final int price;

  /// Product image URL
  @override
  final String imageUrl;

  /// URL to the product page (with affiliate link)
  @override
  final String productUrl;

  /// Source e-commerce platform
  @override
  final EcSource source;

  /// Shipping cost in JPY (null if unknown)
  @override
  final int? shippingCost;

  /// Whether shipping is free
  @override
  @JsonKey()
  final bool isFreeShipping;

  /// Point reward rate (e.g., 0.01 for 1%)
  @override
  final double? pointRate;

  /// Point reward value in JPY
  @override
  final int? pointValue;

  /// Review score (0.0 - 5.0)
  @override
  final double? reviewScore;

  /// Number of reviews
  @override
  final int? reviewCount;

  /// Store/seller name
  @override
  final String? storeName;

  /// Additional product description
  @override
  final String? description;

  /// Original price before discount (if on sale)
  @override
  final int? originalPrice;

  /// Whether the item is in stock
  @override
  @JsonKey()
  final bool inStock;

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, imageUrl: $imageUrl, productUrl: $productUrl, source: $source, shippingCost: $shippingCost, isFreeShipping: $isFreeShipping, pointRate: $pointRate, pointValue: $pointValue, reviewScore: $reviewScore, reviewCount: $reviewCount, storeName: $storeName, description: $description, originalPrice: $originalPrice, inStock: $inStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.productUrl, productUrl) ||
                other.productUrl == productUrl) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.isFreeShipping, isFreeShipping) ||
                other.isFreeShipping == isFreeShipping) &&
            (identical(other.pointRate, pointRate) ||
                other.pointRate == pointRate) &&
            (identical(other.pointValue, pointValue) ||
                other.pointValue == pointValue) &&
            (identical(other.reviewScore, reviewScore) ||
                other.reviewScore == reviewScore) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.inStock, inStock) || other.inStock == inStock));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      price,
      imageUrl,
      productUrl,
      source,
      shippingCost,
      isFreeShipping,
      pointRate,
      pointValue,
      reviewScore,
      reviewCount,
      storeName,
      description,
      originalPrice,
      inStock);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product extends Product {
  const factory _Product(
      {required final String id,
      required final String title,
      required final int price,
      required final String imageUrl,
      required final String productUrl,
      required final EcSource source,
      final int? shippingCost,
      final bool isFreeShipping,
      final double? pointRate,
      final int? pointValue,
      final double? reviewScore,
      final int? reviewCount,
      final String? storeName,
      final String? description,
      final int? originalPrice,
      final bool inStock}) = _$ProductImpl;
  const _Product._() : super._();

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override

  /// Unique identifier (ASIN for Amazon, itemCode for Rakuten, etc.)
  String get id;
  @override

  /// Product title/name
  String get title;
  @override

  /// Base price in JPY
  int get price;
  @override

  /// Product image URL
  String get imageUrl;
  @override

  /// URL to the product page (with affiliate link)
  String get productUrl;
  @override

  /// Source e-commerce platform
  EcSource get source;
  @override

  /// Shipping cost in JPY (null if unknown)
  int? get shippingCost;
  @override

  /// Whether shipping is free
  bool get isFreeShipping;
  @override

  /// Point reward rate (e.g., 0.01 for 1%)
  double? get pointRate;
  @override

  /// Point reward value in JPY
  int? get pointValue;
  @override

  /// Review score (0.0 - 5.0)
  double? get reviewScore;
  @override

  /// Number of reviews
  int? get reviewCount;
  @override

  /// Store/seller name
  String? get storeName;
  @override

  /// Additional product description
  String? get description;
  @override

  /// Original price before discount (if on sale)
  int? get originalPrice;
  @override

  /// Whether the item is in stock
  bool get inStock;
  @override
  @JsonKey(ignore: true)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  /// List of products from the search
  List<Product> get products => throw _privateConstructorUsedError;

  /// Total number of results available
  int get totalCount => throw _privateConstructorUsedError;

  /// Current page number
  int get page => throw _privateConstructorUsedError;

  /// Whether there are more results
  bool get hasMore => throw _privateConstructorUsedError;

  /// Source of this result
  EcSource get source => throw _privateConstructorUsedError;

  /// Error message if the search partially failed
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
          SearchResult value, $Res Function(SearchResult) then) =
      _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call(
      {List<Product> products,
      int totalCount,
      int page,
      bool hasMore,
      EcSource source,
      String? errorMessage});
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? totalCount = null,
    Object? page = null,
    Object? hasMore = null,
    Object? source = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EcSource,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
          _$SearchResultImpl value, $Res Function(_$SearchResultImpl) then) =
      __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Product> products,
      int totalCount,
      int page,
      bool hasMore,
      EcSource source,
      String? errorMessage});
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
      _$SearchResultImpl _value, $Res Function(_$SearchResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? totalCount = null,
    Object? page = null,
    Object? hasMore = null,
    Object? source = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SearchResultImpl(
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EcSource,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl(
      {required final List<Product> products,
      required this.totalCount,
      required this.page,
      required this.hasMore,
      required this.source,
      this.errorMessage})
      : _products = products;

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  /// List of products from the search
  final List<Product> _products;

  /// List of products from the search
  @override
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  /// Total number of results available
  @override
  final int totalCount;

  /// Current page number
  @override
  final int page;

  /// Whether there are more results
  @override
  final bool hasMore;

  /// Source of this result
  @override
  final EcSource source;

  /// Error message if the search partially failed
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SearchResult(products: $products, totalCount: $totalCount, page: $page, hasMore: $hasMore, source: $source, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      totalCount,
      page,
      hasMore,
      source,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(
      this,
    );
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult(
      {required final List<Product> products,
      required final int totalCount,
      required final int page,
      required final bool hasMore,
      required final EcSource source,
      final String? errorMessage}) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  @override

  /// List of products from the search
  List<Product> get products;
  @override

  /// Total number of results available
  int get totalCount;
  @override

  /// Current page number
  int get page;
  @override

  /// Whether there are more results
  bool get hasMore;
  @override

  /// Source of this result
  EcSource get source;
  @override

  /// Error message if the search partially failed
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AggregatedSearchResult _$AggregatedSearchResultFromJson(
    Map<String, dynamic> json) {
  return _AggregatedSearchResult.fromJson(json);
}

/// @nodoc
mixin _$AggregatedSearchResult {
  /// Results grouped by source
  Map<EcSource, SearchResult> get resultsBySource =>
      throw _privateConstructorUsedError;

  /// All products combined and sorted
  List<Product> get allProducts => throw _privateConstructorUsedError;

  /// Total count across all sources
  int get totalCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AggregatedSearchResultCopyWith<AggregatedSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AggregatedSearchResultCopyWith<$Res> {
  factory $AggregatedSearchResultCopyWith(AggregatedSearchResult value,
          $Res Function(AggregatedSearchResult) then) =
      _$AggregatedSearchResultCopyWithImpl<$Res, AggregatedSearchResult>;
  @useResult
  $Res call(
      {Map<EcSource, SearchResult> resultsBySource,
      List<Product> allProducts,
      int totalCount});
}

/// @nodoc
class _$AggregatedSearchResultCopyWithImpl<$Res,
        $Val extends AggregatedSearchResult>
    implements $AggregatedSearchResultCopyWith<$Res> {
  _$AggregatedSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultsBySource = null,
    Object? allProducts = null,
    Object? totalCount = null,
  }) {
    return _then(_value.copyWith(
      resultsBySource: null == resultsBySource
          ? _value.resultsBySource
          : resultsBySource // ignore: cast_nullable_to_non_nullable
              as Map<EcSource, SearchResult>,
      allProducts: null == allProducts
          ? _value.allProducts
          : allProducts // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AggregatedSearchResultImplCopyWith<$Res>
    implements $AggregatedSearchResultCopyWith<$Res> {
  factory _$$AggregatedSearchResultImplCopyWith(
          _$AggregatedSearchResultImpl value,
          $Res Function(_$AggregatedSearchResultImpl) then) =
      __$$AggregatedSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<EcSource, SearchResult> resultsBySource,
      List<Product> allProducts,
      int totalCount});
}

/// @nodoc
class __$$AggregatedSearchResultImplCopyWithImpl<$Res>
    extends _$AggregatedSearchResultCopyWithImpl<$Res,
        _$AggregatedSearchResultImpl>
    implements _$$AggregatedSearchResultImplCopyWith<$Res> {
  __$$AggregatedSearchResultImplCopyWithImpl(
      _$AggregatedSearchResultImpl _value,
      $Res Function(_$AggregatedSearchResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultsBySource = null,
    Object? allProducts = null,
    Object? totalCount = null,
  }) {
    return _then(_$AggregatedSearchResultImpl(
      resultsBySource: null == resultsBySource
          ? _value._resultsBySource
          : resultsBySource // ignore: cast_nullable_to_non_nullable
              as Map<EcSource, SearchResult>,
      allProducts: null == allProducts
          ? _value._allProducts
          : allProducts // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AggregatedSearchResultImpl extends _AggregatedSearchResult {
  const _$AggregatedSearchResultImpl(
      {required final Map<EcSource, SearchResult> resultsBySource,
      required final List<Product> allProducts,
      required this.totalCount})
      : _resultsBySource = resultsBySource,
        _allProducts = allProducts,
        super._();

  factory _$AggregatedSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AggregatedSearchResultImplFromJson(json);

  /// Results grouped by source
  final Map<EcSource, SearchResult> _resultsBySource;

  /// Results grouped by source
  @override
  Map<EcSource, SearchResult> get resultsBySource {
    if (_resultsBySource is EqualUnmodifiableMapView) return _resultsBySource;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_resultsBySource);
  }

  /// All products combined and sorted
  final List<Product> _allProducts;

  /// All products combined and sorted
  @override
  List<Product> get allProducts {
    if (_allProducts is EqualUnmodifiableListView) return _allProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allProducts);
  }

  /// Total count across all sources
  @override
  final int totalCount;

  @override
  String toString() {
    return 'AggregatedSearchResult(resultsBySource: $resultsBySource, allProducts: $allProducts, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AggregatedSearchResultImpl &&
            const DeepCollectionEquality()
                .equals(other._resultsBySource, _resultsBySource) &&
            const DeepCollectionEquality()
                .equals(other._allProducts, _allProducts) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_resultsBySource),
      const DeepCollectionEquality().hash(_allProducts),
      totalCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AggregatedSearchResultImplCopyWith<_$AggregatedSearchResultImpl>
      get copyWith => __$$AggregatedSearchResultImplCopyWithImpl<
          _$AggregatedSearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AggregatedSearchResultImplToJson(
      this,
    );
  }
}

abstract class _AggregatedSearchResult extends AggregatedSearchResult {
  const factory _AggregatedSearchResult(
      {required final Map<EcSource, SearchResult> resultsBySource,
      required final List<Product> allProducts,
      required final int totalCount}) = _$AggregatedSearchResultImpl;
  const _AggregatedSearchResult._() : super._();

  factory _AggregatedSearchResult.fromJson(Map<String, dynamic> json) =
      _$AggregatedSearchResultImpl.fromJson;

  @override

  /// Results grouped by source
  Map<EcSource, SearchResult> get resultsBySource;
  @override

  /// All products combined and sorted
  List<Product> get allProducts;
  @override

  /// Total count across all sources
  int get totalCount;
  @override
  @JsonKey(ignore: true)
  _$$AggregatedSearchResultImplCopyWith<_$AggregatedSearchResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
