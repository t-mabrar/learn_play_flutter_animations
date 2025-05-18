import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vc;

const widthAndheight = 100.0;

class CubeRotating extends StatefulWidget {
  const CubeRotating({super.key});

  @override
  State<CubeRotating> createState() => _CubeRotatingState();
}

class _CubeRotatingState extends State<CubeRotating>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _yController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _zController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _tween = Tween<double>(begin: 0, end: 2 * pi);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..forward();
    _yController
      ..reset()
      ..forward();
    _zController
      ..reset()
      ..forward();
    return AnimatedBuilder(
      animation: Listenable.merge([_xController, _yController, _zController]),
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(height: widthAndheight, width: double.infinity),
            Transform(
              transform:
                  Matrix4.identity()
                    ..rotateX(_tween.evaluate(_xController))
                    ..rotateY(_tween.evaluate(_yController))
                    ..rotateZ(_tween.evaluate(_zController)),
              child: Stack(
                children: [
                  // back
                  Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.identity()
                          ..translate(vc.Vector3(0, 0, -widthAndheight)),
                    child: Container(
                      width: widthAndheight,
                      height: widthAndheight,
                      color: Colors.blue,
                    ),
                  ),
                  // front
                  Container(
                    width: widthAndheight,
                    height: widthAndheight,
                    color: Colors.red,
                  ),
                  // right
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(pi / 2),
                    child: Container(
                      width: widthAndheight,
                      height: widthAndheight,
                      color: Colors.green,
                    ),
                  ),
                  // left
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(-pi / 2),
                    child: Container(
                      width: widthAndheight,
                      height: widthAndheight,
                      color: Colors.yellow,
                    ),
                  ),
                  // top
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()..rotateX(-pi / 2),
                    child: Container(
                      width: widthAndheight,
                      height: widthAndheight,
                      color: Colors.purple,
                    ),
                  ),
                  // top
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..rotateX(pi / 2),
                    child: Container(
                      width: widthAndheight,
                      height: widthAndheight,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
