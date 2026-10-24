part of '../../../views/workflows/workflows.dart';

class _PaymentProcessTimeline extends StatelessWidget {
  final bool paid;
  final String releasedAt;
  final String paidAt;

  const _PaymentProcessTimeline({
    required this.paid,
    required this.releasedAt,
    required this.paidAt,
  });

  String _formatDateTime(String value) {
    final normalized = value.trim().replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) {
      return value.trim().isEmpty ? 'Date unavailable' : value;
    }
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final period = parsed.hour < 12 ? 'AM' : 'PM';
    return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}  $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.colorFFF8FBFD,
      border: Border.all(color: AppColors.colorFFD6E0E7),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workflowText(context, 'Payment Process'),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 15),
        _PaymentProcessStep(
          icon: Icons.description_outlined,
          title: 'Invoice Released',
          dateTime: _formatDateTime(releasedAt),
          complete: true,
        ),
        Container(
          width: 2,
          height: 18,
          margin: const EdgeInsets.only(left: 17),
          color: paid ? AppColors.colorFF43B76F : AppColors.colorFFD4D9DD,
        ),
        _PaymentProcessStep(
          icon: paid ? Icons.check_rounded : Icons.schedule_rounded,
          title: 'Paid',
          dateTime: paid
              ? _formatDateTime(paidAt)
              : workflowText(context, 'Waiting for payment confirmation'),
          complete: paid,
        ),
      ],
    ),
  );
}
