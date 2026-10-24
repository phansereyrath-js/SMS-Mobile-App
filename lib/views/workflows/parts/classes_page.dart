part of '../workflows.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});
  static const works = [
    (
      'Math Worksheet Chapter 4',
      'Complete all questions on multiplication practice.',
      'Complete',
      AppColors.colorFF36AD72,
    ),
    (
      'Khmer Review lesson 1',
      'Complete all questions on multiplication practice.',
      'Pending',
      AppColors.colorFFD5A42A,
    ),
    (
      'Science Review lesson 1',
      'Read chapter 5 and answer the questions.',
      'Pending',
      AppColors.colorFFD5A42A,
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: const _InnerHeader(title: 'My Classes'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 25),
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.groups_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${workflowText(context, 'Grandview')} ${_StudentScope.of(context).grade}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      workflowText(context, 'Active classroom and assignments'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: const [
            _ClassCount(Icons.menu_book_rounded, '3', 'Subjects'),
            SizedBox(width: 7),
            _ClassCount(Icons.task_alt_rounded, '1', 'Completed'),
            SizedBox(width: 7),
            _ClassCount(Icons.schedule_rounded, '2', 'Pending'),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          workflowText(context, 'Homework'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        ...works.map(
          (work) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.colorFFFDFCFB,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: AppColors.color0E000000, blurRadius: 8),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calculate_outlined,
                      color: AppColors.primaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workflowText(context, work.$1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            workflowText(context, work.$2),
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      workflowText(context, 'Teacher'),
                      style: const TextStyle(fontSize: 8),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.calendar_month_outlined, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      workflowText(context, '30 May 2026'),
                      style: const TextStyle(fontSize: 8),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        workflowText(context, 'View Homework'),
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    const SizedBox(width: 5),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        workflowText(context, 'Send Homework'),
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _StatusPill(label: work.$3, color: work.$4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
