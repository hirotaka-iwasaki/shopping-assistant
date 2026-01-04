import '../../core/core.dart';
import '../../data/data.dart';
import 'unit_parser.dart';

/// Service for handling product search operations.
class SearchService {
  SearchService({
    ProductRepository? repository,
  }) : _repository = repository ?? ProductRepository();

  final ProductRepository _repository;

  /// Validates a search query.
  SearchValidationResult validateQuery(SearchQuery query) {
    final errors = <String>[];

    // Keyword validation
    if (query.keyword.trim().isEmpty) {
      errors.add('検索キーワードを入力してください');
    } else if (query.keyword.trim().length < 2) {
      errors.add('検索キーワードは2文字以上で入力してください');
    } else if (query.keyword.length > 100) {
      errors.add('検索キーワードは100文字以内で入力してください');
    }

    // Price validation
    if (query.minPrice != null && query.minPrice! < 0) {
      errors.add('最低価格は0以上で入力してください');
    }
    if (query.maxPrice != null && query.maxPrice! < 0) {
      errors.add('最高価格は0以上で入力してください');
    }
    if (query.minPrice != null &&
        query.maxPrice != null &&
        query.minPrice! > query.maxPrice!) {
      errors.add('最低価格は最高価格以下で入力してください');
    }

    // Page validation
    if (query.page < 1) {
      errors.add('ページ番号は1以上で入力してください');
    }
    if (query.pageSize < 1 || query.pageSize > 100) {
      errors.add('ページサイズは1〜100の範囲で入力してください');
    }

    return SearchValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Searches for products across configured sources.
  Future<SearchServiceResult> search(SearchQuery query) async {
    // Validate query
    final validation = validateQuery(query);
    if (!validation.isValid) {
      return SearchServiceResult.validationError(validation.errors);
    }

    // Normalize query
    final normalizedQuery = _normalizeQuery(query);

    AppLogger.info(
      'Searching for "${normalizedQuery.keyword}"',
      tag: 'SearchService',
    );

    try {
      final result = await _repository.search(normalizedQuery);

      return SearchServiceResult.success(
        result: result,
        query: normalizedQuery,
      );
    } catch (e) {
      AppLogger.error('Search failed', tag: 'SearchService', error: e);
      return SearchServiceResult.error('検索中にエラーが発生しました: $e');
    }
  }

  /// Searches a single source.
  Future<SearchResult> searchSingle(EcSource source, SearchQuery query) async {
    final normalizedQuery = _normalizeQuery(query);
    return _repository.searchSingle(source, normalizedQuery);
  }

  /// Gets a product by ID.
  Future<Product?> getProduct(EcSource source, String id) async {
    return _repository.getProduct(source, id);
  }

  /// Filters products from an existing result.
  List<Product> filterProducts(
    List<Product> products, {
    int? minPrice,
    int? maxPrice,
    bool? freeShippingOnly,
    bool? inStockOnly,
    List<EcSource>? sources,
    double? minReviewScore,
  }) {
    var filtered = _repository.filterProducts(
      products,
      minPrice: minPrice,
      maxPrice: maxPrice,
      freeShippingOnly: freeShippingOnly,
      inStockOnly: inStockOnly,
      sources: sources,
    );

    // Additional filtering
    if (minReviewScore != null) {
      filtered = filtered.where((p) {
        final score = p.reviewScore;
        return score != null && score >= minReviewScore;
      }).toList();
    }

    return filtered;
  }

  /// Sorts products.
  List<Product> sortProducts(List<Product> products, SortOption sortBy) {
    final sorted = List<Product>.from(products);

    switch (sortBy) {
      case SortOption.unitPriceAsc:
        // Sort by unit price (products without unit info go to the end)
        sorted.sort((a, b) {
          final aUnitPrice = a.unitPrice;
          final bUnitPrice = b.unitPrice;

          // Both have unit price: compare normally
          if (aUnitPrice != null && bUnitPrice != null) {
            return aUnitPrice.compareTo(bUnitPrice);
          }
          // Only a has unit price: a comes first
          if (aUnitPrice != null) return -1;
          // Only b has unit price: b comes first
          if (bUnitPrice != null) return 1;
          // Neither has unit price: sort by effective price
          return a.effectivePrice.compareTo(b.effectivePrice);
        });
        break;
      case SortOption.priceAsc:
        sorted.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
        break;
      case SortOption.priceDesc:
        sorted.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
        break;
      case SortOption.reviewDesc:
        sorted.sort((a, b) {
          final aScore = a.reviewScore ?? 0;
          final bScore = b.reviewScore ?? 0;
          if (aScore == bScore) {
            final aCount = a.reviewCount ?? 0;
            final bCount = b.reviewCount ?? 0;
            return bCount.compareTo(aCount);
          }
          return bScore.compareTo(aScore);
        });
        break;
      case SortOption.relevance:
        // Keep original order
        break;
    }

    return sorted;
  }

  /// Parses unit information for all products in a list.
  List<Product> parseUnitInfo(List<Product> products) {
    final parser = UnitParser.instance;
    return products.map((product) {
      if (product.unitInfo != null) return product;

      final unitInfo = parser.parse(
        product.title,
        description: product.description,
      );

      return product.copyWith(unitInfo: unitInfo);
    }).toList();
  }

  /// Gets price statistics for a list of products.
  PriceStats getPriceStats(List<Product> products) {
    if (products.isEmpty) {
      return const PriceStats(
        minPrice: 0,
        maxPrice: 0,
        avgPrice: 0,
        minEffectivePrice: 0,
        maxEffectivePrice: 0,
        avgEffectivePrice: 0,
      );
    }

    final prices = products.map((p) => p.price).toList();
    final effectivePrices = products.map((p) => p.effectivePrice).toList();

    prices.sort();
    effectivePrices.sort();

    return PriceStats(
      minPrice: prices.first,
      maxPrice: prices.last,
      avgPrice: (prices.reduce((a, b) => a + b) / prices.length).round(),
      minEffectivePrice: effectivePrices.first,
      maxEffectivePrice: effectivePrices.last,
      avgEffectivePrice:
          (effectivePrices.reduce((a, b) => a + b) / effectivePrices.length)
              .round(),
    );
  }

  /// Normalizes a search query.
  SearchQuery _normalizeQuery(SearchQuery query) {
    return query.copyWith(
      keyword: query.keyword.trim(),
      pageSize: query.pageSize.clamp(1, 100),
      page: query.page.clamp(1, 100),
    );
  }

  /// Disposes resources.
  void dispose() {
    _repository.dispose();
  }
}

/// Result of search query validation.
class SearchValidationResult {
  const SearchValidationResult({
    required this.isValid,
    required this.errors,
  });

  final bool isValid;
  final List<String> errors;

  String get errorMessage => errors.join('\n');
}

/// Result of a search operation.
class SearchServiceResult {
  const SearchServiceResult._({
    required this.isSuccess,
    this.result,
    this.query,
    this.errorMessage,
    this.validationErrors,
  });

  factory SearchServiceResult.success({
    required AggregatedSearchResult result,
    required SearchQuery query,
  }) {
    return SearchServiceResult._(
      isSuccess: true,
      result: result,
      query: query,
    );
  }

  factory SearchServiceResult.error(String message) {
    return SearchServiceResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }

  factory SearchServiceResult.validationError(List<String> errors) {
    return SearchServiceResult._(
      isSuccess: false,
      validationErrors: errors,
      errorMessage: errors.join('\n'),
    );
  }

  final bool isSuccess;
  final AggregatedSearchResult? result;
  final SearchQuery? query;
  final String? errorMessage;
  final List<String>? validationErrors;

  bool get isValidationError => validationErrors != null;
}

/// Price statistics for a set of products.
class PriceStats {
  const PriceStats({
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
    required this.minEffectivePrice,
    required this.maxEffectivePrice,
    required this.avgEffectivePrice,
  });

  final int minPrice;
  final int maxPrice;
  final int avgPrice;
  final int minEffectivePrice;
  final int maxEffectivePrice;
  final int avgEffectivePrice;

  int get priceDifference => maxEffectivePrice - minEffectivePrice;
}
