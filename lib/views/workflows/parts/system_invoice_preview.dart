part of '../workflows.dart';

class SystemInvoicePreview extends StatelessWidget {
  final String invoice;
  final String date;
  final String description;
  final double amount;
  final String currency;
  const SystemInvoicePreview({
    super.key,
    required this.invoice,
    required this.date,
    required this.description,
    required this.amount,
    required this.currency,
  });

  String _value(
    Map<String, dynamic> row,
    List<String> keys, [
    String fallback = '—',
  ]) {
    for (final key in keys) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final student = _StudentScope.of(context);
    final profile = BackendDataScope.student(context);
    final general = backendFirstRecord(context, 'setting-general');
    final banks = BackendDataScope.records(context, 'setting-bank-account');
    Map<String, dynamic> bank = const {};
    for (final row in banks) {
      final active = '${row['Status'] ?? 'Active'}'.toLowerCase() != 'inactive';
      if (active &&
          '${row['Currency'] ?? currency}'.toUpperCase() ==
              currency.toUpperCase()) {
        bank = row;
        break;
      }
    }
    if (bank.isEmpty) {
      for (final row in banks) {
        if ('${row['Status'] ?? 'Active'}'.toLowerCase() != 'inactive') {
          bank = row;
          break;
        }
      }
    }
    final logo = _value(general, ['companyInvoice', 'companyLogo'], '');
    final qr = _value(bank, ['QR Image'], '');
    final money = '$currency ${amount.toStringAsFixed(2)}';
    const border = BorderSide(color: AppColors.colorFFC8D9EC);
    Widget info(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: value),
          ],
        ),
        style: const TextStyle(fontSize: 9),
      ),
    );
    Widget total(String label, String value) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(border: Border(bottom: border)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 8),
            ),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 8)),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.colorFFD8DDE5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 115,
            child: logo.isNotEmpty
                ? backendDataImage(
                    logo,
                    fit: BoxFit.contain,
                    fallback: backendSchoolLogo(size: 110),
                  )
                : backendSchoolLogo(size: 110),
          ),
          const Text(
            'Proforma Invoice',
            style: TextStyle(fontSize: 18, color: AppColors.colorFF20283B),
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    info('Student', student.name),
                    info('Gender', _value(profile, ['gender', 'Gender'])),
                    info('Time', _value(profile, ['time', 'Time'])),
                    info('Room', _value(profile, ['room', 'Room'])),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    info('Invoice', invoice),
                    info('Date', date),
                    info(
                      'Phone',
                      _value(profile, ['phone', 'main_contact', 'contact']),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: AppColors.colorFFC8D9EC),
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(1.4),
              2: FlexColumnWidth(.8),
              3: FlexColumnWidth(1.3),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: AppColors.colorFFEAF2FF),
                children: [
                  _InvoiceCell('DESCRIPTION', bold: true),
                  _InvoiceCell('LEVEL', bold: true),
                  _InvoiceCell('QTY', bold: true),
                  _InvoiceCell('TOTAL', bold: true),
                ],
              ),
              TableRow(
                children: [
                  _InvoiceCell(description),
                  _InvoiceCell(
                    student.grade.isEmpty ? 'Unassigned' : student.grade,
                  ),
                  const _InvoiceCell('1'),
                  _InvoiceCell(money),
                ],
              ),
            ],
          ),
          total('Sub Total', money),
          total('Discount', '$currency 0.00'),
          total('Grand Total', money),
          total('Amount Paid', money),
          const SizedBox(height: 14),
          if (bank.isNotEmpty) ...[
            SizedBox(
              height: 125,
              child: qr.isEmpty
                  ? const Icon(Icons.qr_code_2, size: 110)
                  : backendDataImage(
                      qr,
                      fit: BoxFit.contain,
                      fallback: const Icon(Icons.qr_code_2, size: 110),
                    ),
            ),
            Text(
              _value(bank, ['Bank Name'], 'Bank Account'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            Text(
              '${_value(bank, ['Account Name'], '')} · ${_value(bank, ['Account Number'], '')} · ${_value(bank, ['Currency'], currency)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9),
            ),
          ] else
            const Text(
              'Bank QR is not configured in School Settings',
              style: TextStyle(fontSize: 9, color: Colors.redAccent),
            ),
          const SizedBox(height: 14),
          Text(
            [
              _value(general, [
                '@Company Address',
                'companyAddress',
                'address',
              ], ''),
              _value(general, ['@Phone Number', 'phone'], ''),
              _value(general, ['@Company Email', 'email'], ''),
            ].where((v) => v.isNotEmpty).join('  ·  '),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 7),
          ),
          const SizedBox(height: 18),
          const Text(
            'Cashier Signature',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
