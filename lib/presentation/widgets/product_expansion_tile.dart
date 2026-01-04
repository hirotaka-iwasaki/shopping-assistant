import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import 'source_badge.dart';

/// Expandable product tile for unit price comparison.
///
/// Collapsed: Shows product image, title, effective price, and unit price.
/// Expanded: Shows full price details, shipping, points, reviews, and link.
class ProductExpansionTile extends StatelessWidget {
  const ProductExpansionTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sourceColor = _getSourceColor(product.source);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: sourceColor, width: 8),
          ),
        ),
        child: Theme(
          // Remove default divider and padding
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            childrenPadding: EdgeInsets.zero,
            leading: _buildThumbnail(colorScheme),
            title: _buildTitle(theme),
            subtitle: _buildPriceRow(theme, colorScheme),
            children: [
              _buildExpandedContent(context, theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSourceColor(EcSource source) {
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

  Widget _buildThumbnail(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 56,
        height: 56,
        child: product.imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.outline,
                    size: 24,
                  ),
                ),
              )
            : Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: colorScheme.outline,
                  size: 24,
                ),
              ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      product.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildPriceRow(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          // Effective price
          Text(
            '実質 ${product.formattedEffectivePrice}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Unit price
          if (product.formattedUnitPrice != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.formattedUnitPrice!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.hasMediumConfidenceUnitPrice)
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
      ),
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price details
          _buildDetailRow(
            icon: Icons.sell_outlined,
            label: '価格',
            value: product.formattedPrice,
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.local_shipping_outlined,
            label: '送料',
            value: product.formattedShippingCost,
            valueColor: product.isFreeShipping ? Colors.green : null,
            theme: theme,
            colorScheme: colorScheme,
          ),
          if (product.pointValue != null && product.pointValue! > 0) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.redeem_outlined,
              label: 'ポイント',
              value: '${product.pointValue}pt 還元',
              valueColor: Colors.orange,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
          if (product.reviewScore != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.star_outline,
              label: 'レビュー',
              value: _formatReview(),
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
          if (product.storeName != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.store_outlined,
              label: '販売元',
              value: product.storeName!,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
          // Unit info confidence note
          if (product.hasMediumConfidenceUnitPrice) ...[
            const SizedBox(height: 8),
            Text(
              '* 単価は推定値です',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Link button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openProductPage(context),
              icon: SourceBadge(
                source: product.source,
                size: SourceBadgeSize.small,
              ),
              label: Text('${product.source.displayName}で見る'),
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
        const SizedBox(width: 8),
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
    final score = product.reviewScore!.toStringAsFixed(1);
    final count = product.reviewCount;
    if (count != null && count > 0) {
      return '★$score ($count件)';
    }
    return '★$score';
  }

  Future<void> _openProductPage(BuildContext context) async {
    final url = Uri.parse(product.productUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ページを開けませんでした')),
        );
      }
    }
  }
}
