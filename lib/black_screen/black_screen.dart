import 'package:flutter/material.dart';
import 'package:learn_play_animations/black_screen/pac_man_animation.dart';
import 'package:learn_play_animations/black_screen/sliding_box.dart';
import 'package:learn_play_animations/black_screen/text_slide.dart';
import 'package:learn_play_animations/black_screen/twisting_squares.dart';
import 'package:learn_play_animations/clipping_button.dart';
import 'package:learn_play_animations/black_screen/fizzy_button.dart';
import 'package:learn_play_animations/black_screen/flip_button.dart';
import 'package:learn_play_animations/black_screen/flush_button.dart';

class BlackScreen extends StatefulWidget {
  const BlackScreen({super.key});

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          spacing: 50.0,
          children: [
            SizedBox(height: 20.0),
            MultiTextSlide(),
            SizedBox(height: 20.0),
            TwistingSquares(),

            FizzyButton(),
            // FlushButton(),
            // ClippingButton(),
            // FlipButton(),
            AnotherFlipButton(),
            PacManAnimation(),
            SizedBox(height: 20.0),

            SlidingBoxAnimation(),
            SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}
