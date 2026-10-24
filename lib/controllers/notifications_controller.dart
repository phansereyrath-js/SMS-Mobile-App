import '../services/notification_read_store.dart';
import 'workflow_controller.dart';

import 'package:get/get.dart';

class NotificationsController extends WorkflowController {
  NotificationsController({required super.loadDashboard});
  final store = NotificationReadStore();
  final unreadKeys = <String>{}.obs;

  @override
  Future<void> reload() async {
    await super.reload();
    final result = data.value;
    if (result == null || isClosed) return;
    final keys = await store.unreadKeys(result);
    if (!isClosed) unreadKeys.assignAll(keys);
  }

  Future<void> markRead(Map<String, dynamic> row, String type) async {
    final key = store.itemKey(row, type);
    await store.markRead(key);
    if (!isClosed) unreadKeys.remove(key);
  }
}
