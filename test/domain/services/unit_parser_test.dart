import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_assistant/data/models/unit_info.dart';
import 'package:shopping_assistant/domain/services/unit_parser.dart';

void main() {
  late UnitParser parser;

  setUp(() {
    parser = UnitParser.instance;
  });

  group('UnitParser.parse', () {
    group('Weight patterns', () {
      test('parses simple gram pattern', () {
        final result = parser.parse('AGF ちょっと贅沢な珈琲店 500g');

        expect(result, isNotNull);
        expect(result!.quantity, 500);
        expect(result.unit, 'g');
        expect(result.totalQuantity, 500);
        expect(result.normalizedUnit, 'g');
        expect(result.method, ExtractMethod.regex);
        expect(result.confidence, greaterThanOrEqualTo(0.9));
      });

      test('parses kilogram pattern', () {
        final result = parser.parse('コーヒー豆 1kg');

        expect(result, isNotNull);
        expect(result!.quantity, 1);
        expect(result.unit, 'kg');
        expect(result.totalQuantity, 1000); // Converted to grams
        expect(result.normalizedUnit, 'g');
      });

      test('parses Japanese gram pattern', () {
        final result = parser.parse('お茶 100グラム');

        expect(result, isNotNull);
        expect(result!.quantity, 100);
        expect(result.normalizedUnit, 'g');
      });

      test('parses decimal weight', () {
        final result = parser.parse('コーヒー 1.5kg');

        expect(result, isNotNull);
        expect(result!.quantity, 1.5);
        expect(result.totalQuantity, 1500);
      });
    });

    group('Volume patterns', () {
      test('parses milliliter pattern', () {
        final result = parser.parse('サントリー 天然水 500ml');

        expect(result, isNotNull);
        expect(result!.quantity, 500);
        expect(result.unit, 'ml');
        expect(result.normalizedUnit, 'ml');
      });

      test('parses liter pattern', () {
        final result = parser.parse('お茶 2L');

        expect(result, isNotNull);
        expect(result!.quantity, 2);
        expect(result.totalQuantity, 2000); // Converted to ml
        expect(result.normalizedUnit, 'ml');
      });

      test('parses cc pattern', () {
        final result = parser.parse('飲料 350cc');

        expect(result, isNotNull);
        expect(result!.quantity, 350);
        expect(result.normalizedUnit, 'ml');
      });
    });

    group('Count patterns', () {
      test('parses 個入り pattern', () {
        final result = parser.parse('みかん 10個入り');

        expect(result, isNotNull);
        expect(result!.quantity, 10);
        expect(result.normalizedUnit, '個');
      });

      test('parses 本セット pattern', () {
        final result = parser.parse('ビール 6本セット');

        expect(result, isNotNull);
        expect(result!.quantity, 6);
        expect(result.normalizedUnit, '個');
      });

      test('parses 缶 pattern', () {
        final result = parser.parse('コーラ 24缶');

        expect(result, isNotNull);
        expect(result!.quantity, 24);
        expect(result.normalizedUnit, '個');
      });
    });

    group('Compound patterns', () {
      test('parses g×count pattern', () {
        final result = parser.parse('コーヒー 200g×3袋');

        expect(result, isNotNull);
        expect(result!.quantity, 200);
        expect(result.packCount, 3);
        expect(result.totalQuantity, 600);
        expect(result.normalizedUnit, 'g');
        expect(result.confidence, greaterThanOrEqualTo(0.9));
      });

      test('parses L×count pattern', () {
        final result = parser.parse('天然水 2L×6本');

        expect(result, isNotNull);
        expect(result!.quantity, 2);
        expect(result.packCount, 6);
        expect(result.totalQuantity, 12000); // 2000ml × 6
        expect(result.normalizedUnit, 'ml');
      });

      test('parses ml×count pattern', () {
        final result = parser.parse('お茶 500ml×24本');

        expect(result, isNotNull);
        expect(result!.quantity, 500);
        expect(result.packCount, 24);
        expect(result.totalQuantity, 12000);
      });

      test('handles ✕ multiplication symbol', () {
        final result = parser.parse('水 500ml✕12');

        expect(result, isNotNull);
        expect(result!.packCount, 12);
      });

      test('handles x multiplication symbol', () {
        final result = parser.parse('ジュース 1Lx6');

        expect(result, isNotNull);
        expect(result!.packCount, 6);
      });
    });

    group('Edge cases', () {
      test('returns null for no pattern match', () {
        final result = parser.parse('普通の商品名');

        expect(result, isNull);
      });

      test('handles multiple patterns - takes compound first', () {
        final result = parser.parse('コーヒー 500g×3袋 お得セット');

        expect(result, isNotNull);
        expect(result!.packCount, 3);
        expect(result.totalQuantity, 1500);
      });

      test('falls back to description when title has no match', () {
        final result = parser.parse(
          '美味しいコーヒー',
          description: '内容量：500g',
        );

        expect(result, isNotNull);
        expect(result!.quantity, 500);
        // Lower confidence for description-based extraction
        expect(result.confidence, lessThan(0.9));
      });
    });
  });

  group('UnitInfo', () {
    test('calculateUnitPrice calculates correctly for weight', () {
      const unitInfo = UnitInfo(
        quantity: 500,
        unit: 'g',
        packCount: 1,
        totalQuantity: 500,
        normalizedUnit: 'g',
        method: ExtractMethod.regex,
        confidence: 0.9,
      );

      // 1000 yen for 500g = 200 yen per 100g
      expect(unitInfo.calculateUnitPrice(1000), 200);
    });

    test('calculateUnitPrice calculates correctly for count', () {
      const unitInfo = UnitInfo(
        quantity: 6,
        unit: '本',
        packCount: 1,
        totalQuantity: 6,
        normalizedUnit: '個',
        method: ExtractMethod.regex,
        confidence: 0.9,
      );

      // 600 yen for 6 items = 100 yen per item
      expect(unitInfo.calculateUnitPrice(600), 100);
    });

    test('formatUnitPrice formats correctly', () {
      const unitInfo = UnitInfo(
        quantity: 500,
        unit: 'g',
        packCount: 1,
        totalQuantity: 500,
        normalizedUnit: 'g',
        method: ExtractMethod.regex,
        confidence: 0.9,
      );

      expect(unitInfo.formatUnitPrice(1000), '¥200/100g');
    });

    test('formatUnitPrice formats count items correctly', () {
      const unitInfo = UnitInfo(
        quantity: 6,
        unit: '本',
        packCount: 1,
        totalQuantity: 6,
        normalizedUnit: '個',
        method: ExtractMethod.regex,
        confidence: 0.9,
      );

      expect(unitInfo.formatUnitPrice(600), '¥100/個');
    });

    test('isHighConfidence returns true for high confidence', () {
      const unitInfo = UnitInfo(
        quantity: 500,
        unit: 'g',
        packCount: 1,
        totalQuantity: 500,
        normalizedUnit: 'g',
        method: ExtractMethod.regex,
        confidence: 0.95,
      );

      expect(unitInfo.isHighConfidence, true);
      expect(unitInfo.isMediumConfidence, false);
    });

    test('isMediumConfidence returns true for medium confidence', () {
      const unitInfo = UnitInfo(
        quantity: 500,
        unit: 'g',
        packCount: 1,
        totalQuantity: 500,
        normalizedUnit: 'g',
        method: ExtractMethod.llm,
        confidence: 0.7,
      );

      expect(unitInfo.isHighConfidence, false);
      expect(unitInfo.isMediumConfidence, true);
    });
  });
}
