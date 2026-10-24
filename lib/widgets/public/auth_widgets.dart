import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/theme_controller.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 115,
    decoration: BoxDecoration(
      gradient: activeAppGradient(),
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
                    colors: [AppColors.buttonStart, AppColors.buttonEnd],
                  )),
      color: white ? Colors.white : null,
      border: outlined
          ? Border.all(color: Colors.white.withValues(alpha: .75))
          : (white
                ? Border.all(color: AppColors.colorFFD7C7F6, width: 1.2)
                : null),
      borderRadius: BorderRadius.circular(25),
      boxShadow: white
          ? const [
              BoxShadow(
                color: AppColors.color27000000,
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
          foregroundColor: outlined ? Colors.white : AppColors.colorFF312739,
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
      Expanded(child: Divider(color: AppColors.colorFFE5E2E8)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'Sign in with',
          style: TextStyle(fontSize: 11, color: AppColors.colorFF8A8490),
        ),
      ),
      Expanded(child: Divider(color: AppColors.colorFFE5E2E8)),
    ],
  );
}

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _social(context, 'G', AppColors.colorFF4285F4),
      const SizedBox(width: 16),
      _social(context, 'f', AppColors.colorFF1877F2),
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
        border: Border.all(color: AppColors.colorFFEBE9EE),
        boxShadow: const [
          BoxShadow(color: AppColors.color12000000, blurRadius: 8),
        ],
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
        style: const TextStyle(fontSize: 12, color: AppColors.colorFF77717C),
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
