import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';

/// Provider for the favorites service.
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

/// Provider for the product repository (for fetching product details).
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final repo = ProductRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// Provider for favorite items list.
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<FavoriteItem>>>(
  (ref) => FavoritesNotifier(ref.watch(favoritesServiceProvider)),
);

class FavoritesNotifier extends StateNotifier<AsyncValue<List<FavoriteItem>>> {
  FavoritesNotifier(this._service) : super(const AsyncValue.loading()) {
    _load();
  }

  final FavoritesService _service;

  Future<void> _load() async {
    try {
      await _service.init();
      final favorites = await _service.getFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Product product) async {
    try {
      final updated = await _service.addProductToFavorites(product);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> remove(String productId, EcSource source) async {
    try {
      final updated = await _service.removeFavorite(productId, source);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggle(Product product) async {
    final favorites = state.valueOrNull ?? [];
    final isFav = favorites.any(
      (f) => f.productId == product.id && f.source == product.source,
    );

    if (isFav) {
      await remove(product.id, product.source);
    } else {
      await add(product);
    }
  }

  Future<void> clear() async {
    try {
      await _service.clearAll();
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _load();
  }
}

/// State for a single favorite product with its fetched details.
class FavoriteProductState {
  const FavoriteProductState({
    required this.favoriteItem,
    this.product,
    this.isLoading = false,
    this.errorMessage,
    this.isUsingCache = false,
  });

  final FavoriteItem favoriteItem;
  final Product? product;
  final bool isLoading;
  final String? errorMessage;
  final bool isUsingCache;

  bool get hasError => errorMessage != null && product == null;
  bool get isNotFound => !isLoading && product == null && !hasError;
}

/// Provider for checking if a specific product is favorited.
final isFavoriteProvider = Provider.family<bool, (String, EcSource)>((ref, params) {
  final (productId, source) = params;
  final favorites = ref.watch(favoritesProvider).valueOrNull ?? [];
  return favorites.any(
    (f) => f.productId == productId && f.source == source,
  );
});

/// Provider for favorite products with their fetched details.
final favoriteProductsProvider = FutureProvider<List<FavoriteProductState>>((ref) async {
  final favorites = ref.watch(favoritesProvider).valueOrNull ?? [];
  final repository = ref.watch(productRepositoryProvider);

  if (favorites.isEmpty) {
    return [];
  }

  // Fetch products in parallel by source
  final results = await Future.wait(
    favorites.map((fav) async {
      try {
        final product = await repository.getProduct(fav.source, fav.productId);
        if (product != null) {
          return FavoriteProductState(
            favoriteItem: fav,
            product: product,
          );
        } else {
          // API returned null - use cached product as fallback
          if (fav.cachedProduct != null) {
            return FavoriteProductState(
              favoriteItem: fav,
              product: fav.cachedProduct,
              isUsingCache: true,
            );
          }
          return FavoriteProductState(
            favoriteItem: fav,
            errorMessage: '商品が見つかりませんでした',
          );
        }
      } catch (e) {
        AppLogger.error(
          'Failed to fetch favorite product',
          tag: 'FavoritesProvider',
          error: e,
        );
        // Use cached product as fallback on error
        if (fav.cachedProduct != null) {
          return FavoriteProductState(
            favoriteItem: fav,
            product: fav.cachedProduct,
            isUsingCache: true,
          );
        }
        return FavoriteProductState(
          favoriteItem: fav,
          errorMessage: '取得に失敗しました',
        );
      }
    }),
  );

  return results;
});

/// Provider for favorites count.
final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).valueOrNull?.length ?? 0;
});
