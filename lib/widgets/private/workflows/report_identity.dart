part of '../../../views/workflows/workflows.dart';

class _ReportIdentity extends StatelessWidget {
  final String period;
  const _ReportIdentity({required this.period});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.colorFFD7D2CE),
    ),
    child: Column(
      children: [
        ColoredBox(
          color: AppColors.primaryLight,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                period,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Name: ${_StudentScope.of(context).name}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              const Expanded(
                child: Text('Sex: Female', style: TextStyle(fontSize: 8)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'ID: ${_StudentScope.of(context).studentId}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              Expanded(
                child: Text(
                  'Level: ${_StudentScope.of(context).grade}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
