import 'dart:async';

import 'package:flutter/material.dart';

class ThreeDButton extends StatefulWidget {
  const ThreeDButton({super.key});

  @override
  State<ThreeDButton> createState() => _ThreeDButtonState();
}

class _ThreeDButtonState extends State<ThreeDButton> {
  final double _buttonHeight = 100.0;
  final double _buttonWidth = 300.0;

  bool _onTap = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: _buttonWidth,
          height: _buttonHeight,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                Positioned(
                  top: 5.0,
                  right: 0.0,
                  left: 0.0,
                  bottom: 0.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(color: Colors.black, width: 8.0),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: _onTap ? 10.0 : 0.0,
                  right: 5.0,
                  left: 5.0,
                  bottom: _onTap ? 7.0 : 15.0,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 150),
                  child: GestureDetector(
                    onPanStart: (_) {
                      setState(() {
                        _onTap = !_onTap;
                      });
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _onTap = !_onTap;
                      });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade900,
                            offset: Offset(0, _onTap ? 2.0 : 10.0),
                          ),
                        ],
                        color:
                            _onTap
                                ? Colors.orange.shade500
                                : Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          "Mobile First",
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
