import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/search_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ShoppingAssistantApp(),
    ),
  );
}

class ShoppingAssistantApp extends ConsumerWidget {
  const ShoppingAssistantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'ショッピング比較',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeModeAsync.when(
        data: (mode) => _getThemeMode(mode),
        loading: () => ThemeMode.system,
        error: (_, _) => ThemeMode.system,
      ),
      home: const SearchScreen(),
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
