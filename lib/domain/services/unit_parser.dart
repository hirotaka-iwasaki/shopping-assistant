import '../../data/models/unit_info.dart';

/// Service for extracting unit information from product titles and descriptions.
class UnitParser {
  UnitParser._();

  /// Singleton instance
  static final UnitParser instance = UnitParser._();

  // Compound pattern: "500g×3袋", "2L×6本", "100ml×12本"
  static final _compoundPattern = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*(g|kg|ml|l|cc|リットル|ミリリットル|グラム|キロ)\s*[×xX✕]\s*(\d+)',
    caseSensitive: false,
  );

  // Weight pattern: "500g", "1.5kg", "500グラム"
  static final _weightPattern = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*(g|kg|キロ(?:グラム)?|グラム)(?![a-zA-Z])',
    caseSensitive: false,
  );

  // Volume pattern: "500ml", "2L", "350cc"
  static final _volumePattern = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*(ml|cc|l|リットル|ミリリットル)(?![a-zA-Z])',
    caseSensitive: false,
  );

  // Count pattern: "3個入り", "6本セット", "12缶", "24袋入"
  static final _countPattern = RegExp(
    r'(\d+)\s*(個|本|袋|缶|枚|パック|セット|入り?|箱|巻|粒|錠|包|玉|切れ|食|杯)',
    caseSensitive: false,
  );

  // Pack multiplier pattern for cases like "2個セット", "3パック"
  static final _packMultiplierPattern = RegExp(
    r'(\d+)\s*(個セット|本セット|袋セット|パック|箱セット|セット入り?)',
    caseSensitive: false,
  );

  /// Extracts unit information from product title and optional description.
  UnitInfo? parse(String title, {String? description}) {
    // Try compound pattern first (most specific)
    final compoundResult = _parseCompound(title);
    if (compoundResult != null) return compoundResult;

    // Try weight pattern
    final weightResult = _parseWeight(title);
    if (weightResult != null) {
      // Check for pack multiplier
      return _applyPackMultiplier(title, weightResult);
    }

    // Try volume pattern
    final volumeResult = _parseVolume(title);
    if (volumeResult != null) {
      return _applyPackMultiplier(title, volumeResult);
    }

    // Try count pattern
    final countResult = _parseCount(title);
    if (countResult != null) return countResult;

    // If title parsing failed and description is provided, try description
    if (description != null && description.isNotEmpty) {
      final descResult = parse(description);
      if (descResult != null) {
        // Lower confidence for description-based extraction
        return descResult.copyWith(
          confidence: descResult.confidence * 0.8,
        );
      }
    }

    return null;
  }

  /// Parses compound patterns like "500g×3袋"
  UnitInfo? _parseCompound(String text) {
    final match = _compoundPattern.firstMatch(text);
    if (match == null) return null;

    final quantity = _parseNumber(match.group(1)!);
    final unit = match.group(2)!.toLowerCase();
    final packCount = int.parse(match.group(3)!);

    final normalizedUnit = _normalizeUnit(unit);
    final normalizedQuantity = _convertToBaseUnit(quantity, unit);
    final totalQuantity = normalizedQuantity * packCount;

    return UnitInfo(
      quantity: quantity,
      unit: unit,
      packCount: packCount,
      totalQuantity: totalQuantity,
      normalizedUnit: normalizedUnit,
      method: ExtractMethod.regex,
      confidence: 0.95,
    );
  }

  /// Parses weight patterns like "500g", "1kg"
  UnitInfo? _parseWeight(String text) {
    final match = _weightPattern.firstMatch(text);
    if (match == null) return null;

    final quantity = _parseNumber(match.group(1)!);
    final unit = match.group(2)!.toLowerCase();

    final normalizedQuantity = _convertToBaseUnit(quantity, unit);

    return UnitInfo(
      quantity: quantity,
      unit: unit,
      packCount: 1,
      totalQuantity: normalizedQuantity,
      normalizedUnit: 'g',
      method: ExtractMethod.regex,
      confidence: 0.9,
    );
  }

  /// Parses volume patterns like "500ml", "2L"
  UnitInfo? _parseVolume(String text) {
    final match = _volumePattern.firstMatch(text);
    if (match == null) return null;

    final quantity = _parseNumber(match.group(1)!);
    final unit = match.group(2)!.toLowerCase();

    final normalizedQuantity = _convertToBaseUnit(quantity, unit);

    return UnitInfo(
      quantity: quantity,
      unit: unit,
      packCount: 1,
      totalQuantity: normalizedQuantity,
      normalizedUnit: 'ml',
      method: ExtractMethod.regex,
      confidence: 0.9,
    );
  }

  /// Parses count patterns like "3個入り", "6本"
  UnitInfo? _parseCount(String text) {
    final match = _countPattern.firstMatch(text);
    if (match == null) return null;

    final quantity = double.parse(match.group(1)!);
    final unit = match.group(2)!;

    // Skip if it's likely not a product quantity (e.g., review count)
    if (_isLikelyNotQuantity(text, match)) return null;

    return UnitInfo(
      quantity: quantity,
      unit: unit,
      packCount: 1,
      totalQuantity: quantity,
      normalizedUnit: '個',
      method: ExtractMethod.regex,
      confidence: 0.85,
    );
  }

  /// Applies pack multiplier if found (e.g., "500g 2個セット" -> 1000g total)
  UnitInfo _applyPackMultiplier(String text, UnitInfo baseInfo) {
    final match = _packMultiplierPattern.firstMatch(text);
    if (match == null) return baseInfo;

    final multiplier = int.parse(match.group(1)!);

    // Avoid applying multiplier if it's the same as the base quantity
    if (multiplier == baseInfo.quantity.toInt()) return baseInfo;

    return baseInfo.copyWith(
      packCount: multiplier,
      totalQuantity: baseInfo.totalQuantity * multiplier,
      confidence: baseInfo.confidence * 0.95, // Slightly lower confidence
    );
  }

  /// Parses number string, handling both "." and "," as decimal separators.
  double _parseNumber(String str) {
    return double.parse(str.replaceAll(',', '.'));
  }

  /// Normalizes unit to base unit type.
  String _normalizeUnit(String unit) {
    final lower = unit.toLowerCase();

    // Weight units
    if (['g', 'kg', 'グラム', 'キロ', 'キログラム'].contains(lower)) {
      return 'g';
    }

    // Volume units
    if (['ml', 'cc', 'l', 'リットル', 'ミリリットル'].contains(lower)) {
      return 'ml';
    }

    return '個';
  }

  /// Converts quantity to base unit (g for weight, ml for volume).
  double _convertToBaseUnit(double quantity, String unit) {
    final lower = unit.toLowerCase();

    // kg to g
    if (lower == 'kg' || lower == 'キロ' || lower == 'キログラム') {
      return quantity * 1000;
    }

    // L to ml
    if (lower == 'l' || lower == 'リットル') {
      return quantity * 1000;
    }

    return quantity;
  }

  /// Checks if the matched count is likely not a product quantity.
  bool _isLikelyNotQuantity(String text, RegExpMatch match) {
    final beforeMatch = text.substring(0, match.start).toLowerCase();

    // Skip if preceded by review-related words
    if (beforeMatch.contains('レビュー') ||
        beforeMatch.contains('評価') ||
        beforeMatch.contains('★') ||
        beforeMatch.contains('件')) {
      return true;
    }

    return false;
  }
}
