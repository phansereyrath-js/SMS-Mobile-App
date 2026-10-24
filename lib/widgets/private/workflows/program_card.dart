part of '../../../views/workflows/workflows.dart';

class _ProgramCard extends StatelessWidget {
  final String name, subtitle;
  final VoidCallback onMonthly;
  final VoidCallback onSemester;
  final VoidCallback onAnnually;
  const _ProgramCard({
    required this.name,
    required this.subtitle,
    required this.onMonthly,
    required this.onSemester,
    required this.onAnnually,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.colorFFE8E1DC),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workflowText(context, name),
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    workflowText(context, subtitle),
                    style: const TextStyle(fontSize: 8, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ReportButton('Monthly', Icons.calendar_month_outlined, onMonthly),
            const SizedBox(width: 7),
            _ReportButton('Semester', Icons.date_range_outlined, onSemester),
            const SizedBox(width: 7),
            _ReportButton('Annually', Icons.event_note_outlined, onAnnually),
          ],
        ),
      ],
    ),
  );
}
