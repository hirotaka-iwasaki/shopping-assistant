import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data.dart';
import '../providers/search_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_expansion_tile.dart';
import '../widgets/product_large_card.dart';

/// View mode for product list.
enum ProductViewMode { compact, large }

/// Provider for the current view mode.
final productViewModeProvider = StateProvider<ProductViewMode>(
  (ref) => ProductViewMode.compact,
);

/// Screen displaying search results with mixi2-inspired design.
class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchStateProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final sortOption = ref.watch(sortOptionProvider);
    final viewMode = ref.watch(productViewModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(searchState.query?.keyword ?? '検索結果'),
        actions: [
          // View mode toggle
          IconButton(
            icon: Icon(
              viewMode == ProductViewMode.compact
                  ? Icons.view_agenda_outlined
                  : Icons.view_list_outlined,
            ),
            onPressed: () {
              ref.read(productViewModeProvider.notifier).state =
                  viewMode == ProductViewMode.compact
                      ? ProductViewMode.large
                      : ProductViewMode.compact;
            },
            tooltip: viewMode == ProductViewMode.compact ? '大きく表示' : 'コンパクト表示',
          ),
          // Sort button
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort_rounded),
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
                      Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: AppTheme.spacingSm),
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
        icon: Icons.search_off_rounded,
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
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                AppTheme.spacingSm,
              ),
              child: Row(
                children: [
                  Text(
                    '${products.length}件の商品',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  _buildUnitPriceStats(context, products),
                  const Spacer(),
                  if (searchState.isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Source filter buttons
          if (availableSources.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingLg,
                  AppTheme.spacingXs,
                  AppTheme.spacingLg,
                  AppTheme.spacingMd,
                ),
                child: Wrap(
                  spacing: AppTheme.spacingSm,
                  runSpacing: AppTheme.spacingSm,
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
                final viewMode = ref.watch(productViewModeProvider);
                if (viewMode == ProductViewMode.large) {
                  return ProductLargeCard(product: product);
                }
                return ProductExpansionTile(product: product);
              },
              childCount: products.length,
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingLg),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitPriceStats(BuildContext context, List<Product> products) {
    final withUnitPrice = products.where((p) => p.unitInfo != null).length;
    if (withUnitPrice == 0) return const SizedBox.shrink();

    final percentage = (withUnitPrice / products.length * 100).round();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Text(
        '単価判定 $percentage%',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

/// Filter chip for toggling source visibility with mixi2-inspired design.
class _SourceFilterChip extends StatefulWidget {
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

  @override
  State<_SourceFilterChip> createState() => _SourceFilterChipState();
}

class _SourceFilterChipState extends State<_SourceFilterChip> {
  bool _isPressed = false;

  Color _getSourceColor() {
    switch (widget.source) {
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppTheme.animFast,
        child: AnimatedContainer(
          duration: AppTheme.animNormal,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: widget.isActive ? color : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.source.displayName,
                style: TextStyle(
                  color: widget.isActive ? Colors.white : colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppTheme.spacingXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? Colors.white.withOpacity(0.25)
                      : colorScheme.outline.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    color: widget.isActive ? Colors.white : colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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
