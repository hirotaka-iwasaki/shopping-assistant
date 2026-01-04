import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/exceptions.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Unified product model representing items from any e-commerce platform.
@freezed
class Product with _$Product {
  const factory Product({
    /// Unique identifier (ASIN for Amazon, itemCode for Rakuten, etc.)
    required String id,

    /// Product title/name
    required String title,

    /// Base price in JPY
    required int price,

    /// Product image URL
    required String imageUrl,

    /// URL to the product page (with affiliate link)
    required String productUrl,

    /// Source e-commerce platform
    required EcSource source,

    /// Shipping cost in JPY (null if unknown)
    int? shippingCost,

    /// Whether shipping is free
    @Default(false) bool isFreeShipping,

    /// Point reward rate (e.g., 0.01 for 1%)
    double? pointRate,

    /// Point reward value in JPY
    int? pointValue,

    /// Review score (0.0 - 5.0)
    double? reviewScore,

    /// Number of reviews
    int? reviewCount,

    /// Store/seller name
    String? storeName,

    /// Additional product description
    String? description,

    /// Original price before discount (if on sale)
    int? originalPrice,

    /// Whether the item is in stock
    @Default(true) bool inStock,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Calculates the effective price considering shipping and points.
  /// effectivePrice = price + shippingCost - pointValue
  int get effectivePrice {
    final shipping = isFreeShipping ? 0 : (shippingCost ?? 0);
    final points = pointValue ?? _calculatePointValue();
    return price + shipping - points;
  }

  /// Calculates point value from point rate if pointValue is not set.
  int _calculatePointValue() {
    if (pointRate == null) return 0;
    return (price * pointRate!).floor();
  }

  /// Discount percentage if originalPrice is available.
  int? get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  /// Formatted price string with yen symbol.
  String get formattedPrice => '¥${_formatNumber(price)}';

  /// Formatted effective price string.
  String get formattedEffectivePrice => '¥${_formatNumber(effectivePrice)}';

  /// Formatted shipping cost string.
  String get formattedShippingCost {
    if (isFreeShipping) return '送料無料';
    if (shippingCost == null) return '送料別';
    if (shippingCost == 0) return '送料無料';
    return '送料 ¥${_formatNumber(shippingCost!)}';
  }

  /// Formatted point value string.
  String? get formattedPoints {
    final points = pointValue ?? _calculatePointValue();
    if (points <= 0) return null;
    return '$points pt';
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}

/// Result of a search query containing products and metadata.
@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    /// List of products from the search
    required List<Product> products,

    /// Total number of results available
    required int totalCount,

    /// Current page number
    required int page,

    /// Whether there are more results
    required bool hasMore,

    /// Source of this result
    required EcSource source,

    /// Error message if the search partially failed
    String? errorMessage,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  /// Creates an empty result (used for failed searches).
  factory SearchResult.empty(EcSource source, {String? errorMessage}) =>
      SearchResult(
        products: const [],
        totalCount: 0,
        page: 1,
        hasMore: false,
        source: source,
        errorMessage: errorMessage,
      );
}

/// Aggregated search results from multiple sources.
@freezed
class AggregatedSearchResult with _$AggregatedSearchResult {
  const factory AggregatedSearchResult({
    /// Results grouped by source
    required Map<EcSource, SearchResult> resultsBySource,

    /// All products combined and sorted
    required List<Product> allProducts,

    /// Total count across all sources
    required int totalCount,
  }) = _AggregatedSearchResult;

  const AggregatedSearchResult._();

  factory AggregatedSearchResult.fromJson(Map<String, dynamic> json) =>
      _$AggregatedSearchResultFromJson(json);

  /// Creates an empty aggregated result.
  factory AggregatedSearchResult.empty() => const AggregatedSearchResult(
        resultsBySource: {},
        allProducts: [],
        totalCount: 0,
      );

  /// Sources that had errors.
  List<EcSource> get failedSources => resultsBySource.entries
      .where((e) => e.value.errorMessage != null)
      .map((e) => e.key)
      .toList();

  /// Sources that succeeded.
  List<EcSource> get successfulSources => resultsBySource.entries
      .where((e) => e.value.errorMessage == null)
      .map((e) => e.key)
      .toList();
}
