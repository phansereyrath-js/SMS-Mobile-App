part of '../../../views/workflows/workflows.dart';

class _InvoiceCell extends StatelessWidget {
  final String text;
  final bool bold;
  const _InvoiceCell(this.text, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(5),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 7,
        fontWeight: bold ? FontWeight.w800 : FontWeight.normal,
      ),
    ),
  );
}
