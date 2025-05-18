import 'package:flutter/material.dart';

class PulseButton extends StatefulWidget {
  const PulseButton({super.key});

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  bool _isHovering = false;
  bool _onTap = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _opacity = Tween(begin: 1.0, end: 0.0).animate(_controller);
    _scale = Tween(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _actualButton({bool showShadow = false}) => AnimatedContainer(
    transform: Matrix4.translationValues(
      0,
      _isHovering && _onTap
          ? -1
          : _isHovering
          ? -3
          : 0,
      0,
    ),
    duration: Duration(milliseconds: 100),
    child: DecoratedBox(
      decoration: BoxDecoration(
        boxShadow:
            _isHovering && showShadow
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 10),
                    blurRadius: 20,
                  ),
                ]
                : [],
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Text("Click Me"),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onPanStart: (details) => setState(() => _onTap = true),
        onPanEnd: (details) => setState(() => _onTap = false),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovering = true;
            });
            _controller.forward();
          },
          onExit: (_) {
            setState(() {
              _isHovering = false;
            });
            _controller.reverse();
          },
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return AnimatedScale(
                    scale: _scale.value,
                    duration: Duration(milliseconds: 200),
                    child: AnimatedOpacity(
                      opacity: _opacity.value,
                      duration: Duration(milliseconds: 300),
                      child: _actualButton(),
                    ),
                  );
                },
              ),
              _actualButton(showShadow: true),
            ],
          ),
        ),
      ),
    );
  }
}
