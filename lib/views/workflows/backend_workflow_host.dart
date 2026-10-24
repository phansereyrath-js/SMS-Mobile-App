import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/workflow_controller.dart';

import '../../controllers/theme_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../services/mobile_api.dart';
import 'workflows.dart' as workflow;

Map<String, dynamic>? backendWorkflowTestData;

enum BackendWorkflow {
  wallet,
  scan,
  homework,
  payments,
  attendance,
  grades,
  timetable,
  progress,
  gallery,
  classes,
}

class BackendWorkflowHost extends StatefulWidget {
  const BackendWorkflowHost({super.key, required this.workflow});
  final BackendWorkflow workflow;

  @override
  State<BackendWorkflowHost> createState() => _BackendWorkflowHostState();
}

class _BackendWorkflowHostState extends State<BackendWorkflowHost> {
  late final WorkflowController _controller;
  String get _themeName => Get.find<ThemeController>().name.value;

  @override
  void initState() {
    super.initState();
    _controller = WorkflowController(
      loadDashboard: () async =>
          backendWorkflowTestData ?? await MobileApi().dashboard(),
    );
    _controller.onStart();
  }

  @override
  void dispose() {
    _controller.onDelete();
    super.dispose();
  }

  void _retry() => _controller.reload();

  Widget _page() => switch (widget.workflow) {
    BackendWorkflow.wallet => const workflow.SchoolFeesPage(),
    BackendWorkflow.scan => const workflow.QrScannerPage(),
    BackendWorkflow.homework => const workflow.HomeworkPage(),
    BackendWorkflow.payments => const workflow.PaymentRecordsPage(),
    BackendWorkflow.attendance => const workflow.AttendancePage(),
    BackendWorkflow.grades => const workflow.GradeReportsPage(),
    BackendWorkflow.timetable => const workflow.TimetablePage(),
    BackendWorkflow.progress => const workflow.StudentReportPage(),
    BackendWorkflow.gallery => const workflow.SchoolNewsPage(),
    BackendWorkflow.classes => const workflow.ClassesPage(),
  };

  workflow.StudentAccount _student(Map<String, dynamic> data) {
    final profile = Map<String, dynamic>.from(data['student'] as Map? ?? {});
    final name = '${profile['name_english'] ?? profile['name'] ?? 'Student'}';
    final words = name.trim().split(RegExp(r'\s+'));
    final initials = words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
    return workflow.StudentAccount(
      name,
      '${profile['id'] ?? ''}',
      '${profile['class'] ?? ''}',
      initials.isEmpty ? 'ST' : initials,
    );
  }

  Widget _phoneFrame(Widget child) {
    final gradient = gradientForAppTheme(_themeName);
    final navy = gradient.colors.first;
    final card = Color.alphaBlend(
      Colors.white.withValues(alpha: .08),
      gradient.colors.first,
    );
    final accent = gradient.colors.last;
    final baseTheme = Theme.of(context);
    final workflowTheme = baseTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: card,
      cardColor: card,
      dividerColor: Colors.white24,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: card,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );

    return Scaffold(
      backgroundColor: navy,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SizedBox.expand(
              key: const ValueKey('workflow-phone-frame'),
              child: Theme(data: workflowTheme, child: child),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final selectedTheme = _themeName;
    if (_controller.loading.value) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: gradientForAppTheme(selectedTheme),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }
    if (_controller.error.value != null || _controller.data.value == null) {
      return Scaffold(
        backgroundColor: AppColors.colorFF082F58,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, color: Colors.white, size: 52),
                const SizedBox(height: 14),
                Text(
                  '${_controller.error.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 18),
                FilledButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }
    final data = _controller.data.value!;
    return _phoneFrame(
      workflow.BackendDataScope(
        data: data,
        child: workflow.StudentContext(
          student: _student(data),
          child: workflow.WorkflowLanguageScope(
            language: _controller.language.value,
            child: _page(),
          ),
        ),
      ),
    );
  });
}
