import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/data.dart';
import 'source_badge.dart';

/// Card widget displaying a product with mixi2-inspired design.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: AppTheme.animFast,
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image and badge
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      // Product image
                      Positioned.fill(
                        child: Container(
                          color: colorScheme.surfaceContainerHighest,
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
                      ),
                      // Source badge
                      Positioned(
                        top: AppTheme.spacingSm,
                        left: AppTheme.spacingSm,
                        child: SourceBadge(
                          source: widget.product.source,
                          size: SourceBadgeSize.small,
                        ),
                      ),
                      // Out of stock overlay
                      if (!widget.product.inStock)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMd,
                                  vertical: AppTheme.spacingXs,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusSm),
                                ),
                                child: Text(
                                  '在庫なし',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Product info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        // Final price (most prominent)
                        Row(
                          children: [
                            Icon(
                              Icons.payments_rounded,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: AppTheme.spacingXs),
                            Flexible(
                              child: Text(
                                widget.product.formattedEffectivePrice,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Base price
                        _buildInfoRow(
                          icon: Icons.sell_outlined,
                          iconColor: colorScheme.outline,
                          text: widget.product.formattedPrice,
                          textColor: colorScheme.outline,
                          theme: theme,
                        ),
                        // Shipping
                        _buildInfoRow(
                          icon: Icons.local_shipping_outlined,
                          iconColor: widget.product.isFreeShipping
                              ? AppTheme.success
                              : colorScheme.outline,
                          text: widget.product.isFreeShipping
                              ? '無料'
                              : widget.product.formattedShippingCost,
                          textColor: widget.product.isFreeShipping
                              ? AppTheme.success
                              : colorScheme.outline,
                          theme: theme,
                        ),
                        // Points
                        if (widget.product.pointValue != null &&
                            widget.product.pointValue! > 0)
                          _buildInfoRow(
                            icon: Icons.redeem_outlined,
                            iconColor: AppTheme.warning,
                            text: '${widget.product.pointValue}pt',
                            textColor: AppTheme.warning,
                            theme: theme,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacingXs),
      child: Row(
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: AppTheme.spacingXs),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.labelSmall?.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal product card for list view with mixi2-inspired design.
class ProductListTile extends StatefulWidget {
  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: AppTheme.animFast,
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: widget.product.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.product.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.outline,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported_outlined,
                              color: colorScheme.outline,
                            ),
                          )
                        : Icon(
                            Icons.shopping_bag_outlined,
                            color: colorScheme.outline,
                          ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  // Content
                  Expanded(
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
                        const SizedBox(height: AppTheme.spacingSm),
                        // Price row
                        Row(
                          children: [
                            Text(
                              widget.product.formattedPrice,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingSm),
                            if (widget.product.isFreeShipping)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.success,
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusFull),
                                ),
                                child: Text(
                                  '送料無料',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
