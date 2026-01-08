import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/search_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/search_bar.dart';
import 'main_shell.dart';
import 'search_results_screen.dart';

/// Main search screen with search bar and history.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  void _onSearch(String keyword) {
    ref.read(searchStateProvider.notifier).search(keyword);
    // Use tab navigator to keep BottomNavigationBar visible
    homeNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const SearchResultsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ヨコダン'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search history
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                ),
                child: _buildSearchHistory(),
              ),
            ),

            // Search bar at bottom
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: AppSearchBar(
                onSearch: _onSearch,
                autofocus: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    final historyAsync = ref.watch(searchHistoryProvider);

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return const EmptyDisplay(
            message: '検索履歴がありません\n商品名を入力して検索してください',
            icon: Icons.search_rounded,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '検索履歴',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
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
            const SizedBox(height: AppTheme.spacingSm),
            Expanded(
              child: ListView.separated(
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: AppTheme.spacingSm,
                ),
                itemBuilder: (context, index) {
                  final keyword = history[index];
                  return _HistoryItem(
                    keyword: keyword,
                    onTap: () => _onSearch(keyword),
                    onDelete: () {
                      ref.read(searchHistoryProvider.notifier).remove(keyword);
                    },
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

/// History item with mixi2-inspired design.
class _HistoryItem extends StatefulWidget {
  const _HistoryItem({
    required this.keyword,
    required this.onTap,
    required this.onDelete,
  });

  final String keyword;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: AppTheme.animFast,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingMd,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: colorScheme.outline,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  widget.keyword,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: colorScheme.outline,
                ),
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
