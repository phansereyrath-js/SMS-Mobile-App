import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/mobile_api.dart';
import '../services/notification_read_store.dart';

class DashboardController extends GetxController {
  DashboardController({required this.loadDashboard, MobileApi? api})
    : _api = api ?? MobileApi();
  final Future<Map<String, dynamic>> Function() loadDashboard;
  final MobileApi _api;
  final _notifications = NotificationReadStore();
  final data = <String, dynamic>{}.obs;
  final unreadCount = 0.obs;
  final language = 'English'.obs;

  Future<void> loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    if (!isClosed) {
      language.value = preferences.getString('app.language') ?? 'English';
    }
  }

  Future<void> reload() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final result = await loadDashboard().timeout(const Duration(seconds: 8));
      final count = (preferences.getBool('app.notifications') ?? true)
          ? await _notifications.unreadCount(result)
          : 0;
      if (isClosed) return;
      data.assignAll(result);
      unreadCount.value = count;
    } catch (_) {
      // Retain the last dashboard during a temporary connection failure.
    }
  }

  Future<void> logout() => _api.logout();
}
