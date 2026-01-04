import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import '../providers/search_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_expansion_tile.dart';

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

    final availableSources = ref.watch(availableSourcesProvider);
    final excludedSources = ref.watch(excludedSourcesProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(searchStateProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          // Results count and unit price availability
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Text(
                    '${products.length}件の商品',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(width: 8),
                  _buildUnitPriceStats(context, products),
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
          // Source filter buttons
          if (availableSources.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: availableSources.entries.map((entry) {
                    final source = entry.key;
                    final count = entry.value;
                    final isExcluded = excludedSources.contains(source);

                    return _SourceFilterChip(
                      source: source,
                      count: count,
                      isActive: !isExcluded,
                      onTap: () {
                        final notifier = ref.read(excludedSourcesProvider.notifier);
                        if (isExcluded) {
                          notifier.state = {...excludedSources}..remove(source);
                        } else {
                          notifier.state = {...excludedSources, source};
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          // Product list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return ProductExpansionTile(product: product);
              },
              childCount: products.length,
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

  Widget _buildUnitPriceStats(BuildContext context, List<Product> products) {
    final withUnitPrice = products.where((p) => p.unitInfo != null).length;
    if (withUnitPrice == 0) return const SizedBox.shrink();

    final percentage = (withUnitPrice / products.length * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '単価判定 $percentage%',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
      ),
    );
  }
}

/// Filter chip for toggling source visibility.
class _SourceFilterChip extends StatelessWidget {
  const _SourceFilterChip({
    required this.source,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final EcSource source;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  Color _getSourceColor() {
    switch (source) {
      case EcSource.amazon:
        return const Color(0xFFFF9900);
      case EcSource.rakuten:
        return const Color(0xFFBF0000);
      case EcSource.yahoo:
        return const Color(0xFFFF0033);
      case EcSource.qoo10:
        return const Color(0xFFE91E63);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSourceColor();

    return Material(
      color: isActive ? color : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                source.displayName,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
