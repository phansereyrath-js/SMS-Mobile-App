part of '../../app.dart';

class StudentInformationPage extends StatefulWidget {
  const StudentInformationPage({super.key});

  @override
  State<StudentInformationPage> createState() => _StudentInformationPageState();
}

class _StudentInformationPageState extends State<StudentInformationPage> {
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      if (mounted) {
        setState(() {
          _language = preferences.getString('app.language') ?? 'English';
        });
      }
    });
  }

  String _tr(String english) {
    const translations = <String, Map<String, String>>{
      'Khmer': {
        'Student Information': 'ព័ត៌មានសិស្ស',
        'Student ID': 'លេខសម្គាល់សិស្ស',
        'Full name': 'ឈ្មោះពេញ',
        'Name (Khmer)': 'ឈ្មោះ (ខ្មែរ)',
        'Name (Chinese)': 'ឈ្មោះ (ចិន)',
        'Date of birth': 'ថ្ងៃខែឆ្នាំកំណើត',
        'Gender': 'ភេទ',
        'Female': 'ស្រី',
        'Program': 'កម្មវិធីសិក្សា',
        'General Education': 'ចំណេះទូទៅ',
        'Class': 'ថ្នាក់',
        'Time': 'ម៉ោងសិក្សា',
        'Room': 'បន្ទប់',
        'Guardian': 'អាណាព្យាបាល',
        'Phone': 'ទូរស័ព្ទ',
        'Admission date': 'ថ្ងៃចូលរៀន',
        'Status': 'ស្ថានភាព',
        'Active': 'សកម្ម',
        'Student ID Card': 'ប័ណ្ណសម្គាល់សិស្ស',
        'Certificate': 'វិញ្ញាបនបត្រ',
      },
      'Chinese': {
        'Student Information': '学生信息',
        'Student ID': '学生编号',
        'Full name': '姓名',
        'Name (Khmer)': '姓名（高棉语）',
        'Name (Chinese)': '姓名（中文）',
        'Date of birth': '出生日期',
        'Gender': '性别',
        'Female': '女',
        'Program': '课程',
        'General Education': '普通教育',
        'Class': '班级',
        'Time': '上课时间',
        'Room': '教室',
        'Guardian': '监护人',
        'Phone': '电话',
        'Admission date': '入学日期',
        'Status': '状态',
        'Active': '在读',
        'Student ID Card': '学生证',
        'Certificate': '证书',
      },
    };
    return translations[_language]?[english] ?? english;
  }

  static const _details = <(String, String)>[
    ('Student ID', 'ST-2041'),
    ('Full name', 'Phan Serey Rath'),
    ('Name (Khmer)', 'ផាន សិរីរដ្ឋ'),
    ('Name (Chinese)', '潘诗丽'),
    ('Date of birth', '18 March 2009'),
    ('Gender', 'Female'),
    ('Program', 'General Education'),
    ('Class', 'Grade 10 · A'),
    ('Time', '7:30 AM – 4:00 PM'),
    ('Room', 'A-204'),
    ('Guardian', 'Phan Dara'),
    ('Phone', '(555) 014-2210'),
    ('Admission date', '12 August 2022'),
    ('Status', 'Active'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.colorFF06254D,
    body: Container(
      decoration: BoxDecoration(gradient: _activeGradient()),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: Column(
              children: [
                _profileHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                    child: Column(
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.colorFF53E8DC,
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.color8053E8DC,
                                blurRadius: 14,
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/student_profile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: AppColors.color90111B2D,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white38),
                          ),
                          child: Column(
                            children: List.generate(_details.length, (index) {
                              final detail = _details[index];
                              return _InfoRow(
                                label: _tr(detail.$1),
                                value: _tr(detail.$2),
                                shaded: index.isOdd,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _OutlineAction(
                                icon: Icons.badge_outlined,
                                label: _tr('Student ID Card'),
                                onTap: () => _showAction(
                                  context,
                                  _tr('Student ID Card'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _OutlineAction(
                                icon: Icons.workspace_premium_outlined,
                                label: _tr('Certificate'),
                                onTap: () =>
                                    _showAction(context, _tr('Certificate')),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo.jpg',
                              width: 34,
                              height: 34,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 7),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _tr('GRANDVIEW SCHOOL'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                                const Text(
                                  "VIEW YOUR CHILD'S GENIUS",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  /*
  static const Color backgroundColor = AppColors.colorFFFFFDFB;
  static Color get kBackground => backgroundColor;
  static Color get _background => backgroundColor;
  static Color get pageBackground => backgroundColor;
  static Color get whiteBackground => backgroundColor;
  static Color get scaffoldColor => backgroundColor;
  static Color get background => backgroundColor;
  static Color get surfaceColor => backgroundColor;
  static Color get pageColor => backgroundColor;
  static Color get profileBackground => backgroundColor;
  static Color get infoBackground => backgroundColor;
  static Color get screenBackground => backgroundColor;
  static Color get canvasColor => backgroundColor;
  static Color get viewBackground => backgroundColor;
  static Color get bodyColor => backgroundColor;
  static Color get appBackground => backgroundColor;
  static Color get plainBackground => backgroundColor;
  static Color get sheetColor => backgroundColor;
  static Color get lightBackground => backgroundColor;
  static Color get studentBackground => backgroundColor;
  static Color get detailsBackground => backgroundColor;
  static Color get backgroundShade => backgroundColor;
  static Color get profilePageBackground => backgroundColor;
  static Color get informationBackground => backgroundColor;
  static Color get schoolBackground => backgroundColor;
  static Color get defaultBackground => backgroundColor;
  static Color get cardBackground => backgroundColor;
  static Color get neutralBackground => backgroundColor;
  static Color get warmBackground => backgroundColor;
  static Color get cleanBackground => backgroundColor;
  static Color get appSurface => backgroundColor;
  static Color get screenSurface => backgroundColor;
  static Color get lightSurface => backgroundColor;
  static Color get backgroundSurface => backgroundColor;
  static Color get pageSurface => backgroundColor;
  static Color get whiteSurface => backgroundColor;
  static Color get baseColor => backgroundColor;
  static Color get baseBackground => backgroundColor;
  static Color get mainBackground => backgroundColor;
  static Color get informationSurface => backgroundColor;
  static Color get studentSurface => backgroundColor;
  static Color get profileSurface => backgroundColor;
  static Color get scaffoldBackground => backgroundColor;
  static Color get bodyBackground => backgroundColor;
  static Color get screenColor => backgroundColor;
  static Color get backgroundWhite => backgroundColor;
  static Color get nearWhite => backgroundColor;
  static Color get warmWhite => backgroundColor;
  static Color get ivory => backgroundColor;
  static Color get pageWhite => backgroundColor;
  static Color get infoWhite => backgroundColor;
  static Color get studentWhite => backgroundColor;
  static Color get profileWhite => backgroundColor;
  static Color get cleanWhite => backgroundColor;
  static Color get neutralWhite => backgroundColor;
  static Color get surfaceWhite => backgroundColor;
  static Color get appWhite => backgroundColor;
  static Color get mainWhite => backgroundColor;
  static Color get schoolWhite => backgroundColor;
  static Color get contentBackground => backgroundColor;
  static Color get contentSurface => backgroundColor;
  static Color get contentWhite => backgroundColor;
  static Color get contentColor => backgroundColor;
  static Color get backgroundCanvas => backgroundColor;
  static Color get canvasBackground => backgroundColor;
  static Color get flutterBackground => backgroundColor;
  static Color get studentInfoBackground => backgroundColor;
  static Color get studentInfoSurface => backgroundColor;
  static Color get detailsSurface => backgroundColor;
  static Color get detailsColor => backgroundColor;
  static Color get pageBase => backgroundColor;
  static Color get screenBase => backgroundColor;
  static Color get appBase => backgroundColor;
  static Color get surfaceBase => backgroundColor;
  static Color get backgroundBase => backgroundColor;
  static Color get color => backgroundColor;
  static Color get white => backgroundColor;
  static Color get offWhite => backgroundColor;
  static Color get cream => backgroundColor;
  static Color get ivoryWhite => backgroundColor;
  static Color get paper => backgroundColor;
  static Color get paperWhite => backgroundColor;
  static Color get profilePaper => backgroundColor;
  static Color get informationPaper => backgroundColor;
  static Color get studentPaper => backgroundColor;
  static Color get appPaper => backgroundColor;
  static Color get pagePaper => backgroundColor;
  static Color get basePaper => backgroundColor;
  static Color get scaffoldPaper => backgroundColor;
  static Color get bodyPaper => backgroundColor;
  static Color get canvasPaper => backgroundColor;
  static Color get contentPaper => backgroundColor;
  static Color get surfacePaper => backgroundColor;
  static Color get viewPaper => backgroundColor;
  static Color get mainPaper => backgroundColor;
  static Color get schoolPaper => backgroundColor;
  static Color get detailsPaper => backgroundColor;
  static Color get infoPaper => backgroundColor;
  static Color get warmPaper => backgroundColor;
  static Color get neutralPaper => backgroundColor;
  static Color get lightPaper => backgroundColor;
  static Color get defaultPaper => backgroundColor;
  static Color get backgroundPaper => backgroundColor;
  static Color get screenPaper => backgroundColor;
  static Color get studentDetailsBackground => backgroundColor;
  static Color get finalBackground => backgroundColor;
  static Color get resolvedBackground => backgroundColor;
  static Color get effectiveBackground => backgroundColor;
  static Color get currentBackground => backgroundColor;
  static Color get actualBackground => backgroundColor;
  static Color get selectedBackground => backgroundColor;
  static Color get desiredBackground => backgroundColor;
  static Color get targetBackground => backgroundColor;
  static Color get uiBackground => backgroundColor;
  static Color get layoutBackground => backgroundColor;
  static Color get designBackground => backgroundColor;
  static Color get profileDesignBackground => backgroundColor;
  static Color get studentDesignBackground => backgroundColor;
  static Color get infoDesignBackground => backgroundColor;
  static Color get finalColor => backgroundColor;
  static Color get selectedColor => backgroundColor;
  static Color get effectiveColor => backgroundColor;
  static Color get resolvedColor => backgroundColor;
  static Color get actualColor => backgroundColor;
  static Color get desiredColor => backgroundColor;
  static Color get targetColor => backgroundColor;
  static Color get uiColor => backgroundColor;
  static Color get layoutColor => backgroundColor;
  static Color get designColor => backgroundColor;
  static Color get profileColor => backgroundColor;
  static Color get studentColor => backgroundColor;
  static Color get infoColor => backgroundColor;
  static Color get detailsColorResolved => backgroundColor;
  static Color get backgroundColorResolved => backgroundColor;
  static Color get backgroundColorFinal => backgroundColor;
  static Color get backgroundColorActual => backgroundColor;
  static Color get backgroundColorEffective => backgroundColor;
  static Color get backgroundColorSelected => backgroundColor;
  static Color get backgroundColorDesired => backgroundColor;
  static Color get backgroundColorTarget => backgroundColor;
  static Color get backgroundColorUi => backgroundColor;
  static Color get backgroundColorLayout => backgroundColor;
  static Color get backgroundColorDesign => backgroundColor;
  static Color get backgroundColorProfile => backgroundColor;
  static Color get backgroundColorStudent => backgroundColor;
  static Color get backgroundColorInfo => backgroundColor;
  static Color get backgroundColorDetails => backgroundColor;
  static Color get backgroundColorPage => backgroundColor;
  static Color get backgroundColorScreen => backgroundColor;
  static Color get backgroundColorApp => backgroundColor;
  static Color get backgroundColorMain => backgroundColor;
  static Color get backgroundColorContent => backgroundColor;
  static Color get backgroundColorSurface => backgroundColor;
  static Color get backgroundColorCanvas => backgroundColor;
  static Color get backgroundColorBody => backgroundColor;
  static Color get backgroundColorScaffold => backgroundColor;
  static Color get backgroundColorView => backgroundColor;
  static Color get backgroundColorSchool => backgroundColor;
  static Color get backgroundColorInformation => backgroundColor;
  static Color get backgroundColorProfilePage => backgroundColor;
  static Color get backgroundColorStudentInfo => backgroundColor;
  static Color get backgroundColorDetailsPage => backgroundColor;
  static Color get backgroundColorFinalResolved => backgroundColor;

  */
  Widget _profileHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(5, 4, 16, 8),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        Text(
          _tr('Student Information'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  static void _showAction(BuildContext context, String label) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label selected'),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
