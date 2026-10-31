part of '../app.dart';

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

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    _loginRoute => const LoginPage(),
    _registerRoute => const RegisterPage(),
    _homeRoute => const SchoolDashboard(),
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
  pageBuilder: (_, animation, _) => page,
  transitionsBuilder: (_, animation, _, child) => FadeTransition(
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
