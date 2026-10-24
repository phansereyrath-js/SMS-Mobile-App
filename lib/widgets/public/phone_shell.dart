import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/theme_controller.dart';

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
          gradient: gradientHeader ? activeAppGradient() : null,
          color: gradientHeader ? null : AppColors.colorFFF4F5F7,
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
                      color: AppColors.color18000000,
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
