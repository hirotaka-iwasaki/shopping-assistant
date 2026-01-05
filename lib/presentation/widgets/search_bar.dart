import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Custom search bar widget with mixi2-inspired pill design.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.initialValue,
    required this.onSearch,
    this.onChanged,
    this.hintText = '商品を検索',
    this.autofocus = false,
  });

  final String? initialValue;
  final ValueChanged<String> onSearch;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      widget.onSearch(trimmed);
      _focusNode.unfocus();
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppTheme.animNormal,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: _isFocused ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSubmitted,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 15,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: colorScheme.outline,
            fontSize: 15,
          ),
          prefixIcon: AnimatedContainer(
            duration: AppTheme.animNormal,
            child: Icon(
              Icons.search_rounded,
              color: _isFocused ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.cancel_rounded,
                  color: colorScheme.outline,
                  size: 20,
                ),
                onPressed: _clear,
              );
            },
          ),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingMd,
          ),
        ),
      ),
    );
  }
}

/// Search suggestions dropdown with mixi2-inspired design.
class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSelect,
    this.onDelete,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelect;
  final ValueChanged<String>? onDelete;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: AppTheme.spacingLg,
          endIndent: AppTheme.spacingLg,
          color: colorScheme.outlineVariant,
        ),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
            ),
            leading: Icon(
              Icons.history_rounded,
              color: colorScheme.outline,
              size: 20,
            ),
            title: Text(
              suggestion,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
            trailing: onDelete != null
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colorScheme.outline,
                    ),
                    onPressed: () => onDelete!(suggestion),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  )
                : null,
            onTap: () => onSelect(suggestion),
          );
        },
      ),
    );
  }
}
