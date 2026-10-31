import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MobileApiException implements Exception {
  const MobileApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class MobileApi {
  static const _configuredUrl = String.fromEnvironment('API_BASE_URL');
  static const _tokenKey = 'wg_mobile_token';

  static String get baseUrl => _configuredUrl.isNotEmpty
      ? _configuredUrl
      : kIsWeb
      ? 'http://10.0.2.2:8010/api.php'
      : 'http://192.168.0.116:8010/api.php';

  Future<String?> savedToken() async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);

  Future<bool> hasSession() async {
    final token = await savedToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> login(String studentId, String password) async {
    final login = await _request(
      'mobile-login',
      method: 'POST',
      body: {'student_id': studentId.trim(), 'password': password},
    );
    final token = login['token']?.toString() ?? '';
    if (token.isEmpty) {
      throw const MobileApiException('Login token was not returned');
    }
    await (await SharedPreferences.getInstance()).setString(_tokenKey, token);
    return dashboard(token);
  }

  Future<Map<String, dynamic>> dashboard([String? accessToken]) async {
    final token = accessToken ?? await savedToken();
    if (token == null || token.isEmpty) {
      throw const MobileApiException('Please sign in');
    }
    return _request('mobile-dashboard', token: token);
  }

  Future<Map<String, dynamic>> scanAttendance(String payload) async =>
      _authorizedPost('mobile-attendance-scan', {'payload': payload});

  Future<Map<String, dynamic>> prepareInvoicePayment(String invoiceId) async =>
      _authorizedPost('mobile-pay-invoice', {
        'operation': 'prepare',
        'invoice_id': invoiceId,
      });

  Future<Map<String, dynamic>> completeInvoicePayment(String invoiceId) async =>
      _authorizedPost('mobile-pay-invoice', {
        'operation': 'complete',
        'invoice_id': invoiceId,
      });

  Future<Map<String, dynamic>> uploadPaymentProof({
    required String invoiceId,
    required String reference,
    required String receiptImage,
  }) async => _authorizedPost('mobile-payment-proof', {
    'invoice_id': invoiceId,
    'reference': reference,
    'receipt_image': receiptImage,
  });

  Future<void> logout() async {
    final token = await savedToken();
    if (token != null && token.isNotEmpty) {
      try {
        await _request('mobile-logout', method: 'POST', token: token);
      } catch (_) {
        // Always clear the local token, even if the server is unavailable.
      }
    }
    await (await SharedPreferences.getInstance()).remove(_tokenKey);
  }

  Future<Map<String, dynamic>> _authorizedPost(
    String resource,
    Map<String, dynamic> body,
  ) async {
    final token = await savedToken();
    if (token == null || token.isEmpty) {
      throw const MobileApiException('Please sign in');
    }
    return _request(resource, method: 'POST', token: token, body: body);
  }

  Future<Map<String, dynamic>> _request(
    String resource, {
    String method = 'GET',
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(
      '$baseUrl?resource=${Uri.encodeQueryComponent(resource)}',
    );
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    if (token != null) headers['Authorization'] = 'Bearer $token';

    late http.Response response;
    try {
      response = method == 'POST'
          ? await http.post(uri, headers: headers, body: jsonEncode(body ?? {}))
          : await http.get(uri, headers: headers);
    } catch (_) {
      throw MobileApiException('Cannot connect to $baseUrl');
    }

    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const MobileApiException('The server returned an invalid response');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MobileApiException(
        payload['error']?.toString() ?? 'Request failed',
      );
    }
    return payload;
  }
}
