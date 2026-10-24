part of '../../../views/workflows/workflows.dart';

class _PaymentProcessStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String dateTime;
  final bool complete;

  const _PaymentProcessStep({
    required this.icon,
    required this.title,
    required this.dateTime,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: complete ? AppColors.colorFF43B76F : AppColors.colorFFE5E9EC,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 19,
          color: complete ? Colors.white : Colors.black45,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workflowText(context, title),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              dateTime,
              style: TextStyle(
                fontSize: 11,
                color: complete ? AppColors.colorFF52616A : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
