import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';

/// Provider for the settings service.
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

/// Provider for selected e-commerce sources.
final selectedSourcesProvider =
    StateNotifierProvider<SelectedSourcesNotifier, AsyncValue<List<EcSource>>>(
  (ref) => SelectedSourcesNotifier(ref.watch(settingsServiceProvider)),
);

class SelectedSourcesNotifier
    extends StateNotifier<AsyncValue<List<EcSource>>> {
  SelectedSourcesNotifier(this._settingsService)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final SettingsService _settingsService;

  Future<void> _load() async {
    try {
      await _settingsService.init();
      final sources = await _settingsService.getSelectedSources();
      state = AsyncValue.data(sources);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggle(EcSource source) async {
    final current = state.valueOrNull ?? [];
    try {
      final updated = await _settingsService.toggleSource(source);
      state = AsyncValue.data(updated);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(current);
    }
  }

  Future<void> setAll(List<EcSource> sources) async {
    try {
      await _settingsService.setSelectedSources(sources);
      state = AsyncValue.data(sources);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for search history.
final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, AsyncValue<List<String>>>(
  (ref) => SearchHistoryNotifier(ref.watch(settingsServiceProvider)),
);

class SearchHistoryNotifier extends StateNotifier<AsyncValue<List<String>>> {
  SearchHistoryNotifier(this._settingsService)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final SettingsService _settingsService;

  Future<void> _load() async {
    try {
      await _settingsService.init();
      final history = await _settingsService.getSearchHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(String keyword) async {
    try {
      await _settingsService.addToSearchHistory(keyword);
      final history = await _settingsService.getSearchHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> remove(String keyword) async {
    try {
      await _settingsService.removeFromSearchHistory(keyword);
      final history = await _settingsService.getSearchHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clear() async {
    try {
      await _settingsService.clearSearchHistory();
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for theme mode.
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AsyncValue<String>>(
  (ref) => ThemeModeNotifier(ref.watch(settingsServiceProvider)),
);

class ThemeModeNotifier extends StateNotifier<AsyncValue<String>> {
  ThemeModeNotifier(this._settingsService)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final SettingsService _settingsService;

  Future<void> _load() async {
    try {
      await _settingsService.init();
      final mode = await _settingsService.getThemeMode();
      state = AsyncValue.data(mode);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setMode(String mode) async {
    try {
      await _settingsService.setThemeMode(mode);
      state = AsyncValue.data(mode);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
