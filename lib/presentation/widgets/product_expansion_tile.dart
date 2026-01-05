import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data.dart';
import 'source_badge.dart';

/// Expandable product tile for unit price comparison with mixi2-inspired design.
///
/// Collapsed: Shows product image, title, effective price, and unit price.
/// Expanded: Shows full price details, shipping, points, reviews, and link.
class ProductExpansionTile extends StatefulWidget {
  const ProductExpansionTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductExpansionTile> createState() => _ProductExpansionTileState();
}

class _ProductExpansionTileState extends State<ProductExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sourceColor = _getSourceColor(widget.product.source);

    return AnimatedContainer(
      duration: AppTheme.animNormal,
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: _isExpanded
              ? sourceColor.withOpacity(0.3)
              : colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: sourceColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Left accent bar + main content
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: sourceColor, width: 4),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildThumbnail(colorScheme),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(theme),
                            const SizedBox(height: AppTheme.spacingSm),
                            _buildPriceRow(theme, colorScheme),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: AppTheme.animNormal,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(context, theme, colorScheme),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppTheme.animNormal,
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }

  Color _getSourceColor(EcSource source) {
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

  Widget _buildThumbnail(ColorScheme colorScheme) {
    return Container(
      width: 56,
      height: 56,
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
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.outline,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.image_not_supported_outlined,
                color: colorScheme.outline,
                size: 24,
              ),
            )
          : Icon(
              Icons.shopping_bag_outlined,
              color: colorScheme.outline,
              size: 24,
            ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      widget.product.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(
        height: 1.3,
      ),
    );
  }

  Widget _buildPriceRow(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        // Effective price
        Text(
          '実質 ${widget.product.formattedEffectivePrice}',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        // Unit price
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
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      '*',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          Text(
            '単価 -',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price details
          _buildDetailRow(
            icon: Icons.sell_outlined,
            label: '価格',
            value: widget.product.formattedPrice,
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _buildDetailRow(
            icon: Icons.local_shipping_outlined,
            label: '送料',
            value: widget.product.formattedShippingCost,
            valueColor: widget.product.isFreeShipping ? AppTheme.success : null,
            theme: theme,
            colorScheme: colorScheme,
          ),
          if (widget.product.pointValue != null &&
              widget.product.pointValue! > 0) ...[
            const SizedBox(height: AppTheme.spacingSm),
            _buildDetailRow(
              icon: Icons.redeem_outlined,
              label: 'ポイント',
              value: '${widget.product.pointValue}pt 還元',
              valueColor: AppTheme.warning,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
          if (widget.product.reviewScore != null) ...[
            const SizedBox(height: AppTheme.spacingSm),
            _buildDetailRow(
              icon: Icons.star_outline_rounded,
              label: 'レビュー',
              value: _formatReview(),
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
          if (widget.product.storeName != null) ...[
            const SizedBox(height: AppTheme.spacingSm),
            _buildDetailRow(
              icon: Icons.store_outlined,
              label: '販売元',
              value: widget.product.storeName!,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
          // Unit info confidence note
          if (widget.product.hasMediumConfidenceUnitPrice) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              '* 単価は推定値です',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spacingLg),
          // Link button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openProductPage(context),
              icon: SourceBadge(
                source: widget.product.source,
                size: SourceBadgeSize.small,
              ),
              label: Text('${widget.product.source.displayName}で見る'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.outline),
        const SizedBox(width: AppTheme.spacingSm),
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  String _formatReview() {
    final score = widget.product.reviewScore!.toStringAsFixed(1);
    final count = widget.product.reviewCount;
    if (count != null && count > 0) {
      return '$score ($count件)';
    }
    return '$score';
  }

  Future<void> _openProductPage(BuildContext context) async {
    final url = Uri.parse(widget.product.productUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ページを開けませんでした'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
        );
      }
    }
  }
}
