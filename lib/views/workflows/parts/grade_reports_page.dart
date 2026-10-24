part of '../workflows.dart';

class GradeReportsPage extends StatelessWidget {
  const GradeReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Grade Reports'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          Text(
            workflowText(context, 'Programs'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _ProgramCard(
            name: 'Chinese English',
            subtitle: 'Chinese & English language program',
            onMonthly: () => _openMonthly(context),
            onSemester: () => _openComparison(
              context,
              'Semester',
              'First Quarter',
              'Second Quarter',
            ),
            onAnnually: () => _openComparison(
              context,
              'Annually',
              'Semester 1',
              'Semester 2',
            ),
          ),
          _ProgramCard(
            name: 'Khmer',
            subtitle: 'Khmer language program',
            onMonthly: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KhmerMonthlyReportPage(),
              ),
            ),
            onSemester: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KhmerPeriodReportPage(
                  title: 'Semester',
                  period: 'Semester 1 in 2026–2027',
                ),
              ),
            ),
            onAnnually: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KhmerPeriodReportPage(
                  title: 'Annually',
                  period: 'Year 2026–2027',
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          Text(
            workflowText(context, 'Recent Reports'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _ReportTile(
            title: 'Chinese English – Monthly Exam',
            date: 'May 2026',
            score: '3.67 GPA',
            onTap: () => _openMonthly(context),
          ),
          _ReportTile(
            title: 'Khmer – Semester',
            date: 'July 2025',
            score: '4.00 GPA',
            onTap: () => _openMonthly(context),
          ),
        ],
      ),
    );
  }

  void _openMonthly(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => const MonthlyReportPage()));

  void _openComparison(
    BuildContext context,
    String title,
    String left,
    String right,
  ) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ComparisonReportPage(
        title: title,
        leftHeader: left,
        rightHeader: right,
      ),
    ),
  );
}
