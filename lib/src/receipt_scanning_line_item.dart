/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart' as schema;

/// Represents a single line item in a scanned receipt.
///
/// Added in version 8.2.0
class ReceiptScanningLineItem {
  final String _name;
  final double? _unitPrice;
  final double? _discount;
  final double _quantity;
  final double? _totalPrice;

  ReceiptScanningLineItem._({
    required String name,
    double? unitPrice,
    double? discount,
    required double quantity,
    double? totalPrice,
  })  : _name = name,
        _unitPrice = unitPrice,
        _discount = discount,
        _quantity = quantity,
        _totalPrice = totalPrice;

  /// The name or description of the item as it appears on the receipt.
  ///
  /// Added in version 8.2.0
  String get name => _name;

  /// Price for a single unit of the item. Is the same as the totalPrice if only one item is purchased.
  ///
  /// Added in version 8.2.0
  double? get unitPrice => _unitPrice;

  /// The discount amount applied to this item, if any.
  ///
  /// Added in version 8.2.0
  double? get discount => _discount;

  /// Quantity for the specific item.
  ///
  /// Added in version 8.2.0
  double get quantity => _quantity;

  /// Total Price for a specific product, quantity * unitPrice. Normally on the right of the item.
  ///
  /// Added in version 8.2.0
  double? get totalPrice => _totalPrice;

  factory ReceiptScanningLineItem.fromJSON(Map<String, dynamic> json) {
    return ReceiptScanningLineItem._(
      name: json['name'] as String,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );
  }

  // Single-parse path (SDC-34081): builds from the already schema-validated
  // generated type instead of re-parsing the raw payload a second time.
  // `!` keeps the public non-null contract `fromJSON`'s `as String` / `as num`
  // casts already imposed: omitting either throws on both paths, unchanged.
  ReceiptScanningLineItem._fromGenerated(schema.ReceiptScanningLineItem src)
      : this._(
          name: src.name!,
          unitPrice: src.unitPrice,
          discount: src.discount,
          quantity: src.quantity!,
          totalPrice: src.totalPrice,
        );
}

// Kept top-level (not a factory on the class) so the barrel's `show ReceiptScanningLineItem`
// export cannot surface it: only class members are re-exported by `show`. [SDC-34081]
ReceiptScanningLineItem receiptScanningLineItemFromGenerated(schema.ReceiptScanningLineItem src) =>
    ReceiptScanningLineItem._fromGenerated(src);
