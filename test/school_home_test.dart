import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pastel_auth_ui/app.dart';
import 'package:pastel_auth_ui/core/theme/app_colors.dart';
import 'package:pastel_auth_ui/views/workflows/backend_workflow_host.dart';

void main() {
  setUp(() {
    Get.reset();
    SharedPreferences.setMockInitialValues({'app.theme': 'ACLEDA Blue'});
    backendWorkflowTestData = {
      'student': {
        'name_english': 'Srey Rath',
        'class': 'Grade 9A',
        'program': 'General Education',
      },
      'academic_summary': {'gpa': 3.91, 'credits': 172, 'passed_courses': 37},
      'records': {
        'setting-announcement': [
          {
            'Title': 'Parent–teacher meeting',
            'Description':
                'Connect with your teachers and review your learning progress.',
            'updated_at': '2026-10-31',
          },
        ],
      },
    };
  });
  tearDown(() {
    backendWorkflowTestData = null;
    Get.reset();
  });

  testWidgets(
    'school home shows school identity and opens school announcements',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: const PastelAuthApp(initialRoute: '/home'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hello, Srey Rath'), findsOneWidget);
      expect(find.text('Learning hub'), findsOneWidget);
      expect(find.text('3.91'), findsOneWidget);
      expect(find.text('Cards'), findsNothing);
      expect(
        find.byKey(const ValueKey('advertisement-carousel')),
        findsNothing,
      );
      expect(
        (await SharedPreferences.getInstance()).getString('app.theme'),
        'Grandview School',
      );
      expect(AppColors.normalize('ACLEDA Blue'), 'Grandview School');
      await tester.ensureVisible(find.text('Parent–teacher meeting'));
      await tester.tap(find.text('Parent–teacher meeting'));
      await tester.pumpAndSettle();
      expect(find.text('Parent–teacher meeting'), findsOneWidget);
      expect(find.text('No backend payments received.'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('school home handles small screens and enlarged text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('School Fees'));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'school home never invents academic results for an empty profile',
    (tester) async {
      backendWorkflowTestData = <String, dynamic>{};
      await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
      await tester.pumpAndSettle();
      expect(find.text('Hello, Student'), findsOneWidget);
      expect(find.text('—'), findsNWidgets(3));
      expect(find.text('75.82'), findsNothing);
      expect(find.text('No announcements yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
