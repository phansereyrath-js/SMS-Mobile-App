part of '../workflows.dart';

class SchoolFeesPage extends StatelessWidget {
  const SchoolFeesPage({super.key});
  static const brown = AppColors.primaryLight;

  @override
  Widget build(BuildContext context) {
    final student = _StudentScope.of(context);
    final profile = BackendDataScope.student(context);
    final payments = BackendDataScope.list(context, 'payments');
    final courses = <(String, String, String)>[
      if ('${profile['program'] ?? ''}'.isNotEmpty)
        ('${profile['program']}', student.grade, '${profile['balance'] ?? 0}'),
    ];
    final totalPaid = payments.fold<double>(
      0,
      (sum, row) => sum + (num.tryParse('${row['amount']}')?.toDouble() ?? 0),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'School Fees'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          Text(
            workflowText(
              context,
              'Student fee information and payment history',
            ),
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const Divider(),
          Text(
            '1. ${workflowText(context, 'Current study programs')}',
            style: const TextStyle(
              color: brown,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/student-avatar.png',
                      width: 76,
                      height: 92,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    student.grade,
                    style: const TextStyle(fontSize: 9, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: courses
                      .map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.$1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      course.$2,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const _StatusPill(label: '2026/27', color: brown),
                              const SizedBox(width: 7),
                              SizedBox(
                                width: 49,
                                child: Text(
                                  course.$3,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '2. ${workflowText(context, 'Recent payment records')}',
            style: const TextStyle(
              color: brown,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorFFD7D2CE),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(.6),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(1.4),
                3: FlexColumnWidth(1.2),
              },
              border: const TableBorder(
                horizontalInside: BorderSide(color: AppColors.colorFFE1DCD8),
              ),
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: brown),
                  children: [
                    _Cell('#', light: true),
                    _Cell('Description', light: true),
                    _Cell('Date', light: true),
                    _Cell('Receipt', light: true),
                  ],
                ),
                ...List.generate(
                  payments.length,
                  (i) => TableRow(
                    children: [
                      _Cell('${i + 1}'),
                      _Cell('${payments[i]['category'] ?? 'Payment'}'),
                      _Cell('${payments[i]['paid_at'] ?? ''}'.split(' ').first),
                      const Padding(
                        padding: EdgeInsets.all(7),
                        child: Icon(
                          Icons.download_rounded,
                          size: 15,
                          color: brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: brown,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${workflowText(context, 'Total paid')}: ${totalPaid.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
