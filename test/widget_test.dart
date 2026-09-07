import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_auth_ui/backend_workflow_host.dart';
import 'package:pastel_auth_ui/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    backendWorkflowTestData = {
      'student': {
        'id': 'ST-TEST',
        'name': 'Test Student',
        'name_english': 'Test Student',
        'class': 'Grade 9A',
        'program': 'General English',
        'balance': 350,
      },
      'payments': <Map<String, dynamic>>[
        {
          'receipt': 'REC-001',
          'category': 'Tuition Fee',
          'amount': 350,
          'currency': 'USD',
          'method': 'Bank Transfer',
          'paid_at': '2026-09-04 10:30:00',
        },
      ],
      'attendance': <Map<String, dynamic>>[],
      'records': {
        'setting-announcement': [
          {
            'Title': 'Parent meeting',
            'Description': 'Meeting on Friday at 4:00 PM.',
            'updated_at': '2026-09-04 09:00:00',
          },
        ],
        'setting-activities': [
          {
            'Title': 'Science classroom project',
            'Description': 'Students presented their science models.',
            'updated_at': '2026-09-04 11:00:00',
          },
        ],
        'setting-general': [
          {
            '@Company Address': 'Phnom Penh, Cambodia',
            '@Phone Number': '+855 12 345 678',
            '@Company Email': 'school@example.com',
          },
        ],
        'setting-content': [
          {'Title': 'English Program', 'Description': 'Language learning'},
        ],
        'pre-invoices': [
          {
            'id': '8',
            'invoice_no': 'Invoice #08',
            'invoice_date': '2026-08-31',
            'description': 'Tuition Fee',
            'total': 350,
            'paid': 0,
            'currency': 'USD',
            'published_mobile': 'Yes',
          },
        ],
      },
    };
  });

  testWidgets('login provides secure Face ID action', (tester) async {
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/login'));
    await tester.pumpAndSettle();

    expect(find.text('Log In with Face ID'), findsOneWidget);
    expect(find.byIcon(Icons.face_retouching_natural), findsOneWidget);
  });

  tearDown(() => backendWorkflowTestData = null);
  testWidgets('refresh route restores the home page', (tester) async {
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, SREY RATH'), findsOneWidget);
    expect(find.text('Log In'), findsNothing);
  });

  testWidgets('bell badge decreases only when each message is viewed', (
    tester,
  ) async {
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('notification-unread-count')),
      findsOneWidget,
    );
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    expect(find.text('3 New'), findsOneWidget);

    await tester.tap(find.text('Tuition Fee payment received'));
    await tester.pumpAndSettle();
    expect(find.text('Payment Detail'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2 New'), findsOneWidget);

    await tester.tap(find.text('School'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parent meeting'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('1 New'), findsOneWidget);

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Invoice #08'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.text('0 New'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('notification-unread-count')),
      findsNothing,
    );
  });

  testWidgets('refresh route restores notifications', (tester) async {
    await tester.pumpWidget(
      const PastelAuthApp(initialRoute: '/notifications'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Log In'), findsNothing);
  });

  testWidgets('notification tabs show backend payments and announcements', (
    tester,
  ) async {
    await tester.pumpWidget(
      const PastelAuthApp(initialRoute: '/notifications'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tuition Fee payment received'), findsOneWidget);
    expect(find.textContaining('Bank Transfer'), findsOneWidget);
    expect(find.text('Invoice #08'), findsOneWidget);

    await tester.tap(find.text('School'));
    await tester.pumpAndSettle();
    expect(find.text('Parent meeting'), findsOneWidget);
    expect(find.text('Meeting on Friday at 4:00 PM.'), findsOneWidget);
    expect(find.text('Tuition Fee payment received'), findsNothing);

    await tester.tap(find.text('Parent meeting'));
    await tester.pumpAndSettle();
    expect(find.text('School Announcement'), findsOneWidget);
  });

  testWidgets('refresh route restores student information', (tester) async {
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/student'));
    await tester.pumpAndSettle();
    expect(find.text('Student Information'), findsOneWidget);
    expect(find.text('Log In'), findsNothing);
  });

  testWidgets('student information follows Khmer language', (tester) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/student'));
    await tester.pumpAndSettle();

    expect(find.text('ព័ត៌មានសិស្ស'), findsOneWidget);
    expect(find.text('លេខសម្គាល់សិស្ស'), findsOneWidget);
    expect(find.text('ឈ្មោះពេញ'), findsOneWidget);
    expect(find.text('កម្មវិធីសិក្សា'), findsOneWidget);
    expect(find.text('ប័ណ្ណសម្គាល់សិស្ស'), findsOneWidget);
    expect(find.text('Student Information'), findsNothing);
  });

  testWidgets('notifications follow Khmer language', (tester) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});
    await tester.pumpWidget(
      const PastelAuthApp(initialRoute: '/notifications'),
    );
    await tester.pumpAndSettle();

    expect(find.text('ការជូនដំណឹង'), findsOneWidget);
    expect(find.text('ប្រតិបត្តិការ'), findsWidgets);
    expect(find.text('សាលា'), findsOneWidget);
    expect(find.text('Notifications'), findsNothing);
    expect(find.text('Transactions'), findsNothing);
  });

  testWidgets('class activity shows only backend classroom activities', (
    tester,
  ) async {
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/gallery'));
    await tester.pumpAndSettle();
    expect(find.text('Class Activities'), findsOneWidget);
    expect(find.text('Science classroom project'), findsOneWidget);
    expect(find.text('Parent meeting'), findsNothing);
    expect(find.text('Invoice #08'), findsNothing);
  });

  testWidgets('menu shows requested categories and backend location', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();

    expect(find.text('GRANDVIEW'), findsOneWidget);
    expect(find.text('Test Student'), findsOneWidget);
    expect(find.text('ST-TEST'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Phnom Penh, Cambodia'), findsOneWidget);
    expect(find.text('Products & Services'), findsOneWidget);
    expect(find.text('Contact Us'), findsOneWidget);
    expect(find.text('Rating & Review'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('ខ្មែរ'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text('中文'), findsOneWidget);

    await tester.tap(find.text('ខ្មែរ'));
    await tester.pumpAndSettle();
    expect(find.text('ម៉ឺនុយ'), findsOneWidget);
    expect(find.text('ផលិតផល និងសេវាកម្ម'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.text('ការទូទាត់'), findsOneWidget);
    expect(find.text('កិច្ចការផ្ទះ'), findsOneWidget);
    expect(find.text('សកម្មភាពថ្នាក់'), findsOneWidget);
  });

  testWidgets('settings contains themes, face id and my face', (tester) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Themes'), findsOneWidget);
    expect(find.text('Enable Face ID'), findsOneWidget);
    expect(find.text('My Face'), findsOneWidget);
    expect(find.text('Language'), findsNothing);

    await tester.tap(find.text('My Face'));
    await tester.pumpAndSettle();
    expect(find.text('Face Verification'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });

  testWidgets('five themes are available and selection persists', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Themes'));
    await tester.pumpAndSettle();

    for (final theme in appThemeNames) {
      expect(find.text(theme), findsWidgets);
    }
    await tester.tap(find.text('Emerald').last);
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('app.theme'), 'Emerald');
    expect(appThemeName.value, 'Emerald');

    await tester.pumpWidget(
      const PastelAuthApp(
        key: ValueKey('theme-restart'),
        initialRoute: '/home',
      ),
    );
    await tester.pumpAndSettle();
    expect(appThemeName.value, 'Emerald');
  });

  testWidgets('old Light theme is migrated to ACLEDA Blue', (tester) async {
    SharedPreferences.setMockInitialValues({'app.theme': 'Light'});
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();

    expect(appThemeName.value, 'ACLEDA Blue');
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('app.theme'), 'ACLEDA Blue');
  });

  testWidgets('menu detail screens follow Khmer language', (tester) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ម៉ឺនុយ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ផលិតផល និងសេវាកម្ម'));
    await tester.pumpAndSettle();
    expect(find.text('ផលិតផល និងសេវាកម្ម'), findsOneWidget);
    expect(find.text('Products & Services'), findsNothing);
  });

  testWidgets('home profile and academic summary follow Khmer language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();

    expect(find.text('សួស្តី, SREY RATH'), findsOneWidget);
    expect(find.textContaining('មើលព័ត៌មានសិស្ស'), findsOneWidget);
    expect(find.text('មធ្យមភាគ'), findsOneWidget);
    expect(find.text('ក្រេឌីត'), findsOneWidget);
    expect(find.text('មុខវិជ្ជាបានជាប់'), findsOneWidget);
    expect(find.text('ហ្គ្រែនវីយូ'), findsOneWidget);
    expect(find.text('Passed Courses'), findsNothing);
  });

  testWidgets('home academic summary uses dashboard API values', (
    tester,
  ) async {
    backendWorkflowTestData!['academic_summary'] = {
      'gpa': 3.91,
      'ects': 172,
      'passed_courses': 37,
    };

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();

    expect(find.text('3.91'), findsOneWidget);
    expect(find.text('172'), findsOneWidget);
    expect(find.text('37'), findsOneWidget);
  });

  testWidgets('home replaces quick categories with advertisement carousel', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/home'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('advertisement-carousel')),
    );
    expect(
      find.byKey(const ValueKey('advertisement-carousel')),
      findsOneWidget,
    );
    expect(find.text('My Points'), findsNothing);
    expect(find.text('CSX'), findsNothing);
  });

  testWidgets('school tool routes open their cloned feature pages', (
    tester,
  ) async {
    const routes = <String, String>{
      '/wallet': 'School Fees',
      '/scan': 'Scan the school attendance QR code',
      '/homework': 'Homework',
      '/payments': 'Payment Records',
      '/attendance': 'Attendance',
      '/grades': 'Grade Reports',
      '/timetable': 'Class Timetable',
      '/progress': 'Report Student',
      '/gallery': 'Class Activities',
      '/classes': 'My Classes',
    };

    for (final entry in routes.entries) {
      await tester.pumpWidget(
        PastelAuthApp(key: ValueKey(entry.key), initialRoute: entry.key),
      );
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsWidgets, reason: entry.key);
    }
  });

  testWidgets('dashboard cards navigate to cloned feature flows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const cards = <String, String>{
      'Cards': 'School Fees',
      'Scan QR': 'Scan the school attendance QR code',
      'My Grades': 'Grade Reports',
      'Attendance': 'Attendance records by date',
      'Timetable': 'Class Timetable',
      'Progress': 'Report Student',
      'Payments': 'Payment Records',
      'Homework': 'Your assignments and current status',
      'Class Activity': 'Class Activities',
      'My Classes': 'Active classroom and assignments',
    };

    for (final entry in cards.entries) {
      await tester.pumpWidget(
        PastelAuthApp(key: ValueKey(entry.key), initialRoute: '/home'),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(entry.key).first);
      await tester.tap(find.text(entry.key).first);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsWidgets, reason: entry.key);
    }
  });

  testWidgets('feature pages keep the Home phone width on wide screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/payments'));
    await tester.pumpAndSettle();

    final frame = find.byKey(const ValueKey('workflow-phone-frame'));
    expect(frame, findsOneWidget);
    expect(tester.getSize(frame).width, 430);
    expect(find.text('Payment Records'), findsOneWidget);
  });

  testWidgets('feature pages follow the selected Chinese language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Chinese'});

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/wallet'));
    await tester.pumpAndSettle();

    expect(find.text('学校费用'), findsOneWidget);
    expect(find.text('学生费用信息和付款记录'), findsOneWidget);
    expect(find.text('1. 当前学习课程'), findsOneWidget);
    expect(find.text('2. 最近付款记录'), findsOneWidget);
  });

  testWidgets('feature categories and tables follow Khmer language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/wallet'));
    await tester.pumpAndSettle();

    expect(find.text('ថ្លៃសាលា'), findsOneWidget);
    expect(find.text('1. កម្មវិធីសិក្សាបច្ចុប្បន្ន'), findsOneWidget);
    expect(find.text('បរិយាយ'), findsOneWidget);
    expect(find.text('កាលបរិច្ឆេទ'), findsOneWidget);
    expect(find.text('បង្កាន់ដៃ'), findsOneWidget);
    expect(find.textContaining('សរុបបានបង់'), findsOneWidget);
  });

  testWidgets('grade report items fully follow Khmer language', (tester) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/grades'));
    await tester.pumpAndSettle();

    expect(find.text('កម្មវិធីសិក្សា'), findsOneWidget);
    expect(find.text('កម្មវិធីភាសាខ្មែរ'), findsOneWidget);
    expect(find.text('របាយការណ៍ថ្មីៗ'), findsOneWidget);
    expect(find.text('ភាសាចិន និងអង់គ្លេស – ប្រឡងប្រចាំខែ'), findsOneWidget);
    expect(find.text('ភាសាខ្មែរ – ឆមាស'), findsOneWidget);
    expect(find.text('Recent Reports'), findsNothing);
  });

  testWidgets('student progress items fully follow Khmer language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/progress'));
    await tester.pumpAndSettle();

    expect(find.text('ការវាយតម្លៃសិស្ស'), findsOneWidget);
    expect(find.text('ការទទួលខុសត្រូវ'), findsOneWidget);
    expect(find.text('ការវាយតម្លៃរបស់គ្រូ'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('មតិយោបល់មាតាបិតា'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('មតិយោបល់មាតាបិតា'), findsOneWidget);
    expect(find.text('ផ្ញើមតិយោបល់'), findsOneWidget);
    expect(find.text("Teacher's Evaluation"), findsNothing);
    expect(find.text('Parent Feedback'), findsNothing);
  });

  testWidgets('class assignment items fully follow Khmer language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app.language': 'Khmer'});

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/classes'));
    await tester.pumpAndSettle();

    expect(find.text('មុខវិជ្ជា'), findsOneWidget);
    expect(find.text('បានបញ្ចប់'), findsOneWidget);
    expect(find.text('កិច្ចការផ្ទះ'), findsOneWidget);
    expect(find.text('លំហាត់គណិតវិទ្យា ជំពូកទី៤'), findsOneWidget);
    expect(find.text('គ្រូ'), findsWidgets);
    expect(find.text('មើលកិច្ចការផ្ទះ'), findsWidgets);
    expect(find.text('ផ្ញើកិច្ចការផ្ទះ'), findsWidgets);
    expect(find.text('Homework'), findsNothing);
    expect(find.text('Teacher'), findsNothing);
  });

  testWidgets('backend transaction opens its payment workflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const PastelAuthApp(initialRoute: '/payments'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Invoice #08'));
    await tester.pumpAndSettle();

    expect(find.text('Payment Detail'), findsOneWidget);
    expect(find.text('Invoice #08'), findsWidgets);
  });
}
