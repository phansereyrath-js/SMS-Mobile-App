part of '../workflows.dart';

class KhmerMonthlyReportPage extends StatelessWidget {
  const KhmerMonthlyReportPage({super.key});
  static const subjects = [
    'Khmer',
    'Math',
    'History',
    'Biology',
    'English',
    'Science',
    'Computer',
    'Chemistry',
    'Geography',
    'Earth Science',
    'Sport',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: const _InnerHeader(title: 'Monthly'),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        const _ReportIdentity(period: 'Monthly in 2026–2027'),
        Table(
          border: TableBorder.all(color: AppColors.colorFFD7D2CE),
          columnWidths: const {
            0: FlexColumnWidth(.45),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(2.4),
            3: FlexColumnWidth(.7),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: AppColors.primaryLight),
              children: [
                _Cell('#', light: true),
                _Cell('Khmer', light: true),
                _Cell('Subject', light: true),
                _Cell('Scores', light: true),
              ],
            ),
            ...subjects.asMap().entries.map(
              (e) => TableRow(
                children: [
                  _Cell('${e.key + 1}'),
                  const _Cell('Khmer'),
                  _Cell(e.value),
                  const _Cell('100'),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: AppColors.colorFFF0E6DC),
              children: [
                _Cell(''),
                _Cell('Total'),
                _Cell('Total'),
                _Cell('1100'),
              ],
            ),
          ],
        ),
        const _ReportTotals(),
      ],
    ),
  );
}
