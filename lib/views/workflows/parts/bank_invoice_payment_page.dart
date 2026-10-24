part of '../workflows.dart';

class BankInvoicePaymentPage extends StatefulWidget {
  final Map<String, dynamic> intent;
  const BankInvoicePaymentPage({super.key, required this.intent});

  @override
  State<BankInvoicePaymentPage> createState() => _BankInvoicePaymentPageState();
}

class _BankInvoicePaymentPageState extends State<BankInvoicePaymentPage> {
  final _payment = PaymentController();
  bool get completing => _payment.busy.value;

  @override
  void dispose() {
    _payment.onDelete();
    super.dispose();
  }

  Uint8List? receiptBytes;
  String receiptMime = 'image/jpeg';

  Map<String, dynamic> get bank =>
      Map<String, dynamic>.from(widget.intent['bank'] as Map? ?? const {});

  String value(String key, [String fallback = '—']) {
    final result = '${bank[key] ?? ''}'.trim();
    return result.isEmpty ? fallback : result;
  }

  Future<void> copyText(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$label copied')));
    }
  }

  Future<void> pickReceipt() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    if (bytes.length > 5 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt image must be 5 MB or smaller'),
          ),
        );
      }
      return;
    }
    final lower = image.name.toLowerCase();
    setState(() {
      receiptBytes = bytes;
      receiptMime = lower.endsWith('.png')
          ? 'image/png'
          : lower.endsWith('.webp')
          ? 'image/webp'
          : 'image/jpeg';
    });
  }

  Future<void> submitReceipt() async {
    if (receiptBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload your bank payment receipt first')),
      );
      return;
    }
    if (completing) return;
    try {
      final submitted = await _payment.submitReceipt(
        invoiceId: '${widget.intent['invoice_id'] ?? ''}',
        reference: '${widget.intent['reference'] ?? ''}',
        bytes: receiptBytes!,
        mimeType: receiptMime,
      );
      if (!mounted || !submitted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.colorFF3278C8,
            size: 54,
          ),
          title: const Text('Receipt submitted'),
          content: const Text(
            'The school will verify your bank receipt. The invoice status is now Pending Verification.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context, 'Pending Verification');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final qr = value('QR Image', '');
    final reference = '${widget.intent['reference'] ?? ''}';
    final paymentLink = '${widget.intent['payment_link'] ?? ''}';
    final amount = num.tryParse('${widget.intent['amount']}') ?? 0;
    final currency = '${widget.intent['currency'] ?? 'USD'}';
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const _InnerHeader(title: 'Bank Payment'),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.color14042F49,
                    blurRadius: 18,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.colorFF126F93,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Secure school payment',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '${widget.intent['invoice_no'] ?? ''}',
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const SizedBox(height: 18),
                  if (qr.isNotEmpty)
                    SizedBox(
                      height: 210,
                      child: backendDataImage(
                        qr,
                        fit: BoxFit.contain,
                        fallback: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 180,
                        ),
                      ),
                    )
                  else
                    const Icon(Icons.qr_code_2_rounded, size: 180),
                  const SizedBox(height: 12),
                  Text(
                    '$currency ${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.colorFF126F93,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DetailLine('Bank', value('Bank Name')),
                  _DetailLine('Account name', value('Account Name')),
                  _DetailLine('Account number', value('Account Number')),
                  _DetailLine('Currency', value('Currency', currency)),
                  _DetailLine('Reference', reference),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => copyText(reference, 'Payment reference'),
                    icon: const Icon(Icons.copy_rounded, size: 17),
                    label: const Text('Copy payment reference'),
                  ),
                  if (paymentLink.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => copyText(paymentLink, 'Payment link'),
                      icon: const Icon(Icons.link_rounded, size: 17),
                      label: const Text('Copy bank payment link'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Transfer the exact amount using the QR or bank account above. Then upload the bank receipt. The school must approve it before the invoice becomes Paid.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: completing ? null : pickReceipt,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                receiptBytes == null
                    ? 'Upload payment receipt'
                    : 'Change payment receipt',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: completing ? null : submitReceipt,
              icon: completing
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                completing
                    ? 'Uploading receipt…'
                    : 'Confirm Paid & Submit Receipt',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.colorFF35A864,
                padding: const EdgeInsets.all(15),
              ),
            ),
            if (receiptBytes != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  receiptBytes!,
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
