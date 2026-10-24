import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../services/mobile_api.dart';

class PaymentController extends GetxController {
  PaymentController({MobileApi? api}) : _api = api ?? MobileApi();
  final MobileApi _api;
  final busy = false.obs;

  Future<Map<String, dynamic>?> prepare(String invoiceId) async {
    if (busy.value) return null;
    busy.value = true;
    try {
      return await _api.prepareInvoicePayment(invoiceId);
    } finally {
      if (!isClosed) busy.value = false;
    }
  }

  Future<bool> submitReceipt({
    required String invoiceId,
    required String reference,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    if (busy.value) return false;
    if (bytes.length > 5 * 1024 * 1024) {
      throw const MobileApiException('Receipt image must be 5 MB or smaller');
    }
    busy.value = true;
    try {
      await _api.uploadPaymentProof(
        invoiceId: invoiceId,
        reference: reference,
        receiptImage: 'data:$mimeType;base64,${base64Encode(bytes)}',
      );
      return !isClosed;
    } finally {
      if (!isClosed) busy.value = false;
    }
  }
}
