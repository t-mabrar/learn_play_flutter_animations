import 'package:flutter/material.dart';
import 'package:learn_play_animations/basic_screen/circle_fliping_container.dart';
import 'package:learn_play_animations/basic_screen/cube_rotating.dart';
import 'package:learn_play_animations/basic_screen/flip_containter.dart';
import 'package:learn_play_animations/basic_screen/polygon_animation.dart';
import 'package:learn_play_animations/basic_screen/shape_shifter.dart';

class BasicScreen extends StatefulWidget {
  const BasicScreen({super.key});

  @override
  State<BasicScreen> createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            spacing: 30.0,
            children: [
              SizedBox(height: 20.0),
              FlipContainer(),
              CircleFlipingContainer(),
              // CubeRotating(),
              ShapeShifter()
            ],
          ),
        ),
        // Expanded(child: Column(children: [PolygonAnimation()])),
      ],
    );
  }
}


