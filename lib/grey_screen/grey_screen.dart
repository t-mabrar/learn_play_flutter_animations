import 'package:flutter/material.dart';
import 'package:learn_play_animations/grey_screen/enveloper_animation.dart';
import 'package:learn_play_animations/blue_screen/file_drawer.dart';

class GreyScreen extends StatefulWidget {
  const GreyScreen({super.key});

  @override
  State<GreyScreen> createState() => _GreyScreenState();
}

class _GreyScreenState extends State<GreyScreen> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey,
      child: SingleChildScrollView(
        child: Column(
          spacing: 50.0,
          children: [
            SizedBox(height: 20.0),
            EnveloperAnimation(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
