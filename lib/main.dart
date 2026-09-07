import 'dart:math' as math;
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend_workflow_host.dart';
import 'app_theme.dart';
import 'mobile_api.dart';
import 'notification_read_store.dart';
import 'system_cs_workflows.dart' as workflow;

export 'app_theme.dart';

void main() => runApp(const PastelAuthApp());

LinearGradient _activeGradient() => activeAppGradient();

Future<bool> _authenticateWithDeviceBiometrics(String reason) async {
  if (kIsWeb) return false;
  final authentication = LocalAuthentication();
  if (!await authentication.isDeviceSupported()) return false;
  return authentication.authenticate(
    localizedReason: reason,
    biometricOnly: true,
    persistAcrossBackgrounding: true,
  );
}

class PastelAuthApp extends StatefulWidget {
  const PastelAuthApp({super.key, this.initialRoute});

  final String? initialRoute;

  @override
  State<PastelAuthApp> createState() => _PastelAuthAppState();
}

class _PastelAuthAppState extends State<PastelAuthApp> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      final saved = preferences.getString('app.theme');
      final normalized = normalizeAppTheme(saved);
      appThemeName.value = normalized;
      if (saved != normalized) preferences.setString('app.theme', normalized);
    });
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: appThemeName,
    builder: (context, themeName, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pastel Auth',
      initialRoute: widget.initialRoute,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: gradientForAppTheme(themeName).colors[1],
        ),
        scaffoldBackgroundColor: const Color(0xfff3f0f5),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: .86),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xffe9dff5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xffe9dff5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xffb79bf7), width: 1.5),
          ),
        ),
      ),
      onGenerateRoute: _onGenerateRoute,
    ),
  );
}

const _welcomeRoute = '/';
const _loginRoute = '/login';
const _registerRoute = '/register';
const _homeRoute = '/home';
const _notificationsRoute = '/notifications';
const _studentRoute = '/student';
const _walletRoute = '/wallet';
const _scanRoute = '/scan';
const _homeworkRoute = '/homework';
const _paymentsRoute = '/payments';
const _attendanceRoute = '/attendance';
const _gradesRoute = '/grades';
const _timetableRoute = '/timetable';
const _progressRoute = '/progress';
const _galleryRoute = '/gallery';
const _classesRoute = '/classes';

const _gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xff041f45),
    Color(0xff073f7a),
    Color(0xff0b63b6),
    Color(0xff174ea6),
  ],
  stops: [0, .38, .7, 1],
);

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    _loginRoute => const LoginPage(),
    _registerRoute => const RegisterPage(),
    _homeRoute => const BankingDashboard(),
    _notificationsRoute => const BackendNotificationPage(),
    _studentRoute => const StudentInformationPage(),
    _walletRoute => const BackendWorkflowHost(workflow: BackendWorkflow.wallet),
    _scanRoute => const BackendWorkflowHost(workflow: BackendWorkflow.scan),
    _homeworkRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.homework,
    ),
    _paymentsRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.payments,
    ),
    _attendanceRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.attendance,
    ),
    _gradesRoute => const BackendWorkflowHost(workflow: BackendWorkflow.grades),
    _timetableRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.timetable,
    ),
    _progressRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.progress,
    ),
    _galleryRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.gallery,
    ),
    _classesRoute => const BackendWorkflowHost(
      workflow: BackendWorkflow.classes,
    ),
    _ => const WelcomePage(),
  };
  return _route(page, settings.name ?? _welcomeRoute);
}

Route<T> _route<T>(Widget page, String name) => PageRouteBuilder<T>(
  settings: RouteSettings(name: name),
  pageBuilder: (_, animation, __) => page,
  transitionsBuilder: (_, animation, __, child) => FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween(
        begin: const Offset(.08, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  ),
);

class PhoneShell extends StatelessWidget {
  const PhoneShell({
    super.key,
    required this.child,
    this.gradientHeader = false,
  });
  final Widget child;
  final bool gradientHeader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradientHeader ? _activeGradient() : null,
          color: gradientHeader ? null : const Color(0xfff4f5f7),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                margin: MediaQuery.sizeOf(context).width > 500
                    ? const EdgeInsets.symmetric(vertical: 22)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: MediaQuery.sizeOf(context).width > 500
                      ? BorderRadius.circular(34)
                      : BorderRadius.zero,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneShell(
      gradientHeader: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final artHeight = constraints.maxHeight < 700 ? 180.0 : 240.0;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                decoration: BoxDecoration(gradient: _activeGradient()),
                padding: const EdgeInsets.fromLTRB(28, 48, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Grandview School',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.8,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Hi There!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "We're here to make your journey easier.\nThe choice is yours: log in or create an account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.45,
                        color: Colors.white.withValues(alpha: .72),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: artHeight,
                      child: const Center(child: SchoolLogoIllustration()),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Our School Programs',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(
                          child: ProgramCard(
                            imagePath: 'assets/khmer_education_program.png',
                            title: 'National Program',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ProgramCard(
                            imagePath: 'assets/cambridge_program.png',
                            title: 'Cambridge Program',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Language Programs',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    const Row(
                      children: [
                        Expanded(
                          child: LanguageProgramCard(
                            icon: '🇰🇭',
                            title: 'Khmer\nProgram',
                            color: Color(0xffe65f52),
                          ),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: LanguageProgramCard(
                            icon: '🇬🇧',
                            title: 'English\nProgram',
                            color: Color(0xff5876d8),
                          ),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: LanguageProgramCard(
                            icon: '🇨🇳',
                            title: 'Chinese\nProgram',
                            color: Color(0xffd94b4b),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      label: 'Log In',
                      white: true,
                      onTap: () => Navigator.pushNamed(context, _loginRoute),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SchoolLogoIllustration extends StatelessWidget {
  const SchoolLogoIllustration({super.key});

  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/school_icon.png', fit: BoxFit.contain);
}

class ProgramCard extends StatelessWidget {
  const ProgramCard({super.key, required this.imagePath, required this.title});
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) => Container(
    height: 132,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0x99111b2d),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: Colors.white38),
      boxShadow: const [
        BoxShadow(
          color: Color(0x18000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
        const SizedBox(height: 7),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

class LanguageProgramCard extends StatelessWidget {
  const LanguageProgramCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });
  final String icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0x99111b2d),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.white38),
    ),
    child: Column(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: Text(icon, style: const TextStyle(fontSize: 22)),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            height: 1.25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

class _SchoolLogoPainter extends CustomPainter {
  const _SchoolLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final roofPaint = Paint()..color = const Color(0xff8b4a2d);
    final roofShadow = Paint()..color = const Color(0xff6b301b);
    final bodyPaint = Paint()..color = const Color(0xfff5ab2d);
    final darkPaint = Paint()..color = const Color(0xff4d2a19);
    final windowPaint = Paint()..color = const Color(0xffbfe7ff);
    final flagPaint = Paint()..color = const Color(0xffd84131);
    final polePaint = Paint()..color = const Color(0xff4d2a19);
    final trimPaint = Paint()..color = const Color(0xfff5dba8);

    final roof = Path()
      ..moveTo(size.width * 0.10, size.height * 0.35)
      ..lineTo(size.width * 0.90, size.height * 0.35)
      ..lineTo(size.width * 0.78, size.height * 0.58)
      ..lineTo(size.width * 0.22, size.height * 0.58)
      ..close();
    canvas.drawPath(roof, roofShadow);

    final roof2 = Path()
      ..moveTo(size.width * 0.12, size.height * 0.33)
      ..lineTo(size.width * 0.88, size.height * 0.33)
      ..lineTo(size.width * 0.74, size.height * 0.54)
      ..lineTo(size.width * 0.26, size.height * 0.54)
      ..close();
    canvas.drawPath(roof2, roofPaint);

    final building = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.42,
        size.width * 0.64,
        size.height * 0.42,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(building, bodyPaint);

    // top trim band
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.42,
        size.width * 0.64,
        10,
      ),
      trimPaint,
    );

    // windows
    final windowRects = [
      Rect.fromLTWH(
        size.width * 0.24,
        size.height * 0.50,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.36,
        size.height * 0.50,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.48,
        size.height * 0.50,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.60,
        size.height * 0.50,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.24,
        size.height * 0.64,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.36,
        size.height * 0.64,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.48,
        size.height * 0.64,
        size.width * 0.09,
        size.height * 0.10,
      ),
      Rect.fromLTWH(
        size.width * 0.60,
        size.height * 0.64,
        size.width * 0.09,
        size.height * 0.10,
      ),
    ];
    for (final rect in windowRects) {
      canvas.drawRect(rect, windowPaint);
    }

    // front steps / door
    final door = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.43,
        size.height * 0.67,
        size.width * 0.14,
        size.height * 0.17,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(door, Paint()..color = const Color(0xffc8f0ff));
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.47,
        size.height * 0.71,
        size.width * 0.06,
        size.height * 0.11,
      ),
      darkPaint,
    );

    // clock tower
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.27),
      21,
      Paint()..color = const Color(0xfff3f0e9),
    );
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.27),
      17,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = darkPaint.color
        ..strokeWidth = 2.5,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.27),
      Offset(size.width * 0.50, size.height * 0.20),
      darkPaint..strokeWidth = 2.5,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.27),
      Offset(size.width * 0.56, size.height * 0.29),
      darkPaint..strokeWidth = 2.5,
    );

    // flag pole
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.09,
        4,
        size.height * 0.18,
      ),
      polePaint,
    );
    final flag = Path()
      ..moveTo(size.width * 0.50, size.height * 0.09)
      ..lineTo(size.width * 0.50 + 28, size.height * 0.09)
      ..lineTo(size.width * 0.50 + 28, size.height * 0.17)
      ..lineTo(size.width * 0.50, size.height * 0.17)
      ..close();
    canvas.drawPath(flag, flagPaint);

    // roof line accent
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.42),
      Offset(size.width * 0.82, size.height * 0.42),
      darkPaint..strokeWidth = 2,
    );

    final schoolText = TextPainter(
      text: const TextSpan(
        text: 'SCHOOL',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Color(0xff2c1f1c),
          letterSpacing: 0.5,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    schoolText.paint(
      canvas,
      Offset((size.width - schoolText.width) / 2, size.height * 0.17),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _api = MobileApi();
  bool _hidden = true, _remember = true, _busy = false;
  bool _faceLoginEnabled = false;
  bool _faceBusy = false;

  @override
  void initState() {
    super.initState();
    _loadFaceLogin();
  }

  Future<void> _loadFaceLogin() async {
    final preferences = await SharedPreferences.getInstance();
    final enabled = preferences.getBool('app.face_id') ?? false;
    final hasSession = await _api.hasSession();
    if (mounted) setState(() => _faceLoginEnabled = enabled && hasSession);
  }

  Future<void> _faceLogin() async {
    if (_faceBusy) return;
    if (kIsWeb) {
      _showLoginMessage(
        'Secure Face Login is available in the iPhone and Android app.',
      );
      return;
    }
    if (!_faceLoginEnabled || !await _api.hasSession()) {
      _showLoginMessage(
        'Sign in with your password once, then enable Face ID in Settings.',
      );
      return;
    }
    setState(() => _faceBusy = true);
    try {
      final authenticated = await _authenticateWithDeviceBiometrics(
        'Scan your face to sign in to Grandview School',
      );
      if (!mounted) return;
      if (authenticated) {
        Navigator.pushNamedAndRemoveUntil(context, _homeRoute, (_) => false);
      } else {
        _showLoginMessage('Face authentication was not completed.');
      }
    } catch (_) {
      if (mounted) {
        _showLoginMessage(
          'Face authentication is unavailable. Check your phone biometric settings.',
        );
      }
    } finally {
      if (mounted) setState(() => _faceBusy = false);
    }
  }

  void _showLoginMessage(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await _api.login(_email.text, _password.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, _homeRoute, (_) => false);
    } on MobileApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhoneShell(
      child: Column(
        children: [
          const AuthHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(27, 26, 27, 26),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Image.asset(
                        'assets/logo.jpg',
                        height: 156,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Ready to continue your learning journey?\nWe're glad to have you back.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff79747e),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _email,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Student ID',
                        prefixIcon: Icon(Icons.badge_outlined, size: 19),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter your Student ID'
                          : null,
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      controller: _password,
                      obscureText: _hidden,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, size: 19),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 19,
                          ),
                          onPressed: () => setState(() => _hidden = !_hidden),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Password must contain at least 6 characters'
                          : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _remember,
                                visualDensity: VisualDensity.compact,
                                onChanged: (v) =>
                                    setState(() => _remember = v ?? false),
                              ),
                              const Flexible(
                                child: Text(
                                  'Remember me',
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _forgotDialog(context),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    GradientButton(
                      label: _busy ? 'Signing in...' : 'Log In',
                      onTap: _submit,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _faceBusy ? null : _faceLogin,
                        icon: _faceBusy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.face_retouching_natural),
                        label: Text(
                          _faceBusy ? 'Scanning Face…' : 'Log In with Face ID',
                        ),
                      ),
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
}

class BankingDashboard extends StatefulWidget {
  const BankingDashboard({super.key});

  @override
  State<BankingDashboard> createState() => _BankingDashboardState();
}

class _BankingDashboardState extends State<BankingDashboard> {
  int _selectedIndex = 0;
  int _unreadNotifications = 0;
  String _language = 'English';
  Map<String, dynamic> _dashboardData = const {};
  final _notificationStore = NotificationReadStore();
  final _dashboardApi = MobileApi();
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
    _advertisementTimer?.cancel();
    _advertisementController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final language = preferences.getString('app.language') ?? 'English';
    if (mounted) setState(() => _language = language);
  }

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

  Future<void> _loadUnreadNotifications() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!(preferences.getBool('app.notifications') ?? true)) {
        if (mounted) setState(() => _unreadNotifications = 0);
        return;
      }
      final data = backendWorkflowTestData ?? await _dashboardApi.dashboard();
      final count = await _notificationStore.unreadCount(data);
      if (mounted) {
        setState(() {
          _dashboardData = data;
          _unreadNotifications = count;
        });
      }
    } catch (_) {
      // Keep the dashboard available during a temporary backend interruption.
    }
  }

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
      data = backendWorkflowTestData ?? await _dashboardApi.dashboard();
    } catch (_) {}
    if (!mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _MenuPage(
          backendData: data,
          language: _language,
          onLogout: () async {
            await _dashboardApi.logout();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff082f58),
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
  }

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
                color: Color(0xffffcf45),
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
                  color: Color(0xfff36a8d),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(color: Color(0x33ffffff), blurRadius: 6),
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
      color: const Color(0x90111b2d),
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
          color: const Color(0x90111b2d),
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
                            ? const Color(0xff55dff5)
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
        color: const Color(0xe6151722),
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
                    color: active ? const Color(0xffffcf45) : Colors.white,
                    size: 27,
                  ),
                  Text(
                    _tr(item.label),
                    style: TextStyle(
                      color: active ? const Color(0xffffcf45) : Colors.white,
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
      backgroundColor: const Color(0xff06254d),
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
        color: const Color(0xff102d50),
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
                          (language) => RadioListTile<String>(
                            value: language,
                            groupValue: _language,
                            onChanged: (value) {
                              if (value != null) _selectLanguage(value);
                            },
                            dense: true,
                            activeColor: const Color(0xff55dff5),
                            title: Text(
                              _languageLabel(language),
                              style: const TextStyle(color: Colors.white),
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
                color: const Color(0xffff8b9d),
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
                      color: const Color(0xffffb92d),
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
              (theme) => RadioListTile<String>(
                value: theme,
                groupValue: _theme,
                title: Text(_tr(theme)),
                onChanged: (value) => Navigator.pop(context, value),
              ),
            )
            .toList(),
      ),
    );
    if (selected == null) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app.theme', selected);
    appThemeName.value = selected;
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
                        color: Color(0xff343434),
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
                      color: Color(0xffffc928),
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
                      backgroundColor: const Color(0xff412c1a),
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

class _DottedFaceRingPainter extends CustomPainter {
  const _DottedFaceRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xffeeeeee);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 8;
    const dots = 54;
    for (var index = 0; index < dots; index++) {
      final angle = math.pi * 2 * index / dots;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        3.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FaceBackdropPainter extends CustomPainter {
  const _FaceBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
    final shapes = Paint()..color = const Color(0xff2c1c10);
    canvas.drawCircle(Offset(size.width * .88, size.height * .05), 145, shapes);
    canvas.drawCircle(Offset(size.width * .05, size.height * .63), 120, shapes);
    shapes.color = const Color(0xff3a2818);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .72, size.height * .58),
        width: 390,
        height: 145,
      ),
      shapes,
    );
    shapes
      ..color = const Color(0xff20150d)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 54;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .55, size.height * .9),
        width: 210,
        height: 480,
      ),
      shapes,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuDetailScaffold extends StatelessWidget {
  const _MenuDetailScaffold({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff041f45),
    body: Container(
      decoration: BoxDecoration(gradient: _activeGradient()),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              body: Theme(
                data: Theme.of(context).copyWith(
                  cardColor: const Color(0xff102f50),
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xff55dff5),
                    surface: Color(0xff102f50),
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child, required this.padding});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: const Color(0x90111b2d),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white38),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
    ),
    child: child,
  );
}

class _AcademicMetric extends StatelessWidget {
  const _AcademicMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white60, fontSize: 10),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - 10) / 2;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = Colors.white.withValues(alpha: .12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..shader = const SweepGradient(
        colors: [Color(0xff46bfff), Color(0xff35f4c2), Color(0xff46bfff)],
      ).createShader(bounds)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final ring = Paint()
      ..shader = const SweepGradient(
        colors: [Color(0xff46bfff), Color(0xff35f4c2), Color(0xff46bfff)],
      ).createShader(bounds)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final sweep = math.pi * 2 * progress;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(bounds, -math.pi / 2, sweep, false, glow);
    canvas.drawArc(bounds, -math.pi / 2, sweep, false, ring);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _HomeworkTile extends StatelessWidget {
  const _HomeworkTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _GlassPanel(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/homework_icon.png',
            width: 42,
            height: 42,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.horizontal = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool horizontal;
  @override
  Widget build(BuildContext context) => _GlassPanel(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal ? 13 : 8,
      vertical: horizontal ? 15 : 12,
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: horizontal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                label == 'Scan QR'
                    ? const CustomPaint(
                        key: Key('scan-corners-icon'),
                        size: Size.square(36),
                        painter: _ScanQrIconPainter(),
                      )
                    : Icon(icon, color: Colors.white, size: 36),
                const SizedBox(height: 9),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
    ),
  );
}

class _ScanQrIconPainter extends CustomPainter {
  const _ScanQrIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final inset = size.width * .16;
    final arm = size.width * .22;
    final far = size.width - inset;
    final corners = Path()
      ..moveTo(inset + arm, inset)
      ..lineTo(inset, inset)
      ..lineTo(inset, inset + arm)
      ..moveTo(far - arm, inset)
      ..lineTo(far, inset)
      ..lineTo(far, inset + arm)
      ..moveTo(inset, far - arm)
      ..lineTo(inset, far)
      ..lineTo(inset + arm, far)
      ..moveTo(far, far - arm)
      ..lineTo(far, far)
      ..lineTo(far - arm, far);
    canvas.drawPath(corners, paint);
    canvas.drawLine(
      Offset(size.width * .34, size.height * .50),
      Offset(size.width * .66, size.height * .50),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashboardBackdrop extends StatelessWidget {
  const _DashboardBackdrop();
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff041f45),
          Color(0xff073f7a),
          Color(0xff0b63b6),
          Color(0xff174ea6),
        ],
        stops: [0, .38, .7, 1],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          top: -70,
          right: -70,
          child: _glow(const Color(0xffffd35c), 220),
        ),
        Positioned(
          top: 320,
          left: -100,
          child: _glow(const Color(0xffdf2f9c), 260),
        ),
        Positioned(
          bottom: 80,
          right: -90,
          child: _glow(const Color(0xff1b78ff), 260),
        ),
      ],
    ),
  );

  static Widget _glow(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withValues(alpha: .38), color.withValues(alpha: 0)],
      ),
    ),
  );
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const _categories = <({String label, IconData icon, Color color})>[
    (
      label: 'Transactions',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xff59c8ff),
    ),
    (label: 'School', icon: Icons.school_rounded, color: Color(0xff7ee7b2)),
  ];

  static const _items =
      <
        ({
          String category,
          String title,
          String summary,
          String time,
          IconData icon,
          Color color,
        })
      >[
        (
          category: 'Transactions',
          title: 'Tuition payment successful',
          summary: 'Tuition for Grade 10 Term 2 was paid and a receipt was sent to your email.',
          time: '2h ago',
          icon: Icons.payment_rounded,
          color: Color(0xff59c8ff),
        ),
        (
          category: 'School',
          title: 'Academic report available',
          summary: 'Your child\'s latest progress report is now available in the school portal.',
          time: 'Today',
          icon: Icons.description_outlined,
          color: Color(0xff7ee7b2),
        ),
        (
          category: 'Transactions',
          title: 'Lunch account refill',
          summary: 'The school cafeteria balance was topped up with USD 18.00.',
          time: 'Yesterday',
          icon: Icons.fastfood_rounded,
          color: Color(0xff59c8ff),
        ),
        (
          category: 'School',
          title: 'Parent meeting reminder',
          summary: 'The monthly parent-teacher meeting is scheduled for Friday at 4:00 PM.',
          time: 'Yesterday',
          icon: Icons.event_available_rounded,
          color: Color(0xff7ee7b2),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06254d),
      body: Container(
        decoration: BoxDecoration(gradient: _activeGradient()),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 16, 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            '4 New',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((category) {
                        final active = category.label == 'Transactions';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white.withValues(alpha: .18)
                                : Colors.black.withValues(alpha: .14),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: active ? Colors.white38 : Colors.white12,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                color: category.color,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.label,
                                style: TextStyle(
                                  color: active ? Colors.white : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0x99111b2d),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: item.color.withValues(alpha: .22),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: item.color.withValues(alpha: .5),
                                  ),
                                ),
                                child: Icon(
                                  item.icon,
                                  color: item.color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item.time,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.color.withValues(
                                          alpha: .18,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        item.category,
                                        style: TextStyle(
                                          color: item.color,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      item.summary,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

class BackendNotificationPage extends StatefulWidget {
  const BackendNotificationPage({super.key});

  @override
  State<BackendNotificationPage> createState() =>
      _BackendNotificationPageState();
}

class _BackendNotificationPageState extends State<BackendNotificationPage> {
  final _api = MobileApi();
  final _notificationStore = NotificationReadStore();
  late Future<Map<String, dynamic>> _request;
  String _selected = 'Transactions';
  bool _loadedUnread = false;
  Set<String> _unreadKeys = {};
  String _language = 'English';

  String _tr(String english) {
    const translations = <String, Map<String, String>>{
      'Khmer': {
        'Notifications': 'ការជូនដំណឹង',
        'New': 'ថ្មី',
        'Transactions': 'ប្រតិបត្តិការ',
        'School': 'សាលា',
        'Retry': 'ព្យាយាមម្ដងទៀត',
        'Loading notifications...': 'កំពុងផ្ទុកការជូនដំណឹង...',
        'No backend payments received.': 'មិនមានការទូទាត់ពីប្រព័ន្ធទេ។',
        'No school announcements available.': 'មិនមានសេចក្ដីជូនដំណឹងពីសាលាទេ។',
        'Invoice released': 'វិក្កយបត្របានចេញ',
        'Payment received': 'បានទទួលការទូទាត់',
        'payment received': 'បានទទួលការទូទាត់',
        'Paid': 'បានបង់',
        'Pending': 'កំពុងរង់ចាំ',
        'Payment method unavailable': 'មិនមានវិធីទូទាត់',
        'Receipt': 'បង្កាន់ដៃ',
        'School announcement': 'សេចក្ដីជូនដំណឹងពីសាលា',
      },
      'Chinese': {
        'Notifications': '通知',
        'New': '新消息',
        'Transactions': '交易',
        'School': '学校',
        'Retry': '重试',
        'Loading notifications...': '正在加载通知...',
        'No backend payments received.': '暂无后台付款记录。',
        'No school announcements available.': '暂无学校公告。',
        'Invoice released': '发票已发布',
        'Payment received': '已收到付款',
        'payment received': '已收到付款',
        'Paid': '已付款',
        'Pending': '待处理',
        'Payment method unavailable': '付款方式不可用',
        'Receipt': '收据',
        'School announcement': '学校公告',
      },
    };
    return translations[_language]?[english] ?? english;
  }

  @override
  void initState() {
    super.initState();
    _request = backendWorkflowTestData != null
        ? Future.value(backendWorkflowTestData!)
        : _api.dashboard().timeout(const Duration(seconds: 8));
    SharedPreferences.getInstance().then((preferences) {
      if (mounted) {
        setState(() {
          _language = preferences.getString('app.language') ?? 'English';
        });
      }
    });
  }

  void _reload() => setState(() {
    _request = _api.dashboard().timeout(const Duration(seconds: 8));
  });

  String _plain(Object? value) => '${value ?? ''}'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();

  List<Map<String, dynamic>> _list(Map<String, dynamic> data, String key) =>
      (data[key] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

  List<Map<String, dynamic>> _records(
    Map<String, dynamic> data,
    String workflow,
  ) {
    final records = data['records'] as Map? ?? const {};
    return (records[workflow] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _transactionTitle(Map<String, dynamic> row) {
    if (row['_notification_type'] == 'invoice') {
      return _plain(row['invoice_no']).isEmpty
          ? _tr('Invoice released')
          : _plain(row['invoice_no']);
    }
    final category = _plain(row['category']);
    return category.isEmpty
        ? _tr('Payment received')
        : '$category ${_tr('payment received')}';
  }

  String _transactionSummary(Map<String, dynamic> row) {
    if (row['_notification_type'] == 'invoice') {
      final currency = _plain(row['currency']).isEmpty
          ? 'USD'
          : _plain(row['currency']);
      final total = num.tryParse('${row['total']}')?.toDouble() ?? 0;
      final paid = num.tryParse('${row['paid']}')?.toDouble() ?? 0;
      final method = _plain(row['payment_method']);
      final status = paid >= total && total > 0
          ? _tr('Paid')
          : _plain(row['payment_status']).isEmpty
          ? _tr('Pending')
          : _plain(row['payment_status']);
      return '$currency ${total.toStringAsFixed(2)} • $status${method.isEmpty ? '' : ' • $method'}';
    }
    final currency = _plain(row['currency']).isEmpty
        ? 'USD'
        : _plain(row['currency']);
    final amount = num.tryParse('${row['amount']}')?.toDouble() ?? 0;
    final method = _plain(row['method']).isEmpty
        ? _tr('Payment method unavailable')
        : _plain(row['method']);
    final receipt = _plain(row['receipt']);
    return '$currency ${amount.toStringAsFixed(2)} • $method${receipt.isEmpty ? '' : ' • ${_tr('Receipt')} $receipt'}';
  }

  List<Map<String, dynamic>> _transactions(Map<String, dynamic> data) {
    final payments = _list(
      data,
      'payments',
    ).map((row) => {...row, '_notification_type': 'payment'}).toList();
    final receipts = payments
        .map((row) => _plain(row['receipt']))
        .where((value) => value.isNotEmpty)
        .toSet();
    final invoices = _records(data, 'pre-invoices')
        .where((row) => !receipts.contains(_plain(row['payment_receipt'])))
        .map((row) => {...row, '_notification_type': 'invoice'});
    return [...payments, ...invoices]
      ..sort((a, b) => _transactionDate(b).compareTo(_transactionDate(a)));
  }

  String _transactionDate(Map<String, dynamic> row) => _plain(
    row['paid_at'] ??
        row['released_at'] ??
        row['updated_at'] ??
        row['created_at'] ??
        row['invoice_date'],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff06254d),
    body: Container(
      decoration: BoxDecoration(gradient: _activeGradient()),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _request,
              builder: (context, snapshot) {
                final data = snapshot.data ?? const <String, dynamic>{};
                if (snapshot.hasData && !_loadedUnread) {
                  _loadedUnread = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loadUnreadKeys(data);
                  });
                }
                final transactions = _transactions(data);
                final announcements = _records(data, 'setting-announcement')
                  ..sort(
                    (
                      a,
                      b,
                    ) => '${b['updated_at'] ?? b['UpdatedAt'] ?? b['created_at'] ?? ''}'
                        .compareTo(
                          '${a['updated_at'] ?? a['UpdatedAt'] ?? a['created_at'] ?? ''}',
                        ),
                  );
                final items = _selected == 'Transactions'
                    ? transactions
                    : announcements;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 16, 10),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _tr('Notifications'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              '${_unreadKeys.length} ${_tr('New')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _notificationTab(
                            'Transactions',
                            Icons.account_balance_wallet_rounded,
                            const Color(0xff59c8ff),
                          ),
                          const SizedBox(width: 10),
                          _notificationTab(
                            'School',
                            Icons.school_rounded,
                            const Color(0xff7ee7b2),
                          ),
                        ],
                      ),
                    ),
                    if (snapshot.connectionState != ConnectionState.done)
                      const LinearProgressIndicator(color: Color(0xff55dff5)),
                    if (snapshot.hasError)
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: _reload,
                              child: Text(_tr('Retry')),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: items.isEmpty
                          ? Center(
                              child: Text(
                                snapshot.connectionState != ConnectionState.done
                                    ? _tr('Loading notifications...')
                                    : _selected == 'Transactions'
                                    ? _tr('No backend payments received.')
                                    : _tr('No school announcements available.'),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                _reload();
                                await _request;
                              },
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  24,
                                ),
                                itemCount: items.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final row = items[index];
                                  final transaction =
                                      _selected == 'Transactions';
                                  final color = transaction
                                      ? const Color(0xff59c8ff)
                                      : const Color(0xff7ee7b2);
                                  final title = transaction
                                      ? _transactionTitle(row)
                                      : _plain(
                                          row['Title'] ??
                                              _tr('School announcement'),
                                        );
                                  final summary = transaction
                                      ? _transactionSummary(row)
                                      : _plain(row['Description']);
                                  final time = transaction
                                      ? _transactionDate(row)
                                      : _plain(
                                          row['UpdatedAt'] ??
                                              row['updated_at'] ??
                                              row['created_at'],
                                        );
                                  return _backendNotificationCard(
                                    category: _selected,
                                    title: title,
                                    summary: summary,
                                    time: time,
                                    color: color,
                                    icon: transaction
                                        ? Icons.payment_rounded
                                        : Icons.campaign_outlined,
                                    image: transaction
                                        ? ''
                                        : _plain(
                                            row['Image'] ?? row['Attachment'],
                                          ),
                                    onTap: transaction
                                        ? () => _openTransaction(data, row)
                                        : () => _openAnnouncement(row),
                                    unread: _unreadKeys.contains(
                                      _notificationStore.itemKey(
                                        row,
                                        transaction
                                            ? '${row['_notification_type']}'
                                            : 'school',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );

  Widget _notificationTab(String label, IconData icon, Color color) {
    final active = _selected == label;
    return InkWell(
      onTap: () => setState(() => _selected = label),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? Colors.white.withValues(alpha: .18)
              : Colors.black.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: active ? Colors.white38 : Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              _tr(label),
              style: TextStyle(
                color: active ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backendNotificationCard({
    required String category,
    required String title,
    required String summary,
    required String time,
    required Color color,
    required IconData icon,
    String image = '',
    VoidCallback? onTap,
    bool unread = false,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x99111b2d),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (unread)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xfff36a8d),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _tr('New'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          if (image.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 145,
                child: _notificationImage(image),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: .5)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            time,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _tr(category),
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        summary,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _notificationImage(String source) {
    if (source.startsWith('data:image') && source.contains(',')) {
      try {
        return Image.memory(
          base64Decode(source.substring(source.indexOf(',') + 1)),
          fit: BoxFit.cover,
        );
      } catch (_) {}
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            Image.asset('assets/welcome-back.png', fit: BoxFit.cover),
      );
    }
    return Image.asset('assets/welcome-back.png', fit: BoxFit.cover);
  }

  Future<void> _loadUnreadKeys(Map<String, dynamic> data) async {
    final keys = await _notificationStore.unreadKeys(data);
    if (mounted) setState(() => _unreadKeys = keys);
  }

  Future<void> _markItemRead(Map<String, dynamic> row, String type) async {
    final key = _notificationStore.itemKey(row, type);
    await _notificationStore.markRead(key);
    if (mounted) setState(() => _unreadKeys.remove(key));
  }

  Future<void> _openAnnouncement(Map<String, dynamic> row) async {
    await _markItemRead(row, 'school');
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _SchoolAnnouncementPage(announcement: row),
      ),
    );
  }

  Future<void> _openTransaction(
    Map<String, dynamic> data,
    Map<String, dynamic> row,
  ) async {
    final type = '${row['_notification_type']}';
    await _markItemRead(row, type);
    if (!mounted) return;
    final invoice = type == 'invoice';
    final total =
        num.tryParse('${row[invoice ? 'total' : 'amount']}')?.toDouble() ?? 0;
    final paidAmount = num.tryParse('${row['paid']}')?.toDouble() ?? 0;
    final paid = !invoice || (total > 0 && paidAmount >= total);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => workflow.BackendDataScope(
          data: data,
          child: workflow.WorkflowLanguageScope(
            language: _language,
            child: workflow.PaymentDetailPage(
              invoice: _plain(invoice ? row['invoice_no'] : row['receipt']),
              date: _plain(invoice ? row['invoice_date'] : row['paid_at']),
              status: paid
                  ? 'Paid'
                  : _plain(row['payment_status']).isEmpty
                  ? 'Pending'
                  : _plain(row['payment_status']),
              statusColor: paid
                  ? const Color(0xff43b76f)
                  : const Color(0xffe59a23),
              description: _plain(
                invoice ? row['description'] : row['category'],
              ),
              amount: total,
              currency: _plain(row['currency']).isEmpty
                  ? 'USD'
                  : _plain(row['currency']),
              preInvoiceId: invoice ? _plain(row['id']) : '',
              canPay: invoice && !paid,
              releasedAt: _transactionDate(row),
              paidAt: _plain(row['paid_at']),
            ),
          ),
        ),
      ),
    );
  }
}

class _SchoolAnnouncementPage extends StatelessWidget {
  const _SchoolAnnouncementPage({required this.announcement});
  final Map<String, dynamic> announcement;

  String _plain(Object? value) => '${value ?? ''}'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();

  @override
  Widget build(BuildContext context) {
    final title = _plain(announcement['Title'] ?? 'School announcement');
    final description = _plain(announcement['Description']);
    final date = _plain(
      announcement['UpdatedAt'] ??
          announcement['updated_at'] ??
          announcement['created_at'],
    );
    final image = _plain(announcement['Image'] ?? announcement['Attachment']);
    return Scaffold(
      backgroundColor: const Color(0xff06254d),
      appBar: AppBar(
        title: const Text('School Announcement'),
        backgroundColor: const Color(0xff073b68),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: _activeGradient()),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            if (image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 220,
                  child: image.startsWith('data:image') && image.contains(',')
                      ? Image.memory(
                          base64Decode(image.substring(image.indexOf(',') + 1)),
                          fit: BoxFit.cover,
                        )
                      : image.startsWith('http')
                      ? Image.network(image, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/welcome-back.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.white54)),
            const Divider(height: 30, color: Colors.white24),
            Text(
              description.isEmpty ? 'No additional details.' : description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    backgroundColor: const Color(0xff06254d),
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
                              color: const Color(0xff53e8dc),
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x8053e8dc),
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
                            color: const Color(0x90111b2d),
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
  static const Color backgroundColor = Color(0xfffffdfb);
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.shaded,
  });
  final String label, value;
  final bool shaded;
  @override
  Widget build(BuildContext context) => Container(
    color: shaded ? const Color(0x501b3555) : const Color(0x30111b2d),
    child: IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Colors.white24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 18),
    label: Text(label),
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0x50111b2d),
      side: const BorderSide(color: Colors.white54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _email = TextEditingController(),
      _password = TextEditingController();
  bool _hidden = true;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created — connect this button to your API.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => PhoneShell(
    child: Column(
      children: [
        const AuthHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(27, 23, 27, 26),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Create Your Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "We're here to help you reach the goals\nof learning. We are ready!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff79747e),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter full name',
                      prefixIcon: Icon(Icons.person_outline, size: 19),
                    ),
                    validator: (v) => (v?.trim().length ?? 0) < 2
                        ? 'Please enter your full name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                      prefixIcon: Icon(Icons.mail_outline, size: 19),
                    ),
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: _hidden,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      prefixIcon: const Icon(Icons.lock_outline, size: 19),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 19,
                        ),
                        onPressed: () => setState(() => _hidden = !_hidden),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Use at least 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  GradientButton(label: 'Get Started', onTap: _submit),
                  const SizedBox(height: 20),
                  AuthSwitch(
                    text: 'Already have an account?',
                    action: 'Log in',
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, _loginRoute),
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

String? _emailValidator(String? value) {
  final text = value?.trim() ?? '';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
    return 'Please enter a valid email address';
  }
  return null;
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 115,
    decoration: BoxDecoration(
      gradient: _activeGradient(),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(46),
        bottomRight: Radius.circular(46),
      ),
    ),
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
    alignment: Alignment.topLeft,
    child: TextButton.icon(
      onPressed: () => Navigator.maybePop(context),
      icon: const Icon(Icons.arrow_back_ios_new, size: 14),
      label: const Text('Back'),
      style: TextButton.styleFrom(foregroundColor: Colors.white),
    ),
  );
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.white = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool outlined, white;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: white
          ? null
          : (outlined
                ? null
                : const LinearGradient(
                    colors: [Color(0xfff3b6cd), Color(0xffa98bf5)],
                  )),
      color: white ? Colors.white : null,
      border: outlined
          ? Border.all(color: Colors.white.withValues(alpha: .75))
          : (white
                ? Border.all(color: const Color(0xffd7c7f6), width: 1.2)
                : null),
      borderRadius: BorderRadius.circular(25),
      boxShadow: white
          ? const [
              BoxShadow(
                color: Color(0x27000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ]
          : null,
    ),
    child: SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: outlined ? Colors.white : const Color(0xff312739),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    ),
  );
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: Divider(color: Color(0xffe5e2e8))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'Sign in with',
          style: TextStyle(fontSize: 11, color: Color(0xff8a8490)),
        ),
      ),
      Expanded(child: Divider(color: Color(0xffe5e2e8))),
    ],
  );
}

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _social(context, 'G', const Color(0xff4285f4)),
      const SizedBox(width: 16),
      _social(context, 'f', const Color(0xff1877f2)),
      const SizedBox(width: 16),
      _social(context, '●', Colors.black),
    ],
  );
  Widget _social(BuildContext context, String text, Color color) => InkWell(
    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text sign-in selected'),
        behavior: SnackBarBehavior.floating,
      ),
    ),
    borderRadius: BorderRadius.circular(25),
    child: Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffebe9ee)),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 8)],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 21,
        ),
      ),
    ),
  );
}

class AuthSwitch extends StatelessWidget {
  const AuthSwitch({
    super.key,
    required this.text,
    required this.action,
    required this.onTap,
  });
  final String text, action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(
        text,
        style: const TextStyle(fontSize: 12, color: Color(0xff77717c)),
      ),
      TextButton(
        onPressed: onTap,
        child: Text(
          action,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ),
    ],
  );
}

Future<void> _forgotDialog(BuildContext context) async {
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset password'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'Enter your email'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset instructions requested.'),
              ),
            );
          },
          child: const Text('Send'),
        ),
      ],
    ),
  );
  controller.dispose();
}
