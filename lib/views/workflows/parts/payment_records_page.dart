part of '../workflows.dart';

class PaymentRecordsPage extends StatefulWidget {
  const PaymentRecordsPage({super.key});
  @override
  State<PaymentRecordsPage> createState() => _PaymentRecordsPageState();
}

class _PaymentRecordsPageState extends State<PaymentRecordsPage> {
  final Set<String> locallyPaidInvoices = <String>{};
  final Set<String> locallyPendingInvoices = <String>{};

  @override
  Widget build(BuildContext context) {
    final preInvoices = BackendDataScope.records(context, 'pre-invoices');
    final linkedPaymentReceipts = preInvoices
        .map((row) => '${row['payment_receipt'] ?? ''}'.trim())
        .where((receipt) => receipt.isNotEmpty)
        .toSet();
    final records =
        BackendDataScope.list(context, 'payments')
            .where(
              (row) => !linkedPaymentReceipts.contains(
                '${row['receipt'] ?? ''}'.trim(),
              ),
            )
            .map(
              (row) => (
                '${row['receipt'] ?? ''}',
                '${row['paid_at'] ?? ''}'.split(' ').first,
                'Paid',
                AppColors.colorFF43B76F,
                '${row['category'] ?? 'Payment'}',
                num.tryParse('${row['amount']}')?.toDouble() ?? 0,
                '${row['currency'] ?? 'USD'}',
                '',
                false,
                '${row['paid_at'] ?? ''}',
                '${row['paid_at'] ?? ''}',
              ),
            )
            .toList()
          ..addAll(
            preInvoices.map((row) {
              final id = '${row['id'] ?? ''}';
              final paid =
                  locallyPaidInvoices.contains(id) ||
                  (num.tryParse('${row['paid']}') ?? 0) >=
                      (num.tryParse('${row['total']}') ?? 0);
              final backendStatus = locallyPendingInvoices.contains(id)
                  ? 'Pending Verification'
                  : '${row['payment_status'] ?? ''}';
              final status = paid
                  ? 'Paid'
                  : backendStatus == 'Pending Verification'
                  ? 'Pending Verification'
                  : backendStatus == 'Rejected'
                  ? 'Receipt Rejected'
                  : 'Unpaid';
              return (
                '${row['invoice_no'] ?? ''}',
                '${row['invoice_date'] ?? ''}',
                status,
                paid
                    ? AppColors.colorFF43B76F
                    : backendStatus == 'Pending Verification'
                    ? AppColors.colorFF3278C8
                    : backendStatus == 'Rejected'
                    ? AppColors.colorFFD84B55
                    : AppColors.colorFFE59A23,
                '${row['description'] ?? 'Pre-Invoice'}',
                num.tryParse('${row['total']}')?.toDouble() ?? 0,
                '${row['currency'] ?? 'USD'}',
                id,
                true,
                '${row['released_at'] ?? row['created_at'] ?? row['invoice_date'] ?? ''}',
                '${row['paid_at'] ?? ''}',
              );
            }),
          );
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Payment Records', filter: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 25),
        children: [
          Text(
            workflowText(context, 'All transactions and invoice status'),
            style: const TextStyle(fontSize: 9, color: Colors.white70),
          ),
          const Divider(),
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  workflowText(context, 'No payment records registered.'),
                ),
              ),
            ),
          ...records.map(
            (record) => InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                final status = await Navigator.of(context).push<String>(
                  MaterialPageRoute<String>(
                    builder: (_) => PaymentDetailPage(
                      invoice: record.$1,
                      date: record.$2,
                      status: record.$3,
                      statusColor: record.$4,
                      description: record.$5,
                      amount: record.$6,
                      currency: record.$7,
                      preInvoiceId: record.$8,
                      canPay: record.$9,
                      releasedAt: record.$10,
                      paidAt: record.$11,
                    ),
                  ),
                );
                if (status != null && mounted) {
                  setState(() {
                    if (status == 'Paid') {
                      locallyPaidInvoices.add(record.$8);
                    } else if (status == 'Pending Verification') {
                      locallyPendingInvoices.add(record.$8);
                    }
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.colorFFE1DCD8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            record.$1,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _StatusPill(label: record.$3, color: record.$4),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size: 14),
                        const SizedBox(width: 5),
                        Text(record.$2, style: const TextStyle(fontSize: 9)),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 17,
                          color: AppColors.colorFF9C8B80,
                        ),
                      ],
                    ),
                    const Divider(height: 17),
                    Row(
                      children: [
                        Text(record.$5, style: const TextStyle(fontSize: 9)),
                        const Spacer(),
                        _StatusPill(
                          label: '${record.$7} ${record.$6.toStringAsFixed(2)}',
                          color: AppColors.primaryLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
