import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';

/// Service for managing user settings and preferences.
class SettingsService {
  SettingsService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  // Preference keys
  static const String _keySelectedSources = 'selected_sources';
  static const String _keyDefaultSort = 'default_sort';
  static const String _keyFreeShippingOnly = 'free_shipping_only';
  static const String _keySearchHistory = 'search_history';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyFirstLaunch = 'first_launch';

  static const int _maxSearchHistory = 20;

  /// Initializes the settings service.
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

  // --- Selected Sources ---

  /// Gets the list of selected e-commerce sources.
  Future<List<EcSource>> getSelectedSources() async {
    final prefs = await _ensurePrefs();
    final json = prefs.getString(_keySelectedSources);

    if (json == null) {
      // Default: all sources except Qoo10
      return [EcSource.amazon, EcSource.rakuten, EcSource.yahoo];
    }

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((name) => EcSource.values.firstWhere(
                (s) => s.name == name,
                orElse: () => EcSource.amazon,
              ))
          .toList();
    } catch (e) {
      AppLogger.warning('Failed to parse selected sources', error: e);
      return [EcSource.amazon, EcSource.rakuten, EcSource.yahoo];
    }
  }

  /// Sets the list of selected e-commerce sources.
  Future<void> setSelectedSources(List<EcSource> sources) async {
    final prefs = await _ensurePrefs();
    final json = jsonEncode(sources.map((s) => s.name).toList());
    await prefs.setString(_keySelectedSources, json);
  }

  /// Toggles a source on/off.
  Future<List<EcSource>> toggleSource(EcSource source) async {
    final current = await getSelectedSources();

    if (current.contains(source)) {
      // Don't allow deselecting if it's the only one
      if (current.length > 1) {
        current.remove(source);
      }
    } else {
      current.add(source);
    }

    await setSelectedSources(current);
    return current;
  }

  // --- Default Sort ---

  /// Gets the default sort option.
  Future<String> getDefaultSort() async {
    final prefs = await _ensurePrefs();
    return prefs.getString(_keyDefaultSort) ?? 'relevance';
  }

  /// Sets the default sort option.
  Future<void> setDefaultSort(String sortName) async {
    final prefs = await _ensurePrefs();
    await prefs.setString(_keyDefaultSort, sortName);
  }

  // --- Free Shipping Filter ---

  /// Gets the free shipping only preference.
  Future<bool> getFreeShippingOnly() async {
    final prefs = await _ensurePrefs();
    return prefs.getBool(_keyFreeShippingOnly) ?? false;
  }

  /// Sets the free shipping only preference.
  Future<void> setFreeShippingOnly(bool value) async {
    final prefs = await _ensurePrefs();
    await prefs.setBool(_keyFreeShippingOnly, value);
  }

  // --- Search History ---

  /// Gets the search history.
  Future<List<String>> getSearchHistory() async {
    final prefs = await _ensurePrefs();
    return prefs.getStringList(_keySearchHistory) ?? [];
  }

  /// Adds a keyword to search history.
  Future<void> addToSearchHistory(String keyword) async {
    final prefs = await _ensurePrefs();
    final history = await getSearchHistory();

    // Remove if already exists (to move it to the top)
    history.remove(keyword);

    // Add to the beginning
    history.insert(0, keyword);

    // Limit history size
    if (history.length > _maxSearchHistory) {
      history.removeRange(_maxSearchHistory, history.length);
    }

    await prefs.setStringList(_keySearchHistory, history);
  }

  /// Removes a keyword from search history.
  Future<void> removeFromSearchHistory(String keyword) async {
    final prefs = await _ensurePrefs();
    final history = await getSearchHistory();
    history.remove(keyword);
    await prefs.setStringList(_keySearchHistory, history);
  }

  /// Clears all search history.
  Future<void> clearSearchHistory() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(_keySearchHistory);
  }

  // --- Theme ---

  /// Gets the theme mode ('light', 'dark', or 'system').
  Future<String> getThemeMode() async {
    final prefs = await _ensurePrefs();
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  /// Sets the theme mode.
  Future<void> setThemeMode(String mode) async {
    final prefs = await _ensurePrefs();
    await prefs.setString(_keyThemeMode, mode);
  }

  // --- First Launch ---

  /// Checks if this is the first launch.
  Future<bool> isFirstLaunch() async {
    final prefs = await _ensurePrefs();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Marks that the app has been launched.
  Future<void> markLaunched() async {
    final prefs = await _ensurePrefs();
    await prefs.setBool(_keyFirstLaunch, false);
  }

  // --- All Settings ---

  /// Gets all settings as a map.
  Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'selectedSources': (await getSelectedSources()).map((s) => s.name).toList(),
      'defaultSort': await getDefaultSort(),
      'freeShippingOnly': await getFreeShippingOnly(),
      'themeMode': await getThemeMode(),
      'isFirstLaunch': await isFirstLaunch(),
    };
  }

  /// Resets all settings to defaults.
  Future<void> resetAllSettings() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(_keySelectedSources);
    await prefs.remove(_keyDefaultSort);
    await prefs.remove(_keyFreeShippingOnly);
    await prefs.remove(_keyThemeMode);
    // Note: Not resetting first launch or search history
  }
}
