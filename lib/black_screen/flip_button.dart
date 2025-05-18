import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FlipButton extends StatefulWidget {
  const FlipButton({super.key});

  @override
  _FlipButtonState createState() => _FlipButtonState();
}

class _FlipButtonState extends State<FlipButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  final double height = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween(
      begin: 0.0,
      end: pi / 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: GestureDetector(
        onPanStart: (_) {
          _controller.forward();
        },
        onPanEnd: (_) {
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..translate(
                          0.0,
                          -(cos(animation.value) * (height / 2)),
                          -(height / 2) * sin(animation.value),
                        )
                        ..rotateX(-(pi / 2) + animation.value),
                  child: Container(
                    color: Colors.red,
                    height: height,
                    child: Center(child: Text("Back")),
                  ),
                ),
                animation.value < (85 * pi / 180)
                    ? Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..translate(
                              0.0,
                              (height / 2) * sin(animation.value),
                              -(height / 2) * cos(animation.value),
                            )
                            ..rotateX(animation.value),
                      child: Container(
                        color: Colors.blue,
                        height: height,
                        child: Center(child: Text("Front")),
                      ),
                    )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnotherFlipButton extends StatefulWidget {
  const AnotherFlipButton({super.key});

  @override
  State<AnotherFlipButton> createState() => _AnotherFlipButtonState();
}

class _AnotherFlipButtonState extends State<AnotherFlipButton>
    with TickerProviderStateMixin {
  final double buttonWidth = 300.0;
  final double buttonHeight = 100.0;
  late AnimationController _frontController;
  late AnimationController _backController;

  late Animation<double> _frontRotationAnimation;
  late Animation<double> _frontTranslateAnimation;
  late Animation<double> _backRotationAnimation;
  late Animation<double> _backTranslateAnimation;

  @override
  void initState() {
    super.initState();
    _frontController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _frontRotationAnimation = Tween<double>(
      begin: 0.0,
      end: (pi / 2),
    ).animate(_frontController);
    _frontTranslateAnimation = Tween<double>(
      begin: 0.0,
      end: buttonHeight,
    ).animate(_frontController);

    _backController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _backRotationAnimation = Tween<double>(
      begin: -(pi / 2),
      end: 0.0,
    ).animate(_backController);
    _backTranslateAnimation = Tween<double>(
      begin: buttonHeight,
      end: 0.0,
    ).animate(_backController);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: AnimatedBuilder(
        animation: Listenable.merge([_frontController, _backController]),
        builder: (context, child) {
          return GestureDetector(
            onPanStart: (details) {
              _backController.forward();
              _frontController.forward();
            },
            onPanEnd: (_) {
              _backController.reverse();
              _frontController.reverse();
            },
            child: Stack(
              children: [
                Transform(
                  alignment: Alignment.bottomCenter,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..translate(
                          Vector3(0, -_backTranslateAnimation.value, 0),
                        )
                        ..rotateX(_backRotationAnimation.value),
                  child: Container(
                    // width: buttonWidth,
                    // height: buttonHeight,
                    color: Colors.green,
                    child: Center(child: Text("Back")),
                  ),
                ),
                Transform(
                  alignment: Alignment.topCenter,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..translate(
                          Vector3(0, (_frontTranslateAnimation.value), 0),
                        )
                        ..rotateX(_frontRotationAnimation.value),
                  child: Container(
                    // width: buttonWidth,
                    // height: buttonHeight,
                    color: Colors.red,
                    child: Center(child: Text("Front")),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
