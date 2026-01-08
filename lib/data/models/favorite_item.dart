import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/exceptions.dart';
import 'product.dart';

part 'favorite_item.freezed.dart';
part 'favorite_item.g.dart';

/// Represents a favorited product with cached product data.
/// Product info is stored at the time of adding to favorites.
/// API re-fetch is attempted for latest price, but cached data is used as fallback.
@freezed
class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    /// Product ID (ASIN for Amazon, itemCode for Rakuten, code for Yahoo)
    required String productId,

    /// Source e-commerce platform
    required EcSource source,

    /// When the item was added to favorites
    required DateTime addedAt,

    /// Cached product data (stored at the time of adding)
    Product? cachedProduct,
  }) = _FavoriteItem;

  factory FavoriteItem.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemFromJson(json);

  /// Creates a FavoriteItem from a Product.
  factory FavoriteItem.fromProduct(Product product) => FavoriteItem(
        productId: product.id,
        source: product.source,
        addedAt: DateTime.now(),
        cachedProduct: product,
      );
}
