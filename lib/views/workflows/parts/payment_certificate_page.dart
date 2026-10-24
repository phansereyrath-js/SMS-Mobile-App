part of '../workflows.dart';

class PaymentCertificatePage extends StatelessWidget {
  final StudentAccount student;
  final String invoice;
  final String date;
  final String status;
  final double amount;
  final String currency;
  const PaymentCertificatePage({
    super.key,
    required this.student,
    required this.invoice,
    required this.date,
    required this.status,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const _InnerHeader(title: 'Payment Certificate'),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.colorFFFFFCF8,
            border: Border.all(color: AppColors.colorFFD8C5B5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Image.asset('assets/grandview-logo.jpg', width: 65, height: 65),
              const SizedBox(height: 10),
              const Text(
                'GRANDVIEW SCHOOL',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Official Payment Certificate',
                style: TextStyle(fontSize: 11),
              ),
              const Divider(height: 28),
              _DetailLine('Invoice', invoice),
              _DetailLine('Student', student.name),
              _DetailLine('Student ID', student.studentId),
              _DetailLine('Grade / Class', student.grade),
              _DetailLine('Payment date', date),
              _DetailLine('Status', status),
              _DetailLine('Amount', '$currency ${amount.toStringAsFixed(2)}'),
              const Divider(height: 28),
              const Text(
                'This document confirms the payment record registered for the student above.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
