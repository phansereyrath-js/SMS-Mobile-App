part of '../workflows.dart';

class ComparisonReportPage extends StatelessWidget {
  final String title;
  final String leftHeader;
  final String rightHeader;
  const ComparisonReportPage({
    super.key,
    required this.title,
    required this.leftHeader,
    required this.rightHeader,
  });
  static const rows = [
    ('Reading', '100', 'Reading', '100'),
    ('Writing', '100', 'Writing', '100'),
    ('Speaking', '100', 'Speaking', '100'),
    ('Listening', '100', 'Listening', '100'),
    ('Quiz', '100', 'Quiz', '100'),
    ('Home', '100', 'Home', '100'),
    ('Art', '100', 'Art', '100'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: _InnerHeader(title: title),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      children: [
        _ReportIdentity(period: title == 'Annually' ? '2026–2027' : 'Semester'),
        Table(
          border: TableBorder.all(color: AppColors.colorFFD7D2CE),
          columnWidths: const {
            0: FlexColumnWidth(.42),
            1: FlexColumnWidth(1.15),
            2: FlexColumnWidth(.65),
            3: FlexColumnWidth(.42),
            4: FlexColumnWidth(1.15),
            5: FlexColumnWidth(.65),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(color: AppColors.primaryLight),
              children: [
                _Cell(leftHeader, light: true),
                const _Cell('Scores', light: true),
                const _Cell(''),
                _Cell(rightHeader, light: true),
                const _Cell('Scores', light: true),
                const _Cell(''),
              ],
            ),
            ...rows.asMap().entries.map(
              (e) => TableRow(
                children: [
                  _Cell('${e.key + 1}'),
                  _Cell(e.value.$1),
                  _Cell(e.value.$2),
                  _Cell('${e.key + 1}'),
                  _Cell(e.value.$3),
                  _Cell(e.value.$4),
                ],
              ),
            ),
            const TableRow(
              decoration: BoxDecoration(color: AppColors.colorFFF0E6DC),
              children: [
                _Cell(''),
                _Cell('Total'),
                _Cell('1000'),
                _Cell(''),
                _Cell('Total'),
                _Cell('1000'),
              ],
            ),
          ],
        ),
        const _ReportTotals(),
      ],
    ),
  );
}
