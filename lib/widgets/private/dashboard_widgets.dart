part of '../../app.dart';

class _DottedFaceRingPainter extends CustomPainter {
  const _DottedFaceRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.colorFFEEEEEE;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 8;
    const dots = 54;
    for (var index = 0; index < dots; index++) {
      final angle = math.pi * 2 * index / dots;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        3.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FaceBackdropPainter extends CustomPainter {
  const _FaceBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
    final shapes = Paint()..color = AppColors.colorFF2C1C10;
    canvas.drawCircle(Offset(size.width * .88, size.height * .05), 145, shapes);
    canvas.drawCircle(Offset(size.width * .05, size.height * .63), 120, shapes);
    shapes.color = AppColors.colorFF3A2818;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .72, size.height * .58),
        width: 390,
        height: 145,
      ),
      shapes,
    );
    shapes
      ..color = AppColors.colorFF20150D
      ..style = PaintingStyle.stroke
      ..strokeWidth = 54;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .55, size.height * .9),
        width: 210,
        height: 480,
      ),
      shapes,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuDetailScaffold extends StatelessWidget {
  const _MenuDetailScaffold({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primaryDark,
    body: Container(
      decoration: BoxDecoration(gradient: _activeGradient()),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              body: Theme(
                data: Theme.of(context).copyWith(
                  cardColor: AppColors.schoolDarkCard,
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.schoolDarkAccent,
                    surface: AppColors.schoolDarkCard,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
