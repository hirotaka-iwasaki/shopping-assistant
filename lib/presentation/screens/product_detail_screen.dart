import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/data.dart';
import '../providers/favorites_provider.dart';
import '../widgets/source_badge.dart';

/// Screen displaying product details.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  Future<void> _openProductPage() async {
    debugPrint('Opening URL: ${product.productUrl}');
    final uri = Uri.parse(product.productUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Cannot launch URL: ${product.productUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品詳細'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: colorScheme.surfaceContainerHighest,
                child: product.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported_outlined,
                          size: 64,
                          color: colorScheme.outline,
                        ),
                      )
                    : Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: colorScheme.outline,
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source badge and stock status
                  Row(
                    children: [
                      SourceBadge(source: product.source),
                      const Spacer(),
                      if (!product.inStock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '在庫なし',
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    product.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  // Store name
                  if (product.storeName != null) ...[
                    Text(
                      'ストア: ${product.storeName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Price section
                  _buildPriceSection(theme, colorScheme),
                  const SizedBox(height: 16),

                  // Points
                  if (product.formattedPoints != null) ...[
                    _buildInfoRow(
                      'ポイント',
                      '+${product.formattedPoints}',
                      valueColor: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Shipping
                  _buildInfoRow(
                    '送料',
                    product.formattedShippingCost,
                    valueColor: product.isFreeShipping ? Colors.green : null,
                  ),
                  const SizedBox(height: 16),

                  // Reviews
                  if (product.reviewScore != null) ...[
                    _buildReviewSection(theme, colorScheme),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    Text(
                      '商品説明',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // お気に入りボタン
              _FavoriteActionButton(product: product),
              const SizedBox(height: 12),
              // ショップで見るボタン
              FilledButton.icon(
                onPressed: _openProductPage,
                icon: const Icon(Icons.open_in_new),
                label: Text('${product.source.displayName}で見る'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original price (if discounted)
          if (product.originalPrice != null &&
              product.originalPrice! > product.price) ...[
            Row(
              children: [
                Text(
                  '定価: ¥${_formatNumber(product.originalPrice!)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${product.discountPercent}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],

          // Current price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.formattedPrice,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(税込)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),

          // Effective price
          if (product.effectivePrice != product.price) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.savings_outlined,
                  size: 18,
                  color: Colors.green.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  '実質 ${product.formattedEffectivePrice}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '(ポイント還元考慮)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        // Stars
        Row(
          children: List.generate(5, (index) {
            final filled = index < product.reviewScore!.floor();
            final half = index == product.reviewScore!.floor() &&
                product.reviewScore! % 1 >= 0.5;

            return Icon(
              half ? Icons.star_half : (filled ? Icons.star : Icons.star_border),
              size: 24,
              color: Colors.amber.shade700,
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          product.reviewScore!.toStringAsFixed(1),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (product.reviewCount != null) ...[
          const SizedBox(width: 8),
          Text(
            '(${product.reviewCount}件のレビュー)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}

/// Large favorite action button for bottom bar.
class _FavoriteActionButton extends ConsumerWidget {
  const _FavoriteActionButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider((product.id, product.source)));
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: () {
        ref.read(favoritesProvider.notifier).toggle(product);
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : colorScheme.onSurface,
      ),
      label: Text(isFavorite ? 'お気に入りから削除' : 'お気に入りに追加'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: isFavorite ? Colors.red : colorScheme.onSurface,
        side: BorderSide(
          color: isFavorite ? Colors.red.withValues(alpha: 0.5) : colorScheme.outline,
        ),
      ),
    );
  }
}
