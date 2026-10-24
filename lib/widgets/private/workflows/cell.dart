part of '../../../views/workflows/workflows.dart';

class _Cell extends StatelessWidget {
  final String text;
  final bool light;
  const _Cell(this.text, {this.light = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(7),
    child: Text(
      workflowText(context, text),
      style: TextStyle(
        color: light ? Colors.white : AppColors.colorFF443A34,
        fontSize: 8,
        fontWeight: light ? FontWeight.w800 : FontWeight.w500,
      ),
    ),
  );
}
