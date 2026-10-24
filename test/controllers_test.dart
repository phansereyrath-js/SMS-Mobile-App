import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pastel_auth_ui/controllers/attendance_controller.dart';
import 'package:pastel_auth_ui/controllers/auth_controller.dart';
import 'package:pastel_auth_ui/controllers/dashboard_controller.dart';
import 'package:pastel_auth_ui/controllers/payment_controller.dart';
import 'package:pastel_auth_ui/controllers/workflow_controller.dart';
import 'package:pastel_auth_ui/services/mobile_api.dart';

class _Api extends MobileApi {
  final loginResult = Completer<Map<String, dynamic>>();
  int loginCalls = 0;
  int attendanceCalls = 0;
  int uploadCalls = 0;
  @override
  Future<Map<String, dynamic>> login(String studentId, String password) {
    loginCalls++;
    return loginResult.future;
  }

  @override
  Future<Map<String, dynamic>> scanAttendance(String payload) async {
    attendanceCalls++;
    return {'session': 'Morning', 'state': 'Present'};
  }

  @override
  Future<Map<String, dynamic>> uploadPaymentProof({
    required String invoiceId,
    required String reference,
    required String receiptImage,
  }) async {
    uploadCalls++;
    return {};
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'login blocks duplicate requests and clears busy after failure',
    () async {
      final api = _Api();
      final controller = AuthController(api: api);
      final request = controller.login('ST-1', 'password');
      expect(controller.busy.value, isTrue);
      expect(await controller.login('ST-1', 'password'), isFalse);
      final assertion = expectLater(
        request,
        throwsA(isA<MobileApiException>()),
      );
      api.loginResult.completeError(const MobileApiException('Invalid login'));
      await assertion;
      expect(api.loginCalls, 1);
      expect(controller.busy.value, isFalse);
      controller.onDelete();
    },
  );
  test(
    'workflow ignores an older response that finishes after a retry',
    () async {
      final requests = <Completer<Map<String, dynamic>>>[];
      final controller = WorkflowController(
        loadDashboard: () {
          final request = Completer<Map<String, dynamic>>();
          requests.add(request);
          return request.future;
        },
      );
      final first = controller.reload();
      await Future<void>.delayed(Duration.zero);
      final second = controller.reload();
      await Future<void>.delayed(Duration.zero);
      requests[1].complete({'version': 2});
      await second;
      requests[0].complete({'version': 1});
      await first;
      expect(controller.data.value?['version'], 2);
      expect(controller.loading.value, isFalse);
      controller.onDelete();
    },
  );
  test('workflow can retry after a failed request', () async {
    var fail = true;
    final controller = WorkflowController(
      loadDashboard: () async {
        if (fail) throw const MobileApiException('Offline');
        return {
          'student': {'id': 'ST-1'},
        };
      },
    );
    await controller.reload();
    expect(controller.error.value, isA<MobileApiException>());
    fail = false;
    await controller.reload();
    expect(controller.error.value, isNull);
    expect(controller.data.value, isNotNull);
    controller.onDelete();
  });
  test('dashboard loads academic data with notifications disabled', () async {
    SharedPreferences.setMockInitialValues({'app.notifications': false});
    final controller = DashboardController(
      loadDashboard: () async => {
        'academic_summary': {'gpa': 3.5},
      },
    );
    await controller.reload();
    expect(controller.data['academic_summary']['gpa'], 3.5);
    expect(controller.unreadCount.value, 0);
    controller.onDelete();
  });
  test('successful attendance cannot be submitted twice', () async {
    final api = _Api();
    final controller = AttendanceController(api: api);
    expect(await controller.record('school-qr'), isNotNull);
    expect(await controller.record('school-qr'), isNull);
    expect(api.attendanceCalls, 1);
    controller.onDelete();
  });
  test('oversized receipt is rejected before sending a request', () async {
    final api = _Api();
    final controller = PaymentController(api: api);
    await expectLater(
      controller.submitReceipt(
        invoiceId: '1',
        reference: 'REF',
        bytes: Uint8List(5 * 1024 * 1024 + 1),
        mimeType: 'image/jpeg',
      ),
      throwsA(isA<MobileApiException>()),
    );
    expect(api.uploadCalls, 0);
    expect(controller.busy.value, isFalse);
    controller.onDelete();
  });
}
