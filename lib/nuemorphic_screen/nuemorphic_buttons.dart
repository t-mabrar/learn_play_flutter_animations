import 'package:flutter/material.dart';

class NuemorphicButtons extends StatefulWidget {
  const NuemorphicButtons({super.key});

  @override
  State<NuemorphicButtons> createState() => _NuemorphicButtonsState();
}

class _NuemorphicButtonsState extends State<NuemorphicButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30.0,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            // borderRadius: BorderRadius.circular(30.0),
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade300,
                Colors.grey.shade400,
                Colors.grey.shade400,
                // Colors.grey.shade500,
              ],
              stops: [0.25, 0.5, 0.75, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(4, 4),
              ),
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(-6, -6),
              ),
            ],
          ),
          child: Icon(Icons.android, size: 40.0, color: Colors.black),
        ),
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [Colors.grey.shade400, Colors.white],
              stops: [0.05, 0.95],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 3.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Icon(Icons.android, size: 40.0, color: Colors.black),
        ),
      ],
    );
  }
}
