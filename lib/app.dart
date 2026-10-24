import 'controllers/dashboard_controller.dart';
import 'controllers/notifications_controller.dart';
import 'widgets/public/program_cards.dart';
import 'widgets/public/phone_shell.dart';
import 'widgets/public/auth_widgets.dart';

import 'dart:math' as math;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/workflows/backend_workflow_host.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'controllers/theme_controller.dart';
import 'controllers/auth_controller.dart';

import 'package:get/get.dart';

import 'services/mobile_api.dart';
import 'services/notification_read_store.dart';
import 'views/workflows/workflows.dart' as workflow;

export 'core/theme/app_theme.dart';

part 'routes/app_routes.dart';

part 'views/auth/welcome_page.dart';

part 'views/auth/login_page.dart';
part 'views/dashboard/dashboard_page.dart';
part 'views/settings/menu_pages.dart';
part 'widgets/private/dashboard_widgets.dart';
part 'views/notifications/notifications_page.dart';
part 'views/student/student_information_page.dart';
part 'widgets/private/student_widgets.dart';
part 'views/auth/register_page.dart';

part 'views/auth/forgot_password_dialog.dart';

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
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final ThemeController _theme;
  @override
  void initState() {
    super.initState();
    _theme = Get.put(ThemeController());
    _theme.load();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => GetMaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Grandview School',
      initialRoute: widget.initialRoute,
      theme: AppTheme.build(_theme.name.value),
      onGenerateRoute: _onGenerateRoute,
    ),
  );
}
