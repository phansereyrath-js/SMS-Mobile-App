part of '../../../views/workflows/workflows.dart';

class _StudentScope extends InheritedWidget {
  final StudentAccount student;
  const _StudentScope({required this.student, required super.child});

  static const fallbackStudent = StudentAccount('Student', '', '', 'ST');

  static StudentAccount of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_StudentScope>()?.student ??
      fallbackStudent;

  @override
  bool updateShouldNotify(_StudentScope oldWidget) =>
      oldWidget.student != student;
}
