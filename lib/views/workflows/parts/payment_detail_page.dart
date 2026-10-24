part of '../workflows.dart';

class PaymentDetailPage extends StatefulWidget {
  final String invoice;
  final String date;
  final String status;
  final Color statusColor;
  final String description;
  final double amount;
  final String currency;
  final String preInvoiceId;
  final bool canPay;
  final String releasedAt;
  final String paidAt;
  const PaymentDetailPage({
    super.key,
    required this.invoice,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.description,
    required this.amount,
    required this.currency,
    required this.preInvoiceId,
    required this.canPay,
    required this.releasedAt,
    required this.paidAt,
  });
  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  final _payment = PaymentController();
  bool get preparingPayment => _payment.busy.value;

  @override
  void dispose() {
    _payment.onDelete();
    super.dispose();
  }

  late String currentStatus = widget.status;
  late Color currentStatusColor = widget.statusColor;
  Future<void> startBankPayment() async {
    if (preparingPayment) return;
    try {
      final intent = await _payment.prepare(widget.preInvoiceId);
      if (!mounted || intent == null) return;
      if ('${intent['status']}' == 'Paid') {
        setState(() {
          currentStatus = 'Paid';
          currentStatusColor = AppColors.colorFF43B76F;
        });
        return;
      }
      final paymentStatus = await Navigator.of(context).push<String>(
        MaterialPageRoute<String>(
          builder: (_) => BankInvoicePaymentPage(intent: intent),
        ),
      );
      if (paymentStatus != null && mounted) {
        setState(() {
          currentStatus = paymentStatus;
          currentStatusColor = paymentStatus == 'Paid'
              ? AppColors.colorFF43B76F
              : AppColors.colorFF3278C8;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              paymentStatus == 'Paid'
                  ? 'Payment completed and synced with the school.'
                  : 'Receipt submitted for school verification.',
            ),
          ),
        );
        Navigator.pop(context, paymentStatus);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final preparingPayment = _payment.busy.value;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _InnerHeader(title: 'Payment Detail'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.colorFFFFFBF7,
              border: Border.all(color: AppColors.colorFFDFD5CE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.invoice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    _StatusPill(
                      label: currentStatus,
                      color: currentStatusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DetailLine('Invoice date', widget.date),
                _DetailLine(
                  'Student',
                  '${_StudentScope.of(context).name} • ${_StudentScope.of(context).studentId}',
                ),
                _DetailLine('Description', widget.description),
                const Divider(height: 25),
                Row(
                  children: [
                    Text(
                      workflowText(context, 'Total'),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _PaymentProcessTimeline(
            paid: currentStatus == 'Paid',
            releasedAt: widget.releasedAt,
            paidAt: widget.paidAt,
          ),
          const SizedBox(height: 18),
          SystemInvoicePreview(
            invoice: widget.invoice,
            date: widget.date,
            description: widget.description,
            amount: widget.amount,
            currency: widget.currency,
          ),
          const SizedBox(height: 18),
          if (widget.canPay && currentStatus != 'Paid') ...[
            FilledButton.icon(
              onPressed: preparingPayment ? null : startBankPayment,
              icon: preparingPayment
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.account_balance_rounded),
              label: Text(
                preparingPayment
                    ? workflowText(context, 'Preparing secure payment…')
                    : workflowText(context, 'Pay now with bank account'),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.colorFF126F93,
                padding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PaymentCertificatePage(
                  student: _StudentScope.of(context),
                  invoice: widget.invoice,
                  date: widget.date,
                  status: currentStatus,
                  amount: widget.amount,
                  currency: widget.currency,
                ),
              ),
            ),
            icon: const Icon(Icons.receipt_long_outlined),
            label: Text(workflowText(context, 'View Payment Certificate')),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  });
}
