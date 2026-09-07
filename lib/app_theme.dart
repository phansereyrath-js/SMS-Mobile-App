import 'package:flutter/material.dart';

const appThemeNames = <String>[
  'ACLEDA Blue',
  'Ocean Blue',
  'Emerald',
  'Royal Purple',
  'Sunset',
];

final appThemeName = ValueNotifier<String>('ACLEDA Blue');

String normalizeAppTheme(String? saved) {
  if (saved == 'ACLEDA Dark' || saved == 'Light') return 'ACLEDA Blue';
  return appThemeNames.contains(saved) ? saved! : 'ACLEDA Blue';
}

LinearGradient gradientForAppTheme(String name) => switch (name) {
  'Ocean Blue' => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff032b44), Color(0xff006994), Color(0xff00a6c8)],
  ),
  'Emerald' => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff063d35), Color(0xff087f5b), Color(0xff20a875)],
  ),
  'Royal Purple' => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff241047), Color(0xff57309a), Color(0xff8a4fd3)],
  ),
  'Sunset' => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff542449), Color(0xffb5475b), Color(0xffe88945)],
  ),
  _ => const LinearGradient(
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
};

LinearGradient activeAppGradient() => gradientForAppTheme(appThemeName.value);
