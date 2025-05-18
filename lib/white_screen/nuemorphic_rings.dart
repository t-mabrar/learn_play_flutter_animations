import 'package:flutter/material.dart';

class NuemorphicRings extends StatefulWidget {
  const NuemorphicRings({super.key});

  @override
  State<NuemorphicRings> createState() => _NuemorphicRingsState();
}

class _NuemorphicRingsState extends State<NuemorphicRings> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.0,
      width: 500.0,
      child: Stack(
        children: [
          EachRing(widthAndHeight: 400.0),
          EachRing(widthAndHeight: 300.0),
          EachRing(widthAndHeight: 200.0),
          EachRing(widthAndHeight: 100.0),
        ],
      ),
    );
  }
}

class EachRing extends StatelessWidget {
  final double widthAndHeight;
  const EachRing({super.key, required this.widthAndHeight});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: widthAndHeight,
              width: widthAndHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(125),
                      blurRadius: 10.0,
                      spreadRadius: 3.0,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: widthAndHeight - 40.0,
              width: widthAndHeight - 40.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withAlpha(100)),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 0.0,
                      blurRadius: 10.0,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
