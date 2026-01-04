import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_assistant/core/core.dart';
import 'package:shopping_assistant/data/data.dart';

void main() {
  group('Product', () {
    test('effectivePrice calculates correctly with points', () {
      final product = Product(
        id: 'test-1',
        title: 'Test Product',
        price: 1000,
        imageUrl: 'https://example.com/image.jpg',
        productUrl: 'https://example.com/product',
        source: EcSource.rakuten,
        pointRate: 0.1, // 10%
        pointValue: 100,
        isFreeShipping: true,
      );

      // effectivePrice = price + shipping - points = 1000 + 0 - 100 = 900
      expect(product.effectivePrice, 900);
    });

    test('effectivePrice includes shipping cost', () {
      final product = Product(
        id: 'test-2',
        title: 'Test Product',
        price: 1000,
        imageUrl: 'https://example.com/image.jpg',
        productUrl: 'https://example.com/product',
        source: EcSource.amazon,
        shippingCost: 500,
        isFreeShipping: false,
      );

      // effectivePrice = price + shipping - points = 1000 + 500 - 0 = 1500
      expect(product.effectivePrice, 1500);
    });

    test('effectivePrice with free shipping ignores shippingCost', () {
      final product = Product(
        id: 'test-3',
        title: 'Test Product',
        price: 1000,
        imageUrl: 'https://example.com/image.jpg',
        productUrl: 'https://example.com/product',
        source: EcSource.yahoo,
        shippingCost: 500, // Should be ignored
        isFreeShipping: true,
      );

      expect(product.effectivePrice, 1000);
    });

    test('effectivePrice calculates points from rate if pointValue is null', () {
      final product = Product(
        id: 'test-4',
        title: 'Test Product',
        price: 1000,
        imageUrl: 'https://example.com/image.jpg',
        productUrl: 'https://example.com/product',
        source: EcSource.rakuten,
        pointRate: 0.05, // 5%
        isFreeShipping: true,
      );

      // points = 1000 * 0.05 = 50
      // effectivePrice = 1000 - 50 = 950
      expect(product.effectivePrice, 950);
    });

    test('formattedPrice formats correctly', () {
      final product = Product(
        id: 'test-5',
        title: 'Test Product',
        price: 12345,
        imageUrl: '',
        productUrl: '',
        source: EcSource.amazon,
      );

      expect(product.formattedPrice, '¥12,345');
    });

    test('formattedShippingCost shows free shipping', () {
      final product = Product(
        id: 'test-6',
        title: 'Test Product',
        price: 1000,
        imageUrl: '',
        productUrl: '',
        source: EcSource.amazon,
        isFreeShipping: true,
      );

      expect(product.formattedShippingCost, '送料無料');
    });

    test('formattedShippingCost shows shipping cost', () {
      final product = Product(
        id: 'test-7',
        title: 'Test Product',
        price: 1000,
        imageUrl: '',
        productUrl: '',
        source: EcSource.amazon,
        shippingCost: 550,
        isFreeShipping: false,
      );

      expect(product.formattedShippingCost, '送料 ¥550');
    });

    test('discountPercent calculates correctly', () {
      final product = Product(
        id: 'test-8',
        title: 'Test Product',
        price: 800,
        imageUrl: '',
        productUrl: '',
        source: EcSource.yahoo,
        originalPrice: 1000,
      );

      expect(product.discountPercent, 20);
    });

    test('discountPercent is null when no originalPrice', () {
      final product = Product(
        id: 'test-9',
        title: 'Test Product',
        price: 800,
        imageUrl: '',
        productUrl: '',
        source: EcSource.yahoo,
      );

      expect(product.discountPercent, isNull);
    });
  });

  group('SearchResult', () {
    test('empty creates valid empty result', () {
      final result = SearchResult.empty(
        EcSource.amazon,
        errorMessage: 'Test error',
      );

      expect(result.products, isEmpty);
      expect(result.totalCount, 0);
      expect(result.hasMore, false);
      expect(result.source, EcSource.amazon);
      expect(result.errorMessage, 'Test error');
    });
  });

  group('SearchQuery', () {
    test('nextPage increments page', () {
      const query = SearchQuery(keyword: 'test', page: 1);
      final nextQuery = query.nextPage();

      expect(nextQuery.page, 2);
      expect(nextQuery.keyword, 'test');
    });

    test('firstPage resets to page 1', () {
      const query = SearchQuery(keyword: 'test', page: 5);
      final firstQuery = query.firstPage();

      expect(firstQuery.page, 1);
    });

    test('hasFilters detects filters', () {
      const noFilters = SearchQuery(keyword: 'test');
      expect(noFilters.hasFilters, false);

      const withMinPrice = SearchQuery(keyword: 'test', minPrice: 100);
      expect(withMinPrice.hasFilters, true);

      const withFreeShipping = SearchQuery(keyword: 'test', freeShippingOnly: true);
      expect(withFreeShipping.hasFilters, true);
    });
  });
}
