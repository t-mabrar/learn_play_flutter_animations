import 'package:flutter/material.dart';

class ClippingButton extends StatefulWidget {
  const ClippingButton({super.key});

  @override
  State<ClippingButton> createState() => _ClippingButtonState();
}

class _ClippingButtonState extends State<ClippingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<bool> _animation;
  late Animation<double> _clipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<bool>(begin: false, end: true).animate(_controller);
    _clipAnimation = Tween<double>(
      begin: 0,
      end: 25.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: Stack(
        children: [
          SizedBox(
            height: 50.0,
            width: 250.0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BoxPaint(_animation.value),
                  child: Center(
                    child: Text(
                      "HOVER ME!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // fontWeight: FontWeight.w100,
                        // letterSpacing: 2.25,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BoxPaint extends CustomPainter {
  final bool isHover;
  BoxPaint(this.isHover);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height);
    final hoverPath =
        Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height);
    canvas.drawPath(isHover ? hoverPath : path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
