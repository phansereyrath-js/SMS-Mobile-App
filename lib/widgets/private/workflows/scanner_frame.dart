part of '../../../views/workflows/workflows.dart';

class _ScannerFrame extends StatelessWidget {
  final double size;
  const _ScannerFrame({required this.size});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _ScannerFramePainter()),
  );
}
