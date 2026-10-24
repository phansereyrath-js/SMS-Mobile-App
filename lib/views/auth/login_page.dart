part of '../../app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _controller = AuthController();
  bool _hidden = true, _remember = true;
  bool get _busy => _controller.busy.value;
  bool get _faceBusy => _controller.faceBusy.value;

  @override
  void initState() {
    super.initState();
    _loadFaceLogin();
  }

  Future<void> _loadFaceLogin() => _controller.loadFaceLogin();

  Future<void> _faceLogin() async {
    try {
      final authenticated = await _controller.faceLogin();
      if (!mounted) return;
      if (authenticated) {
        Navigator.pushNamedAndRemoveUntil(context, _homeRoute, (_) => false);
      } else {
        _showLoginMessage('Face authentication was not completed.');
      }
    } on MobileApiException catch (error) {
      if (mounted) _showLoginMessage(error.message);
    } catch (_) {
      if (mounted) {
        _showLoginMessage(
          'Face authentication is unavailable. Check your phone biometric settings.',
        );
      }
    }
  }

  void _showLoginMessage(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  @override
  void dispose() {
    _controller.onDelete();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    try {
      final signedIn = await _controller.login(_email.text, _password.text);
      if (!signedIn) return;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PhoneShell(
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
                          color: AppColors.colorFF79747E,
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
                            _faceBusy
                                ? 'Scanning Face…'
                                : 'Log In with Face ID',
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
      ),
    );
  }
}
