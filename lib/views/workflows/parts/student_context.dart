part of '../workflows.dart';

class StudentContext extends StatelessWidget {
  const StudentContext({super.key, required this.student, required this.child});
  final StudentAccount student;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      _StudentScope(student: student, child: child);
}
