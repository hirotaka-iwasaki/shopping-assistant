import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Loading indicator with optional message.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading indicator for search results.
class SearchLoadingIndicator extends StatelessWidget {
  const SearchLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('商品を検索中...'),
        ],
      ),
    );
  }
}

/// Error display widget.
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('再試行'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state display.
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.search_off,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Source-specific status indicator.
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(colorScheme),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBorderColor(colorScheme),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(colorScheme),
          const SizedBox(width: 8),
          Text(
            source.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getTextColor(colorScheme),
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 4),
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
        Icons.error_outline,
        size: 16,
        color: colorScheme.error,
      );
    }

    return Icon(
      Icons.check_circle,
      size: 16,
      color: Colors.green.shade600,
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
