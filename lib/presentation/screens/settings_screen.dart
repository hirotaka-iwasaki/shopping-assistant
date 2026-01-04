import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../providers/settings_provider.dart';
import 'legal_screen.dart';

/// Settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          // Search sources section
          _SectionHeader(title: '検索サイト'),
          _buildSourcesSection(context, ref),
          const Divider(),

          // Theme section
          _SectionHeader(title: '表示設定'),
          _buildThemeSection(context, ref),
          const Divider(),

          // About section
          _SectionHeader(title: 'このアプリについて'),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildSourcesSection(BuildContext context, WidgetRef ref) {
    final selectedSourcesAsync = ref.watch(selectedSourcesProvider);

    return selectedSourcesAsync.when(
      data: (selectedSources) => Column(
        children: [
          for (final source in [EcSource.amazon, EcSource.rakuten, EcSource.yahoo])
            SwitchListTile(
              title: Text(source.displayName),
              subtitle: Text(_getSourceDescription(source)),
              value: selectedSources.contains(source),
              onChanged: (value) {
                ref.read(selectedSourcesProvider.notifier).toggle(source);
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '※少なくとも1つのサイトを選択してください',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
        ],
      ),
      loading: () => const ListTile(
        title: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => ListTile(
        title: Text('Error: $e'),
      ),
    );
  }

  String _getSourceDescription(EcSource source) {
    switch (source) {
      case EcSource.amazon:
        return 'Amazon.co.jp の商品を検索';
      case EcSource.rakuten:
        return '楽天市場の商品を検索';
      case EcSource.yahoo:
        return 'Yahoo!ショッピングの商品を検索';
      case EcSource.qoo10:
        return 'Qoo10の商品を検索（未対応）';
    }
  }

  Widget _buildThemeSection(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);

    return themeModeAsync.when(
      data: (themeMode) => Column(
        children: [
          _ThemeTile(
            title: 'システム設定に従う',
            value: 'system',
            groupValue: themeMode,
            onChanged: (value) => ref.read(themeModeProvider.notifier).setMode(value),
          ),
          _ThemeTile(
            title: 'ライトモード',
            value: 'light',
            groupValue: themeMode,
            onChanged: (value) => ref.read(themeModeProvider.notifier).setMode(value),
          ),
          _ThemeTile(
            title: 'ダークモード',
            value: 'dark',
            groupValue: themeMode,
            onChanged: (value) => ref.read(themeModeProvider.notifier).setMode(value),
          ),
        ],
      ),
      loading: () => const ListTile(
        title: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => ListTile(
        title: Text('Error: $e'),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('バージョン'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.policy_outlined),
          title: const Text('プライバシーポリシー'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('利用規約'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TermsOfServiceScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.storefront_outlined),
          title: const Text('アフィリエイトについて'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAffiliateDialog(context),
        ),
      ],
    );
  }

  void _showAffiliateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アフィリエイトについて'),
        content: const SingleChildScrollView(
          child: Text(
            'このアプリはアフィリエイトプログラムを利用しています。\n\n'
            '商品リンクをクリックして購入された場合、当アプリの運営者に報酬が支払われることがあります。\n\n'
            '対象プログラム:\n'
            '• Amazonアソシエイト\n'
            '• 楽天アフィリエイト\n'
            '• バリューコマース（Yahoo!ショッピング）\n\n'
            'この収益はアプリの開発・運営費用に充てられます。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(title),
      onTap: () => onChanged(value),
    );
  }
}
