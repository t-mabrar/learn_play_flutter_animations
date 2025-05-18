import 'package:flutter/material.dart';
import 'package:learn_play_animations/nuemorphic_screen/nuemorphic_buttons.dart';
import 'package:learn_play_animations/white_screen/nuemorphic_rings.dart';

class NuemorphicScreen extends StatefulWidget {
  const NuemorphicScreen({super.key});

  @override
  State<NuemorphicScreen> createState() => _NuemorphicScreenState();
}

class _NuemorphicScreenState extends State<NuemorphicScreen> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade300,
      child: SingleChildScrollView(
        child: Column(children: [NuemorphicRings(), NuemorphicButtons()]),
      ),
    );
  }
}
