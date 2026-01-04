import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_assistant/core/core.dart';
import 'package:shopping_assistant/data/data.dart';
import 'package:shopping_assistant/domain/domain.dart';

void main() {
  late SearchService searchService;

  setUp(() {
    searchService = SearchService();
  });

  tearDown(() {
    searchService.dispose();
  });

  group('SearchService.validateQuery', () {
    test('validates empty keyword', () {
      const query = SearchQuery(keyword: '');
      final result = searchService.validateQuery(query);

      expect(result.isValid, false);
      expect(result.errors, contains('検索キーワードを入力してください'));
    });

    test('validates short keyword', () {
      const query = SearchQuery(keyword: 'a');
      final result = searchService.validateQuery(query);

      expect(result.isValid, false);
      expect(result.errors, contains('検索キーワードは2文字以上で入力してください'));
    });

    test('validates long keyword', () {
      final longKeyword = 'a' * 101;
      final query = SearchQuery(keyword: longKeyword);
      final result = searchService.validateQuery(query);

      expect(result.isValid, false);
      expect(result.errors, contains('検索キーワードは100文字以内で入力してください'));
    });

    test('validates negative minPrice', () {
      const query = SearchQuery(keyword: 'test', minPrice: -100);
      final result = searchService.validateQuery(query);

      expect(result.isValid, false);
      expect(result.errors, contains('最低価格は0以上で入力してください'));
    });

    test('validates minPrice > maxPrice', () {
      const query = SearchQuery(keyword: 'test', minPrice: 1000, maxPrice: 500);
      final result = searchService.validateQuery(query);

      expect(result.isValid, false);
      expect(result.errors, contains('最低価格は最高価格以下で入力してください'));
    });

    test('accepts valid query', () {
      const query = SearchQuery(
        keyword: 'iPhone',
        minPrice: 50000,
        maxPrice: 100000,
      );
      final result = searchService.validateQuery(query);

      expect(result.isValid, true);
      expect(result.errors, isEmpty);
    });
  });

  group('SearchService.sortProducts', () {
    final products = [
      Product(
        id: '1',
        title: 'Product A',
        price: 1000,
        imageUrl: '',
        productUrl: '',
        source: EcSource.amazon,
        pointValue: 100,
        reviewScore: 4.5,
      ),
      Product(
        id: '2',
        title: 'Product B',
        price: 500,
        imageUrl: '',
        productUrl: '',
        source: EcSource.rakuten,
        pointValue: 50,
        reviewScore: 3.0,
      ),
      Product(
        id: '3',
        title: 'Product C',
        price: 800,
        imageUrl: '',
        productUrl: '',
        source: EcSource.yahoo,
        pointValue: 200,
        reviewScore: 5.0,
      ),
    ];

    test('sorts by price ascending', () {
      final sorted = searchService.sortProducts(products, SortOption.priceAsc);

      expect(sorted[0].id, '2'); // 500 - 50 = 450
      expect(sorted[1].id, '3'); // 800 - 200 = 600
      expect(sorted[2].id, '1'); // 1000 - 100 = 900
    });

    test('sorts by price descending', () {
      final sorted = searchService.sortProducts(products, SortOption.priceDesc);

      expect(sorted[0].id, '1'); // 900
      expect(sorted[1].id, '3'); // 600
      expect(sorted[2].id, '2'); // 450
    });

    test('sorts by points descending', () {
      final sorted = searchService.sortProducts(products, SortOption.pointsDesc);

      expect(sorted[0].id, '3'); // 200 points
      expect(sorted[1].id, '1'); // 100 points
      expect(sorted[2].id, '2'); // 50 points
    });

    test('sorts by review descending', () {
      final sorted = searchService.sortProducts(products, SortOption.reviewDesc);

      expect(sorted[0].id, '3'); // 5.0
      expect(sorted[1].id, '1'); // 4.5
      expect(sorted[2].id, '2'); // 3.0
    });
  });

  group('SearchService.filterProducts', () {
    final products = [
      Product(
        id: '1',
        title: 'Product A',
        price: 1000,
        imageUrl: '',
        productUrl: '',
        source: EcSource.amazon,
        isFreeShipping: true,
        inStock: true,
      ),
      Product(
        id: '2',
        title: 'Product B',
        price: 500,
        imageUrl: '',
        productUrl: '',
        source: EcSource.rakuten,
        isFreeShipping: false,
        inStock: true,
      ),
      Product(
        id: '3',
        title: 'Product C',
        price: 800,
        imageUrl: '',
        productUrl: '',
        source: EcSource.yahoo,
        isFreeShipping: true,
        inStock: false,
      ),
    ];

    test('filters by minPrice', () {
      final filtered = searchService.filterProducts(products, minPrice: 600);

      expect(filtered.length, 2);
      expect(filtered.any((p) => p.id == '2'), false);
    });

    test('filters by maxPrice', () {
      final filtered = searchService.filterProducts(products, maxPrice: 800);

      expect(filtered.length, 2);
      expect(filtered.any((p) => p.id == '1'), false);
    });

    test('filters by freeShippingOnly', () {
      final filtered = searchService.filterProducts(products, freeShippingOnly: true);

      expect(filtered.length, 2);
      expect(filtered.every((p) => p.isFreeShipping), true);
    });

    test('filters by inStockOnly', () {
      final filtered = searchService.filterProducts(products, inStockOnly: true);

      expect(filtered.length, 2);
      expect(filtered.every((p) => p.inStock), true);
    });

    test('filters by sources', () {
      final filtered = searchService.filterProducts(
        products,
        sources: [EcSource.amazon, EcSource.rakuten],
      );

      expect(filtered.length, 2);
      expect(filtered.any((p) => p.source == EcSource.yahoo), false);
    });

    test('combines multiple filters', () {
      final filtered = searchService.filterProducts(
        products,
        freeShippingOnly: true,
        inStockOnly: true,
      );

      expect(filtered.length, 1);
      expect(filtered.first.id, '1');
    });
  });

  group('SearchService.getPriceStats', () {
    test('calculates stats correctly', () {
      final products = [
        Product(
          id: '1',
          title: 'A',
          price: 1000,
          imageUrl: '',
          productUrl: '',
          source: EcSource.amazon,
        ),
        Product(
          id: '2',
          title: 'B',
          price: 500,
          imageUrl: '',
          productUrl: '',
          source: EcSource.rakuten,
        ),
        Product(
          id: '3',
          title: 'C',
          price: 800,
          imageUrl: '',
          productUrl: '',
          source: EcSource.yahoo,
        ),
      ];

      final stats = searchService.getPriceStats(products);

      expect(stats.minPrice, 500);
      expect(stats.maxPrice, 1000);
      expect(stats.avgPrice, 767); // (1000 + 500 + 800) / 3 = 766.67
    });

    test('returns zero stats for empty list', () {
      final stats = searchService.getPriceStats([]);

      expect(stats.minPrice, 0);
      expect(stats.maxPrice, 0);
      expect(stats.avgPrice, 0);
    });
  });
}
