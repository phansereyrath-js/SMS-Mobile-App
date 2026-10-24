part of '../../app.dart';

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
                      color: AppColors.colorFF79747E,
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
