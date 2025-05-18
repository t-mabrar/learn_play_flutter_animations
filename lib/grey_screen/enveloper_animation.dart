import 'dart:math';

import 'package:flutter/material.dart';

enum EnvelopeSide { right, left, top }

extension on EnvelopeSide {
  void getCanvas(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;
    var path = Path();

    switch (this) {
      case EnvelopeSide.right:
        path.moveTo(0, 0);
        paint.color = Colors.red;
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case EnvelopeSide.left:
        paint.color = Colors.red.shade400;
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case EnvelopeSide.top:
        paint.color = Colors.red.shade600;
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width / 2, size.height / 2);
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}

class EnveloperAnimation extends StatefulWidget {
  const EnveloperAnimation({super.key});

  @override
  State<EnveloperAnimation> createState() => _EnveloperAnimationState();
}

class _EnveloperAnimationState extends State<EnveloperAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _letterTranslateController;

  late Animation<double> _rotateAnimation;
  late Animation<double> _enveloperTranslateAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _letterTranslateAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: pi).animate(_controller);
    _enveloperTranslateAnimation = Tween<double>(
      begin: 0.0,
      end: 50.0,
    ).animate(_controller);
    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 25.0,
    ).animate(_controller);

    _letterTranslateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _letterTranslateAnimation = Tween<double>(
      begin: 85.0,
      end: 0.0,
    ).animate(_letterTranslateController);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _letterTranslateController.forward();
      }
    });
    _letterTranslateController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget positionedWidget({
    required Widget child,
    double x = 0.0,
    double? y,
    double z = 0.0,
  }) => Positioned(
    top: 0.0,
    left: 0.0,
    right: 0.0,
    child: Transform(
      transform:
          Matrix4.identity()
            ..translate(x, y ?? _enveloperTranslateAnimation.value, x),
      child: child,
    ),
  );

  Widget enveloperSide({required EnvelopeSide side}) => Center(
    child: SizedBox(
      width: 200.0,
      height: 100.0,
      child: CustomPaint(
        painter: EnveloperSidePaint(side: side),
        child: Container(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _letterTranslateController]),
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) {
            _controller.forward();
          },
          onExit: (_) {
            _controller.reverse();
            _letterTranslateController.reverse();
          },

          child: SizedBox(
            height: 180.0,
            width: 250.0,
            child: Stack(
              children: [
                positionedWidget(
                  child: Center(
                    child: ColoredBox(
                      color: Colors.red.shade600,
                      child: SizedBox(width: 200.0, height: 100.0),
                    ),
                  ),
                ),
                positionedWidget(
                  child: Center(
                    child: Transform(
                      alignment: Alignment.topCenter,
                      transform:
                          Matrix4.identity()..rotateX(_rotateAnimation.value),
                      child: enveloperSide(side: EnvelopeSide.top),
                    ),
                  ),
                  z: 10.0,
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1),
                  top: _letterTranslateAnimation.value,
                  left: 0.0,
                  right: 0.0,
                  bottom: 80.0,
                  child: Center(
                    child: SizedBox(
                      height: 180.0,
                      width: 150.0,
                      child: ColoredBox(
                        color: Colors.white,
                        child: LetterContent(),
                      ),
                    ),
                  ),
                ),
                positionedWidget(
                  child: enveloperSide(side: EnvelopeSide.right),
                ),
                positionedWidget(child: enveloperSide(side: EnvelopeSide.left)),
                AnimatedPositioned(
                  bottom: 0.0,
                  left: 0.0 + _shadowAnimation.value,
                  right: 0.0 + _shadowAnimation.value,
                  duration: Duration(milliseconds: 1),
                  child: SizedBox(
                    width: _shadowAnimation.value,
                    height: 20.0,
                    child: CustomPaint(painter: EnveloperShadow()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LetterContent extends StatelessWidget {
  const LetterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.red.shade400, width: 7.0),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Divider(
                  color: Colors.red.shade400,
                  thickness: 7.0,
                  endIndent: 70.0,
                ),
                Divider(
                  color: Colors.red.shade400,
                  thickness: 7.0,
                  endIndent: 100.0,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400.withAlpha(50),
                ),
                child: SizedBox(width: 30.0, height: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnveloperShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;
    final paint =
        Paint()
          ..color = Colors.black12
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0)
          ..blendMode = BlendMode.darken;
    final paint2 =
        Paint()
          ..color = Colors.black38
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0)
          ..blendMode = BlendMode.darken;
    final paint3 =
        Paint()
          ..color = Colors.black
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.0)
          ..blendMode = BlendMode.darken;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: width - 10.0,
        height: height - 10.0,
      ),
      paint2,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: width - 20.0,
        height: height - 20.0,
      ),
      paint3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class EnveloperSidePaint extends CustomPainter {
  final EnvelopeSide side;

  EnveloperSidePaint({required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    side.getCanvas(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
