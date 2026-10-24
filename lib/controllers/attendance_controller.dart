import 'package:get/get.dart';

import '../services/mobile_api.dart';

class AttendanceController extends GetxController {
  AttendanceController({MobileApi? api}) : _api = api ?? MobileApi();
  final MobileApi _api;
  final submitting = false.obs;
  final message = 'Scan the school attendance QR code'.obs;

  Future<Map<String, dynamic>?> record(String payload) async {
    if (submitting.value || payload.trim().isEmpty) return null;
    submitting.value = true;
    message.value = 'Checking attendance…';
    try {
      final result = await _api.scanAttendance(payload.trim());
      if (isClosed) return null;
      message.value =
          'Attendance recorded: ${result['session']} · ${result['state']}';
      // Keep scanning locked until the success view leaves the screen.
      return result;
    } catch (error) {
      if (!isClosed) {
        submitting.value = false;
        message.value = error is MobileApiException
            ? error.message
            : 'Unable to record attendance';
      }
      return null;
    }
  }
}
