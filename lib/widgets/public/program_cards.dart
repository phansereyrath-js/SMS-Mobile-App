import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

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
      color: AppColors.schoolDarkSurface,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: Colors.white38),
      boxShadow: const [
        BoxShadow(
          color: AppColors.color18000000,
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
      color: AppColors.schoolDarkSurface,
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
