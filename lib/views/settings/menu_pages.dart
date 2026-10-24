part of '../../app.dart';

class _MenuPage extends StatelessWidget {
  const _MenuPage({
    required this.backendData,
    required this.language,
    required this.onLogout,
  });
  final Map<String, dynamic> backendData;
  final String language;
  final Future<void> Function() onLogout;

  Map<String, dynamic> get _student =>
      Map<String, dynamic>.from(backendData['student'] as Map? ?? const {});

  @override
  Widget build(BuildContext context) {
    final name = '${_student['name_english'] ?? _student['name'] ?? 'Student'}';
    return Scaffold(
      backgroundColor: AppColors.colorFF06254D,
      body: Container(
        decoration: BoxDecoration(gradient: _activeGradient()),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 14, 6),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 19,
                          backgroundImage: AssetImage(
                            'assets/student_profile.png',
                          ),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${_student['id'] ?? ''}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          language == 'Khmer' ? 'ហ្គ្រែនវីយូ' : 'GRANDVIEW',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 9),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/grandview-logo.jpg',
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _AppMenuSheet(
                      backendData: backendData,
                      onLogout: onLogout,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppMenuSheet extends StatefulWidget {
  const _AppMenuSheet({required this.backendData, required this.onLogout});
  final Map<String, dynamic> backendData;
  final Future<void> Function() onLogout;

  @override
  State<_AppMenuSheet> createState() => _AppMenuSheetState();
}

class _AppMenuSheetState extends State<_AppMenuSheet> {
  String _language = 'English';
  bool _languageOpen = false;

  @override
  void initState() {
    super.initState();
    _restoreLanguage();
  }

  Future<void> _restoreLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString('app.language') ?? 'English';
    if (mounted) setState(() => _language = value);
  }

  Future<void> _selectLanguage(String language) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app.language', language);
    if (mounted) {
      setState(() {
        _language = language;
        _languageOpen = false;
      });
    }
  }

  String _tr(String english) {
    const translations = <String, Map<String, String>>{
      'Khmer': {
        'Menu': 'ម៉ឺនុយ',
        'Language': 'ភាសា',
        'Location': 'ទីតាំង',
        'School Location': 'ទីតាំងសាលា',
        'Products & Services': 'ផលិតផល និងសេវាកម្ម',
        'School programs, services and fees': 'កម្មវិធី សេវាកម្ម និងថ្លៃសិក្សា',
        'Contact Us': 'ទាក់ទងយើង',
        'Rating & Review': 'ការវាយតម្លៃ និងមតិយោបល់',
        'Share your experience': 'ចែករំលែកបទពិសោធន៍របស់អ្នក',
        'Settings': 'ការកំណត់',
        'Notifications and app preferences': 'ការជូនដំណឹង និងការកំណត់កម្មវិធី',
        'Log Out': 'ចាកចេញ',
        'Sign out of this student account': 'ចាកចេញពីគណនីសិស្សនេះ',
        'Write your review': 'សរសេរមតិយោបល់របស់អ្នក',
        'Submit Review': 'ផ្ញើការវាយតម្លៃ',
      },
      'Chinese': {
        'Menu': '菜单',
        'Language': '语言',
        'Location': '学校位置',
        'School Location': '学校位置',
        'Products & Services': '产品与服务',
        'School programs, services and fees': '学校课程、服务和费用',
        'Contact Us': '联系我们',
        'Rating & Review': '评分与评价',
        'Share your experience': '分享您的体验',
        'Settings': '设置',
        'Notifications and app preferences': '通知和应用设置',
        'Log Out': '退出登录',
        'Sign out of this student account': '退出当前学生账户',
        'Write your review': '填写您的评价',
        'Submit Review': '提交评价',
      },
    };
    return translations[_language]?[english] ?? english;
  }

  String _languageLabel(String language) => switch (language) {
    'Khmer' => 'ខ្មែរ',
    'Chinese' => '中文',
    _ => 'English',
  };

  List<Map<String, dynamic>> _records(String workflowName) {
    final groups = widget.backendData['records'] as Map? ?? const {};
    return (groups[workflowName] as List? ?? const [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  Map<String, dynamic> get _school {
    final rows = _records('setting-general');
    return rows.isEmpty ? const {} : rows.first;
  }

  String _field(List<String> keys, [String fallback = 'Not configured']) {
    for (final key in keys) {
      final value = '${_school[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Container(
      constraints: const BoxConstraints(maxWidth: 430),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
      decoration: BoxDecoration(
        color: AppColors.colorFF102D50,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white24),
      ),
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 13),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _tr('Menu'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _menuItem(
                icon: Icons.language_rounded,
                title: _tr('Language'),
                subtitle: _languageLabel(_language),
                onTap: () => setState(() => _languageOpen = !_languageOpen),
                trailing: Icon(
                  _languageOpen ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white54,
                ),
              ),
              if (_languageOpen)
                Padding(
                  padding: const EdgeInsets.only(left: 34, bottom: 6),
                  child: Column(
                    children: ['Khmer', 'English', 'Chinese']
                        .map(
                          (language) => RadioGroup<String>(
                            groupValue: _language,
                            onChanged: (value) {
                              if (value != null) _selectLanguage(value);
                            },
                            child: RadioListTile<String>(
                              value: language,

                              dense: true,
                              activeColor: AppColors.colorFF55DFF5,
                              title: Text(
                                _languageLabel(language),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              _menuItem(
                icon: Icons.location_on_outlined,
                title: _tr('Location'),
                subtitle: _field([
                  '@Company Address',
                  'companyAddress',
                  'address',
                ]),
                onTap: () => _showInformation(
                  _tr('School Location'),
                  _field(['@Company Address', 'companyAddress', 'address']),
                ),
              ),
              _menuItem(
                icon: Icons.widgets_outlined,
                title: _tr('Products & Services'),
                subtitle: _tr('School programs, services and fees'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => _ProductsServicesPage(
                      content: _records('setting-content'),
                      fees: _records('setting-fee'),
                      language: _language,
                    ),
                  ),
                ),
              ),
              _menuItem(
                icon: Icons.support_agent_rounded,
                title: _tr('Contact Us'),
                subtitle: _field(['@Phone Number', 'companyPhone', 'phone']),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => _ContactUsPage(school: _school),
                  ),
                ),
              ),
              _menuItem(
                icon: Icons.star_outline_rounded,
                title: _tr('Rating & Review'),
                subtitle: _tr('Share your experience'),
                onTap: _showRating,
              ),
              _menuItem(
                icon: Icons.settings_outlined,
                title: _tr('Settings'),
                subtitle: _tr('Notifications and app preferences'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const _SettingsPage(),
                  ),
                ),
              ),
              const Divider(color: Colors.white24, height: 22),
              _menuItem(
                icon: Icons.logout_rounded,
                title: _tr('Log Out'),
                subtitle: _tr('Sign out of this student account'),
                color: AppColors.colorFFFF8B9D,
                onTap: () {
                  widget.onLogout();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color color = Colors.white,
  }) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(
      title,
      style: TextStyle(color: color, fontWeight: FontWeight.w800),
    ),
    subtitle: Text(
      subtitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white54, fontSize: 11),
    ),
    trailing:
        trailing ?? const Icon(Icons.chevron_right, color: Colors.white38),
  );

  Future<void> _showInformation(String title, String value) => showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(title: Text(title), content: Text(value)),
  );

  Future<void> _showRating() async {
    var selected = 0;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(_tr('Rating & Review')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: () => update(() => selected = index + 1),
                    icon: Icon(
                      index < selected ? Icons.star : Icons.star_border,
                      color: AppColors.colorFFFFB92D,
                    ),
                  ),
                ),
              ),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(hintText: _tr('Write your review')),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: selected == 0
                  ? null
                  : () => Navigator.pop(dialogContext),
              child: Text(_tr('Submit Review')),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsServicesPage extends StatelessWidget {
  const _ProductsServicesPage({
    required this.content,
    required this.fees,
    required this.language,
  });
  final List<Map<String, dynamic>> content;
  final List<Map<String, dynamic>> fees;
  final String language;

  String _tr(String english) => switch ((language, english)) {
    ('Khmer', 'Products & Services') => 'ផលិតផល និងសេវាកម្ម',
    ('Khmer', 'No products or services configured.') =>
      'មិនទាន់មានផលិតផល ឬសេវាកម្មទេ។',
    ('Khmer', 'Service') => 'សេវាកម្ម',
    ('Chinese', 'Products & Services') => '产品与服务',
    ('Chinese', 'No products or services configured.') => '暂无产品或服务。',
    ('Chinese', 'Service') => '服务',
    _ => english,
  };

  @override
  Widget build(BuildContext context) {
    final rows = [...content, ...fees];
    return _MenuDetailScaffold(
      title: _tr('Products & Services'),
      child: rows.isEmpty
          ? Center(child: Text(_tr('No products or services configured.')))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rows.length,
              itemBuilder: (_, index) {
                final row = rows[index];
                final title =
                    '${row['Title'] ?? row['Fee Name'] ?? row['Name'] ?? _tr('Service')}';
                final description =
                    '${row['Description'] ?? row['Fee Type'] ?? ''}';
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(title),
                    subtitle: description.isEmpty ? null : Text(description),
                  ),
                );
              },
            ),
    );
  }
}

class _ContactUsPage extends StatelessWidget {
  const _ContactUsPage({required this.school});
  final Map<String, dynamic> school;

  String _field(List<String> keys) {
    for (final key in keys) {
      final value = '${school[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return 'Not configured';
  }

  @override
  Widget build(BuildContext context) => _MenuDetailScaffold(
    title: 'Contact Us',
    child: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('Phone'),
          subtitle: Text(_field(['@Phone Number', 'companyPhone', 'phone'])),
        ),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('Email'),
          subtitle: Text(_field(['@Company Email', 'companyEmail', 'email'])),
        ),
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text('Address'),
          subtitle: Text(
            _field(['@Company Address', 'companyAddress', 'address']),
          ),
        ),
      ],
    ),
  );
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  bool _notifications = true;
  bool _faceId = false;
  String _theme = 'ACLEDA Blue';
  String _language = 'English';

  String _tr(String english) {
    const translations = <String, Map<String, String>>{
      'Khmer': {
        'Settings': 'ការកំណត់',
        'Themes': 'រូបរាង',
        'Choose Theme': 'ជ្រើសរើសរូបរាង',
        'ACLEDA Blue': 'អេស៊ីលីដាពណ៌ខៀវ',
        'Ocean Blue': 'ខៀវសមុទ្រ',
        'Emerald': 'ត្បូងមរកត',
        'Royal Purple': 'ស្វាយរាជវង្ស',
        'Sunset': 'ថ្ងៃលិច',
        'Notifications': 'ការជូនដំណឹង',
        'Show new payment and school message counts':
            'បង្ហាញចំនួនការទូទាត់ និងសារសាលាថ្មី',
        'Enable Face ID': 'បើកការសម្គាល់មុខ',
        'Use your enrolled face for faster login':
            'ប្រើមុខដែលបានចុះឈ្មោះ ដើម្បីចូលលឿន',
        'My Face': 'មុខរបស់ខ្ញុំ',
        'Capture or update your face photo': 'ថត ឬកែប្រែរូបថតមុខរបស់អ្នក',
        'Backend connection': 'ការតភ្ជាប់ប្រព័ន្ធ',
        'Connected to the school system': 'បានតភ្ជាប់ទៅប្រព័ន្ធសាលា',
      },
      'Chinese': {
        'Settings': '设置',
        'Themes': '主题',
        'Choose Theme': '选择主题',
        'ACLEDA Blue': 'ACLEDA 蓝',
        'Ocean Blue': '海洋蓝',
        'Emerald': '翡翠绿',
        'Royal Purple': '皇家紫',
        'Sunset': '日落橙',
        'Notifications': '通知',
        'Show new payment and school message counts': '显示新的付款和学校消息数量',
        'Enable Face ID': '启用面容识别',
        'Use your enrolled face for faster login': '使用已录入的面容快速登录',
        'My Face': '我的面容',
        'Capture or update your face photo': '拍摄或更新您的面容照片',
        'Backend connection': '后台连接',
        'Connected to the school system': '已连接到学校系统',
      },
    };
    return translations[_language]?[english] ?? english;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notifications = preferences.getBool('app.notifications') ?? true;
      _faceId = preferences.getBool('app.face_id') ?? false;
      final savedTheme = preferences.getString('app.theme');
      _theme = normalizeAppTheme(savedTheme);
      if (savedTheme != _theme) preferences.setString('app.theme', _theme);
      _language = preferences.getString('app.language') ?? 'English';
    });
  }

  Future<void> _setNotifications(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('app.notifications', value);
    if (mounted) setState(() => _notifications = value);
  }

  Future<void> _setFaceId(bool value) async {
    if (value) {
      if (kIsWeb) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Face ID setup is available in the iPhone and Android app.',
              ),
            ),
          );
        }
        return;
      }
      try {
        final authenticated = await _authenticateWithDeviceBiometrics(
          'Confirm your identity to enable Face ID login',
        );
        if (!authenticated) return;
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No enrolled face biometric is available on this phone.',
              ),
            ),
          );
        }
        return;
      }
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('app.face_id', value);
    if (mounted) setState(() => _faceId = value);
  }

  Future<void> _chooseTheme() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(_tr('Choose Theme')),
        children: appThemeNames
            .map(
              (theme) => RadioGroup<String>(
                groupValue: _theme,
                onChanged: (value) => Navigator.pop(context, value),
                child: RadioListTile<String>(
                  value: theme,

                  title: Text(_tr(theme)),
                ),
              ),
            )
            .toList(),
      ),
    );
    if (selected == null) return;
    await Get.find<ThemeController>().select(selected);
    if (mounted) setState(() => _theme = selected);
  }

  @override
  Widget build(BuildContext context) => _MenuDetailScaffold(
    title: _tr('Settings'),
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(_tr('Themes')),
            subtitle: Text(_tr(_theme)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _chooseTheme,
          ),
        ),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(_tr('Notifications')),
            subtitle: Text(_tr('Show new payment and school message counts')),
            value: _notifications,
            onChanged: _setNotifications,
          ),
        ),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.face_retouching_natural),
            title: Text(_tr('Enable Face ID')),
            subtitle: Text(_tr('Use your enrolled face for faster login')),
            value: _faceId,
            onChanged: _setFaceId,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.face_outlined),
            title: Text(_tr('My Face')),
            subtitle: Text(_tr('Capture or update your face photo')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const _MyFacePage()),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cloud_done_outlined),
            title: Text(_tr('Backend connection')),
            subtitle: Text(_tr('Connected to the school system')),
          ),
        ),
      ],
    ),
  );
}

class _MyFacePage extends StatefulWidget {
  const _MyFacePage();

  @override
  State<_MyFacePage> createState() => _MyFacePageState();
}

class _MyFacePageState extends State<_MyFacePage> {
  Uint8List? _face;
  bool _saving = false;
  String _language = 'English';

  String _tr(String english) => switch ((_language, english)) {
    ('Khmer', 'My Face') => 'មុខរបស់ខ្ញុំ',
    ('Khmer', 'Face Verification') => 'ការផ្ទៀងផ្ទាត់មុខ',
    ('Khmer', 'Saving Face...') => 'កំពុងរក្សាទុកមុខ...',
    ('Khmer', 'Reset') => 'កំណត់ឡើងវិញ',
    ('Khmer', 'Capture Face') => 'ថតរូបមុខ',
    ('Khmer', 'Choose From Gallery') => 'ជ្រើសរើសពីវិចិត្រសាល',
    ('Khmer', 'My Face saved successfully') => 'បានរក្សាទុករូបមុខដោយជោគជ័យ',
    ('Chinese', 'My Face') => '我的面容',
    ('Chinese', 'Face Verification') => '面容验证',
    ('Chinese', 'Saving Face...') => '正在保存面容...',
    ('Chinese', 'Reset') => '重置',
    ('Chinese', 'Capture Face') => '拍摄面容',
    ('Chinese', 'Choose From Gallery') => '从相册选择',
    ('Chinese', 'My Face saved successfully') => '面容保存成功',
    _ => english,
  };

  @override
  void initState() {
    super.initState();
    _loadFace();
  }

  Future<void> _loadFace() async {
    final preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _language = preferences.getString('app.language') ?? 'English';
      });
    }
    final encoded = preferences.getString('app.my_face');
    if (encoded == null || encoded.isEmpty) return;
    try {
      final bytes = base64Decode(encoded);
      if (mounted) setState(() => _face = bytes);
    } catch (_) {}
  }

  Future<void> _selectFace(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1000,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Face image must be 5 MB or smaller')),
        );
      }
      return;
    }
    if (mounted) {
      setState(() => _face = bytes);
      await _saveFace();
    }
  }

  Future<void> _saveFace() async {
    if (_face == null) return;
    setState(() => _saving = true);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app.my_face', base64Encode(_face!));
    if (!kIsWeb) {
      try {
        final authenticated = await _authenticateWithDeviceBiometrics(
          'Confirm your face to enable Face ID login',
        );
        if (authenticated) {
          await preferences.setBool('app.face_id', true);
        }
      } catch (_) {
        // Keep the profile photo even when secure device biometrics are absent.
      }
    }
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_tr('My Face saved successfully'))));
  }

  Future<void> _resetFace() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('app.my_face');
    if (mounted) setState(() => _face = null);
  }

  Future<void> _chooseFaceSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(_tr('Capture Face')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(_tr('Choose From Gallery')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) await _selectFace(source);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        const Positioned.fill(
          child: CustomPaint(painter: _FaceBackdropPainter()),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.colorFF343434,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _tr('My Face'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.flutter_dash_rounded,
                      color: AppColors.colorFFFFC928,
                      size: 38,
                    ),
                  ],
                ),
                const SizedBox(height: 58),
                GestureDetector(
                  onTap: _saving ? null : _chooseFaceSource,
                  child: SizedBox(
                    width: 310,
                    height: 310,
                    child: CustomPaint(
                      painter: const _DottedFaceRingPainter(),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: ClipOval(
                          child: _face == null
                              ? Image.asset(
                                  'assets/student_profile.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(_face!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  _tr(_saving ? 'Saving Face...' : 'Face Verification'),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: FilledButton(
                    onPressed: _resetFace,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.colorFF412C1A,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    child: Text(
                      _tr('Reset'),
                      style: const TextStyle(fontSize: 23),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
