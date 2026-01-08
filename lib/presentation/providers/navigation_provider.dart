import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for current tab index in BottomNavigationBar.
final currentTabIndexProvider = StateProvider<int>((ref) => 0);

/// Tab indices for the main navigation.
class MainTabs {
  static const int home = 0;
  static const int favorites = 1;
  static const int settings = 2;
}
