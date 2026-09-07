import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'mobile_api.dart';
import 'system_cs_workflows.dart' as workflow;

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
  final MobileApi _api = MobileApi();
  late Future<Map<String, dynamic>> _dashboard;
  String _language = 'English';
  String _themeName = 'ACLEDA Blue';

  @override
  void initState() {
    super.initState();
    _dashboard = _loadDashboard();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    final language = preferences.getString('app.language') ?? 'English';
    final savedTheme = preferences.getString('app.theme');
    final normalizedTheme = normalizeAppTheme(savedTheme);
    if (savedTheme != normalizedTheme) {
      await preferences.setString('app.theme', normalizedTheme);
    }
    if (mounted) {
      setState(() {
        _language = language;
        _themeName = normalizedTheme;
      });
    }
  }

  Future<Map<String, dynamic>> _loadDashboard() {
    final testData = backendWorkflowTestData;
    if (testData != null) return Future.value(testData);
    return _api.dashboard().timeout(const Duration(seconds: 8));
  }

  void _retry() => setState(() => _dashboard = _loadDashboard());

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
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: appThemeName,
    builder: (context, selectedTheme, _) {
      if (_themeName != selectedTheme) _themeName = selectedTheme;
      return FutureBuilder<Map<String, dynamic>>(
        future: _dashboard,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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
          if (snapshot.hasError || !snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color(0xff082f58),
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
                      const Icon(
                        Icons.cloud_off,
                        color: Colors.white,
                        size: 52,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: _retry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final data = snapshot.data!;
          return _phoneFrame(
            workflow.BackendDataScope(
              data: data,
              child: workflow.StudentContext(
                student: _student(data),
                child: workflow.WorkflowLanguageScope(
                  language: _language,
                  child: _page(),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
