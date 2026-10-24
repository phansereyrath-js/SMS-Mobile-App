part of '../workflows.dart';

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});
  static const assignments = <(String, String, String, Color)>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Homework', filter: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 24),
        children: [
          Text(
            workflowText(context, 'Your assignments and current status'),
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _SummaryBox('All', '0', AppColors.primaryLight),
              _SummaryBox('Done', '0', AppColors.colorFF16815E),
              _SummaryBox('Overdue', '0', AppColors.colorFFDB3A3A),
              _SummaryBox('Pending', '0', AppColors.colorFFD39D18),
            ],
          ),
          const SizedBox(height: 16),
          if (assignments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  workflowText(
                    context,
                    'No homework records registered in the backend.',
                  ),
                ),
              ),
            ),
          ...assignments.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.colorFFE3DEDB),
                boxShadow: const [
                  BoxShadow(color: AppColors.color0C000000, blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 15),
                            const SizedBox(width: 5),
                            Text(item.$2, style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _StatusPill(label: item.$3, color: item.$4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
