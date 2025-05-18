import 'package:flutter/material.dart';

class PulseScreen extends StatefulWidget {
  const PulseScreen({super.key});

  @override
  State<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends State<PulseScreen>
    with TickerProviderStateMixin {
  late AnimationController _firstController;
  late Animation<double> _firstOpacityAnimation;
  late Animation<double> _firstScaleAnimation;

  late AnimationController _secondController;
  late Animation<double> _secondOpacityAnimation;
  late Animation<double> _secondScaleAnimation;

  late AnimationController _thirdController;
  late Animation<double> _thirdOpacityAnimation;
  late Animation<double> _thirdScaleAnimation;

  @override
  void initState() {
    super.initState();
    _firstController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _firstScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: _firstController, curve: Curves.ease));
    _firstOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _firstController, curve: Curves.ease));

    _secondController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _secondScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: _secondController, curve: Curves.ease));
    _secondOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _secondController, curve: Curves.ease));

    _thirdController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _thirdScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: _thirdController, curve: Curves.ease));
    _thirdOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _thirdController, curve: Curves.ease));
    _startPulseLoop();
  }

  void _startPulseLoop() async {
    while (mounted) {
      if (mounted) {
        _firstController
          ..reset()
          ..forward();
      }
      await Future.delayed(Duration(milliseconds: 900)); // Half of 5 seconds

      if (mounted) {
        _secondController
          ..reset()
          ..forward();
      }
      await Future.delayed(Duration(milliseconds: 900));

      if (mounted) {
        _thirdController
          ..reset()
          ..forward();
      }
      await Future.delayed(Duration(milliseconds: 900));
    }
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _firstController,
        _secondController,
        _thirdController,
      ]),
      builder: (context, child) {
        return SizedBox(
          width: 500.0,
          height: 500.0,
          child: Stack(
            children: [
              AnimatedScale(
                scale: _firstScaleAnimation.value,
                duration: Duration(),
                child: AnimatedOpacity(
                  opacity: _firstOpacityAnimation.value,
                  duration: Duration(),
                  child: MiddleSection(),
                ),
              ),
              AnimatedScale(
                scale: _secondScaleAnimation.value,
                duration: Duration(),
                child: AnimatedOpacity(
                  opacity: _secondOpacityAnimation.value,
                  duration: Duration(),
                  child: MiddleSection(),
                ),
              ),
              AnimatedScale(
                scale: _thirdScaleAnimation.value,
                duration: Duration(),
                child: AnimatedOpacity(
                  opacity: _thirdOpacityAnimation.value,
                  duration: Duration(),
                  child: MiddleSection(),
                ),
              ),
              MiddleSection(color: Colors.white),
            ],
          ),
        );
      },
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Color? color;
  const MiddleSection({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Colors.white54,
        ),
        child: SizedBox(width: 100.0, height: 100.0),
      ),
    );
  }
}
