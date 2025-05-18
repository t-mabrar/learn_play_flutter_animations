import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FileDrawer extends StatefulWidget {
  const FileDrawer({super.key});

  @override
  State<FileDrawer> createState() => _FileDrawerState();
}

class _FileDrawerState extends State<FileDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.0,
      width: 400.0,
      child: Center(
        child: Transform(
          transform: Matrix4.identity()..translate(-100.0),
          child: Stack(
            children: [
              // Right Size
              Transform(
                transform: Matrix4.skew(0.0, 0.57)
                  ..translate(249.0, -297.0, 0.0),
                child: SizedBox(
                  width: 165.0,
                  height: 400.0,
                  child: ColoredBox(color: Colors.black87),
                ),
              ),
              //BACK side
              // Transform(
              //   transform: Matrix4.skew(0.0, -0.5),
              //   child: SizedBox(
              //     width: 200.0,
              //     height: 400.0,
              //     child: ColoredBox(color: Colors.grey.shade700),
              //   ),
              // ),
              // TOP side
              Transform(
                transform: Matrix4.skew(1.0, -0.5)..rotateX(-pi / 4),
                child: SizedBox(
                  width: 250.0,
                  height: 150.0,
                  child: ColoredBox(color: Colors.grey.shade700),
                ),
              ),

              // FRONT side
              Transform(
                transform: Matrix4.skew(0.0, -0.5)
                  ..translate(165.0, 195.0, 0.0),
                child: SizedBox(
                  width: 250.0,
                  height: 400.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 10.0,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        debugPrint(constraints.maxHeight.toString());
                        return Stack(
                          children: [
                            // third drawer
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              bottom: 0.0,
                              child: DrawerBox(
                                height: constraints.maxHeight / 3 - 5.0,
                              ),
                            ),
                            // second drawer divider
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              top: ((constraints.maxHeight / 3) * 2),
                              child: Divider(
                                color: Colors.grey.shade500,
                                height: 5.0,
                                thickness: 5.0,
                              ),
                            ),
                            // second drawer
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              top: constraints.maxHeight / 3 + 5.0,
                              child: DrawerBox(
                                height: constraints.maxHeight / 3 - 5.0,
                              ),
                            ),
                            // First drawer divider
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              top: constraints.maxHeight / 3,
                              child: Divider(
                                color: Colors.grey.shade500,
                                height: 5.0,
                                thickness: 5.0,
                              ),
                            ),
                            // First drawer
                            DrawerBox(height: constraints.maxHeight / 3),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Left side
              Transform(
                transform: Matrix4.skew(0.0, 0.57),
                child: SizedBox(
                  width: 165.0,
                  height: 400.0,
                  child: ColoredBox(color: Colors.black87),
                ),
              ),
              // Transform(
              //   transform: Matrix4.skew(0.0, 0.57),
              //   child: SizedBox(
              //     width: 165.0,
              //     height: 400.0,
              //     child: ColoredBox(color: Colors.black87),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerBox extends StatefulWidget {
  final double height;
  const DrawerBox({super.key, required this.height});

  @override
  State<DrawerBox> createState() => _DrawerBoxState();
}

class _DrawerBoxState extends State<DrawerBox> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isTap = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0.0, end: 5.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (details) {
        _animation = Tween<double>(
          begin: _animation.value,
          end: 5.0,
        ).animate(_controller);
        _controller
          ..reset()
          ..forward();
      },
      onExit: (_) {
        if (!_isTap) {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..translate(_animation.value, _animation.value),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isTap = true;
                });
                debugPrint(_isTap.toString());
                _animation = Tween<double>(
                  begin: _animation.value,
                  end: 100.0,
                ).animate(_controller);
                _controller
                  ..reset()
                  ..forward();
                Future.delayed(Duration(seconds: 5), () {
                  setState(() {
                    _isTap = false;
                  });
                  _animation = Tween<double>(
                    begin: _animation.value,
                    end: 0.0,
                  ).animate(_controller);
                  _controller
                    ..reset()
                    ..forward();
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: widget.height,
                    decoration: BoxDecoration(color: Colors.grey.shade900),
                    child: Center(
                      child: Divider(
                        color: Colors.white,
                        height: 5.0,
                        indent: 50.0,
                        endIndent: 50.0,
                        thickness: 5.0,
                      ),
                    ),
                  ),
                  // Transform(
                  //   alignment: Alignment.bottomCenter,
                  //   transform: Matrix4.skew(0.8, 0.0)..rotateX(-pi / 3),
                  //   child: Container(color: Colors.white, height: 600.0),
                  // ),
    
                  // Transform(
                  //   transform: Matrix4.identity()..rotateX(pi / 2),
                  //   child: Container(color: Colors.white),
                  // ),
                  // Transform(
                  //   alignment: Alignment.bottomCenter,
                  //   transform: Matrix4.identity()..rotateX(-pi / 2),
                  //   child: Container(color: Colors.white),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
