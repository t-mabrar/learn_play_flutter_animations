import 'package:flutter/material.dart';

class FizzyButton extends StatefulWidget {
  const FizzyButton({super.key});

  @override
  State<FizzyButton> createState() => _FizzyButtonState();
}

class _FizzyButtonState extends State<FizzyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> position;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _textColorAnimation;

  bool _onHover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    position = Tween<Offset>(
      begin: const Offset(1.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _textColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200.0,
          height: 50.0,
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _onHover = true;
              });
              _controller.forward();
            },
            onExit: (_) {
              setState(() {
                _onHover = false;
              });
              _controller.reverse();
            },
            child: AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_onHover) ...[
                          AnimatedBuilder(
                            animation: position,
                            child: Icon(Icons.download, color: Colors.black),
                            builder:
                                (context, child) => SlideTransition(
                                  position: position,
                                  child: child,
                                ),
                          ),
                          SizedBox(width: 20.0),
                        ],
                        Stack(
                          children: [
                            AnimatedPositioned(
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 50),
                              child: AnimatedDefaultTextStyle(
                                curve: Curves.ease,
                                style: TextStyle(
                                  color: _textColorAnimation.value,
                                ),
                                duration: Duration(milliseconds: 50),
                                child: Text("Download"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
