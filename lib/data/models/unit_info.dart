import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_info.freezed.dart';
part 'unit_info.g.dart';

/// Represents extracted unit information for price comparison.
@freezed
class UnitInfo with _$UnitInfo {
  const factory UnitInfo({
    /// Numeric quantity (e.g., 500 for "500g")
    required double quantity,

    /// Original unit string (e.g., "g", "ml", "個")
    required String unit,

    /// Pack count for compound quantities (e.g., 3 for "500g×3袋")
    @Default(1) int packCount,

    /// Total quantity after multiplication (quantity × packCount)
    required double totalQuantity,

    /// Normalized unit for comparison ("g", "ml", or "個")
    required String normalizedUnit,

    /// How the unit info was extracted
    required ExtractMethod method,

    /// Confidence score (0.0 - 1.0)
    required double confidence,
  }) = _UnitInfo;

  const UnitInfo._();

  factory UnitInfo.fromJson(Map<String, dynamic> json) =>
      _$UnitInfoFromJson(json);

  /// Calculates unit price (e.g., per 100g or 100ml).
  /// For items counted in pieces, calculates per 1 item.
  double calculateUnitPrice(int price, {int per = 100}) {
    if (totalQuantity <= 0) return 0;
    if (normalizedUnit == '個') {
      // For countable items, calculate per 1 item
      return price / totalQuantity;
    }
    return (price / totalQuantity) * per;
  }

  /// Formats unit price for display (e.g., "¥198/100g").
  String formatUnitPrice(int price) {
    final unitPrice = calculateUnitPrice(price);
    if (normalizedUnit == '個') {
      return '¥${_formatNumber(unitPrice.round())}/個';
    }
    return '¥${_formatNumber(unitPrice.round())}/100$normalizedUnit';
  }

  /// Whether the confidence is high enough to display without warning.
  bool get isHighConfidence => confidence >= 0.9;

  /// Whether the confidence is medium (show with asterisk).
  bool get isMediumConfidence => confidence >= 0.5 && confidence < 0.9;

  /// Whether extraction failed or confidence is too low.
  bool get isLowConfidence => confidence < 0.5;

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}

/// Method used to extract unit information.
enum ExtractMethod {
  /// Extracted using regular expressions
  regex,

  /// Extracted using LLM analysis
  llm,

  /// Manually entered by user
  userInput,

  /// Retrieved from cache
  cached,

  /// Extraction failed
  unknown,
}
