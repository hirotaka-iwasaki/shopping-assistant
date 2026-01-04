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
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref),
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
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.55,
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

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeShippingOnly = ref.watch(freeShippingFilterProvider);
    final priceRange = ref.watch(priceRangeProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'フィルター',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(freeShippingFilterProvider.notifier).state = false;
                      ref.read(priceRangeProvider.notifier).state = null;
                    },
                    child: const Text('リセット'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Free shipping toggle
              SwitchListTile(
                title: const Text('送料無料のみ'),
                value: freeShippingOnly,
                onChanged: (value) {
                  ref.read(freeShippingFilterProvider.notifier).state = value;
                },
              ),
              const Divider(),
              // Price range (simplified)
              ListTile(
                title: const Text('価格帯'),
                subtitle: priceRange?.hasFilter == true
                    ? Text(_formatPriceRange(priceRange!))
                    : const Text('指定なし'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPriceRangeDialog(context, ref),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatPriceRange(PriceRange range) {
    if (range.min != null && range.max != null) {
      return '¥${range.min} 〜 ¥${range.max}';
    } else if (range.min != null) {
      return '¥${range.min} 以上';
    } else if (range.max != null) {
      return '¥${range.max} 以下';
    }
    return '指定なし';
  }

  void _showPriceRangeDialog(BuildContext context, WidgetRef ref) {
    final minController = TextEditingController();
    final maxController = TextEditingController();
    final currentRange = ref.read(priceRangeProvider);

    if (currentRange?.min != null) {
      minController.text = currentRange!.min.toString();
    }
    if (currentRange?.max != null) {
      maxController.text = currentRange!.max.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('価格帯'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                decoration: const InputDecoration(
                  labelText: '最低価格',
                  prefixText: '¥',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('〜'),
            ),
            Expanded(
              child: TextField(
                controller: maxController,
                decoration: const InputDecoration(
                  labelText: '最高価格',
                  prefixText: '¥',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              final min = int.tryParse(minController.text);
              final max = int.tryParse(maxController.text);
              ref.read(priceRangeProvider.notifier).state = PriceRange(
                min: min,
                max: max,
              );
              Navigator.pop(context);
            },
            child: const Text('適用'),
          ),
        ],
      ),
    );
  }
}
