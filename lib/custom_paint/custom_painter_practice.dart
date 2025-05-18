import 'package:flutter/material.dart';
import 'package:learn_play_animations/custom_paint/draw_squar.dart';

class CustomPainterPracticeScreen extends StatefulWidget {
  const CustomPainterPracticeScreen({super.key});

  @override
  State<CustomPainterPracticeScreen> createState() =>
      _CustomPainterPracticeScreenState();
}

class _CustomPainterPracticeScreenState
    extends State<CustomPainterPracticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [SizedBox(height: 200.0, child: Center(child: DrawSquare()))],
    );
  }
}
