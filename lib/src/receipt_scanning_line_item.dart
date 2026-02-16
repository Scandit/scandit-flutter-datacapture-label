/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

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

  String get name => _name;

  double? get unitPrice => _unitPrice;

  double? get discount => _discount;

  double get quantity => _quantity;

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
}
