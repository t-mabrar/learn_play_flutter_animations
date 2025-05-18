import 'dart:math';

import 'package:flutter/material.dart';

class PacManFace extends CustomClipper<Path> {
  final PacMacFaceSide side;

  PacManFace({required this.side});
  @override
  Path getClip(Size size) {
    return side.path(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class PacManAnimation extends StatefulWidget {
  const PacManAnimation({super.key});

  @override
  State<PacManAnimation> createState() => _PacManAnimationState();
}

class _PacManAnimationState extends State<PacManAnimation>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 500.0,
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 20.0,
            right: 0.0,
            child: PacmanItems(),
          ),
          Positioned(top: 0.0, bottom: 0.0, left: 0.0, child: PacManHead()),
        ],
      ),
    );
  }
}

class PacmanItems extends StatefulWidget {
  const PacmanItems({super.key});

  @override
  State<PacmanItems> createState() => _PacmanItemsState();
}

class _PacmanItemsState extends State<PacmanItems>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  static const int pelletCount = 100; // High enough to simulate infinity
  static const double pelletSpacing = 35.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    _animationController.addListener(() {
      _scrollController.jumpTo(
        _animationController.value * pelletCount * pelletSpacing,
      );
    });

    _animationController.repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      itemCount: pelletCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 20.0),
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

enum PacMacFaceSide { top, bottom }

extension on PacMacFaceSide {
  Path path(Size size) {
    var path = Path();
    late Offset arcEnd;
    late bool clockWise;
    switch (this) {
      case PacMacFaceSide.top:
        path.moveTo(0, size.height);
        arcEnd = Offset(size.width, size.height);
        clockWise = true;
        break;
      case PacMacFaceSide.bottom:
        arcEnd = Offset(size.width, 0);
        clockWise = false;
        break;
    }
    path.arcToPoint(
      arcEnd,
      radius: Radius.elliptical(size.width / 2, size.height),
      clockwise: clockWise,
    );
    return path;
  }
}

class PacManHead extends StatefulWidget {
  const PacManHead({super.key});

  @override
  State<PacManHead> createState() => _PacManHeadState();
}

class _PacManHeadState extends State<PacManHead>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotatateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _rotatateAnimation = Tween<double>(
      begin: 0.0,
      end: pi / 6,
    ).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Expanded(
                child: Transform.rotate(
                  alignment: Alignment.bottomCenter,
                  angle: -(_rotatateAnimation.value),
                  child: Transform.translate(
                    offset: Offset.zero,
                    child: ClipPath(
                      clipper: PacManFace(side: PacMacFaceSide.top),
                      child: Container(
                        height: 50.0,
                        width: 100.0,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Transform.rotate(
                  alignment: Alignment.topCenter,
                  angle: _rotatateAnimation.value,
                  child: Transform.translate(
                    offset: Offset.zero,
                    child: ClipPath(
                      clipper: PacManFace(side: PacMacFaceSide.bottom),
                      child: Container(
                        height: 50.0,
                        width: 100.0,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
