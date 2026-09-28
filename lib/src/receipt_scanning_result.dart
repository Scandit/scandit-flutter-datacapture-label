/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result.dart';
import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result_type.dart';
import 'package:scandit_flutter_datacapture_label/src/receipt_scanning_line_item.dart';

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

  @override
  AdaptiveRecognitionResultType get resultType => AdaptiveRecognitionResultType.receipt;

  String? get storeName => _storeName;

  String? get storeCity => _storeCity;

  String? get storeAddress => _storeAddress;

  String? get date => _date;

  String? get time => _time;

  double? get paymentPreTaxTotal => _paymentPreTaxTotal;

  double? get paymentTax => _paymentTax;

  double? get paymentTotal => _paymentTotal;

  int? get loyaltyNumber => _loyaltyNumber;

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
}
