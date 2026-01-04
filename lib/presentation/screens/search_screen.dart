import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../providers/search_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/search_bar.dart';
import '../widgets/source_badge.dart';
import 'search_results_screen.dart';
import 'settings_screen.dart';

/// Main search screen with search bar and history.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  void _onSearch(String keyword) {
    ref.read(searchStateProvider.notifier).search(keyword);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchResultsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ショッピング比較'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              AppSearchBar(
                onSearch: _onSearch,
                autofocus: false,
              ),
              const SizedBox(height: 16),

              // Source selection
              _buildSourceSelection(),
              const SizedBox(height: 24),

              // Search history
              Expanded(
                child: _buildSearchHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceSelection() {
    final selectedSourcesAsync = ref.watch(selectedSourcesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '検索サイト',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 8),
        selectedSourcesAsync.when(
          data: (selectedSources) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final source in [EcSource.amazon, EcSource.rakuten, EcSource.yahoo])
                SourceChip(
                  source: source,
                  isSelected: selectedSources.contains(source),
                  onTap: () {
                    ref.read(selectedSourcesProvider.notifier).toggle(source);
                  },
                ),
            ],
          ),
          loading: () => const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, st) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildSearchHistory() {
    final historyAsync = ref.watch(searchHistoryProvider);

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return const EmptyDisplay(
            message: '検索履歴がありません\n商品名を入力して検索してください',
            icon: Icons.search,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '検索履歴',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(searchHistoryProvider.notifier).clear();
                  },
                  child: const Text('すべて削除'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final keyword = history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(keyword),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        ref.read(searchHistoryProvider.notifier).remove(keyword);
                      },
                    ),
                    onTap: () => _onSearch(keyword),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => ErrorDisplay(message: '$e'),
    );
  }
}
