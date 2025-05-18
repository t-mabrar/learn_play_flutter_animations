import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class SlidingBoxAnimation extends StatefulWidget {
  const SlidingBoxAnimation({super.key});

  @override
  State<SlidingBoxAnimation> createState() => _SlidingBoxAnimationState();
}

class _SlidingBoxAnimationState extends State<SlidingBoxAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late Animation<double> _rotationAnimation;

  late AnimationController _translateController;
  late Animation<double> _translateAnimation;

  bool clockWise = true;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: pi / 2).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _translateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _translateAnimation = Tween<double>(
      begin: 25.0,
      end: 75.0,
    ).animate(_translateController);

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _rotateController.forward();
        _translateController.forward();
      }
    });

    _rotateController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_rotationAnimation.value == (2 * pi)) {
          clockWise = false;
        }
        if (clockWise) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (mounted) {
              _rotationAnimation = Tween<double>(
                begin: _rotationAnimation.value,
                end: _rotationAnimation.value + pi / 2,
              ).animate(_rotateController);
              _translateAnimation = Tween<double>(
                begin: _translateAnimation.value,
                end: _translateAnimation.value + 50.0,
              ).animate(_translateController);

              _rotateController.duration = Duration(milliseconds: 300);
              _translateController.duration = Duration(milliseconds: 300);
              _rotateController
                ..reset()
                ..forward();
              _translateController
                ..reset()
                ..forward();
            }
          });
        } else {
          Future.delayed(Duration(microseconds: 1), () {
            if (mounted) {
              _rotationAnimation = Tween<double>(
                begin: _rotationAnimation.value,
                end: _rotationAnimation.value - pi / 2,
              ).animate(_rotateController);
              _translateAnimation = Tween<double>(
                begin: _translateAnimation.value,
                end: _translateAnimation.value - 50.0,
              ).animate(_translateController);
              _rotateController.duration = Duration(milliseconds: 150);
              _translateController.duration = Duration(milliseconds: 150);
              _rotateController
                ..reset()
                ..forward();
              _translateController
                ..reset()
                ..forward();
            }
          });
        }
        if (!clockWise) {
          clockWise = (_translateAnimation.value).floorToDouble() <= 80.0;
        }
      }
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 300.0,
      child: Transform.rotate(
        angle: -pi / 4,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _translateController,
            _rotateController,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1),
                  bottom: 7.0,
                  left: _translateAnimation.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.identity()..rotateZ(_rotationAnimation.value),
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.white, width: 5.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Divider(
                    height: 7.0,
                    thickness: 7.0,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
