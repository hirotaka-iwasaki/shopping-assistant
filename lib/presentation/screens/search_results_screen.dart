import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../providers/search_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Screen displaying search results.
class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchStateProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final sortOption = ref.watch(sortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(searchState.query?.keyword ?? '検索結果'),
        actions: [
          // Sort button
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            initialValue: sortOption,
            onSelected: (option) {
              ref.read(searchStateProvider.notifier).updateSort(option);
            },
            itemBuilder: (context) => SortOption.values.map((option) {
              return PopupMenuItem(
                value: option,
                child: Row(
                  children: [
                    if (option == sortOption)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(option.displayName),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: _buildBody(context, ref, searchState, filteredProducts),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SearchState searchState,
    List<Product> products,
  ) {
    if (searchState.isLoading && products.isEmpty) {
      return const SearchLoadingIndicator();
    }

    if (searchState.hasError && products.isEmpty) {
      return ErrorDisplay(
        message: searchState.error!,
        onRetry: () => ref.read(searchStateProvider.notifier).refresh(),
      );
    }

    if (products.isEmpty) {
      return const EmptyDisplay(
        message: '検索結果がありません\n別のキーワードで検索してください',
        icon: Icons.search_off,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(searchStateProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '${products.length}件の商品',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const Spacer(),
                  if (searchState.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
          ),
          // Product grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _openProductDetail(context, product),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  void _openProductDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

}
