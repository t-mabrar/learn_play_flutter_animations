import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class DashedButton extends StatefulWidget {
  const DashedButton({super.key});

  @override
  _DashedButtonState createState() => _DashedButtonState();
}

class _DashedButtonState extends State<DashedButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _dashOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _dashOffset = Tween<double>(
      begin: 150,
      end: 480,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onEnter(bool hovering) {
    setState(() {
      _isHovered = hovering;
      if (hovering) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(true),
      onExit: (_) => _onEnter(false),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        width: 180,
        height: 60,
        decoration: BoxDecoration(
          color: _isHovered ? Color(0xFF4F95DA) : Colors.transparent,
          border: Border.all(color: Color(0xFF91C9FF)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _dashOffset,
                builder: (context, child) {
                  return CustomPaint(
                    painter: AnimatedBorderPainter(_controller),
                  );
                },
              ),
            ),
            Center(
              child: Text(
                'HOVER ME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBorderPainter extends CustomPainter {
  final Animation<double> animation;

  AnimatedBorderPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path();
    path.moveTo(rect.left, rect.top);
    if (animation.isAnimating) {
      path.lineTo(rect.left, rect.bottom);
      path.lineTo(rect.right, rect.bottom);
      path.lineTo(rect.right, rect.top);
    }
    path.close();

    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    final dashArray = CircularIntervalList<double>([150, 480]);
    final dashOffset = DashOffset.absolute(
      150 - (630 * animation.value),
    ); // mimic stroke-dashoffset

    canvas.drawPath(
      dashPath(path, dashArray: dashArray, dashOffset: dashOffset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant AnimatedBorderPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class MyCustomPainter extends CustomPainter {
  final Animation<double> animation;

  MyCustomPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // Drawing logic using the animationValue, e.g., changing the radius of a circle
    final paint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      animation.value * size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  State<MyAnimatedWidget> createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true); // Start the animation repeating
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: CustomPaint(painter: MyCustomPainter(animation: _animation)),
      ),
    );
  }
}
