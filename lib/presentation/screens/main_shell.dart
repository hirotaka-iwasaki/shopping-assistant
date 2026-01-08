import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/favorites_provider.dart';
import '../providers/navigation_provider.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

/// Global navigator keys for each tab.
final homeNavigatorKey = GlobalKey<NavigatorState>();
final favoritesNavigatorKey = GlobalKey<NavigatorState>();
final settingsNavigatorKey = GlobalKey<NavigatorState>();

/// Main shell widget with BottomNavigationBar.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabIndexProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Handle back button: pop within current tab's navigator
        final navigatorKey = _getNavigatorKey(currentIndex);
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            _TabNavigator(
              navigatorKey: homeNavigatorKey,
              child: const SearchScreen(),
            ),
            _TabNavigator(
              navigatorKey: favoritesNavigatorKey,
              child: const FavoritesScreen(),
            ),
            _TabNavigator(
              navigatorKey: settingsNavigatorKey,
              child: const SettingsScreen(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              if (index == currentIndex) {
                // Tap on current tab: pop to root
                final navigatorKey = _getNavigatorKey(index);
                navigatorKey.currentState?.popUntil((route) => route.isFirst);
              } else {
                ref.read(currentTabIndexProvider.notifier).state = index;
              }
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                activeIcon: Icon(Icons.search_rounded),
                label: 'ホーム',
              ),
              BottomNavigationBarItem(
                icon: _FavoritesIcon(
                  isActive: false,
                  count: favoritesCount,
                ),
                activeIcon: _FavoritesIcon(
                  isActive: true,
                  count: favoritesCount,
                ),
                label: 'お気に入り',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                activeIcon: Icon(Icons.settings_rounded),
                label: '設定',
              ),
            ],
          ),
        ),
      ),
    );
  }

  GlobalKey<NavigatorState> _getNavigatorKey(int index) {
    switch (index) {
      case 0:
        return homeNavigatorKey;
      case 1:
        return favoritesNavigatorKey;
      case 2:
        return settingsNavigatorKey;
      default:
        return homeNavigatorKey;
    }
  }
}

/// Navigator wrapper for each tab.
class _TabNavigator extends StatelessWidget {
  const _TabNavigator({
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => child,
          settings: settings,
        );
      },
    );
  }
}

/// Favorites icon with badge showing count.
class _FavoritesIcon extends StatelessWidget {
  const _FavoritesIcon({
    required this.isActive,
    required this.count,
  });

  final bool isActive;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isActive ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        ),
        if (count > 0)
          Positioned(
            right: -8,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 1,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              decoration: BoxDecoration(
                color: AppTheme.error,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
