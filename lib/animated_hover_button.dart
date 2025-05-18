import 'package:flutter/material.dart';

class AnimatedHoverButton extends StatefulWidget {
  const AnimatedHoverButton({super.key});

  @override
  State<AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<AnimatedHoverButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  late AnimationController _firstFadeController;
  late AnimationController _secondFadeController;
  late AnimationController _thirdFadeController;
  late Animation<double> _firstFadeAnimation;
  late Animation<double> _secondFadeAnimation;
  late Animation<double> _thirdFadeAnimation;

  late AnimationController _allFadeController;
  late Animation<double> _allFadeAnimation;

  @override
  void initState() {
    super.initState();

    _allFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      reverseDuration: Duration(milliseconds: 500),
    );
    _allFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_allFadeController);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset(8.0, 0.0),
    ).animate(_controller);

    //

    _firstFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _secondFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _thirdFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _firstFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_firstFadeController);
    _secondFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_secondFadeController);
    _thirdFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_thirdFadeController);
    _allFadeController.forward();
    _firstFadeController.forward();

    _firstFadeController.addListener(() {
      if (_firstFadeAnimation.value >= 0.5 &&
          _firstFadeController.isForwardOrCompleted) {
        _secondFadeController.forward();
      }
    });

    _secondFadeController.addListener(() {
      if (_secondFadeAnimation.value >= 0.5 &&
          _secondFadeController.isForwardOrCompleted) {
        _thirdFadeController.forward();
      }
    });

    _allFadeController.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed) {
        _firstFadeController.reverse();
        _secondFadeController.reverse();
        _thirdFadeController.reverse();
        await Future.delayed(Duration(milliseconds: 400));
        if (mounted) {
          _allFadeController
            ..reset()
            ..forward();
          _firstFadeController
            ..reset()
            ..forward();
        }
      }
    });

    _thirdFadeController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          _animation = Tween<Offset>(
            begin: Offset(-1.5, 0.0),
            end: Offset(8.0, 0.0),
          ).animate(_controller);
          _controller
            ..reset()
            ..forward();
          await Future.delayed(Duration(seconds: 3));
          if (mounted) {
            _allFadeController.reverse();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _firstFadeController.dispose();
    _secondFadeController.dispose();
    _thirdFadeController.dispose();
    _allFadeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: 300.0,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _firstFadeController,
          _secondFadeController,
          _thirdFadeController,
          _allFadeController,
        ]),
        builder: (context, child) {
          return ClipRRect(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF78C2FF),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Transform(
                    transform: Matrix4.skew(-0.3, 0.0),
                    child: SlideTransition(
                      position: _animation,
                      child: Container(
                        width: 40.0,
                        height: 60.0,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 45.0,
                    right: 0.0,
                    child: FadeTransition(
                      opacity: _allFadeAnimation,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0.0,
                            bottom: 0.0,
                            child: Center(
                              child: AnimatedCrossFade(
                                alignment: Alignment.center,
                                firstChild: Container(),
                                secondChild: CustomPaint(
                                  painter: ArrowPainter(),
                                  child: SizedBox(width: 20.0, height: 25.0),
                                ),
                                crossFadeState:
                                    _thirdFadeAnimation.value == 1.0
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 500),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            bottom: 0.0,
                            left: 15.0,
                            child: Center(
                              child: AnimatedCrossFade(
                                alignment: Alignment.center,
                                firstChild: Container(),
                                secondChild: CustomPaint(
                                  painter: ArrowPainter(),
                                  child: SizedBox(width: 20.0, height: 25.0),
                                ),
                                crossFadeState:
                                    _secondFadeAnimation.value == 1.0
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 500),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            bottom: 0.0,
                            left: 30.0,
                            child: Center(
                              child: AnimatedCrossFade(
                                alignment: Alignment.center,
                                firstChild: Container(),
                                secondChild: CustomPaint(
                                  painter: ArrowPainter(),
                                  child: SizedBox(width: 20.0, height: 25.0),
                                ),
                                crossFadeState:
                                    _firstFadeAnimation.value == 1.0
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "START",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 2.5,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.close();
    var paint = Paint()..color = Color(0xFFf8b600);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
