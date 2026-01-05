import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/theme/app_theme.dart';

/// Badge widget displaying the e-commerce source with mixi2-inspired design.
class SourceBadge extends StatelessWidget {
  const SourceBadge({
    super.key,
    required this.source,
    this.size = SourceBadgeSize.medium,
  });

  final EcSource source;
  final SourceBadgeSize size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.horizontalPadding,
        vertical: size.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(size.borderRadius),
        boxShadow: [
          BoxShadow(
            color: _getBackgroundColor().withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _getShortName(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (source) {
      case EcSource.amazon:
        return const Color(0xFFFF9900); // Amazon orange
      case EcSource.rakuten:
        return const Color(0xFFBF0000); // Rakuten red
      case EcSource.yahoo:
        return const Color(0xFFFF0033); // Yahoo red
      case EcSource.qoo10:
        return const Color(0xFFE91E63); // Qoo10 pink
    }
  }

  String _getShortName() {
    switch (source) {
      case EcSource.amazon:
        return 'Amazon';
      case EcSource.rakuten:
        return '楽天';
      case EcSource.yahoo:
        return 'Yahoo!';
      case EcSource.qoo10:
        return 'Qoo10';
    }
  }
}

enum SourceBadgeSize {
  small(
    fontSize: 10,
    horizontalPadding: 8,
    verticalPadding: 4,
    borderRadius: AppTheme.radiusFull,
  ),
  medium(
    fontSize: 12,
    horizontalPadding: 10,
    verticalPadding: 5,
    borderRadius: AppTheme.radiusFull,
  ),
  large(
    fontSize: 14,
    horizontalPadding: 14,
    verticalPadding: 6,
    borderRadius: AppTheme.radiusFull,
  );

  const SourceBadgeSize({
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
  });

  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
}

/// Chip for selecting/deselecting a source with mixi2-inspired design.
class SourceChip extends StatefulWidget {
  const SourceChip({
    super.key,
    required this.source,
    required this.isSelected,
    required this.onTap,
  });

  final EcSource source;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<SourceChip> createState() => _SourceChipState();
}

class _SourceChipState extends State<SourceChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sourceColor = _getSelectedColor();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppTheme.animFast,
        child: AnimatedContainer(
          duration: AppTheme.animNormal,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? sourceColor.withOpacity(0.15)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color: widget.isSelected ? sourceColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected) ...[
                Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: sourceColor,
                ),
                const SizedBox(width: AppTheme.spacingXs),
              ],
              Text(
                widget.source.displayName,
                style: TextStyle(
                  color: widget.isSelected ? sourceColor : colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSelectedColor() {
    switch (widget.source) {
      case EcSource.amazon:
        return const Color(0xFFFF9900);
      case EcSource.rakuten:
        return const Color(0xFFBF0000);
      case EcSource.yahoo:
        return const Color(0xFFFF0033);
      case EcSource.qoo10:
        return const Color(0xFFE91E63);
    }
  }
}
