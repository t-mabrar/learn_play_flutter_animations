import 'dart:math';

import 'package:flutter/material.dart';

class PolygonAnimation extends StatefulWidget {
  const PolygonAnimation({super.key});

  @override
  State<PolygonAnimation> createState() => _PolygonAnimationState();
}

class _PolygonAnimationState extends State<PolygonAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void dispose() {
    _sidesController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _sidesAnimation = IntTween(begin: 3, end: 10).animate(_sidesController);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnimation = Tween<double>(begin: 30.0, end: 200.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceInOut),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_rotationController);

    _sidesController.repeat(reverse: true);
    _scaleController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_sidesController, _scaleController]),
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.identity()
                ..rotateX(_rotationAnimation.value)
                ..rotateY(_rotationAnimation.value)
                ..rotateZ(_rotationAnimation.value),
          alignment: Alignment.center,
          child: SizedBox(
            width: _scaleAnimation.value,
            height: _scaleAnimation.value,
            child: CustomPaint(
              painter: PolygonPainter(sides: _sidesAnimation.value),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class PolygonPainter extends CustomPainter {
  final int sides;
  PolygonPainter({required this.sides});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.red
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
    final angle = (2 * pi) / sides;
    final angles = List.generate(sides, (index) => index * angle);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final path = Path();
    path.moveTo(center.dx + (radius * cos(0)), center.dy + (radius * sin(0)));
    for (final eachAngle in angles) {
      path.lineTo(
        center.dx + (radius * cos(eachAngle)),
        center.dy + (radius * sin(eachAngle)),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is PolygonPainter && oldDelegate.sides != sides;
  }
}
