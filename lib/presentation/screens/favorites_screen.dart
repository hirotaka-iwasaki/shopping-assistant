import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/data.dart';
import '../providers/favorites_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_large_card.dart';

/// Screen displaying user's favorite products.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り'),
        actions: [
          // Clear all button (only show if there are favorites)
          favoritesAsync.whenOrNull(
                data: (favorites) => favorites.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => _showClearConfirmation(context, ref),
                        tooltip: '全て削除',
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: favoritesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => ErrorDisplay(
          message: 'お気に入りの読み込みに失敗しました',
          onRetry: () => ref.read(favoritesProvider.notifier).refresh(),
        ),
        data: (favorites) {
          if (favorites.isEmpty) {
            return const EmptyDisplay(
              message: 'お気に入りはまだありません\n検索結果からハートをタップして追加できます',
              icon: Icons.favorite_border_rounded,
            );
          }

          return _FavoritesList(favorites: favorites);
        },
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('お気に入りを全て削除'),
        content: const Text('全てのお気に入りを削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).clear();
              Navigator.pop(context);
            },
            child: Text(
              '削除',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// List of favorite products with lazy loading.
class _FavoritesList extends ConsumerWidget {
  const _FavoritesList({required this.favorites});

  final List<FavoriteItem> favorites;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProductsAsync = ref.watch(favoriteProductsProvider);

    return favoriteProductsAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppTheme.spacingLg),
            Text('商品情報を取得中...'),
          ],
        ),
      ),
      error: (error, stack) => ErrorDisplay(
        message: '商品情報の取得に失敗しました',
        onRetry: () => ref.invalidate(favoriteProductsProvider),
      ),
      data: (productStates) {
        final successfulProducts = productStates
            .where((state) => state.product != null)
            .map((state) => state.product!)
            .toList();

        final failedProducts = productStates
            .where((state) => state.hasError || state.isNotFound)
            .toList();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(favoriteProductsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Header with count
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
                        '${favorites.length}件のお気に入り',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      if (failedProducts.isNotEmpty) ...[
                        const SizedBox(width: AppTheme.spacingSm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                            vertical: AppTheme.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            '${failedProducts.length}件取得失敗',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Failed products section
              if (failedProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLg,
                      vertical: AppTheme.spacingSm,
                    ),
                    child: _FailedProductsSection(
                      failedProducts: failedProducts,
                    ),
                  ),
                ),
              // Product list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = successfulProducts[index];
                    return ProductLargeCard(product: product);
                  },
                  childCount: successfulProducts.length,
                ),
              ),
              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingLg),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Section showing failed product fetches with removal option.
class _FailedProductsSection extends ConsumerWidget {
  const _FailedProductsSection({required this.failedProducts});

  final List<FavoriteProductState> failedProducts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: colorScheme.errorContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                '一部の商品を取得できませんでした',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.error,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            '商品が削除されたか、一時的にアクセスできない可能性があります。',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Wrap(
            spacing: AppTheme.spacingSm,
            runSpacing: AppTheme.spacingSm,
            children: failedProducts.map((state) {
              return Chip(
                label: Text(
                  '${state.favoriteItem.source.displayName}: ${state.favoriteItem.productId.substring(0, 8)}...',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  ref.read(favoritesProvider.notifier).remove(
                        state.favoriteItem.productId,
                        state.favoriteItem.source,
                      );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
