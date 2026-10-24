part of '../../../views/workflows/workflows.dart';

class _EvaluationRow extends StatelessWidget {
  final String label, result;
  final Color color;
  const _EvaluationRow(this.label, this.result, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(
            workflowText(context, label),
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
        ),
        Text(
          workflowText(context, result),
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
