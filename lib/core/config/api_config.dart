/// API endpoint configurations for each e-commerce platform.
class ApiConfig {
  ApiConfig._();

  // Amazon PA-API v5
  static const String amazonBaseUrl =
      'https://webservices.amazon.co.jp/paapi5';
  static const String amazonSearchEndpoint = '/searchitems';
  static const String amazonGetItemsEndpoint = '/getitems';

  // Rakuten Ichiba API
  static const String rakutenBaseUrl =
      'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601';

  // Yahoo Shopping API
  static const String yahooBaseUrl =
      'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch';

  // Common settings
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);

  // Rate limiting (requests per second)
  static const int amazonRateLimit = 1;
  static const int rakutenRateLimit = 1;
  static const int yahooRateLimit = 1;

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
