import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide { left, right }

extension on CircleSide {
  Path path(Size size) {
    final path = Path();
    late Offset arcEnd;
    late bool clockWise;
    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        arcEnd = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        arcEnd = Offset(0, size.height);
        clockWise = true;
        break;
    }
    path.arcToPoint(
      arcEnd,
      radius: Radius.elliptical(size.width, size.height / 2),
      clockwise: clockWise,
    );
    return path;
  }
}

class CircleFlipingContainer extends StatefulWidget {
  const CircleFlipingContainer({super.key});

  @override
  State<CircleFlipingContainer> createState() => CircleFlipingContainerState();
}

class CircleFlipingContainerState extends State<CircleFlipingContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void dispose() {
    _controller.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
        );
        _flipController
          ..reset()
          ..forward();
      }
    });
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animation = Tween<double>(
          begin: _animation.value,
          end: _animation.value + (-pi / 2),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
        );
        _controller
          ..reset()
          ..forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      _controller
        ..reset()
        ..forward();
    });

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _flipController]),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..rotateZ(_animation.value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.rotationY(_flipAnimation.value),
                child: ClipPath(
                  clipper: CircleClipper(side: CircleSide.left),
                  child: Container(
                    width: 100.0,
                    height: 200.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.rotationY(_flipAnimation.value),
                child: ClipPath(
                  clipper: CircleClipper(side: CircleSide.right),
                  child: Container(
                    width: 100.0,
                    height: 200.0,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  CircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    return side.path(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
