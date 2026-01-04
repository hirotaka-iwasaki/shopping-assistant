import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/exceptions.dart';

part 'search_query.freezed.dart';
part 'search_query.g.dart';

/// Search query parameters.
@freezed
class SearchQuery with _$SearchQuery {
  const factory SearchQuery({
    /// Search keyword
    required String keyword,

    /// Target e-commerce sources (empty means all)
    @Default([]) List<EcSource> sources,

    /// Minimum price filter
    int? minPrice,

    /// Maximum price filter
    int? maxPrice,

    /// Filter for free shipping only
    @Default(false) bool freeShippingOnly,

    /// Sort option
    @Default(SortOption.relevance) SortOption sortBy,

    /// Page number (1-indexed)
    @Default(1) int page,

    /// Number of items per page
    @Default(20) int pageSize,
  }) = _SearchQuery;

  const SearchQuery._();

  factory SearchQuery.fromJson(Map<String, dynamic> json) =>
      _$SearchQueryFromJson(json);

  /// Creates a copy with the next page.
  SearchQuery nextPage() => copyWith(page: page + 1);

  /// Creates a copy with the first page.
  SearchQuery firstPage() => copyWith(page: 1);

  /// Whether this query has any filters applied.
  bool get hasFilters =>
      minPrice != null ||
      maxPrice != null ||
      freeShippingOnly ||
      sources.isNotEmpty;
}

/// Sort options for search results.
enum SortOption {
  /// Most relevant first (default)
  relevance('関連度順'),

  /// Lowest effective price first
  priceAsc('価格が安い順'),

  /// Highest effective price first
  priceDesc('価格が高い順'),

  /// Highest point rate first
  pointsDesc('ポイント順'),

  /// Highest review score first
  reviewDesc('レビュー順'),

  /// Newest first
  newest('新着順');

  const SortOption(this.displayName);
  final String displayName;
}
