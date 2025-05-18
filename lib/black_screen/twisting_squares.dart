import 'dart:math';

import 'package:flutter/material.dart';

class TwistingSquares extends StatefulWidget {
  const TwistingSquares({super.key});

  @override
  State<TwistingSquares> createState() => _TwistingSquaresState();
}

class _TwistingSquaresState extends State<TwistingSquares>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int squaresCount = 9;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: pi / 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      width: 300.0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              for (int i = 0; i < squaresCount; i++)
                Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()..rotateZ(_animation.value * (i + 1)),
                  child: EachSquare(index: i, lastItem: i == squaresCount - 1),
                ),
            ],
          );
        },
      ),
    );
  }
}

class EachSquare extends StatelessWidget {
  final bool lastItem;
  final int index;
  const EachSquare({super.key, required this.index, this.lastItem = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0 - (index * 30.0),
        height: 300.0 - (index * 30.0),
        decoration: BoxDecoration(
          color: lastItem ? Colors.green : Colors.white,
          border: lastItem ? null : Border.all(color: Colors.green, width: 5.0),
        ),
      ),
    );
  }
}
