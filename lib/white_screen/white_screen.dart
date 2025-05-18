import 'package:flutter/material.dart';
import 'package:learn_play_animations/white_screen/remove_button.dart';
import 'package:learn_play_animations/white_screen/three_d_button.dart';
import 'package:learn_play_animations/animated_hover_button.dart';
import 'package:learn_play_animations/white_screen/glow_button.dart';

class WhiteScreen extends StatefulWidget {
  const WhiteScreen({super.key});

  @override
  State<WhiteScreen> createState() => _WhiteScreenState();
}

class _WhiteScreenState extends State<WhiteScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 30.0,
        children: [
          SizedBox(height: 20.0),
          AnimatedHoverButton(),
          GlowButton(),
          ThreeDButton(),
          RemoveButton(),
        ],
      ),
    );
  }
}
