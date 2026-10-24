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
                  cardColor: AppColors.colorFF102F50,
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.colorFF55DFF5,
                    surface: AppColors.colorFF102F50,
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

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child, required this.padding});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.color90111B2D,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white38),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
    ),
    child: child,
  );
}

class _AcademicMetric extends StatelessWidget {
  const _AcademicMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white60, fontSize: 10),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - 10) / 2;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = Colors.white.withValues(alpha: .12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..shader = const SweepGradient(
        colors: [
          AppColors.colorFF46BFFF,
          AppColors.colorFF35F4C2,
          AppColors.colorFF46BFFF,
        ],
      ).createShader(bounds)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final ring = Paint()
      ..shader = const SweepGradient(
        colors: [
          AppColors.colorFF46BFFF,
          AppColors.colorFF35F4C2,
          AppColors.colorFF46BFFF,
        ],
      ).createShader(bounds)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final sweep = math.pi * 2 * progress;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(bounds, -math.pi / 2, sweep, false, glow);
    canvas.drawArc(bounds, -math.pi / 2, sweep, false, ring);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _HomeworkTile extends StatelessWidget {
  const _HomeworkTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _GlassPanel(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/homework_icon.png',
            width: 42,
            height: 42,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.horizontal = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool horizontal;
  @override
  Widget build(BuildContext context) => _GlassPanel(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal ? 13 : 8,
      vertical: horizontal ? 15 : 12,
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: horizontal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                label == 'Scan QR'
                    ? const CustomPaint(
                        key: Key('scan-corners-icon'),
                        size: Size.square(36),
                        painter: _ScanQrIconPainter(),
                      )
                    : Icon(icon, color: Colors.white, size: 36),
                const SizedBox(height: 9),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
    ),
  );
}

class _ScanQrIconPainter extends CustomPainter {
  const _ScanQrIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final inset = size.width * .16;
    final arm = size.width * .22;
    final far = size.width - inset;
    final corners = Path()
      ..moveTo(inset + arm, inset)
      ..lineTo(inset, inset)
      ..lineTo(inset, inset + arm)
      ..moveTo(far - arm, inset)
      ..lineTo(far, inset)
      ..lineTo(far, inset + arm)
      ..moveTo(inset, far - arm)
      ..lineTo(inset, far)
      ..lineTo(inset + arm, far)
      ..moveTo(far, far - arm)
      ..lineTo(far, far)
      ..lineTo(far - arm, far);
    canvas.drawPath(corners, paint);
    canvas.drawLine(
      Offset(size.width * .34, size.height * .50),
      Offset(size.width * .66, size.height * .50),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashboardBackdrop extends StatelessWidget {
  const _DashboardBackdrop();
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryDark,
          AppColors.primary,
          AppColors.primaryLight,
          AppColors.primaryAccent,
        ],
        stops: [0, .38, .7, 1],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          top: -70,
          right: -70,
          child: _glow(AppColors.colorFFFFD35C, 220),
        ),
        Positioned(
          top: 320,
          left: -100,
          child: _glow(AppColors.colorFFDF2F9C, 260),
        ),
        Positioned(
          bottom: 80,
          right: -90,
          child: _glow(AppColors.colorFF1B78FF, 260),
        ),
      ],
    ),
  );

  static Widget _glow(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withValues(alpha: .38), color.withValues(alpha: 0)],
      ),
    ),
  );
}
