import 'dart:math';

import 'package:flutter/material.dart';

class DrawSquare extends StatefulWidget {
  const DrawSquare({super.key});

  @override
  State<DrawSquare> createState() => _DrawSquareState();
}

class _DrawSquareState extends State<DrawSquare> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SquarePaint(3, 100));
  }
}

class SquarePaint extends CustomPainter {
  final int sides;
  final double radius;
  SquarePaint(this.sides, this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var angle = (pi * 2) / sides;
    print("Angle: $angle, PI: $pi");
    Offset center = Offset(size.width / 2, size.height / 2);

    // startPoint => (100.0, 0.0)
    Offset startPoint = Offset(radius * cos(0.0), radius * sin(0.0));

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * cos(angle * i) + center.dx;
      double y = radius * sin(angle * i) + center.dy;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, Paint()..color = Colors.red);
    path.close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
