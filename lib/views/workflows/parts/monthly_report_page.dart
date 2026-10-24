part of '../workflows.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});
  static const rows = [
    ('English', 'Class Work Completion', '100'),
    ('English', 'Homework Completion', '100'),
    ('English', 'Student Punctuality', '100'),
    ('English', 'Work Independently', '100'),
    ('English', 'Task Responsibility', '100'),
    ('English', 'Student Attendance', '100'),
    ('English', 'Respectful in the class', '100'),
    ('English', 'Morality', '100'),
    ('English', 'Reflection', '100'),
    ('English', 'Communication', '100'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: const _InnerHeader(title: 'Monthly Report'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        Row(
          children: ['English', 'Chinese', 'Math']
              .map(
                (subject) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: subject == 'English'
                          ? AppColors.primaryLight
                          : Colors.white,
                      border: Border.all(color: AppColors.colorFFE3DEDB),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      subject,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: subject == 'English'
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const _ReportHeader(),
        Table(
          border: TableBorder.all(color: AppColors.colorFFD7D2CE),
          columnWidths: const {
            0: FlexColumnWidth(.45),
            1: FlexColumnWidth(1.1),
            2: FlexColumnWidth(2.8),
            3: FlexColumnWidth(.7),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: AppColors.primaryLight),
              children: [
                _Cell('#', light: true),
                _Cell('Subject', light: true),
                _Cell('Class Work', light: true),
                _Cell('Score', light: true),
              ],
            ),
            ...rows.asMap().entries.map(
              (e) => TableRow(
                children: [
                  _Cell('${e.key + 1}'),
                  _Cell(e.value.$1),
                  _Cell(e.value.$2),
                  _Cell(e.value.$3),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: AppColors.colorFFF0E6DC),
              children: [_Cell(''), _Cell(''), _Cell('Total'), _Cell('1000')],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: AppColors.colorFFFFF7EF,
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Score', style: TextStyle(fontSize: 9)),
                  Text('1000', style: TextStyle(fontSize: 9)),
                  Text('Grade: A+', style: TextStyle(fontSize: 9)),
                ],
              ),
              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Average', style: TextStyle(fontSize: 9)),
                  Text('100.0', style: TextStyle(fontSize: 9)),
                  Text('GPA: 4.00', style: TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
