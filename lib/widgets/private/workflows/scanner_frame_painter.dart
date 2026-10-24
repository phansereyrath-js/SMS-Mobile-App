part of '../../../views/workflows/workflows.dart';

class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const length = 38.0;
    final paths = [
      Path()
        ..moveTo(0, length)
        ..lineTo(0, 0)
        ..lineTo(length, 0),
      Path()
        ..moveTo(size.width - length, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, length),
      Path()
        ..moveTo(0, size.height - length)
        ..lineTo(0, size.height)
        ..lineTo(length, size.height),
      Path()
        ..moveTo(size.width - length, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - length),
    ];
    for (final path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
