import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/mobile_api.dart';

class AuthController extends GetxController {
  AuthController({MobileApi? api}) : _api = api ?? MobileApi();
  final MobileApi _api;
  final busy = false.obs;
  final faceBusy = false.obs;
  final faceLoginEnabled = false.obs;

  Future<void> loadFaceLogin() async {
    final preferences = await SharedPreferences.getInstance();
    final hasSession = await _api.hasSession();
    if (!isClosed) {
      faceLoginEnabled.value =
          (preferences.getBool('app.face_id') ?? false) && hasSession;
    }
  }

  Future<bool> login(String studentId, String password) async {
    if (busy.value) return false;
    busy.value = true;
    try {
      await _api.login(studentId, password);
      return !isClosed;
    } finally {
      if (!isClosed) busy.value = false;
    }
  }

  Future<bool> faceLogin() async {
    if (faceBusy.value) return false;
    if (kIsWeb) {
      throw const MobileApiException(
        'Secure Face Login is available in the iPhone and Android app.',
      );
    }
    if (!faceLoginEnabled.value || !await _api.hasSession()) {
      throw const MobileApiException(
        'Sign in with your password once, then enable Face ID in Settings.',
      );
    }
    faceBusy.value = true;
    try {
      final authentication = LocalAuthentication();
      if (!await authentication.isDeviceSupported()) return false;
      return await authentication.authenticate(
        localizedReason: 'Scan your face to sign in to Grandview School',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } finally {
      if (!isClosed) faceBusy.value = false;
    }
  }
}
