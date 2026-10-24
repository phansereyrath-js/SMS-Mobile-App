part of '../../app.dart';

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
                            color: AppColors.colorFFE65F52,
                          ),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: LanguageProgramCard(
                            icon: '🇬🇧',
                            title: 'English\nProgram',
                            color: AppColors.colorFF5876D8,
                          ),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: LanguageProgramCard(
                            icon: '🇨🇳',
                            title: 'Chinese\nProgram',
                            color: AppColors.colorFFD94B4B,
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
