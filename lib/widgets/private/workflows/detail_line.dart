part of '../../../views/workflows/workflows.dart';

class _DetailLine extends StatelessWidget {
  final String label, value;
  const _DetailLine(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
