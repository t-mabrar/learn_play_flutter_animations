import 'dart:ui';

import 'package:flutter/material.dart';

class GlowButton extends StatefulWidget {
  const GlowButton({super.key});

  @override
  _GlowButtonState createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  bool _onTapped = false;

  final BackdropKey backdropKey = BackdropKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2, milliseconds: 500),
    )..repeat(reverse: true); // loops forward and backward
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 70,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: Stack(
          children: [
            if (_isHovered) ...[
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue,
                          Colors.indigo,
                          Colors.purple,
                        ],
                        stops: [0.0, 0.1, 0.2, 0.4, 0.6, 0.8, 1.0],
                        transform: GradientRotation(210.0),
                        begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
                        end: Alignment(1.0 + 2.0 * _controller.value, 0),
                      ),
                    ),
                  );
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                clipBehavior: Clip.antiAlias,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // soft blur
                  child: Container(
                    // width: 300,
                    // height: 100,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
            GestureDetector(
              onPanStart: (_) {
                setState(() {
                  _onTapped = true;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _onTapped = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _onTapped ? Colors.transparent : Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "Hover Me, Then click Me",
                      style: TextStyle(
                        color: _onTapped ? Colors.black : Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
