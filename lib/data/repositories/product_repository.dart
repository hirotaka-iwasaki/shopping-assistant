import '../../core/core.dart';
import '../clients/amazon_client.dart';
import '../clients/base_client.dart';
import '../clients/rakuten_client.dart';
import '../clients/yahoo_client.dart';
import '../models/product.dart';
import '../models/search_query.dart';

/// Repository for product search operations across multiple e-commerce platforms.
class ProductRepository {
  ProductRepository({
    AmazonClient? amazonClient,
    RakutenClient? rakutenClient,
    YahooClient? yahooClient,
  })  : _amazonClient = amazonClient ?? AmazonClient(),
        _rakutenClient = rakutenClient ?? RakutenClient(),
        _yahooClient = yahooClient ?? YahooClient();

  final AmazonClient _amazonClient;
  final RakutenClient _rakutenClient;
  final YahooClient _yahooClient;

  /// Gets the client for a specific source.
  EcClient _getClient(EcSource source) {
    switch (source) {
      case EcSource.amazon:
        return _amazonClient;
      case EcSource.rakuten:
        return _rakutenClient;
      case EcSource.yahoo:
        return _yahooClient;
      case EcSource.qoo10:
        throw UnimplementedError('Qoo10 client is not implemented');
    }
  }

  /// Searches across multiple e-commerce platforms in parallel.
  Future<AggregatedSearchResult> search(SearchQuery query) async {
    final sources = query.sources.isEmpty
        ? [EcSource.amazon, EcSource.rakuten, EcSource.yahoo]
        : query.sources.where((s) => s != EcSource.qoo10).toList();

    AppLogger.info(
      'Starting parallel search for "${query.keyword}" on ${sources.length} sources',
      tag: 'ProductRepository',
    );

    // Execute searches in parallel
    final results = await Future.wait(
      sources.map((source) => _searchSource(source, query)),
      eagerError: false,
    );

    // Build results map
    final resultsBySource = <EcSource, SearchResult>{};
    for (var i = 0; i < sources.length; i++) {
      resultsBySource[sources[i]] = results[i];
    }

    // Combine and sort products
    final allProducts = <Product>[];
    for (final result in results) {
      allProducts.addAll(result.products);
    }

    // Sort combined results
    _sortProducts(allProducts, query.sortBy);

    // Calculate total count
    final totalCount = results.fold<int>(0, (sum, r) => sum + r.totalCount);

    AppLogger.info(
      'Search completed: ${allProducts.length} products from ${sources.length} sources',
      tag: 'ProductRepository',
    );

    return AggregatedSearchResult(
      resultsBySource: resultsBySource,
      allProducts: allProducts,
      totalCount: totalCount,
    );
  }

  /// Searches a single source with error handling.
  Future<SearchResult> _searchSource(EcSource source, SearchQuery query) async {
    try {
      final client = _getClient(source);
      final result = await client.search(query);
      AppLogger.debug(
        '${source.displayName}: ${result.products.length} products found',
        tag: 'ProductRepository',
      );
      return result;
    } catch (e) {
      AppLogger.error(
        'Search failed for ${source.displayName}',
        tag: 'ProductRepository',
        error: e,
      );
      return SearchResult.empty(
        source,
        errorMessage: 'Failed to search: $e',
      );
    }
  }

  /// Searches a single source.
  Future<SearchResult> searchSingle(EcSource source, SearchQuery query) async {
    return _searchSource(source, query);
  }

  /// Gets a product by ID from a specific source.
  Future<Product?> getProduct(EcSource source, String id) async {
    try {
      final client = _getClient(source);
      return await client.getProduct(id);
    } catch (e) {
      AppLogger.error(
        'Get product failed for ${source.displayName}',
        tag: 'ProductRepository',
        error: e,
      );
      return null;
    }
  }

  /// Sorts products based on the sort option.
  void _sortProducts(List<Product> products, SortOption sortBy) {
    switch (sortBy) {
      case SortOption.priceAsc:
        products.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
        break;
      case SortOption.priceDesc:
        products.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
        break;
      case SortOption.reviewDesc:
        products.sort((a, b) {
          final aScore = a.reviewScore ?? 0;
          final bScore = b.reviewScore ?? 0;
          return bScore.compareTo(aScore);
        });
        break;
      case SortOption.unitPriceAsc:
        // Unit price sort requires unit info parsing, done in SearchService
        // Fall through to relevance for initial sort
        break;
      case SortOption.relevance:
        // Keep original order (relevance from API)
        break;
    }
  }

  /// Filters products based on criteria.
  List<Product> filterProducts(
    List<Product> products, {
    int? minPrice,
    int? maxPrice,
    bool? freeShippingOnly,
    bool? inStockOnly,
    List<EcSource>? sources,
  }) {
    return products.where((product) {
      if (minPrice != null && product.effectivePrice < minPrice) {
        return false;
      }
      if (maxPrice != null && product.effectivePrice > maxPrice) {
        return false;
      }
      if (freeShippingOnly == true && !product.isFreeShipping) {
        return false;
      }
      if (inStockOnly == true && !product.inStock) {
        return false;
      }
      if (sources != null && sources.isNotEmpty && !sources.contains(product.source)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Disposes all clients.
  void dispose() {
    _amazonClient.dispose();
    _rakutenClient.dispose();
    _yahooClient.dispose();
  }
}
