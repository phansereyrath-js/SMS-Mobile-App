import 'dart:async';

import 'package:flutter/material.dart';

import 'download_helper.dart';

const _featureNavy = Color(0xff082f58);
const _featureCard = Color(0xff102d48);
const _featureAccent = Color(0xff55dff5);

void main() => runApp(const StudentApp());

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  String language = 'en';
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grandview School',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff55dff5)),
        fontFamily: language == 'km' ? 'KhmerOS' : 'sans-serif',
        scaffoldBackgroundColor: const Color(0xff102d48),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffd3a16e),
          brightness: Brightness.dark,
        ),
        fontFamily: language == 'km' ? 'KhmerOS' : 'sans-serif',
        scaffoldBackgroundColor: const Color(0xff171318),
      ),
      themeMode: themeMode,
      home: StudentHomePage(
        language: language,
        onLanguageChanged: (value) => setState(() => language = value),
        themeMode: themeMode,
        onThemeChanged: (value) => setState(() => themeMode = value),
      ),
    );
  }
}

class StudentHomePage extends StatefulWidget {
  final String language;
  final ValueChanged<String> onLanguageChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  const StudentHomePage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  static const chocolate = Color(0xff55dff5);
  static const translations = <String, Map<String, String>>{
    'en': {
      'setting': 'Setting',
      'studentAccount': 'Student account',
      'parentAccount': 'Parent Account',
      'parentAccess': 'Parent access',
      'settings': 'Settings',
      'account': 'Account',
      'privacy': 'Privacy & security',
      'notifications': 'Notifications',
      'language': 'Language',
      'download': 'Download App',
      'logout': 'Log out',
      'home': 'Home',
      'alerts': 'Alerts',
      'messages': 'Messages',
      'welcome': 'Welcome to',
      'dashboard': 'Here is your dashboard',
      'tools': 'STUDENT TOOLS',
      'need': 'What do you need?',
      'viewAll': 'View all',
    },
    'km': {
      'setting': 'ការកំណត់',
      'studentAccount': 'គណនីសិស្ស',
      'parentAccount': 'គណនីអាណាព្យាបាល',
      'parentAccess': 'សិទ្ធិអាណាព្យាបាល',
      'settings': 'ការកំណត់',
      'account': 'គណនី',
      'privacy': 'ឯកជនភាព និងសុវត្ថិភាព',
      'notifications': 'ការជូនដំណឹង',
      'language': 'ភាសា',
      'download': 'ទាញយកកម្មវិធី',
      'logout': 'ចាកចេញ',
      'home': 'ទំព័រដើម',
      'alerts': 'ដំណឹង',
      'messages': 'សារ',
      'welcome': 'សូមស្វាគមន៍',
      'dashboard': 'នេះជាផ្ទាំងព័ត៌មានរបស់អ្នក',
      'tools': 'ឧបករណ៍សិស្ស',
      'need': 'តើអ្នកត្រូវការអ្វី?',
      'viewAll': 'មើលទាំងអស់',
    },
    'zh': {
      'setting': '设置',
      'studentAccount': '学生账户',
      'parentAccount': '家长账户',
      'parentAccess': '家长访问',
      'settings': '设置',
      'account': '账户',
      'privacy': '隐私与安全',
      'notifications': '通知',
      'language': '语言',
      'download': '下载应用',
      'logout': '退出登录',
      'home': '首页',
      'alerts': '通知',
      'messages': '消息',
      'welcome': '欢迎来到',
      'dashboard': '这是您的控制面板',
      'tools': '学生工具',
      'need': '您需要什么？',
      'viewAll': '查看全部',
    },
  };
  String t(String key) =>
      translations[widget.language]?[key] ?? translations['en']![key] ?? key;
  String get languageName =>
      {'en': 'English', 'km': 'ខ្មែរ', 'zh': '中文'}[widget.language]!;

  final GlobalKey<NavigatorState> _contentNavigatorKey =
      GlobalKey<NavigatorState>();

  Future<T?> _pushContent<T>(Widget page) => _contentNavigatorKey.currentState!
      .push<T>(MaterialPageRoute<T>(builder: (_) => page));

  Future<void> _chooseLanguage() async {
    final selected = await _pushContent<String>(
      LanguagePage(selectedLanguage: widget.language),
    );
    if (selected != null) widget.onLanguageChanged(selected);
  }

  String get themeName => switch (widget.themeMode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };

  Future<void> _chooseTheme() async {
    final selected = await _pushContent<ThemeMode>(
      ThemeSelectionPage(selectedTheme: widget.themeMode),
    );
    if (selected != null) widget.onThemeChanged(selected);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  Timer? _carouselTimer;
  int _page = 0;
  int _navIndex = 0;
  bool _settingsExpanded = true;
  int _selectedStudentIndex = 0;

  static const studentAccounts = <StudentAccount>[
    StudentAccount('Sombat Sok', 'GVS-023', 'Grade 9A', 'SS'),
    StudentAccount('Dara Sok', 'GVS-107', 'Grade 6B', 'DS'),
    StudentAccount('Lina Sok', 'GVS-214', 'Grade 3A', 'LS'),
    StudentAccount('Nita Sok', 'GVS-318', 'Kindergarten', 'NS'),
  ];

  StudentAccount get activeStudent => studentAccounts[_selectedStudentIndex];

  final tools = const <StudentTool>[
    StudentTool(
      'My Wallet',
      Icons.account_balance_wallet_outlined,
      Color(0xffe8f8f4),
      Color(0xff2dbf99),
      0,
    ),
    StudentTool(
      'My Profile',
      Icons.badge_outlined,
      Color(0xfffff0e8),
      Color(0xffef9b55),
      1,
    ),
    StudentTool(
      'Homework',
      Icons.assignment_outlined,
      Color(0xfffff8e9),
      Color(0xffeab84b),
      2,
    ),
    StudentTool(
      'Attendance',
      Icons.calendar_month_outlined,
      Color(0xffeaf8ed),
      Color(0xff48b96a),
      3,
    ),
    StudentTool(
      'My Grades',
      Icons.workspace_premium_outlined,
      Color(0xffeaf7fb),
      Color(0xff4caacb),
      4,
    ),
    StudentTool(
      'Timetable',
      Icons.access_alarm_rounded,
      Color(0xfff2edfc),
      Color(0xff8a78d3),
      5,
    ),
    StudentTool(
      'Progress',
      Icons.bar_chart_rounded,
      Color(0xfffff7d9),
      Color(0xffe5a82f),
      6,
    ),
    StudentTool(
      'Gallery',
      Icons.photo_library_outlined,
      Color(0xffe7f8f6),
      Color(0xff3ab5aa),
      7,
    ),
    StudentTool(
      'My Classes',
      Icons.co_present_outlined,
      Color(0xfffff0f1),
      Color(0xffef7180),
      8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients) return;
      _pageController.animateToPage(
        (_page + 1) % 3,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1400),
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          backgroundColor: const Color(0xff4a2a16),
        ),
      );
  }

  void _openProfile() {
    _pushContent<void>(StudentProfilePage(student: activeStudent));
  }

  Future<void> _chooseStudentAccount() async {
    Navigator.pop(context);
    final selected = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Switch student account',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                '${studentAccounts.length} children linked to this parent account',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(studentAccounts.length, (index) {
                final student = studentAccounts[index];
                final selected = index == _selectedStudentIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Material(
                    color: selected
                        ? Theme.of(sheetContext).colorScheme.primaryContainer
                        : Theme.of(sheetContext).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: selected
                            ? chocolate
                            : Theme.of(sheetContext).colorScheme.outlineVariant,
                        width: selected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ListTile(
                      onTap: () => Navigator.pop(sheetContext, index),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xff55dff5),
                        foregroundColor: Colors.white,
                        child: Text(student.initials),
                      ),
                      title: Text(
                        student.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text('${student.studentId} • ${student.grade}'),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: chocolate,
                            )
                          : const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
    if (selected != null && selected != _selectedStudentIndex) {
      setState(() => _selectedStudentIndex = selected);
      _contentNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      _showMessage('Switched to ${activeStudent.name}');
    }
  }

  void _openTool(String label) {
    final Widget? page = switch (label) {
      'My Wallet' => const SchoolFeesPage(),
      'My Profile' => StudentProfilePage(student: activeStudent),
      'Homework' => const HomeworkPage(),
      'Attendance' => const AttendancePage(),
      'My Grades' => const GradeReportsPage(),
      'Timetable' => const TimetablePage(),
      'Progress' => const StudentReportPage(),
      'My Classes' => const ClassesPage(),
      'Gallery' => const SchoolNewsPage(),
      _ => null,
    };
    if (page != null) {
      _pushContent<void>(page);
    } else {
      _showMessage('Opening $label…');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _StudentScope(
      student: activeStudent,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        drawerScrimColor: Colors.white70,
        drawer: _buildMenu(),
        body: Navigator(
          key: _contentNavigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => Container(
              decoration: const BoxDecoration(
                color: Color(0xff352132),
                image: DecorationImage(
                  image: AssetImage('assets/education-tools-background.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  colorFilter: ColorFilter.mode(
                    Color(0x3d160d18),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHero()),
                    SliverToBoxAdapter(child: _buildCarousel()),
                    SliverToBoxAdapter(child: _buildTools()),
                    const SliverToBoxAdapter(child: SizedBox(height: 92)),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildNavigation(),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 184,
      padding: EdgeInsets.fromLTRB(
        18,
        MediaQuery.paddingOf(context).top + 10,
        18,
        16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xc72b1830), Color(0x9c70401f), Color(0x9c102f46)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            bottom: -50,
            child: Icon(
              Icons.school_rounded,
              size: 190,
              color: Colors.white.withValues(alpha: .08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _featureCard,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xffffc54d),
                        width: 3,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/grandview-logo.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GRANDVIEW SCHOOL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .5,
                        ),
                      ),
                      Text(
                        "View Your Child's Genius",
                        style: TextStyle(color: Colors.white70, fontSize: 8),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: _openProfile,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffffbd70),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/student-avatar.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                t('welcome'),
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                activeStudent.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                t('dashboard'),
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * .82,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 19),
                  ),
                  Text(
                    t('setting'),
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Center(child: _SchoolSeal()),
              const SizedBox(height: 12),
              const Text(
                'GRANDVIEW SCHOOL',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 28),
              _ProfileTile(
                initials: activeStudent.initials,
                name: activeStudent.name,
                subtitle: '${activeStudent.grade} • ${activeStudent.studentId}',
                color: const Color(0xff50b9af),
                imageAsset: 'assets/student-avatar.png',
                onTap: () {
                  Navigator.pop(context);
                  _openProfile();
                },
              ),
              const SizedBox(height: 8),
              _ProfileTile(
                initials: '${studentAccounts.length}',
                name: 'Switch Student',
                subtitle: '${studentAccounts.length} children linked',
                color: const Color(0xffffb866),
                onTap: _chooseStudentAccount,
              ),
              const SizedBox(height: 24),
              _MenuTile(
                icon: Icons.settings_outlined,
                label: t('settings'),
                trailing: Icon(
                  _settingsExpanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.chevron_right_rounded,
                  size: 19,
                  color: chocolate,
                ),
                onTap: () =>
                    setState(() => _settingsExpanded = !_settingsExpanded),
              ),
              if (_settingsExpanded) ...[
                _MenuTile(
                  icon: Icons.person_outline_rounded,
                  label: t('account'),
                  onTap: () {
                    Navigator.pop(context);
                    _openProfile();
                  },
                ),
                _MenuTile(
                  icon: Icons.lock_outline_rounded,
                  label: t('privacy'),
                  onTap: () => _showMessage('Opening privacy & security…'),
                ),
                _MenuTile(
                  icon: Icons.notifications_none_rounded,
                  label: t('notifications'),
                  onTap: () => _showMessage('Opening notification settings…'),
                ),
              ],
              _MenuTile(
                icon: Icons.language_rounded,
                label: t('language'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(languageName, style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  _chooseLanguage();
                },
              ),
              _MenuTile(
                icon: Icons.palette_outlined,
                label: 'Theme',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(themeName, style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  _chooseTheme();
                },
              ),
              _MenuTile(
                icon: Icons.download_rounded,
                label: t('download'),
                onTap: () {
                  Navigator.pop(context);
                  _pushContent<void>(const DownloadAppPage());
                },
              ),
              _MenuTile(
                icon: Icons.logout_rounded,
                label: t('logout'),
                onTap: () => _showMessage('Log out selected'),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MiniSchoolMark(),
                  SizedBox(width: 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GRANDVIEW SCHOOL',
                        style: TextStyle(
                          color: chocolate,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "VIEW YOUR CHILD'S GENIUS",
                        style: TextStyle(fontSize: 5, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'App Version: V1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return ColoredBox(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 6),
        child: Column(
          children: [
            SizedBox(
              height: 152,
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _page = value),
                children: [
                  _bannerImage(),
                  _messageBanner(
                    'Keep learning!',
                    'Your next lesson is waiting.',
                    Icons.auto_stories_rounded,
                    const [Color(0xff75d7e8), Color(0xffd9f9fa)],
                  ),
                  _messageBanner(
                    'Great progress',
                    'See your latest achievements.',
                    Icons.emoji_events_rounded,
                    const [Color(0xffffd58b), Color(0xffffeee0)],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: index == _page ? 20 : 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    color: index == _page ? chocolate : const Color(0xffcbbeb3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerImage() => ClipRRect(
    borderRadius: BorderRadius.circular(17),
    child: Image.asset('assets/welcome-back.png', fit: BoxFit.cover),
  );

  Widget _messageBanner(
    String title,
    String subtitle,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 58, color: const Color(0xff55dff5)),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(subtitle, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTools() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0x34140b16),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('tools'),
                      style: const TextStyle(
                        color: Color(0xffe7a92d),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      t('need'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showMessage('All student tools'),
                child: Text(
                  t('viewAll'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tools.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 104,
              crossAxisSpacing: 9,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, index) => _ToolButton(
              tool: tools[index],
              onTap: () => _openTool(tools[index].label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    const items = ['Home', 'Notices', 'Scan', 'Payments', 'Contact'];
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: SizedBox(
        height: 66,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xed241a2a),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: const Color(0xff5c405c)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = _navIndex == index;
              return Expanded(
                child: InkWell(
                  key: index == 2
                      ? const ValueKey('persistent-scan-button')
                      : null,
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    setState(() => _navIndex = index);
                    if (index == 0) {
                      _contentNavigatorKey.currentState?.popUntil(
                        (route) => route.isFirst,
                      );
                    } else if (index == 1) {
                      _pushContent<void>(const SchoolNewsPage());
                    } else if (index == 2) {
                      _pushContent<void>(const QrScannerPage());
                    } else if (index == 3) {
                      _pushContent<void>(const PaymentRecordsPage());
                    } else if (index == 4) {
                      _pushContent<void>(const ContactSchoolPage());
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GeneratedAtlasIcon(
                        asset: 'assets/generated-navigation-icons.png',
                        index: index,
                        columns: 5,
                        rows: 1,
                        size: index == 2 ? 28 : 25,
                        color: selected
                            ? const Color(0xffffc44d)
                            : Colors.white,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[index],
                        style: TextStyle(
                          fontSize: 8.2,
                          color: selected
                              ? const Color(0xffffc44d)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class SchoolFeesPage extends StatelessWidget {
  const SchoolFeesPage({super.key});
  static const brown = Color(0xff55dff5);

  @override
  Widget build(BuildContext context) {
    final student = _StudentScope.of(context);
    const courses = [
      ('Mathematics program', 'Grade 9 • Level 2', '150.00\$'),
      ('English program', 'English Level 2', '100.00\$'),
      ('Science program', 'Grade 9 • Level 2', '100.00\$'),
    ];
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: const _InnerHeader(title: 'School Fees'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          const Text(
            'Student fee information and payment history',
            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const Divider(),
          const Text(
            '1. Current study programs',
            style: TextStyle(
              color: brown,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/student-avatar.png',
                      width: 76,
                      height: 92,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    student.grade,
                    style: const TextStyle(fontSize: 9, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: courses
                      .map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.$1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      course.$2,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const _StatusPill(label: '2026/27', color: brown),
                              const SizedBox(width: 7),
                              SizedBox(
                                width: 49,
                                child: Text(
                                  course.$3,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '2. Recent payment records',
            style: TextStyle(
              color: brown,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(.6),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(1.4),
                3: FlexColumnWidth(1.2),
              },
              border: const TableBorder(
                horizontalInside: BorderSide(color: Color(0x3dffffff)),
              ),
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: brown),
                  children: [
                    _Cell('#', light: true),
                    _Cell('Description', light: true),
                    _Cell('Date', light: true),
                    _Cell('Receipt', light: true),
                  ],
                ),
                ...List.generate(
                  4,
                  (i) => TableRow(
                    children: [
                      _Cell('${i + 1}'),
                      _Cell(
                        [
                          'Registration fee',
                          'English Level 2',
                          'Tuition payment',
                          'Activity fee',
                        ][i],
                      ),
                      const _Cell('07/04/2026'),
                      const Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(
                          Icons.download_rounded,
                          size: 15,
                          color: brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: brown,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Total school fees: 350.00\$',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});
  static const assignments = [
    ('Mathematics • Unit 1', '07-05-2026', 'Completed', Color(0xff13795b)),
    ('English • Unit 4', '07-05-2026', 'In progress', Color(0xff5452d9)),
    ('Science • Unit 2', '07-05-2026', 'Overdue', Color(0xffe23d3d)),
    ('Khmer • Unit 3', '07-05-2026', 'Pending', Color(0xffe1a822)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: const _InnerHeader(title: 'Homework', filter: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 24),
        children: [
          const Text(
            'Your assignments and current status',
            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _SummaryBox('All', '4', Color(0xff55dff5)),
              _SummaryBox('Done', '1', Color(0xff16815e)),
              _SummaryBox('Overdue', '1', Color(0xffdb3a3a)),
              _SummaryBox('Pending', '2', Color(0xffd39d18)),
            ],
          ),
          const SizedBox(height: 16),
          ...assignments.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _featureCard,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0x3dffffff)),
                boxShadow: const [
                  BoxShadow(color: Color(0x0c000000), blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 15),
                            const SizedBox(width: 5),
                            Text(item.$2, style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _StatusPill(label: item.$3, color: item.$4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  static const records = [
    (
      'Mathematics • Grade 9',
      '07-05-2026',
      '08-05-2026',
      'Excused',
      Color(0xffd6a928),
    ),
    (
      'English • Grade 9',
      '07-05-2026',
      '08-05-2026',
      'Present',
      Color(0xff28945e),
    ),
    (
      'Science • Grade 9',
      '07-05-2026',
      '08-05-2026',
      'Absent',
      Color(0xffd94c4c),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: const _InnerHeader(title: 'Attendance', filter: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 90),
        children: [
          const Text(
            'Attendance records by date',
            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const Divider(),
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _featureCard,
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text('2026-05-31', style: TextStyle(fontSize: 11)),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 17,
                  color: Color(0xff55dff5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'All records',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
              SizedBox(width: 15),
              Text(
                '● Present   ○ Absent   ○ Excused',
                style: TextStyle(fontSize: 9, color: Colors.white70),
              ),
            ],
          ),
          const Divider(),
          ...records.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xff102d48),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _StatusPill(label: item.$4, color: item.$5),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        '${item.$2}  until  ${item.$3}',
                        style: const TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _featureCard,
                      border: Border.all(color: const Color(0xff8d6a50)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      'Teacher note',
                      style: TextStyle(fontSize: 9, color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xff55dff5),
        foregroundColor: Colors.white,
        label: const Text('Request leave', style: TextStyle(fontSize: 11)),
      ),
    );
  }
}

class _InnerHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool filter;
  const _InnerHeader({required this.title, this.filter = false});
  @override
  Size get preferredSize => const Size.fromHeight(58);
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: _featureNavy,
    surfaceTintColor: _featureNavy,
    elevation: 0,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.chevron_left_rounded, color: Color(0xff55dff5)),
    ),
    titleSpacing: 0,
    title: Text(
      title,
      style: const TextStyle(
        color: Color(0xff55dff5),
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    ),
    actions: filter
        ? [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded, size: 15),
                label: const Text('Filter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff55dff5),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ]
        : null,
  );
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _SummaryBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _SummaryBox(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x3dffffff)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 9)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Cell extends StatelessWidget {
  final String text;
  final bool light;
  const _Cell(this.text, {this.light = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(7),
    child: Text(
      text,
      style: TextStyle(
        color: light ? Colors.white : const Color(0xb3ffffff),
        fontSize: 8,
        fontWeight: light ? FontWeight.w800 : FontWeight.w500,
      ),
    ),
  );
}

class ThemeSelectionPage extends StatelessWidget {
  final ThemeMode selectedTheme;
  const ThemeSelectionPage({super.key, required this.selectedTheme});

  @override
  Widget build(BuildContext context) {
    const choices = [
      (ThemeMode.light, 'Light', 'Bright appearance', Icons.light_mode_rounded),
      (
        ThemeMode.dark,
        'Dark',
        'Comfortable in low light',
        Icons.dark_mode_rounded,
      ),
      (
        ThemeMode.system,
        'Follow System',
        'Match your phone setting',
        Icons.settings_brightness_rounded,
      ),
    ];
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const _InnerHeader(title: 'Theme'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
        children: [
          Text(
            'Choose how Grandview School looks',
            style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          ...choices.map((choice) {
            final selected = choice.$1 == selectedTheme;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: selected
                    ? colors.primaryContainer.withValues(alpha: .45)
                    : colors.surface,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: selected ? colors.primary : colors.outlineVariant,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: RadioListTile<ThemeMode>(
                  value: choice.$1,
                  groupValue: selectedTheme,
                  activeColor: colors.primary,
                  onChanged: (value) => Navigator.pop(context, value),
                  secondary: Icon(choice.$4, color: colors.primary),
                  title: Text(
                    choice.$2,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(choice.$3),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  final String selectedLanguage;
  const LanguagePage({super.key, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    const languages = [
      ('en', 'English', 'English', 'Use the app in English'),
      ('km', 'ខ្មែរ', 'Khmer', 'ប្រើកម្មវិធីជាភាសាខ្មែរ'),
      ('zh', '中文', 'Chinese', '使用中文浏览应用'),
    ];
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: const _InnerHeader(title: 'Language'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
        children: [
          const Text(
            'Choose your preferred language',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 14),
          ...languages.map((language) {
            final selected = language.$1 == selectedLanguage;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selected
                      ? const Color(0xff55dff5)
                      : const Color(0x3dffffff),
                  width: selected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: RadioListTile<String>(
                value: language.$1,
                groupValue: selectedLanguage,
                activeColor: const Color(0xff55dff5),
                onChanged: (value) => Navigator.pop(context, value),
                title: Text(
                  language.$2,
                  style: TextStyle(
                    fontFamily: language.$1 == 'km' ? 'KhmerOS' : null,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  '${language.$3} • ${language.$4}',
                  style: TextStyle(
                    fontFamily: language.$1 == 'km' ? 'KhmerOS' : null,
                    fontSize: 9,
                    color: Colors.white70,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class DownloadAppPage extends StatelessWidget {
  const DownloadAppPage({super.key});
  static const androidBuildReady = false;
  static const iosBuildReady = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'Download Grandview App'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
      children: [
        Center(
          child: Container(
            width: 105,
            height: 105,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _featureCard,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xff55dff5), width: 3),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/grandview-logo.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'GRANDVIEW SCHOOL',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff55dff5),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Choose your device to install the student app.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.white70),
        ),
        const SizedBox(height: 28),
        _DownloadCard(
          icon: Icons.android_rounded,
          title: 'Android',
          subtitle: 'Download the Grandview School APK',
          buttonLabel: androidBuildReady ? 'Download APK' : 'APK build pending',
          enabled: androidBuildReady,
          onPressed: () {
            downloadAndroidApp();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Android download started')),
            );
          },
        ),
        const SizedBox(height: 13),
        _DownloadCard(
          icon: Icons.apple_rounded,
          title: 'iPhone & iPad',
          subtitle: 'Install directly from the school website',
          buttonLabel: iosBuildReady ? 'Install on iOS' : 'Signed IPA pending',
          enabled: iosBuildReady,
          onPressed: () {
            installIosApp();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening the direct iOS installer')),
            );
          },
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xff102d48),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Color(0xff55dff5),
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'No app store is used. Android installs the APK from this website. iOS installs a signed IPA through an HTTPS manifest and school-managed Apple provisioning.',
                  style: TextStyle(
                    fontSize: 9,
                    height: 1.4,
                    color: Color(0xb3ffffff),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DownloadCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, buttonLabel;
  final bool enabled;
  final VoidCallback? onPressed;
  const _DownloadCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.enabled,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _featureCard,
      border: Border.all(color: const Color(0x3dffffff)),
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [BoxShadow(color: Color(0x0d000000), blurRadius: 8)],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xff102d48),
          child: Icon(icon, color: const Color(0xff55dff5), size: 30),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 9, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: enabled ? onPressed : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xff55dff5),
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(buttonLabel, style: const TextStyle(fontSize: 9)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});
  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool torchOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: Colors.black)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Scan the student QR code',
                    style: TextStyle(
                      color: Color(0xffd3a16e),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 36),
                  const _ScannerFrame(size: 250),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text('Choose a QR image from gallery'),
                              ),
                            ),
                        icon: const Icon(
                          Icons.add_photo_alternate_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 42),
                      IconButton(
                        onPressed: () => setState(() => torchOn = !torchOn),
                        icon: Icon(
                          torchOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: torchOn
                              ? const Color(0xffffc14d)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerFrame extends StatelessWidget {
  final double size;
  const _ScannerFrame({required this.size});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _ScannerFramePainter()),
  );
}

class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const length = 38.0;
    final paths = [
      Path()
        ..moveTo(0, length)
        ..lineTo(0, 0)
        ..lineTo(length, 0),
      Path()
        ..moveTo(size.width - length, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, length),
      Path()
        ..moveTo(0, size.height - length)
        ..lineTo(0, size.height)
        ..lineTo(length, size.height),
      Path()
        ..moveTo(size.width - length, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - length),
    ];
    for (final path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScannerNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ScannerNavItem(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: SizedBox(
      width: 54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 21, color: const Color(0xb3ffffff)),
          Text(
            label,
            style: const TextStyle(fontSize: 7, color: Color(0xb3ffffff)),
          ),
        ],
      ),
    ),
  );
}

class SchoolNewsPage extends StatelessWidget {
  const SchoolNewsPage({super.key});
  static const posts = [
    (
      'Welcome to the new Grandview learning year',
      'School activities',
      'August 15, 2026',
    ),
    (
      'Students explore art, reading and creativity',
      'Learning highlights',
      'August 12, 2026',
    ),
    (
      'Grandview teachers complete development workshop',
      'School news',
      'August 9, 2026',
    ),
    (
      'Our students celebrate another successful week',
      'Community',
      'August 6, 2026',
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff082f58),
    appBar: const _InnerHeader(title: 'School News'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 25),
      children: [
        const Text(
          'Latest school activities and announcements',
          style: TextStyle(fontSize: 9, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/welcome-back.png',
            height: 145,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 9),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 9,
            mainAxisSpacing: 12,
            mainAxisExtent: 185,
          ),
          itemBuilder: (_, index) {
            final post = posts[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    index.isEven
                        ? 'assets/student-avatar.png'
                        : 'assets/welcome-back.png',
                    height: 92,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: index == 1
                        ? Alignment.centerLeft
                        : Alignment.center,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  post.$1,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  post.$3,
                  style: const TextStyle(fontSize: 8, color: Color(0xb3ffffff)),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class PaymentRecordsPage extends StatelessWidget {
  const PaymentRecordsPage({super.key});
  static const records = [
    ('Invoice #08', '31/08/2026', 'Pending', Color(0xb3ffffff)),
    ('Invoice #07', '31/05/2025', 'Paid', Color(0xff43b76f)),
    ('Invoice #06', '31/05/2025', 'Overdue', Color(0xffe45757)),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'Payment Records', filter: true),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 25),
      children: [
        const Text(
          'All transactions and invoice status',
          style: TextStyle(fontSize: 9, color: Colors.white70),
        ),
        const Divider(),
        ...records.map(
          (record) => InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PaymentDetailPage(
                  invoice: record.$1,
                  date: record.$2,
                  status: record.$3,
                  statusColor: record.$4,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _featureCard,
                border: Border.all(color: const Color(0x3dffffff)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          record.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _StatusPill(label: record.$3, color: record.$4),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 14),
                      const SizedBox(width: 5),
                      Text(record.$2, style: const TextStyle(fontSize: 9)),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 17,
                        color: Color(0xb3ffffff),
                      ),
                    ],
                  ),
                  const Divider(height: 17),
                  Row(
                    children: [
                      Text(
                        'Tuition Fee • ${_StudentScope.of(context).grade}',
                        style: const TextStyle(fontSize: 9),
                      ),
                      const Spacer(),
                      const _StatusPill(
                        label: '350\$',
                        color: Color(0xff55dff5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class PaymentDetailPage extends StatefulWidget {
  final String invoice;
  final String date;
  final String status;
  final Color statusColor;
  const PaymentDetailPage({
    super.key,
    required this.invoice,
    required this.date,
    required this.status,
    required this.statusColor,
  });
  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController(text: 'parent@grandview.edu.kh');
  final note = TextEditingController();
  bool submitting = false;
  @override
  void dispose() {
    email.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> submitInvoiceRequest() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invoice request for ${widget.invoice} queued for backend',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'Payment Detail'),
    body: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xff102d48),
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.invoice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff55dff5),
                        ),
                      ),
                    ),
                    _StatusPill(
                      label: widget.status,
                      color: widget.statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DetailLine('Invoice date', widget.date),
                _DetailLine(
                  'Student',
                  '${_StudentScope.of(context).name} • ${_StudentScope.of(context).studentId}',
                ),
                _DetailLine(
                  'Description',
                  'Tuition Fee • ${_StudentScope.of(context).grade}',
                ),
                const _DetailLine('Academic year', '2026–2027'),
                const Divider(height: 25),
                const Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Spacer(),
                    Text(
                      '350.00\$',
                      style: TextStyle(
                        color: Color(0xff55dff5),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PaymentCertificatePage(
                  student: _StudentScope.of(context),
                  invoice: widget.invoice,
                  date: widget.date,
                  status: widget.status,
                ),
              ),
            ),
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('View Payment Certificate'),
          ),
          const SizedBox(height: 14),
          const Text(
            'Request invoice from school',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          const Text(
            'The backend will send the invoice to this address.',
            style: TextStyle(fontSize: 9, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 11),
            decoration: const InputDecoration(
              labelText: 'Recipient email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || !value.contains('@')
                ? 'Enter a valid email'
                : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: note,
            maxLines: 3,
            style: const TextStyle(fontSize: 11),
            decoration: const InputDecoration(
              labelText: 'Note for accounting (optional)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: submitting ? null : submitInvoiceRequest,
            icon: submitting
                ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, size: 17),
            label: Text(submitting ? 'Sending…' : 'Send Invoice Request'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xff55dff5),
              padding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    ),
  );
}

class PaymentCertificatePage extends StatelessWidget {
  final StudentAccount student;
  final String invoice;
  final String date;
  final String status;
  const PaymentCertificatePage({
    super.key,
    required this.student,
    required this.invoice,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const _InnerHeader(title: 'Payment Certificate'),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xff102d48),
            border: Border.all(color: const Color(0x3dffffff)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Image.asset('assets/grandview-logo.jpg', width: 65, height: 65),
              const SizedBox(height: 10),
              const Text(
                'GRANDVIEW SCHOOL',
                style: TextStyle(
                  color: Color(0xff55dff5),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Official Payment Certificate',
                style: TextStyle(fontSize: 11),
              ),
              const Divider(height: 28),
              _DetailLine('Invoice', invoice),
              _DetailLine('Student', student.name),
              _DetailLine('Student ID', student.studentId),
              _DetailLine('Grade / Class', student.grade),
              _DetailLine('Payment date', date),
              _DetailLine('Status', status),
              const _DetailLine('Amount', '350.00\$'),
              const _DetailLine('Academic year', '2026–2027'),
              const Divider(height: 28),
              const Text(
                'This document confirms the payment record registered for the student above.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DetailLine extends StatelessWidget {
  final String label, value;
  const _DetailLine(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.white70),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class ContactSchoolPage extends StatelessWidget {
  const ContactSchoolPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'Contact Grandview'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 25),
      children: [
        const Text(
          'Contact the school administration',
          style: TextStyle(fontSize: 9, color: Colors.white70),
        ),
        const Divider(),
        const _ContactTile(
          Icons.location_on_outlined,
          'Visit Us',
          'Phnom Penh, Cambodia',
        ),
        Container(
          height: 38,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xff102d48),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Open in Google Maps',
            style: TextStyle(color: Color(0xff55dff5), fontSize: 9),
          ),
        ),
        const _ContactTile(Icons.phone_outlined, 'Phone', '096 342 7230'),
        const _ContactTile(
          Icons.email_outlined,
          'Email',
          'info@grandviewschool.edu.kh',
        ),
        const _ContactTile(
          Icons.language_rounded,
          'Website',
          'www.grandviewschool.edu.kh',
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_outlined, size: 14),
                label: const Text('Call Now', style: TextStyle(fontSize: 9)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email_outlined, size: 14),
                label: const Text('Send Email', style: TextStyle(fontSize: 9)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'or follow us',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9),
        ),
        const SizedBox(height: 9),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xff1877f2),
              child: Text(
                'f',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Color(0xff1da1f2),
              child: Text(
                'X',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Color(0xff0a66c2),
              child: Text(
                'in',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _ContactTile(this.icon, this.title, this.value);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0x3dffffff)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xff102d48),
          child: Icon(icon, color: const Color(0xff55dff5), size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff55dff5),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(value, style: const TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ],
    ),
  );
}

class StudentReportPage extends StatefulWidget {
  const StudentReportPage({super.key});
  @override
  State<StudentReportPage> createState() => _StudentReportPageState();
}

class _StudentReportPageState extends State<StudentReportPage> {
  int period = 0;
  final feedback = TextEditingController();
  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xff55dff5);
    final student = _StudentScope.of(context);
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: const _InnerHeader(title: 'Report Student'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          const Text(
            "Track your child's study progress",
            style: TextStyle(fontSize: 9, color: Colors.white70),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: brown,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/student-avatar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          color: brown,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(student.grade, style: const TextStyle(fontSize: 10)),
                      const SizedBox(height: 5),
                      Text(
                        'Student ID: ${student.studentId}',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => setState(() => period = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: period == i ? brown : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      ['Monthly', 'Semester', 'Annually'][i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: period == i ? Colors.white : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _RankCard(
                  icon: Icons.menu_book_rounded,
                  color: brown,
                  title: 'Chinese English',
                  score: '96.00',
                  rank: '#2 / 40',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GradeReportsPage(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RankCard(
                  icon: Icons.auto_stories_rounded,
                  color: Color(0xffd7a326),
                  title: 'Khmer',
                  score: '96.50',
                  rank: '#3 / 40',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GradeReportsPage(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Evaluation',
                  style: TextStyle(
                    color: brown,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                Divider(),
                _EvaluationRow(
                  'Responsibility',
                  'Excellent',
                  Color(0xff279765),
                ),
                _EvaluationRow(
                  'Class participation',
                  'Very good',
                  Color(0xff3a8fc3),
                ),
                _EvaluationRow('Homework quality', 'Good', Color(0xffd39820)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school_outlined, size: 16, color: brown),
                    SizedBox(width: 6),
                    Text(
                      "Teacher's Evaluation",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    Text('July 24, 2026', style: TextStyle(fontSize: 8)),
                  ],
                ),
                SizedBox(height: 9),
                ColoredBox(
                  color: Color(0xff102d48),
                  child: Padding(
                    padding: EdgeInsets.all(11),
                    child: Text(
                      'The student has shown excellent progress, participates actively, and demonstrates a positive attitude toward learning.',
                      style: TextStyle(fontSize: 9, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x3dffffff)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Parent Feedback',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: feedback,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    hintText: 'Write your comment here…',
                    hintStyle: const TextStyle(fontSize: 9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feedback submitted')),
                    ),
                    style: FilledButton.styleFrom(backgroundColor: brown),
                    child: const Text(
                      'Submit Feedback',
                      style: TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, score, rank;
  final VoidCallback onTap;
  const _RankCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.score,
    required this.rank,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff102d48),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 13),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 14),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AVG Point', style: TextStyle(fontSize: 7)),
                    Text(
                      score,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rank', style: TextStyle(fontSize: 7)),
                    Text(
                      rank,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _EvaluationRow extends StatelessWidget {
  final String label, result;
  final Color color;
  const _EvaluationRow(this.label, this.result, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 9))),
        Text(
          result,
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});
  static const works = [
    (
      'Math Worksheet Chapter 4',
      'Complete all questions on multiplication practice.',
      'Complete',
      Color(0xff36ad72),
    ),
    (
      'Khmer Review lesson 1',
      'Complete all questions on multiplication practice.',
      'Pending',
      Color(0xffd5a42a),
    ),
    (
      'Science Review lesson 1',
      'Read chapter 5 and answer the questions.',
      'Pending',
      Color(0xffd5a42a),
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'My Classes'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 25),
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xff55dff5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.groups_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grandview ${_StudentScope.of(context).grade}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Active classroom and assignments',
                      style: TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: const [
            _ClassCount(Icons.menu_book_rounded, '3', 'Subjects'),
            SizedBox(width: 7),
            _ClassCount(Icons.task_alt_rounded, '1', 'Completed'),
            SizedBox(width: 7),
            _ClassCount(Icons.schedule_rounded, '2', 'Pending'),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Homework',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        ...works.map(
          (work) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff102d48),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x0e000000), blurRadius: 8),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calculate_outlined,
                      color: Color(0xff55dff5),
                      size: 20,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            work.$1,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            work.$2,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.person_outline, size: 13),
                    SizedBox(width: 4),
                    Text('Teacher', style: TextStyle(fontSize: 8)),
                    SizedBox(width: 12),
                    Icon(Icons.calendar_month_outlined, size: 13),
                    SizedBox(width: 4),
                    Text('30 May 2026', style: TextStyle(fontSize: 8)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'View Homework',
                        style: TextStyle(fontSize: 8),
                      ),
                    ),
                    const SizedBox(width: 5),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Send Homework',
                        style: TextStyle(fontSize: 8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _StatusPill(label: work.$3, color: work.$4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _ClassCount extends StatelessWidget {
  final IconData icon;
  final String count, label;
  const _ClassCount(this.icon, this.count, this.label);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff55dff5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 7),
          Column(
            children: [
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 7),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int selectedDay = 0;
  static const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const lessons = [
    ('07:00 – 09:00', 'Mathematics', 'Room 101 • Mr. Dara'),
    ('09:15 – 10:45', 'English', 'Room 203 • Ms. Lina'),
    ('11:00 – 13:00', 'Science', 'Laboratory • Mr. Vannak'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: const _InnerHeader(title: 'Class Timetable'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          const Text(
            'Your weekly classroom schedule',
            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const Divider(),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                days.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    selected: selectedDay == index,
                    onSelected: (_) => setState(() => selectedDay = index),
                    label: Text(days[index]),
                    selectedColor: const Color(0xff55dff5),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: selectedDay == index
                          ? Colors.white
                          : const Color(0xff55dff5),
                    ),
                    side: const BorderSide(color: Color(0xff55dff5)),
                    showCheckmark: false,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          ...lessons.asMap().entries.map((entry) {
            final lesson = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 78,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lesson ${entry.key + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.$1,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xff102d48),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.$2,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lesson.$3,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xff55dff5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time_rounded, color: Colors.white, size: 15),
                SizedBox(width: 8),
                Text(
                  'Break time: 10:45 – 11:00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradeReportsPage extends StatelessWidget {
  const GradeReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff082f58),
      appBar: const _InnerHeader(title: 'Grade Reports'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          const Text(
            'Programs',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          _ProgramCard(
            name: 'Chinese English',
            subtitle: 'Chinese & English language program',
            onMonthly: () => _openMonthly(context),
            onSemester: () => _openComparison(
              context,
              'Semester',
              'First Quarter',
              'Second Quarter',
            ),
            onAnnually: () => _openComparison(
              context,
              'Annually',
              'Semester 1',
              'Semester 2',
            ),
          ),
          _ProgramCard(
            name: 'Khmer',
            subtitle: 'Khmer language program',
            onMonthly: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KhmerMonthlyReportPage(),
              ),
            ),
            onSemester: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KhmerPeriodReportPage(
                  title: 'Semester',
                  period: 'Semester 1 in 2026–2027',
                ),
              ),
            ),
            onAnnually: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KhmerPeriodReportPage(
                  title: 'Annually',
                  period: 'Year 2026–2027',
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'Recent Reports',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          _ReportTile(
            title: 'Chinese English – Monthly Exam',
            date: 'May 2026',
            score: '3.67 GPA',
            onTap: () => _openMonthly(context),
          ),
          _ReportTile(
            title: 'Khmer – Semester',
            date: 'July 2025',
            score: '4.00 GPA',
            onTap: () => _openMonthly(context),
          ),
        ],
      ),
    );
  }

  void _openMonthly(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => const MonthlyReportPage()));

  void _openComparison(
    BuildContext context,
    String title,
    String left,
    String right,
  ) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ComparisonReportPage(
        title: title,
        leftHeader: left,
        rightHeader: right,
      ),
    ),
  );
}

class _ProgramCard extends StatelessWidget {
  final String name, subtitle;
  final VoidCallback onMonthly;
  final VoidCallback onSemester;
  final VoidCallback onAnnually;
  const _ProgramCard({
    required this.name,
    required this.subtitle,
    required this.onMonthly,
    required this.onSemester,
    required this.onAnnually,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: _featureCard,
      border: Border.all(color: const Color(0x3dffffff)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0xff55dff5),
              child: Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xff55dff5),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 8, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ReportButton('Monthly', Icons.calendar_month_outlined, onMonthly),
            const SizedBox(width: 7),
            _ReportButton('Semester', Icons.date_range_outlined, onSemester),
            const SizedBox(width: 7),
            _ReportButton('Annually', Icons.event_note_outlined, onAnnually),
          ],
        ),
      ],
    ),
  );
}

class _ReportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ReportButton(this.label, this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => Expanded(
    child: FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13),
      label: Text(label, style: const TextStyle(fontSize: 8)),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xff55dff5),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}

class _ReportTile extends StatelessWidget {
  final String title, date, score;
  final VoidCallback onTap;
  const _ReportTile({
    required this.title,
    required this.date,
    required this.score,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _featureCard,
        border: Border.all(color: const Color(0x3dffffff)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: Color(0xff55dff5),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 8, color: Colors.white60),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xff102d48),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score,
              style: const TextStyle(color: Color(0xff55dff5), fontSize: 8),
            ),
          ),
        ],
      ),
    ),
  );
}

class ComparisonReportPage extends StatelessWidget {
  final String title;
  final String leftHeader;
  final String rightHeader;
  const ComparisonReportPage({
    super.key,
    required this.title,
    required this.leftHeader,
    required this.rightHeader,
  });
  static const rows = [
    ('Reading', '100', 'Reading', '100'),
    ('Writing', '100', 'Writing', '100'),
    ('Speaking', '100', 'Speaking', '100'),
    ('Listening', '100', 'Listening', '100'),
    ('Quiz', '100', 'Quiz', '100'),
    ('Home', '100', 'Home', '100'),
    ('Art', '100', 'Art', '100'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: _InnerHeader(title: title),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        _ReportIdentity(period: title == 'Annually' ? '2026–2027' : 'Semester'),
        Table(
          border: TableBorder.all(color: const Color(0x3dffffff)),
          columnWidths: const {
            0: FlexColumnWidth(.42),
            1: FlexColumnWidth(1.15),
            2: FlexColumnWidth(.65),
            3: FlexColumnWidth(.42),
            4: FlexColumnWidth(1.15),
            5: FlexColumnWidth(.65),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xff55dff5)),
              children: [
                _Cell(leftHeader, light: true),
                const _Cell('Scores', light: true),
                const _Cell(''),
                _Cell(rightHeader, light: true),
                const _Cell('Scores', light: true),
                const _Cell(''),
              ],
            ),
            ...rows.asMap().entries.map(
              (e) => TableRow(
                children: [
                  _Cell('${e.key + 1}'),
                  _Cell(e.value.$1),
                  _Cell(e.value.$2),
                  _Cell('${e.key + 1}'),
                  _Cell(e.value.$3),
                  _Cell(e.value.$4),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff102d48)),
              children: [
                _Cell(''),
                _Cell('Total'),
                _Cell('1000'),
                _Cell(''),
                _Cell('Total'),
                _Cell('1000'),
              ],
            ),
          ],
        ),
        const _ReportTotals(),
      ],
    ),
  );
}

class KhmerPeriodReportPage extends StatelessWidget {
  final String title;
  final String period;
  const KhmerPeriodReportPage({
    super.key,
    required this.title,
    required this.period,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: _InnerHeader(title: title),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        _ReportIdentity(period: period),
        Table(
          border: TableBorder.all(color: const Color(0x3dffffff)),
          columnWidths: const {
            0: FlexColumnWidth(.45),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(2.4),
            3: FlexColumnWidth(.7),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff55dff5)),
              children: [
                _Cell('#', light: true),
                _Cell('Khmer', light: true),
                _Cell('Subject', light: true),
                _Cell('Scores', light: true),
              ],
            ),
            ...KhmerMonthlyReportPage.subjects.asMap().entries.map(
              (entry) => TableRow(
                children: [
                  _Cell('${entry.key + 1}'),
                  const _Cell('Khmer'),
                  _Cell(entry.value),
                  const _Cell('100'),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff102d48)),
              children: [
                _Cell(''),
                _Cell('Total'),
                _Cell('Total'),
                _Cell('1100'),
              ],
            ),
          ],
        ),
        const _ReportTotals(),
      ],
    ),
  );
}

class KhmerMonthlyReportPage extends StatelessWidget {
  const KhmerMonthlyReportPage({super.key});
  static const subjects = [
    'Khmer',
    'Math',
    'History',
    'Biology',
    'English',
    'Science',
    'Computer',
    'Chemistry',
    'Geography',
    'Earth Science',
    'Sport',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'Monthly'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        const _ReportIdentity(period: 'Monthly in 2026–2027'),
        Table(
          border: TableBorder.all(color: const Color(0x3dffffff)),
          columnWidths: const {
            0: FlexColumnWidth(.45),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(2.4),
            3: FlexColumnWidth(.7),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff55dff5)),
              children: [
                _Cell('#', light: true),
                _Cell('Khmer', light: true),
                _Cell('Subject', light: true),
                _Cell('Scores', light: true),
              ],
            ),
            ...subjects.asMap().entries.map(
              (e) => TableRow(
                children: [
                  _Cell('${e.key + 1}'),
                  const _Cell('Khmer'),
                  _Cell(e.value),
                  const _Cell('100'),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff102d48)),
              children: [
                _Cell(''),
                _Cell('Total'),
                _Cell('Total'),
                _Cell('1100'),
              ],
            ),
          ],
        ),
        const _ReportTotals(),
      ],
    ),
  );
}

class _ReportIdentity extends StatelessWidget {
  final String period;
  const _ReportIdentity({required this.period});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0x3dffffff)),
    ),
    child: Column(
      children: [
        ColoredBox(
          color: const Color(0xff55dff5),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                period,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Name: ${_StudentScope.of(context).name}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              const Expanded(
                child: Text('Sex: Female', style: TextStyle(fontSize: 8)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'ID: ${_StudentScope.of(context).studentId}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              Expanded(
                child: Text(
                  'Level: ${_StudentScope.of(context).grade}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ReportTotals extends StatelessWidget {
  const _ReportTotals();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    color: const Color(0xff102d48),
    child: const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Score', style: TextStyle(fontSize: 9)),
            Text('1000', style: TextStyle(fontSize: 9)),
            Text('Grade: A+', style: TextStyle(fontSize: 9)),
          ],
        ),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Average', style: TextStyle(fontSize: 9)),
            Text('100.0', style: TextStyle(fontSize: 9)),
            Text('GPA: 4.00', style: TextStyle(fontSize: 9)),
          ],
        ),
      ],
    ),
  );
}

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});
  static const rows = [
    ('English', 'Class Work Completion', '100'),
    ('English', 'Homework Completion', '100'),
    ('English', 'Student Punctuality', '100'),
    ('English', 'Work Independently', '100'),
    ('English', 'Task Responsibility', '100'),
    ('English', 'Student Attendance', '100'),
    ('English', 'Respectful in the class', '100'),
    ('English', 'Morality', '100'),
    ('English', 'Reflection', '100'),
    ('English', 'Communication', '100'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _featureNavy,
    appBar: const _InnerHeader(title: 'Monthly Report'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        Row(
          children: ['English', 'Chinese', 'Math']
              .map(
                (subject) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: subject == 'English'
                          ? const Color(0xff55dff5)
                          : Colors.white,
                      border: Border.all(color: const Color(0x3dffffff)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      subject,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: subject == 'English'
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const _ReportHeader(),
        Table(
          border: TableBorder.all(color: const Color(0x3dffffff)),
          columnWidths: const {
            0: FlexColumnWidth(.45),
            1: FlexColumnWidth(1.1),
            2: FlexColumnWidth(2.8),
            3: FlexColumnWidth(.7),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff55dff5)),
              children: [
                _Cell('#', light: true),
                _Cell('Subject', light: true),
                _Cell('Class Work', light: true),
                _Cell('Score', light: true),
              ],
            ),
            ...rows.asMap().entries.map(
              (e) => TableRow(
                children: [
                  _Cell('${e.key + 1}'),
                  _Cell(e.value.$1),
                  _Cell(e.value.$2),
                  _Cell(e.value.$3),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: Color(0xff102d48)),
              children: [_Cell(''), _Cell(''), _Cell('Total'), _Cell('1000')],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xff102d48),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Score', style: TextStyle(fontSize: 9)),
                  Text('1000', style: TextStyle(fontSize: 9)),
                  Text('Grade: A+', style: TextStyle(fontSize: 9)),
                ],
              ),
              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Average', style: TextStyle(fontSize: 9)),
                  Text('100.0', style: TextStyle(fontSize: 9)),
                  Text('GPA: 4.00', style: TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ReportHeader extends StatelessWidget {
  const _ReportHeader();
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0x3dffffff)),
    ),
    child: Column(
      children: [
        const ColoredBox(
          color: Color(0xff55dff5),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                'Monthly 2026–2027',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Name: ${_StudentScope.of(context).name}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              const Expanded(
                child: Text('Sex: Female', style: TextStyle(fontSize: 8)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'ID: ${_StudentScope.of(context).studentId}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              Expanded(
                child: Text(
                  'Level: ${_StudentScope.of(context).grade}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class StudentProfilePage extends StatelessWidget {
  final StudentAccount student;
  const StudentProfilePage({super.key, required this.student});

  static const chocolate = Color(0xff55dff5);
  List<(String, String)> get details => <(String, String)>[
    ('Student ID', student.studentId),
    ('Full name', student.name),
    ('Date of birth', '10 October 2010'),
    ('Gender', 'Female'),
    ('Grade', student.grade),
    ('Class', '9 “A”'),
    ('Academic year', '2026–2027'),
    ('Status', 'Active'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _featureNavy,
      appBar: AppBar(
        backgroundColor: _featureNavy,
        surfaceTintColor: _featureNavy,
        elevation: 0,
        leadingWidth: 42,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_rounded, color: chocolate),
        ),
        titleSpacing: 0,
        title: const Text(
          'Student Information',
          style: TextStyle(
            color: chocolate,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(17, 22, 17, 30),
          child: Column(
            children: [
              Container(
                width: 126,
                height: 126,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: chocolate,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/student-avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0x3dffffff)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: List.generate(details.length, (index) {
                    final detail = details[index];
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? const Color(0xff082f58)
                            : const Color(0xfffbf7f3),
                        border: index == details.length - 1
                            ? null
                            : const Border(
                                bottom: BorderSide(color: Color(0x3dffffff)),
                              ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 10,
                              ),
                              child: Text(
                                detail.$1,
                                style: const TextStyle(
                                  color: Color(0xff5d514a),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(width: 1, color: const Color(0x3dffffff)),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 10,
                              ),
                              child: Text(
                                detail.$2,
                                style: const TextStyle(
                                  color: Color(0xff302a26),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => StudentIdCardPage(student: student),
                        ),
                      ),
                      icon: const Icon(Icons.badge_outlined, size: 18),
                      label: const Text('Student ID Card'),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              EnrollmentCertificatePage(student: student),
                        ),
                      ),
                      icon: const Icon(
                        Icons.workspace_premium_outlined,
                        size: 18,
                      ),
                      label: const Text('Certificate'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/grandview-logo.jpg',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GRANDVIEW SCHOOL',
                        style: TextStyle(
                          color: chocolate,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "VIEW YOUR CHILD'S GENIUS",
                        style: TextStyle(fontSize: 6, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentIdCardPage extends StatelessWidget {
  final StudentAccount student;
  const StudentIdCardPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const _InnerHeader(title: 'Student ID Card'),
    body: Center(
      child: Container(
        width: 330,
        margin: const EdgeInsets.all(22),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff55dff5), Color(0xb3ffffff)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x44000000), blurRadius: 18),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/grandview-logo.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'GRANDVIEW SCHOOL\nSTUDENT ID CARD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 45,
              backgroundImage: const AssetImage('assets/student-avatar.png'),
              backgroundColor: _featureNavy,
            ),
            const SizedBox(height: 12),
            Text(
              student.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _IdCardLine('Student ID', student.studentId),
            _IdCardLine('Grade / Class', student.grade),
            const _IdCardLine('Academic Year', '2026–2027'),
            const _IdCardLine('Status', 'ACTIVE'),
          ],
        ),
      ),
    ),
  );
}

class _IdCardLine extends StatelessWidget {
  final String label;
  final String value;
  const _IdCardLine(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class EnrollmentCertificatePage extends StatelessWidget {
  final StudentAccount student;
  const EnrollmentCertificatePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const _InnerHeader(title: 'Enrollment Certificate'),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xff102d48),
            border: Border.all(color: const Color(0xff55dff5), width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Image.asset('assets/grandview-logo.jpg', width: 72, height: 72),
              const SizedBox(height: 12),
              const Text(
                'GRANDVIEW SCHOOL',
                style: TextStyle(
                  color: Color(0xff55dff5),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'CERTIFICATE OF ENROLLMENT',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              Text(
                'This certifies that ${student.name}, student ID ${student.studentId}, is actively enrolled in ${student.grade} for academic year 2026–2027.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, height: 1.7),
              ),
              const SizedBox(height: 28),
              const Divider(),
              const Text(
                'School Administration',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class StudentAccount {
  final String name;
  final String studentId;
  final String grade;
  final String initials;
  const StudentAccount(this.name, this.studentId, this.grade, this.initials);
}

class _StudentScope extends InheritedWidget {
  final StudentAccount student;
  const _StudentScope({required this.student, required super.child});

  static const fallbackStudent = StudentAccount(
    'SREY RATH',
    'GVS-023',
    'Grade 9A',
    'SR',
  );

  static StudentAccount of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_StudentScope>()?.student ??
      fallbackStudent;

  @override
  bool updateShouldNotify(_StudentScope oldWidget) =>
      oldWidget.student != student;
}

/// Hosts a reference feature page with the student context used by its flows.
class ParentFeatureHost extends StatelessWidget {
  const ParentFeatureHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _featureNavy,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _featureAccent,
        brightness: Brightness.dark,
        surface: _featureCard,
      ),
      dividerColor: Colors.white24,
      cardColor: _featureCard,
    ),
    child: _StudentScope(
      student: const StudentAccount('SREY RATH', 'GVS-023', 'Grade 9A', 'SR'),
      child: child,
    ),
  );
}

class StudentTool {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final int atlasIndex;
  const StudentTool(
    this.label,
    this.icon,
    this.background,
    this.foreground,
    this.atlasIndex,
  );
}

class _ToolButton extends StatelessWidget {
  final StudentTool tool;
  final VoidCallback onTap;
  const _ToolButton({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          key: ValueKey('tool-card-${tool.label}'),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff4f2948), Color(0xff2e202f), Color(0xff422331)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xff76566f), width: 1.1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x45241724),
                blurRadius: 9,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0x306f526e),
                blurRadius: 2,
                offset: Offset(-1, -1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SchoolLineIcon(kind: tool.atlasIndex, size: 39),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  tool.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff082f58),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeneratedAtlasIcon extends StatelessWidget {
  final String asset;
  final int index;
  final int columns;
  final int rows;
  final double size;
  final Color? color;
  const _GeneratedAtlasIcon({
    required this.asset,
    required this.index,
    required this.columns,
    required this.rows,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final column = index % columns;
    final row = index ~/ columns;
    final x = columns == 1 ? 0.0 : -1 + (2 * column / (columns - 1));
    final y = rows == 1 ? 0.0 : -1 + (2 * row / (rows - 1));
    return ClipRect(
      child: SizedBox.square(
        dimension: size,
        child: OverflowBox(
          alignment: Alignment(x, y),
          minWidth: size * columns,
          maxWidth: size * columns,
          minHeight: size * rows,
          maxHeight: size * rows,
          child: Image.asset(
            asset,
            width: size * columns,
            height: size * rows,
            fit: BoxFit.fill,
            color: color,
            colorBlendMode: color == null ? null : BlendMode.srcIn,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _SchoolLineIcon extends StatelessWidget {
  final int kind;
  final double size;
  const _SchoolLineIcon({required this.kind, this.size = 38});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _SchoolLineIconPainter(kind),
  );
}

class _SchoolLineIconPainter extends CustomPainter {
  final int kind;
  const _SchoolLineIconPainter(this.kind);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 40;
    canvas.scale(scale);
    final paint = Paint()
      ..color = const Color(0xff082f58)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    RRect rr(double l, double t, double r, double b, double radius) =>
        RRect.fromRectAndRadius(
          Rect.fromLTRB(l, t, r, b),
          Radius.circular(radius),
        );
    void line(double x1, double y1, double x2, double y2) =>
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    switch (kind) {
      case 0: // wallet
        canvas.drawRRect(rr(7, 11, 31, 29, 2.5), paint);
        line(10, 11, 27, 7);
        canvas.drawRRect(rr(23, 16, 34, 24, 2), paint);
        canvas.drawCircle(const Offset(27, 20), 1, paint);
        break;
      case 1: // profile scanner
        line(7, 13, 7, 8);
        line(7, 8, 12, 8);
        line(28, 8, 33, 8);
        line(33, 8, 33, 13);
        line(7, 27, 7, 32);
        line(7, 32, 12, 32);
        line(28, 32, 33, 32);
        line(33, 32, 33, 27);
        canvas.drawCircle(const Offset(20, 16), 4, paint);
        canvas.drawPath(
          Path()..addArc(const Rect.fromLTRB(13, 20, 27, 31), 3.35, 2.75),
          paint,
        );
        break;
      case 2: // homework clipboard
        canvas.drawRRect(rr(9, 9, 31, 33, 2.5), paint);
        canvas.drawRRect(rr(15, 6, 25, 12, 2), paint);
        line(14, 17, 26, 17);
        line(14, 22, 26, 22);
        line(14, 27, 23, 27);
        break;
      case 3: // attendance calendar
        canvas.drawRRect(rr(8, 10, 32, 32, 2.5), paint);
        line(8, 16, 32, 16);
        line(14, 7, 14, 12);
        line(26, 7, 26, 12);
        for (final y in [21.0, 27.0]) {
          for (final x in [14.0, 20.0, 26.0]) {
            canvas.drawCircle(Offset(x, y), .7, paint);
          }
        }
        break;
      case 4: // grade medal
        canvas.drawCircle(const Offset(20, 17), 9, paint);
        canvas.drawPath(
          Path()
            ..moveTo(14, 24)
            ..lineTo(13, 33)
            ..lineTo(20, 29)
            ..lineTo(27, 33)
            ..lineTo(26, 24),
          paint,
        );
        canvas.drawPath(
          Path()
            ..moveTo(20, 12)
            ..lineTo(21.7, 15.6)
            ..lineTo(25.6, 16.1)
            ..lineTo(22.8, 18.8)
            ..lineTo(23.5, 22.5)
            ..lineTo(20, 20.7)
            ..lineTo(16.5, 22.5)
            ..lineTo(17.2, 18.8)
            ..lineTo(14.4, 16.1)
            ..lineTo(18.3, 15.6)
            ..close(),
          paint,
        );
        break;
      case 5: // timetable clock
        canvas.drawCircle(const Offset(20, 21), 11, paint);
        line(20, 21, 20, 14);
        line(20, 21, 26, 24);
        line(11, 8, 7, 12);
        line(29, 8, 33, 12);
        line(14, 33, 12, 36);
        line(26, 33, 28, 36);
        break;
      case 6: // progress chart
        line(8, 31, 8, 9);
        line(8, 31, 33, 31);
        canvas.drawPath(
          Path()
            ..moveTo(12, 25)
            ..lineTo(17, 19)
            ..lineTo(22, 23)
            ..lineTo(31, 12),
          paint,
        );
        line(25, 12, 31, 12);
        line(31, 12, 31, 18);
        break;
      case 7: // gallery
        canvas.drawRRect(rr(10, 8, 33, 29, 2), paint);
        line(7, 12, 7, 33);
        line(7, 33, 29, 33);
        canvas.drawCircle(const Offset(27, 14), 2, paint);
        canvas.drawPath(
          Path()
            ..moveTo(13, 25)
            ..lineTo(18, 19)
            ..lineTo(22, 23)
            ..lineTo(26, 19)
            ..lineTo(31, 25),
          paint,
        );
        break;
      case 8: // classroom
        canvas.drawRRect(rr(7, 8, 33, 30, 2.5), paint);
        canvas.drawCircle(const Offset(20, 16), 4, paint);
        canvas.drawPath(
          Path()..addArc(const Rect.fromLTRB(13, 20, 27, 31), 3.35, 2.75),
          paint,
        );
        line(12, 33, 28, 33);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _SchoolLineIconPainter oldDelegate) =>
      oldDelegate.kind != kind;
}

class _ProfileTile extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  final Color color;
  final String? imageAsset;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0x3dffffff)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 31,
                height: 31,
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0x22000000), blurRadius: 4),
                  ],
                ),
                child: imageAsset == null
                    ? Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : Image.asset(imageAsset!, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xb3ffffff),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color: Color(0xb3ffffff),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x3dffffff))),
      ),
      child: ListTile(
        dense: true,
        minLeadingWidth: 22,
        horizontalTitleGap: 7,
        contentPadding: const EdgeInsets.symmetric(horizontal: 3),
        leading: Icon(icon, color: const Color(0xff55dff5), size: 19),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xb3ffffff)),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

class _SchoolSeal extends StatelessWidget {
  const _SchoolSeal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xff55dff5), width: 3),
        boxShadow: const [BoxShadow(color: Color(0x246b3f1f), blurRadius: 10)],
      ),
      child: ClipOval(
        child: Image.asset('assets/grandview-logo.jpg', fit: BoxFit.contain),
      ),
    );
  }
}

class _MiniSchoolMark extends StatelessWidget {
  const _MiniSchoolMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 29,
      height: 29,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _featureCard,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xff55dff5), width: 2),
      ),
      child: Image.asset('assets/grandview-logo.jpg', fit: BoxFit.contain),
    );
  }
}
