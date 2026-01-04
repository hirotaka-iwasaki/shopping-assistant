import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';
import 'settings_provider.dart';

/// Provider for the search service.
final searchServiceProvider = Provider<SearchService>((ref) {
  final service = SearchService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Current search query state.
final searchQueryProvider = StateProvider<SearchQuery?>((ref) => null);

/// Current sort option (default to unit price for comparison).
final sortOptionProvider = StateProvider<SortOption>((ref) => SortOption.unitPriceAsc);

/// Sources to exclude from results (toggle filter).
final excludedSourcesProvider = StateProvider<Set<EcSource>>((ref) => {});

/// Search state containing results and loading status.
class SearchState {
  const SearchState({
    this.result,
    this.isLoading = false,
    this.error,
    this.query,
  });

  final AggregatedSearchResult? result;
  final bool isLoading;
  final String? error;
  final SearchQuery? query;

  SearchState copyWith({
    AggregatedSearchResult? result,
    bool? isLoading,
    String? error,
    SearchQuery? query,
  }) {
    return SearchState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      query: query ?? this.query,
    );
  }

  bool get hasResults => result != null && result!.allProducts.isNotEmpty;
  bool get hasError => error != null;
  bool get isEmpty => !isLoading && !hasError && !hasResults;

  List<Product> get products => result?.allProducts ?? [];
  int get totalCount => result?.totalCount ?? 0;
}

/// Main search state provider.
final searchStateProvider =
    StateNotifierProvider<SearchStateNotifier, SearchState>(
  (ref) => SearchStateNotifier(ref),
);

class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier(this._ref) : super(const SearchState());

  final Ref _ref;

  SearchService get _searchService => _ref.read(searchServiceProvider);

  /// Executes a search with the given keyword.
  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) return;

    // Reset filters and sort to defaults for new search
    _ref.read(sortOptionProvider.notifier).state = SortOption.unitPriceAsc;
    _ref.read(excludedSourcesProvider.notifier).state = {};

    // Get selected sources
    final sourcesAsync = _ref.read(selectedSourcesProvider);
    final sources = sourcesAsync.valueOrNull ?? [];

    // Get sort option (now reset to default)
    final sortOption = _ref.read(sortOptionProvider);

    final query = SearchQuery(
      keyword: keyword.trim(),
      sources: sources,
      sortBy: sortOption,
    );

    await searchWithQuery(query);

    // Add to search history
    _ref.read(searchHistoryProvider.notifier).add(keyword.trim());
  }

  /// Executes a search with a full query object.
  Future<void> searchWithQuery(SearchQuery query) async {
    state = state.copyWith(isLoading: true, error: null, query: query);
    _ref.read(searchQueryProvider.notifier).state = query;

    try {
      final result = await _searchService.search(query);

      if (result.isSuccess) {
        state = SearchState(
          result: result.result,
          isLoading: false,
          query: query,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      AppLogger.error('Search failed', tag: 'SearchProvider', error: e);
      state = state.copyWith(
        isLoading: false,
        error: '検索中にエラーが発生しました',
      );
    }
  }

  /// Loads more results (next page).
  Future<void> loadMore() async {
    final currentQuery = state.query;
    if (currentQuery == null || state.isLoading) return;

    final hasMore = state.result?.resultsBySource.values
            .any((r) => r.hasMore) ??
        false;
    if (!hasMore) return;

    final nextQuery = currentQuery.nextPage();
    await searchWithQuery(nextQuery);
  }

  /// Refreshes the current search.
  Future<void> refresh() async {
    final currentQuery = state.query;
    if (currentQuery == null) return;

    await searchWithQuery(currentQuery.firstPage());
  }

  /// Clears all search results.
  void clear() {
    state = const SearchState();
    _ref.read(searchQueryProvider.notifier).state = null;
  }

  /// Updates the sort option and re-sorts results.
  void updateSort(SortOption option) {
    _ref.read(sortOptionProvider.notifier).state = option;

    if (state.result != null) {
      final sorted = _searchService.sortProducts(
        state.result!.allProducts,
        option,
      );

      state = state.copyWith(
        result: AggregatedSearchResult(
          resultsBySource: state.result!.resultsBySource,
          allProducts: sorted,
          totalCount: state.result!.totalCount,
        ),
      );
    }
  }
}

/// Filtered products based on current filters.
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final searchState = ref.watch(searchStateProvider);
  final sortOption = ref.watch(sortOptionProvider);
  final selectedSources = ref.watch(selectedSourcesProvider).valueOrNull;
  final excludedSources = ref.watch(excludedSourcesProvider);

  if (!searchState.hasResults) return [];

  final searchService = ref.read(searchServiceProvider);

  var products = searchService.filterProducts(
    searchState.products,
    sources: selectedSources,
  );

  // Filter out excluded sources
  if (excludedSources.isNotEmpty) {
    products = products.where((p) => !excludedSources.contains(p.source)).toList();
  }

  // Parse unit information for all products
  products = searchService.parseUnitInfo(products);

  products = searchService.sortProducts(products, sortOption);

  return products;
});

/// Available sources in current search results (for filter UI).
final availableSourcesProvider = Provider<Map<EcSource, int>>((ref) {
  final searchState = ref.watch(searchStateProvider);
  if (!searchState.hasResults) return {};

  final counts = <EcSource, int>{};
  for (final product in searchState.products) {
    counts[product.source] = (counts[product.source] ?? 0) + 1;
  }
  return counts;
});

/// Price statistics for filtered products.
final priceStatsProvider = Provider<PriceStats?>((ref) {
  final products = ref.watch(filteredProductsProvider);
  if (products.isEmpty) return null;

  final searchService = ref.read(searchServiceProvider);
  return searchService.getPriceStats(products);
});

/// Source-specific results.
final sourceResultsProvider =
    Provider.family<SearchResult?, EcSource>((ref, source) {
  final searchState = ref.watch(searchStateProvider);
  return searchState.result?.resultsBySource[source];
});
