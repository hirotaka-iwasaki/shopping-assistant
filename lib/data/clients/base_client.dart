import '../models/product.dart';
import '../models/search_query.dart';

/// Base interface for all e-commerce API clients.
abstract class EcClient {
  /// Searches for products matching the query.
  Future<SearchResult> search(SearchQuery query);

  /// Gets a single product by its ID.
  Future<Product?> getProduct(String id);

  /// Disposes resources used by the client.
  void dispose();
}
