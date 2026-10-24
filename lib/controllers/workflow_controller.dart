import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkflowController extends GetxController {
  WorkflowController({required this.loadDashboard});
  final Future<Map<String, dynamic>> Function() loadDashboard;
  final data = Rxn<Map<String, dynamic>>();
  final error = Rxn<Object>();
  final loading = true.obs;
  final language = 'English'.obs;
  int _requestId = 0;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    final requestId = ++_requestId;
    loading.value = true;
    error.value = null;
    try {
      final preferences = await SharedPreferences.getInstance();
      final result = await loadDashboard().timeout(const Duration(seconds: 8));
      if (isClosed || requestId != _requestId) return;
      language.value = preferences.getString('app.language') ?? 'English';
      data.value = result;
    } catch (exception) {
      if (!isClosed && requestId == _requestId) error.value = exception;
    } finally {
      if (!isClosed && requestId == _requestId) loading.value = false;
    }
  }
}
