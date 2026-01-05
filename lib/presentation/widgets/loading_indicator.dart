import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/theme/app_theme.dart';

/// Loading indicator with optional message.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading indicator for search results with mixi2-inspired animation.
class SearchLoadingIndicator extends StatefulWidget {
  const SearchLoadingIndicator({super.key});

  @override
  State<SearchLoadingIndicator> createState() => _SearchLoadingIndicatorState();
}

class _SearchLoadingIndicatorState extends State<SearchLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                Icons.search_rounded,
                size: 32,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),
          Text(
            '商品を検索中...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// Error display widget with mixi2-inspired design.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingXl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('再試行'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state display with mixi2-inspired design.
class EmptyDisplay extends StatelessWidget {
  const EmptyDisplay({
    super.key,
    required this.message,
    this.icon,
    this.action,
  });

  final String message;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Icon(
                icon ?? Icons.search_off_rounded,
                size: 40,
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppTheme.spacingXl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Source-specific status indicator with mixi2-inspired design.
class SourceStatusIndicator extends StatelessWidget {
  const SourceStatusIndicator({
    super.key,
    required this.source,
    required this.isLoading,
    this.error,
    this.count,
  });

  final EcSource source;
  final bool isLoading;
  final String? error;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(colorScheme),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: _getBorderColor(colorScheme),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(colorScheme),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            source.displayName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _getTextColor(colorScheme),
              fontSize: 13,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              '($count)',
              style: TextStyle(
                color: colorScheme.outline,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    if (isLoading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.primary,
        ),
      );
    }

    if (error != null) {
      return Icon(
        Icons.error_outline_rounded,
        size: 16,
        color: colorScheme.error,
      );
    }

    return Icon(
      Icons.check_circle_rounded,
      size: 16,
      color: AppTheme.success,
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (error != null) {
      return colorScheme.errorContainer.withOpacity(0.3);
    }
    return colorScheme.surfaceContainerHighest.withOpacity(0.5);
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    if (error != null) {
      return colorScheme.error.withOpacity(0.5);
    }
    return colorScheme.outline.withOpacity(0.3);
  }

  Color _getTextColor(ColorScheme colorScheme) {
    if (error != null) {
      return colorScheme.error;
    }
    return colorScheme.onSurface;
  }
}
