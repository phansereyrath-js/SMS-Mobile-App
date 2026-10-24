part of '../workflows.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int selectedDay = 0;
  static const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const lessons = [
    ('07:00 – 09:00', 'Mathematics', 'Room 101 • Mr. Dara'),
    ('09:15 – 10:45', 'English', 'Room 203 • Ms. Lina'),
    ('11:00 – 13:00', 'Science', 'Laboratory • Mr. Vannak'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Class Timetable'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          Text(
            workflowText(context, 'Your weekly classroom schedule'),
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const Divider(),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                days.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    selected: selectedDay == index,
                    onSelected: (_) => setState(() => selectedDay = index),
                    label: Text(workflowText(context, days[index])),
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: selectedDay == index
                          ? Colors.white
                          : AppColors.primaryLight,
                    ),
                    side: const BorderSide(color: AppColors.primaryLight),
                    showCheckmark: false,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          ...lessons.asMap().entries.map((entry) {
            final lesson = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 78,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${workflowText(context, 'Lesson')} ${entry.key + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.$1,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: AppColors.colorFFF7F4F2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workflowText(context, lesson.$2),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lesson.$3,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Text(
                  '${workflowText(context, 'Break time')}: 10:45 – 11:00',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
