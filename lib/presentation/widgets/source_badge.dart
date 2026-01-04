import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Badge widget displaying the e-commerce source.
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
      ),
      child: Text(
        _getShortName(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size.fontSize,
          fontWeight: FontWeight.bold,
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
  small(fontSize: 10, horizontalPadding: 6, verticalPadding: 2, borderRadius: 4),
  medium(fontSize: 12, horizontalPadding: 8, verticalPadding: 4, borderRadius: 6),
  large(fontSize: 14, horizontalPadding: 12, verticalPadding: 6, borderRadius: 8);

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

/// Chip for selecting/deselecting a source.
class SourceChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(source.displayName),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: _getSelectedColor().withOpacity(0.2),
      checkmarkColor: _getSelectedColor(),
      labelStyle: TextStyle(
        color: isSelected ? _getSelectedColor() : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Color _getSelectedColor() {
    switch (source) {
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
