import 'dart:math' show pi;

import 'package:flutter/material.dart';

class ShapeShifter extends StatefulWidget {
  const ShapeShifter({super.key});

  @override
  State<ShapeShifter> createState() => _ShapeShifterState();
}

class _ShapeShifterState extends State<ShapeShifter>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _borderRadiusController;
  late Animation<double> _borderRadiusAnimation;

  double borderRadius = 150.0;
  bool clockWise = true;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(_colorController);

    _borderRadiusController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    );
    _borderRadiusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_borderRadiusController);

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: pi / 4,
    ).animate(_rotateController);

    _rotateController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 800), () {
          if (mounted) {
            if (_rotateAnimation.value >= pi) {
              clockWise = false;
            }
            if (clockWise) {
              _rotateAnimation = Tween<double>(
                begin: _rotateAnimation.value,
                end: _rotateAnimation.value + (pi / 4),
              ).animate(_rotateController);
              _borderRadiusAnimation = Tween<double>(
                begin: _borderRadiusAnimation.value,
                end: _borderRadiusAnimation.value + 1,
              ).animate(_borderRadiusController);
            } else {
              _rotateAnimation = Tween<double>(
                begin: _rotateAnimation.value,
                end: _rotateAnimation.value - (pi / 4),
              ).animate(_rotateController);
              _borderRadiusAnimation = Tween<double>(
                begin: _borderRadiusAnimation.value,
                end: _borderRadiusAnimation.value - 1,
              ).animate(_borderRadiusController);
            }
            if (!clockWise) {
              clockWise = _rotateAnimation.value == 0.0;
            }
            _rotateController
              ..reset()
              ..forward();
            _borderRadiusController
              ..reset()
              ..forward();
          }
        });
      }
    });
    _rotateController.forward();
    _colorController.repeat(reverse: true);
    _borderRadiusController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _colorController.dispose();
    _borderRadiusController.dispose();
    super.dispose();
  }

  Radius thisBorder(double checkValue, double currentValue) =>
      Radius.circular(currentValue > checkValue ? 150.0 : 0.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotateController,
        _colorController,
        _borderRadiusController,
      ]),
      builder: (context, child) {
        return Stack(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_rotateAnimation.value),
              child: AnimatedContainer(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.only(
                    topLeft: thisBorder(0, _borderRadiusAnimation.value),
                    topRight: thisBorder(1, _borderRadiusAnimation.value),
                    bottomRight: thisBorder(2, _borderRadiusAnimation.value),
                    bottomLeft: thisBorder(3, _borderRadiusAnimation.value),
                  ),
                ),
                duration: Duration(milliseconds: 300),
                child: Container(),
              ),
            ),
          ],
        );
      },
    );
  }
}
