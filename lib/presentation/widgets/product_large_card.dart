import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data.dart';
import '../screens/product_detail_screen.dart';
import 'favorite_button.dart';
import 'source_badge.dart';

/// Large product card for detailed view (1 column layout).
/// Shows all information at a glance without needing to expand.
class ProductLargeCard extends StatefulWidget {
  const ProductLargeCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductLargeCard> createState() => _ProductLargeCardState();
}

class _ProductLargeCardState extends State<ProductLargeCard> {
  bool _isPressed = false;

  Color _getSourceColor() {
    switch (widget.product.source) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sourceColor = _getSourceColor();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => _navigateToDetail(context),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: AppTheme.animFast,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Image + Price info
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: sourceColor, width: 4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large product image
                    _buildImage(colorScheme),
                    // Price and details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingMd),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Source badge
                            SourceBadge(
                              source: widget.product.source,
                              size: SourceBadgeSize.small,
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            // Title
                            Text(
                              widget.product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingMd),
                            // Effective price (prominent)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '実質 ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  widget.product.formattedEffectivePrice,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            // Unit price badge
                            if (widget.product.formattedUnitPrice != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: AppTheme.spacingXs,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.product.formattedUnitPrice!,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (widget.product.hasMediumConfidenceUnitPrice)
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                          fontSize: 10,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom section: Details grid
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  border: Border(
                    top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    // Price
                    _buildInfoChip(
                      icon: Icons.sell_outlined,
                      label: widget.product.formattedPrice,
                      color: colorScheme.onSurfaceVariant,
                      theme: theme,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    // Shipping
                    _buildInfoChip(
                      icon: Icons.local_shipping_outlined,
                      label: widget.product.isFreeShipping
                          ? '送料無料'
                          : widget.product.formattedShippingCost,
                      color: widget.product.isFreeShipping
                          ? AppTheme.success
                          : colorScheme.onSurfaceVariant,
                      theme: theme,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    // Points
                    if (widget.product.pointValue != null &&
                        widget.product.pointValue! > 0)
                      _buildInfoChip(
                        icon: Icons.redeem_outlined,
                        label: '${widget.product.pointValue}pt',
                        color: AppTheme.warning,
                        theme: theme,
                      ),
                    const Spacer(),
                    // Review
                    if (widget.product.reviewScore != null ||
                        widget.product.reviewCount != null)
                      _buildReviewChip(theme, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.product.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.outline,
                      size: 32,
                    ),
                  )
                : Icon(
                    Icons.shopping_bag_outlined,
                    color: colorScheme.outline,
                    size: 40,
                  ),
          ),
          // Out of stock overlay
          if (!widget.product.inStock)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: AppTheme.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                    ),
                    child: Text(
                      '在庫なし',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Favorite button
          Positioned(
            top: 4,
            right: 4,
            child: FavoriteButton(
              product: widget.product,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewChip(ThemeData theme, ColorScheme colorScheme) {
    final score = widget.product.reviewScore;
    final count = widget.product.reviewCount;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 14,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 2),
          if (score != null)
            Text(
              score.toStringAsFixed(1),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (count != null && count > 0) ...[
            const SizedBox(width: 4),
            Text(
              '($count)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: widget.product),
      ),
    );
  }
}
