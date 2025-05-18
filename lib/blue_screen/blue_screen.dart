import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learn_play_animations/blue_screen/color_fan_animation.dart';
import 'package:learn_play_animations/blue_screen/dashed_button.dart';
import 'package:learn_play_animations/blue_screen/pulse_button.dart';
import 'package:learn_play_animations/blue_screen/pulse_screen.dart';
import 'package:learn_play_animations/blue_screen/file_drawer.dart';

class BlueScreen extends StatefulWidget {
  const BlueScreen({super.key});

  @override
  State<BlueScreen> createState() => _BlueScreenState();
}

class _BlueScreenState extends State<BlueScreen> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue,
      child: SingleChildScrollView(
        child: Column(
          spacing: 30.0,
          children: [
            SizedBox(height: 150.0),
            FileDrawer(),
            SizedBox(height: 100.0),
            PulseScreen(),
            PulseButton(),
            DashedButton(),
            ColorFan(),
            SizedBox(height: 50.0),

          ],
        ),
      ),
    );
  }
}
