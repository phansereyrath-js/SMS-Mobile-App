part of '../../app.dart';

class SchoolDashboard extends StatefulWidget {
  const SchoolDashboard({super.key});

  @override
  State<SchoolDashboard> createState() => _SchoolDashboardState();
}

class _SchoolDashboardState extends State<SchoolDashboard> {
  final _controller = DashboardController(
    loadDashboard: () async =>
        backendWorkflowTestData ?? await MobileApi().dashboard(),
  );
  int get _unreadNotifications => _controller.unreadCount.value;
  String get _language => _controller.language.value;
  Map<String, dynamic> get _dashboardData => _controller.data;
  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadUnreadNotifications();
  }

  @override
  void dispose() {
    _controller.onDelete();
    super.dispose();
  }

  Future<void> _loadLanguage() => _controller.loadLanguage();

  String _tr(String english) {
    const values = <String, Map<String, String>>{
      'Khmer': {
        'Student portal': 'ប្រព័ន្ធសិស្ស',
        'Your school day, connected.': 'ភ្ជាប់ជាមួយការសិក្សារបស់អ្នក',
        'Learning hub': 'មជ្ឈមណ្ឌលសិក្សា',
        'Academic overview': 'ទិដ្ឋភាពទូទៅនៃការសិក្សា',
        'School services': 'សេវាសាលា',
        'School Fees': 'ថ្លៃសិក្សា',
        'School announcements': 'សេចក្ដីជូនដំណឹងសាលា',
        'View all': 'មើលទាំងអស់',
        'No announcements yet': 'មិនទាន់មានសេចក្ដីជូនដំណឹង',
        'Updates from your school will appear here.':
            'ព័ត៌មានថ្មីៗពីសាលានឹងបង្ហាញនៅទីនេះ។',
        'Student': 'សិស្ស',
        'Student profile': 'ព័ត៌មានសិស្ស',
        'Check in': 'កត់ត្រាវត្តមាន',
        'View your timetable': 'មើលកាលវិភាគរបស់អ្នក',
        'Plan your next lesson': 'រៀបចំមេរៀនបន្ទាប់',
        'School life': 'ជីវិតក្នុងសាលា',
        'Explore classroom activities': 'ស្វែងយល់ពីសកម្មភាពថ្នាក់',
        'Credits': 'ក្រេឌីត',
        'Grandview School': 'សាលាហ្គ្រែនវីយូ',
        'Payments': 'ការទូទាត់',
        'Homework': 'កិច្ចការផ្ទះ',
        'Cards': 'កាត',
        'Scan QR': 'ស្កេន QR',
        'My Grades': 'ពិន្ទុរបស់ខ្ញុំ',
        'Attendance': 'វត្តមាន',
        'Timetable': 'កាលវិភាគ',
        'Progress': 'វឌ្ឍនភាព',
        'Exchange\nRate': 'អត្រាប្តូរ\nប្រាក់',
        'My Points': 'ពិន្ទុរបស់ខ្ញុំ',
        'Toanchet\nPay': 'ទូទាត់\nតាន់ចិត្ត',
        'Public\nServices': 'សេវា\nសាធារណៈ',
        'Home': 'ទំព័រដើម',
        'Class Activity': 'សកម្មភាពថ្នាក់',
        'My Classes': 'ថ្នាក់របស់ខ្ញុំ',
        'Menu': 'ម៉ឺនុយ',
        'Hello': 'សួស្តី',
        'View student profile': 'មើលព័ត៌មានសិស្ស',
        'GPA': 'មធ្យមភាគ',
        'ECTs': 'ក្រេឌីត',
        'Passed Courses': 'មុខវិជ្ជាបានជាប់',
        'GRANDVIEW': 'ហ្គ្រែនវីយូ',
        'GRANDVIEW SCHOOL': 'សាលាហ្គ្រែនវីយូ',
      },
      'Chinese': {
        'Student portal': '学生门户',
        'Your school day, connected.': '连接你的校园生活',
        'Learning hub': '学习中心',
        'Academic overview': '学业概览',
        'School services': '学校服务',
        'School Fees': '学费',
        'School announcements': '学校公告',
        'View all': '查看全部',
        'No announcements yet': '暂无公告',
        'Updates from your school will appear here.': '学校最新消息将在这里显示。',
        'Student': '学生',
        'Student profile': '学生资料',
        'Check in': '签到',
        'View your timetable': '查看课程表',
        'Plan your next lesson': '安排下一堂课',
        'School life': '校园生活',
        'Explore classroom activities': '探索课堂活动',
        'Credits': '学分',
        'Grandview School': 'GRANDVIEW 学校',
        'Payments': '付款',
        'Homework': '家庭作业',
        'Cards': '卡片',
        'Scan QR': '扫描二维码',
        'My Grades': '我的成绩',
        'Attendance': '考勤',
        'Timetable': '课程表',
        'Progress': '学习进度',
        'Exchange\nRate': '汇率',
        'My Points': '我的积分',
        'Toanchet\nPay': 'Toanchet\n支付',
        'Public\nServices': '公共\n服务',
        'Home': '首页',
        'Class Activity': '课堂活动',
        'My Classes': '我的班级',
        'Menu': '菜单',
        'Hello': '您好',
        'View student profile': '查看学生资料',
        'GPA': '平均绩点',
        'ECTs': '学分',
        'Passed Courses': '已通过课程',
        'GRANDVIEW': 'GRANDVIEW',
        'GRANDVIEW SCHOOL': 'GRANDVIEW SCHOOL',
      },
    };
    return values[_language]?[english] ?? english;
  }

  Future<void> _loadUnreadNotifications() => _controller.reload();

  Future<void> _openNotifications() async {
    await Navigator.pushNamed(context, _notificationsRoute);
    await _loadUnreadNotifications();
  }

  Object? _academicValue(List<String> keys) {
    final sources = <Map<String, dynamic>>[
      Map<String, dynamic>.from(
        _dashboardData['academic_summary'] as Map? ?? const {},
      ),
      Map<String, dynamic>.from(_dashboardData['student'] as Map? ?? const {}),
      _dashboardData,
    ];
    for (final source in sources) {
      for (final key in keys) {
        final value = source[key];
        if (value != null && '$value'.trim().isNotEmpty) return value;
      }
    }
    return null;
  }

  String _academicText(List<String> keys, String fallback) {
    final value = _academicValue(keys);
    if (value == null) return fallback;
    final number = num.tryParse('$value');
    if (number == null) return '$value';
    return number % 1 == 0
        ? number.toInt().toString()
        : number.toStringAsFixed(2);
  }

  Future<void> _openMenu() async {
    Map<String, dynamic> data = const {};
    try {
      data = await _controller.loadDashboard();
    } catch (_) {}
    if (!mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _MenuPage(
          backendData: data,
          language: _language,
          onLogout: () async {
            await _controller.logout();
            if (!mounted) return;
            Navigator.of(context).pop();
            Navigator.pushNamedAndRemoveUntil(
              context,
              _loginRoute,
              (_) => false,
            );
          },
        ),
      ),
    );
    if (mounted) {
      await _loadLanguage();
      await _loadUnreadNotifications();
    }
  }

  static const _learningTools = <({String label, IconData icon, String route})>[
    (label: 'Homework', icon: Icons.menu_book_rounded, route: _homeworkRoute),
    (
      label: 'Timetable',
      icon: Icons.calendar_month_rounded,
      route: _timetableRoute,
    ),
    (
      label: 'Attendance',
      icon: Icons.fact_check_outlined,
      route: _attendanceRoute,
    ),
    (label: 'My Grades', icon: Icons.school_outlined, route: _gradesRoute),
    (label: 'Progress', icon: Icons.insights_rounded, route: _progressRoute),
    (label: 'Scan QR', icon: Icons.qr_code_scanner_rounded, route: _scanRoute),
  ];

  Map get _student => _dashboardData['student'] as Map? ?? const {};
  String get _studentName {
    for (final key in ['name_english', 'name', 'name_khmer']) {
      final name = '${_student[key] ?? ''}'.trim();
      if (name.isNotEmpty) return name;
    }
    return _tr('Student');
  }

  List<Map> get _announcements {
    final records = _dashboardData['records'] as Map? ?? const {};
    final rows = (records['setting-announcement'] as List? ?? const [])
        .whereType<Map>()
        .toList();
    rows.sort(
      (a, b) => '${b['updated_at'] ?? b['UpdatedAt'] ?? ''}'.compareTo(
        '${a['updated_at'] ?? a['UpdatedAt'] ?? ''}',
      ),
    );
    return rows.take(2).toList();
  }

  String _plain(Object? value) => '${value ?? ''}'
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();

  @override
  Widget build(BuildContext context) => Obx(() {
    final studentName = _studentName;
    final unread = _unreadNotifications;
    final announcements = _announcements;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: RefreshIndicator(
              onRefresh: _controller.reload,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _schoolHeader(unread),
                    const SizedBox(height: 24),
                    Text(
                      '${_tr('Hello')}, $studentName',
                      style: const TextStyle(
                        fontSize: 25,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: AppColors.schoolInk,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _tr('Your school day, connected.'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.schoolMuted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _studentCard(studentName),
                    const SizedBox(height: 24),
                    _sectionTitle('Learning hub'),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final largeText =
                            MediaQuery.textScalerOf(context).scale(14) > 19;
                        final columns = largeText || constraints.maxWidth < 310
                            ? 2
                            : 3;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: columns,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: largeText ? .85 : 1.02,
                          children: _learningTools
                              .map(
                                (tool) => _learningTile(
                                  tool.label,
                                  tool.icon,
                                  () =>
                                      Navigator.pushNamed(context, tool.route),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Academic overview'),
                    const SizedBox(height: 12),
                    _academicSummary(),
                    const SizedBox(height: 24),
                    _sectionTitle('School services'),
                    const SizedBox(height: 12),
                    _schoolServices(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _sectionTitle('School announcements')),
                        TextButton(
                          onPressed: _openSchoolAnnouncements,
                          child: Text(_tr('View all')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _announcementList(announcements),
                    const SizedBox(height: 18),
                    _schoolLife(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  });

  Widget _sectionTitle(String text) => Text(
    _tr(text),
    style: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: AppColors.schoolInk,
    ),
  );

  Widget _schoolHeader(int unread) => Row(
    children: [
      Container(
        width: 52,
        height: 58,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'assets/logo.jpg',
          fit: BoxFit.contain,
          semanticLabel: 'Grandview School logo',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('GRANDVIEW'),
              style: const TextStyle(
                fontSize: 17,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _tr('Student portal'),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.schoolMuted,
              ),
            ),
          ],
        ),
      ),
      Badge(
        isLabelVisible: unread > 0,
        label: Text(
          unread > 99 ? '99+' : '$unread',
          key: unread > 0 ? const ValueKey('notification-unread-count') : null,
        ),
        backgroundColor: AppColors.schoolGreen,
        child: IconButton.filledTonal(
          tooltip: _tr('School announcements'),
          onPressed: _openNotifications,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ),
    ],
  );

  Widget _studentCard(String name) => Container(
    key: const ValueKey('school-student-card'),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(22),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    [_student['class'], _student['program']]
                        .where((v) => v != null && '$v'.trim().isNotEmpty)
                        .join(' · '),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: Colors.white24, height: 1),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => Navigator.pushNamed(context, _studentRoute),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _tr('View student profile'),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _learningTile(String label, IconData icon, VoidCallback onTap) =>
      Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.schoolBorder),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.schoolGreenTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 25, color: AppColors.schoolGreen),
                ),
                const SizedBox(height: 9),
                Text(
                  _tr(label),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.schoolInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _academicSummary() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.schoolBorder),
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metric('GPA', _academicText(['gpa', 'GPA', 'average_score'], '—')),
        _metric('Credits', _academicText(['ects', 'ECTs', 'credits'], '—')),
        _metric(
          'Passed Courses',
          _academicText([
            'passed_courses',
            'passedCourses',
            'courses_passed',
          ], '—'),
        ),
      ],
    ),
  );

  Widget _metric(String label, String value) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _tr(label),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppColors.schoolMuted),
        ),
      ],
    ),
  );

  Widget _schoolServices() => Material(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.schoolBorder),
    ),
    child: Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.receipt_long_outlined,
            color: AppColors.primary,
          ),
          title: Text(_tr('School Fees')),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => Navigator.pushNamed(context, _walletRoute),
        ),
        const Divider(height: 1, indent: 56, color: AppColors.schoolBorder),
        ListTile(
          leading: const Icon(
            Icons.history_edu_outlined,
            color: AppColors.primary,
          ),
          title: Text(_tr('Payments')),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => Navigator.pushNamed(context, _paymentsRoute),
        ),
      ],
    ),
  );

  Future<void> _openSchoolAnnouncements() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const BackendNotificationPage(initialTab: 'School'),
      ),
    );
    await _loadUnreadNotifications();
  }

  Widget _announcementList(List<Map> rows) => Material(
    key: const ValueKey('school-announcements'),
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.schoolBorder),
    ),
    child: rows.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(
                  Icons.campaign_outlined,
                  color: AppColors.schoolGreen,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tr('No announcements yet'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.schoolInk,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _tr('Updates from your school will appear here.'),
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.schoolMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: rows
                .map(
                  (row) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    leading: const Icon(
                      Icons.campaign_outlined,
                      color: AppColors.schoolGreen,
                    ),
                    title: Text(
                      _plain(row['Title'] ?? row['title']),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.schoolInk,
                      ),
                    ),
                    subtitle: Text(
                      _plain(row['Description'] ?? row['description']),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.schoolMuted,
                      ),
                    ),
                    onTap: _openSchoolAnnouncements,
                    trailing: const Icon(Icons.chevron_right, size: 18),
                  ),
                )
                .toList(),
          ),
  );

  Widget _schoolLife() => Material(
    color: AppColors.schoolGreenTint,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: () => Navigator.pushNamed(context, _galleryRoute),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(
              Icons.diversity_3_outlined,
              color: AppColors.schoolGreen,
              size: 32,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tr('School life'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.schoolGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _tr('Explore classroom activities'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.schoolMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.schoolGreen,
              size: 20,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _bottomNavigation() => SafeArea(
    top: false,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.schoolBorder)),
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            children: [
              _navItem('Home', Icons.home_rounded, () {}, selected: true),
              _navItem(
                'My Classes',
                Icons.groups_outlined,
                () => Navigator.pushNamed(context, _classesRoute),
              ),
              _navItem(
                'Class Activity',
                Icons.photo_library_outlined,
                () => Navigator.pushNamed(context, _galleryRoute),
              ),
              _navItem('Menu', Icons.menu_rounded, _openMenu),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _navItem(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool selected = false,
  }) => Expanded(
    child: Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.schoolMuted,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                _tr(label),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected ? AppColors.primary : AppColors.schoolMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
