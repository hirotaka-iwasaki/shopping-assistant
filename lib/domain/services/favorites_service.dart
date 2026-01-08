import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../data/data.dart';

/// Service for managing user's favorite products.
class FavoritesService {
  FavoritesService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  static const String _keyFavorites = 'favorites';
  static const int _maxFavorites = 100;

  /// Initializes the service.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensures preferences are initialized.
  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  /// Gets all favorite items.
  Future<List<FavoriteItem>> getFavorites() async {
    final prefs = await _ensurePrefs();
    final json = prefs.getString(_keyFavorites);

    if (json == null) {
      return [];
    }

    try {
      final list = jsonDecode(json) as List;
      return list.map((item) => FavoriteItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.warning('Failed to parse favorites', error: e);
      return [];
    }
  }

  /// Saves the favorites list.
  Future<void> _saveFavorites(List<FavoriteItem> favorites) async {
    final prefs = await _ensurePrefs();
    final json = jsonEncode(favorites.map((f) => f.toJson()).toList());
    await prefs.setString(_keyFavorites, json);
  }

  /// Adds a product to favorites.
  Future<List<FavoriteItem>> addFavorite(FavoriteItem item) async {
    final favorites = await getFavorites();

    // Check if already exists
    final exists = favorites.any(
      (f) => f.productId == item.productId && f.source == item.source,
    );

    if (exists) {
      return favorites;
    }

    // Add to the beginning
    favorites.insert(0, item);

    // Enforce limit
    if (favorites.length > _maxFavorites) {
      favorites.removeRange(_maxFavorites, favorites.length);
    }

    await _saveFavorites(favorites);
    return favorites;
  }

  /// Adds a product to favorites.
  Future<List<FavoriteItem>> addProductToFavorites(Product product) async {
    return addFavorite(FavoriteItem.fromProduct(product));
  }

  /// Removes a product from favorites.
  Future<List<FavoriteItem>> removeFavorite(String productId, EcSource source) async {
    final favorites = await getFavorites();
    favorites.removeWhere(
      (f) => f.productId == productId && f.source == source,
    );
    await _saveFavorites(favorites);
    return favorites;
  }

  /// Checks if a product is in favorites.
  Future<bool> isFavorite(String productId, EcSource source) async {
    final favorites = await getFavorites();
    return favorites.any(
      (f) => f.productId == productId && f.source == source,
    );
  }

  /// Clears all favorites.
  Future<void> clearAll() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(_keyFavorites);
  }

  /// Gets the count of favorites.
  Future<int> getCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }
}
