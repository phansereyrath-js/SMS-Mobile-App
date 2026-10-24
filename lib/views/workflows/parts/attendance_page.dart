part of '../workflows.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final grade = _StudentScope.of(context).grade;
    final records = BackendDataScope.list(context, 'attendance').map((row) {
      final raw = '${row['state'] ?? ''}';
      final state =
          {'P': 'Present', 'L': 'Late', 'A': 'Absent', 'F': 'Excused'}[raw] ??
          raw;
      final color = state == 'Present'
          ? AppColors.colorFF28945E
          : state == 'Absent'
          ? AppColors.colorFFD94C4C
          : AppColors.colorFFD6A928;
      final date = '${row['attendance_date'] ?? ''}';
      return ('$grade · ${row['session'] ?? ''}', date, date, state, color);
    }).toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Attendance', filter: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 90),
        children: [
          Text(
            workflowText(context, 'Attendance records by date'),
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const Divider(),
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.colorFFD7D2CE),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    records.isEmpty
                        ? workflowText(context, 'No attendance date')
                        : records.first.$2,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 17,
                  color: AppColors.primaryLight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                workflowText(context, 'All records'),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 15),
              Text(
                '● ${workflowText(context, 'Present')}   ○ ${workflowText(context, 'Absent')}   ○ ${workflowText(context, 'Excused')}',
                style: const TextStyle(fontSize: 9, color: Colors.white70),
              ),
            ],
          ),
          const Divider(),
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  workflowText(context, 'No attendance records registered.'),
                ),
              ),
            ),
          ...records.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.colorFFFAF8F6,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _StatusPill(label: item.$4, color: item.$5),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        '${item.$2}  until  ${item.$3}',
                        style: const TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primaryLight),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      workflowText(context, 'Teacher note'),
                      style: TextStyle(fontSize: 9, color: Colors.black38),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        label: const Text('Request leave', style: TextStyle(fontSize: 11)),
      ),
    );
  }
}
