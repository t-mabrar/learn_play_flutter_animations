import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ColorFan extends StatefulWidget {
  const ColorFan({super.key});

  @override
  State<ColorFan> createState() => _ColorFanState();
}

class _ColorFanState extends State<ColorFan> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  late final Animation<double> _redOffset;
  late final Animation<double> _orangeOffset;
  late final Animation<double> _yellowOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _rotation = Tween<double>(begin: 0, end: pi).animate(curve);
    _redOffset = Tween<double>(begin: 0, end: 30).animate(curve);
    _orangeOffset = Tween<double>(begin: 0, end: 23).animate(curve);
    _yellowOffset = Tween<double>(begin: 0, end: 12).animate(curve);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFanWing({required double angle, required double dx, required double dy, required Color color}) {
    return Transform(
      alignment: Alignment.bottomCenter,
      transform: Matrix4.identity()
        ..rotateZ(angle)
        ..translate(dx, dy),
      child: FanWing(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [
            _buildFanWing(
              angle: -_rotation.value / 2.5,
              dx: _redOffset.value,
              dy: _redOffset.value,
              color: Colors.brown.shade400,
            ),
            _buildFanWing(
              angle: -_rotation.value / 4,
              dx: _orangeOffset.value,
              dy: _orangeOffset.value,
              color: Colors.blue.shade800,
            ),
            _buildFanWing(
              angle: -_rotation.value / 9.5,
              dx: _yellowOffset.value,
              dy: _yellowOffset.value,
              color: Colors.green,
            ),
            _buildFanWing(
              angle: _rotation.value / 9.5,
              dx: -_yellowOffset.value,
              dy: _yellowOffset.value,
              color: Colors.yellow,
            ),
            _buildFanWing(
              angle: _rotation.value / 4,
              dx: -_orangeOffset.value,
              dy: _orangeOffset.value,
              color: Colors.orange,
            ),
            _buildFanWing(
              angle: _rotation.value / 2.5,
              dx: -_redOffset.value,
              dy: _redOffset.value,
              color: Colors.red,
            ),
            const Positioned(bottom: 20.0, left: 0.0, right: 0.0, child: FanButton()),
          ],
        );
      },
    );
  }
}

class FanButton extends StatelessWidget {
  const FanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20.0,
      height: 20.0,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
    );
  }
}

class FanWing extends StatelessWidget {
  final Color color;
  const FanWing({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      width: 80.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade400, width: 2.0),
              bottom: const BorderSide(color: Colors.grey, width: 3.0),
              left: const BorderSide(color: Colors.white54, width: 3.0),
            ),
            color: color,
          ),
        ),
      ),
    );
  }
}
