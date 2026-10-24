import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';

class ThemeController extends GetxController {
  final name = AppColors.themeNames.first.obs;
  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    if (isClosed) return;
    name.value = AppColors.normalize(preferences.getString('app.theme'));
    await preferences.setString('app.theme', name.value);
  }

  Future<void> select(String selected) async {
    final normalized = AppColors.normalize(selected);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app.theme', normalized);
    if (!isClosed) name.value = normalized;
  }
}

const appThemeNames = AppColors.themeNames;
String normalizeAppTheme(String? name) => AppColors.normalize(name);
LinearGradient gradientForAppTheme(String name) => AppColors.gradient(name);
LinearGradient activeAppGradient() => AppColors.gradient(
  Get.isRegistered<ThemeController>()
      ? Get.find<ThemeController>().name.value
      : AppColors.themeNames.first,
);
