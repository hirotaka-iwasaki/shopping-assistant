// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchQuery _$SearchQueryFromJson(Map<String, dynamic> json) {
  return _SearchQuery.fromJson(json);
}

/// @nodoc
mixin _$SearchQuery {
  /// Search keyword
  String get keyword => throw _privateConstructorUsedError;

  /// Target e-commerce sources (empty means all)
  List<EcSource> get sources => throw _privateConstructorUsedError;

  /// Minimum price filter
  int? get minPrice => throw _privateConstructorUsedError;

  /// Maximum price filter
  int? get maxPrice => throw _privateConstructorUsedError;

  /// Filter for free shipping only
  bool get freeShippingOnly => throw _privateConstructorUsedError;

  /// Sort option
  SortOption get sortBy => throw _privateConstructorUsedError;

  /// Page number (1-indexed)
  int get page => throw _privateConstructorUsedError;

  /// Number of items per page
  int get pageSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchQueryCopyWith<SearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchQueryCopyWith<$Res> {
  factory $SearchQueryCopyWith(
          SearchQuery value, $Res Function(SearchQuery) then) =
      _$SearchQueryCopyWithImpl<$Res, SearchQuery>;
  @useResult
  $Res call(
      {String keyword,
      List<EcSource> sources,
      int? minPrice,
      int? maxPrice,
      bool freeShippingOnly,
      SortOption sortBy,
      int page,
      int pageSize});
}

/// @nodoc
class _$SearchQueryCopyWithImpl<$Res, $Val extends SearchQuery>
    implements $SearchQueryCopyWith<$Res> {
  _$SearchQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyword = null,
    Object? sources = null,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? freeShippingOnly = null,
    Object? sortBy = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(_value.copyWith(
      keyword: null == keyword
          ? _value.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String,
      sources: null == sources
          ? _value.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<EcSource>,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      freeShippingOnly: null == freeShippingOnly
          ? _value.freeShippingOnly
          : freeShippingOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortOption,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchQueryImplCopyWith<$Res>
    implements $SearchQueryCopyWith<$Res> {
  factory _$$SearchQueryImplCopyWith(
          _$SearchQueryImpl value, $Res Function(_$SearchQueryImpl) then) =
      __$$SearchQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String keyword,
      List<EcSource> sources,
      int? minPrice,
      int? maxPrice,
      bool freeShippingOnly,
      SortOption sortBy,
      int page,
      int pageSize});
}

/// @nodoc
class __$$SearchQueryImplCopyWithImpl<$Res>
    extends _$SearchQueryCopyWithImpl<$Res, _$SearchQueryImpl>
    implements _$$SearchQueryImplCopyWith<$Res> {
  __$$SearchQueryImplCopyWithImpl(
      _$SearchQueryImpl _value, $Res Function(_$SearchQueryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyword = null,
    Object? sources = null,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? freeShippingOnly = null,
    Object? sortBy = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(_$SearchQueryImpl(
      keyword: null == keyword
          ? _value.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String,
      sources: null == sources
          ? _value._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<EcSource>,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      freeShippingOnly: null == freeShippingOnly
          ? _value.freeShippingOnly
          : freeShippingOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortOption,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchQueryImpl extends _SearchQuery {
  const _$SearchQueryImpl(
      {required this.keyword,
      final List<EcSource> sources = const [],
      this.minPrice,
      this.maxPrice,
      this.freeShippingOnly = false,
      this.sortBy = SortOption.relevance,
      this.page = 1,
      this.pageSize = 20})
      : _sources = sources,
        super._();

  factory _$SearchQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchQueryImplFromJson(json);

  /// Search keyword
  @override
  final String keyword;

  /// Target e-commerce sources (empty means all)
  final List<EcSource> _sources;

  /// Target e-commerce sources (empty means all)
  @override
  @JsonKey()
  List<EcSource> get sources {
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sources);
  }

  /// Minimum price filter
  @override
  final int? minPrice;

  /// Maximum price filter
  @override
  final int? maxPrice;

  /// Filter for free shipping only
  @override
  @JsonKey()
  final bool freeShippingOnly;

  /// Sort option
  @override
  @JsonKey()
  final SortOption sortBy;

  /// Page number (1-indexed)
  @override
  @JsonKey()
  final int page;

  /// Number of items per page
  @override
  @JsonKey()
  final int pageSize;

  @override
  String toString() {
    return 'SearchQuery(keyword: $keyword, sources: $sources, minPrice: $minPrice, maxPrice: $maxPrice, freeShippingOnly: $freeShippingOnly, sortBy: $sortBy, page: $page, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchQueryImpl &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.freeShippingOnly, freeShippingOnly) ||
                other.freeShippingOnly == freeShippingOnly) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      keyword,
      const DeepCollectionEquality().hash(_sources),
      minPrice,
      maxPrice,
      freeShippingOnly,
      sortBy,
      page,
      pageSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchQueryImplCopyWith<_$SearchQueryImpl> get copyWith =>
      __$$SearchQueryImplCopyWithImpl<_$SearchQueryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchQueryImplToJson(
      this,
    );
  }
}

abstract class _SearchQuery extends SearchQuery {
  const factory _SearchQuery(
      {required final String keyword,
      final List<EcSource> sources,
      final int? minPrice,
      final int? maxPrice,
      final bool freeShippingOnly,
      final SortOption sortBy,
      final int page,
      final int pageSize}) = _$SearchQueryImpl;
  const _SearchQuery._() : super._();

  factory _SearchQuery.fromJson(Map<String, dynamic> json) =
      _$SearchQueryImpl.fromJson;

  @override

  /// Search keyword
  String get keyword;
  @override

  /// Target e-commerce sources (empty means all)
  List<EcSource> get sources;
  @override

  /// Minimum price filter
  int? get minPrice;
  @override

  /// Maximum price filter
  int? get maxPrice;
  @override

  /// Filter for free shipping only
  bool get freeShippingOnly;
  @override

  /// Sort option
  SortOption get sortBy;
  @override

  /// Page number (1-indexed)
  int get page;
  @override

  /// Number of items per page
  int get pageSize;
  @override
  @JsonKey(ignore: true)
  _$$SearchQueryImplCopyWith<_$SearchQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
