part of '../../../views/workflows/workflows.dart';

class _SummaryBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _SummaryBox(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorFFE3DEDB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            workflowText(context, label),
            style: const TextStyle(fontSize: 9),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}
