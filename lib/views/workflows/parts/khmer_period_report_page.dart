part of '../workflows.dart';

class KhmerPeriodReportPage extends StatelessWidget {
  final String title;
  final String period;
  const KhmerPeriodReportPage({
    super.key,
    required this.title,
    required this.period,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: _InnerHeader(title: title),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        _ReportIdentity(period: period),
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
            ...KhmerMonthlyReportPage.subjects.asMap().entries.map(
              (entry) => TableRow(
                children: [
                  _Cell('${entry.key + 1}'),
                  const _Cell('Khmer'),
                  _Cell(entry.value),
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
