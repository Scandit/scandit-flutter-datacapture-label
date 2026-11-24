/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result.dart';
import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result_type.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart' as schema;
import 'package:scandit_flutter_datacapture_label/src/receipt_scanning_line_item.dart';

/// Represents the result of a receipt scanning operation. It provides store information, payment details and a list of purchased items.
///
/// Added in version 8.2.0
class ReceiptScanningResult implements AdaptiveRecognitionResult {
  final String? _storeName;
  final String? _storeCity;
  final String? _storeAddress;
  final String? _date;
  final String? _time;
  final double? _paymentPreTaxTotal;
  final double? _paymentTax;
  final double? _paymentTotal;
  final int? _loyaltyNumber;
  final List<ReceiptScanningLineItem> _lineItems;

  ReceiptScanningResult._({
    String? storeName,
    String? storeCity,
    String? storeAddress,
    String? date,
    String? time,
    double? paymentPreTaxTotal,
    double? paymentTax,
    double? paymentTotal,
    int? loyaltyNumber,
    required List<ReceiptScanningLineItem> lineItems,
  })  : _storeName = storeName,
        _storeCity = storeCity,
        _storeAddress = storeAddress,
        _date = date,
        _time = time,
        _paymentPreTaxTotal = paymentPreTaxTotal,
        _paymentTax = paymentTax,
        _paymentTotal = paymentTotal,
        _loyaltyNumber = loyaltyNumber,
        _lineItems = lineItems;

  /// The type of the adaptive recognition result (Receipt).
  ///
  /// Added in version 8.2.0
  @override
  AdaptiveRecognitionResultType get resultType => AdaptiveRecognitionResultType.receipt;

  /// The name of the store or merchant as it appears on the receipt.
  ///
  /// Added in version 8.2.0
  String? get storeName => _storeName;

  /// The city where the store is located.
  ///
  /// Added in version 8.2.0
  String? get storeCity => _storeCity;

  /// Full address of the store (Street Number, Street, City, State, NPA).
  ///
  /// Added in version 8.2.0
  String? get storeAddress => _storeAddress;

  /// The date of the transaction as it appears on the receipt.
  ///
  /// Added in version 8.2.0
  String? get date => _date;

  /// The time of the transaction as it appears on the receipt.
  ///
  /// Added in version 8.2.0
  String? get time => _time;

  /// Total balance before taxes are applied.
  ///
  /// Added in version 8.2.0
  double? get paymentPreTaxTotal => _paymentPreTaxTotal;

  /// The total tax amount charged on the transaction.
  ///
  /// Added in version 8.2.0
  double? get paymentTax => _paymentTax;

  /// The total amount paid, including all items, taxes, and fees.
  ///
  /// Added in version 8.2.0
  double? get paymentTotal => _paymentTotal;

  /// The loyalty program number or identifier associated with the transaction, if present.
  ///
  /// Added in version 8.2.0
  int? get loyaltyNumber => _loyaltyNumber;

  /// A list of all line items (purchased products) identified in the receipt.
  ///
  /// Added in version 8.2.0
  List<ReceiptScanningLineItem> get lineItems => _lineItems;

  factory ReceiptScanningResult.fromJSON(Map<String, dynamic> json) {
    final lineItemsJson = json['lineItems'] as List<dynamic>? ?? [];
    final lineItems = lineItemsJson.map((e) => ReceiptScanningLineItem.fromJSON(e as Map<String, dynamic>)).toList();

    return ReceiptScanningResult._(
      storeName: json['storeName'] as String?,
      storeCity: json['storeCity'] as String?,
      storeAddress: json['storeAddress'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      paymentPreTaxTotal: (json['paymentPreTaxTotal'] as num?)?.toDouble(),
      paymentTax: (json['paymentTax'] as num?)?.toDouble(),
      paymentTotal: (json['paymentTotal'] as num?)?.toDouble(),
      loyaltyNumber: json['loyaltyNumber'] as int?,
      lineItems: lineItems,
    );
  }

  // Single-parse path (SDC-34081): builds from the already schema-validated
  // generated type instead of re-parsing the raw payload a second time.
  ReceiptScanningResult._fromGenerated(schema.ReceiptScanningResult src)
      : this._(
          storeName: src.storeName,
          storeCity: src.storeCity,
          storeAddress: src.storeAddress,
          date: src.date,
          time: src.time,
          paymentPreTaxTotal: src.paymentPreTaxTotal,
          paymentTax: src.paymentTax,
          paymentTotal: src.paymentTotal,
          loyaltyNumber: src.loyaltyNumber,
          lineItems: (src.lineItems ?? []).map((e) => receiptScanningLineItemFromGenerated(e)).toList(),
        );
}

// Kept top-level (not a factory on the class) so the barrel's `show ReceiptScanningResult`
// export cannot surface it: only class members are re-exported by `show`. [SDC-34081]
ReceiptScanningResult receiptScanningResultFromGenerated(schema.ReceiptScanningResult src) =>
    ReceiptScanningResult._fromGenerated(src);
