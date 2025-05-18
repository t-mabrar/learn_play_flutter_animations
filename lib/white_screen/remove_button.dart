import 'package:flutter/material.dart';

class RemoveButton extends StatefulWidget {
  const RemoveButton({super.key});

  @override
  State<RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<RemoveButton>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<int?> _hoverAnimation;

  late Animation<double> _iconSizeAnimation;

  late AnimationController _tapController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _widthAnimation;

  final double buttonWidth = 300.0;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _hoverAnimation = IntTween(begin: 230, end: 255).animate(_hoverController);

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _iconSizeAnimation = Tween<double>(
      begin: 30.0,
      end: 60.0,
    ).animate(_slideController);
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0.0),
    ).animate(_slideController);
    _widthAnimation = Tween<double>(
      begin: 0.75,
      end: 0.0,
    ).animate(_slideController);

    _tapController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(_tapController);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _slideController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void onExit() {
    _slideController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: 100.0,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _hoverController,
          _slideController,
          _tapController,
        ]),
        builder: (context, child) {
          return MouseRegion(
            onEnter: (_) {
              _hoverController.forward();
              _slideController.forward();
            },
            onExit: (_) {
              _hoverController.reverse();
              if (!_isTapped) {
                onExit();
              }
            },
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _isTapped = true;
                });
                _tapController.forward();
                await Future.delayed(Duration(seconds: 4));
                setState(() {
                  _isTapped = false;
                });
                _tapController.reverse();
                _hoverController.reverse();
                onExit();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: _colorAnimation.value!.withAlpha(
                    _hoverAnimation.value!,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5.0)],
                ),
                child: ClipRRect(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: buttonWidth * 0.75,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "REMOVE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.black26,
                                thickness: 1.5,
                                width: 1.5,
                                endIndent: 10.0,
                                indent: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(),
                        left: buttonWidth * _widthAnimation.value,
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: SizedBox(
                          width: buttonWidth * 0.25,
                          child: Center(
                            child: AnimatedRotation(
                              turns: _isTapped ? 0.0 : 0.25,
                              duration: Duration(milliseconds: 400),
                              child: AnimatedCrossFade(
                                crossFadeState:
                                    _isTapped
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                secondChild: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: _iconSizeAnimation.value,
                                ),
                                firstChild: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: _iconSizeAnimation.value,
                                ),
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
