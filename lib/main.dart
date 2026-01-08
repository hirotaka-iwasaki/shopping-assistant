import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/main_shell.dart';

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
      title: 'ヨコダン',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeModeAsync.when(
        data: (mode) => _getThemeMode(mode),
        loading: () => ThemeMode.system,
        error: (_, _) => ThemeMode.system,
      ),
      home: const MainShell(),
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
