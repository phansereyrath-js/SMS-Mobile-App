part of '../../app.dart';

class BankingDashboard extends StatefulWidget {
  const BankingDashboard({super.key});

  @override
  State<BankingDashboard> createState() => _BankingDashboardState();
}

class _BankingDashboardState extends State<BankingDashboard> {
  int _selectedIndex = 0;
  final _controller = DashboardController(
    loadDashboard: () async =>
        backendWorkflowTestData ?? await MobileApi().dashboard(),
  );
  int get _unreadNotifications => _controller.unreadCount.value;
  String get _language => _controller.language.value;
  Map<String, dynamic> get _dashboardData => _controller.data;
  final _advertisementController = PageController();
  Timer? _advertisementTimer;
  int _advertisementIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadUnreadNotifications();
    _advertisementTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final advertisements = _advertisements;
      if (!mounted || advertisements.length < 2) return;
      _advertisementIndex = (_advertisementIndex + 1) % advertisements.length;
      if (_advertisementController.hasClients) {
        _advertisementController.animateToPage(
          _advertisementIndex,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.onDelete();
    _advertisementTimer?.cancel();
    _advertisementController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() => _controller.loadLanguage();

  String _tr(String english) {
    const values = <String, Map<String, String>>{
      'Khmer': {
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
      setState(() => _selectedIndex = 0);
      await _loadLanguage();
      await _loadUnreadNotifications();
    }
  }

  static const _mainServices = <({String label, IconData icon})>[
    (label: 'Cards', icon: Icons.wallet_outlined),
    (label: 'Scan QR', icon: Icons.qr_code_scanner),
    (label: 'My Grades', icon: Icons.workspace_premium_outlined),
    (label: 'Attendance', icon: Icons.calendar_month_outlined),
    (label: 'Timetable', icon: Icons.alarm_outlined),
    (label: 'Progress', icon: Icons.trending_up_rounded),
  ];

  void _selectService(String name) {
    final route = switch (name) {
      'Cards' || 'My Wallet' => _walletRoute,
      'Scan QR' => _scanRoute,
      'Homework' => _homeworkRoute,
      'Payments' => _paymentsRoute,
      'Attendance' => _attendanceRoute,
      'My Grades' => _gradesRoute,
      'Timetable' => _timetableRoute,
      'Progress' => _progressRoute,
      'Gallery' || 'Class Activity' => _galleryRoute,
      'My Classes' => _classesRoute,
      _ => null,
    };
    if (route != null) {
      Navigator.pushNamed(context, route);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name selected'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    _controller.data.length;
    _controller.unreadCount.value;
    _controller.language.value;
    return Scaffold(
      backgroundColor: AppColors.colorFF082F58,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(
            children: [
              const Positioned.fill(child: _DashboardBackdrop()),
              SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 112),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _topBar(),
                          const SizedBox(height: 24),
                          _profileCard(),
                          const SizedBox(height: 22),
                          _balanceCard(),
                          const SizedBox(height: 16),
                          _wideActions(),
                          const SizedBox(height: 14),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _mainServices.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: .88,
                                ),
                            itemBuilder: (context, index) {
                              final item = _mainServices[index];
                              return _ServiceTile(
                                label: _tr(item.label),
                                icon: item.icon,
                                onTap: () => _selectService(item.label),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          _quickPanel(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 14,
                child: SafeArea(top: false, child: _bottomNavigation()),
              ),
            ],
          ),
        ),
      ),
    );
  });

  Widget _topBar() => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.asset(
          'assets/logo.jpg',
          width: 42,
          height: 42,
          fit: BoxFit.cover,
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
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'MOBILE SCHOOL',
              style: TextStyle(
                color: AppColors.colorFFFFCF45,
                fontSize: 9,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
      ),
      Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: _openNotifications,
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          if (_unreadNotifications > 0)
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                key: const ValueKey('notification-unread-count'),
                constraints: const BoxConstraints(minWidth: 19, minHeight: 19),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.colorFFF36A8D,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(color: AppColors.color33FFFFFF, blurRadius: 6),
                  ],
                ),
                child: Text(
                  _unreadNotifications > 99 ? '99+' : '$_unreadNotifications',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  );

  Widget _profileCard() => _GlassPanel(
    padding: const EdgeInsets.all(13),
    child: InkWell(
      onTap: () => Navigator.pushNamed(context, _studentRoute),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundImage: AssetImage('assets/student_profile.png'),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_tr('Hello')}, SREY RATH',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_tr('View student profile')}  ›',
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    ),
  );

  double get _gpaProgress {
    final raw = num.tryParse(
      '${_academicValue(['gpa', 'GPA', 'average_score']) ?? 75.82}',
    );
    if (raw == null) return .7582;
    return (raw > 4 ? raw / 100 : raw / 4).clamp(0, 1).toDouble();
  }

  Widget _balanceCard() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    decoration: BoxDecoration(
      color: AppColors.color90111B2D,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white38),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
    ),
    child: Row(
      children: [
        SizedBox(
          width: 86,
          height: 86,
          child: CustomPaint(
            painter: _ProgressRingPainter(progress: _gpaProgress),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _academicText(['gpa', 'GPA', 'average_score'], '75.82'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _tr('GPA'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _AcademicMetric(
            label: _tr('ECTs'),
            value: _academicText(['ects', 'ECTs', 'credits'], '165'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AcademicMetric(
            label: _tr('Passed Courses'),
            value: _academicText([
              'passed_courses',
              'passedCourses',
              'courses_passed',
            ], '34'),
          ),
        ),
      ],
    ),
  );

  Widget _wideActions() => Row(
    children: [
      Expanded(
        child: _ServiceTile(
          label: _tr('Payments'),
          icon: Icons.receipt_long_outlined,
          horizontal: true,
          onTap: () => _selectService('Payments'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _HomeworkTile(
          label: _tr('Homework'),
          onTap: () => _selectService('Homework'),
        ),
      ),
    ],
  );

  List<String> get _advertisements {
    final records = _dashboardData['records'] as Map? ?? const {};
    final rows = records['setting-content'] as List? ?? const [];
    final images = rows
        .whereType<Map>()
        .map((row) {
          for (final key in const [
            'Image',
            'image',
            'Attachment',
            'attachment',
            'Banner',
            'banner',
          ]) {
            final value = '${row[key] ?? ''}'.trim();
            if (value.isNotEmpty) return value;
          }
          return '';
        })
        .where((image) => image.isNotEmpty)
        .toList();
    return images.isEmpty
        ? const [
            'assets/cambridge_program.png',
            'assets/khmer_education_program.png',
            'assets/school_icon.png',
          ]
        : images;
  }

  Widget _advertisementImage(String source) {
    if (source.startsWith('data:image') && source.contains(',')) {
      try {
        return Image.memory(
          base64Decode(source.substring(source.indexOf(',') + 1)),
          fit: BoxFit.cover,
        );
      } catch (_) {}
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(source, fit: BoxFit.cover);
    }
    return Image.asset(source, fit: BoxFit.cover);
  }

  Widget _quickPanel() {
    final advertisements = _advertisements;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        key: const ValueKey('advertisement-carousel'),
        height: 145,
        decoration: BoxDecoration(
          color: AppColors.color90111B2D,
          border: Border.all(color: Colors.white38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _advertisementController,
              itemCount: advertisements.length,
              onPageChanged: (index) =>
                  setState(() => _advertisementIndex = index),
              itemBuilder: (_, index) => SizedBox.expand(
                child: _advertisementImage(advertisements[index]),
              ),
            ),
            if (advertisements.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    advertisements.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: index == _advertisementIndex ? 18 : 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == _advertisementIndex
                            ? AppColors.colorFF55DFF5
                            : Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    const items = <({String label, IconData icon})>[
      (label: 'Home', icon: Icons.home_rounded),
      (label: 'Class Activity', icon: Icons.photo_library_outlined),
      (label: 'My Classes', icon: Icons.co_present_outlined),
      (label: 'Menu', icon: Icons.menu_rounded),
    ];
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.colorE6151722,
        borderRadius: BorderRadius.circular(38),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 18)],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index], active = index == _selectedIndex;
          return Expanded(
            child: InkWell(
              onTap: () {
                if (item.label == 'Class Activity') {
                  Navigator.pushNamed(context, _galleryRoute);
                } else if (item.label == 'My Classes') {
                  Navigator.pushNamed(context, _classesRoute);
                } else if (item.label == 'Menu') {
                  setState(() => _selectedIndex = index);
                  _openMenu();
                } else {
                  setState(() => _selectedIndex = index);
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: active ? AppColors.colorFFFFCF45 : Colors.white,
                    size: 27,
                  ),
                  Text(
                    _tr(item.label),
                    style: TextStyle(
                      color: active ? AppColors.colorFFFFCF45 : Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
