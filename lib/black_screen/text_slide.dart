import 'dart:async';

import 'package:flutter/material.dart';

class MultiTextSlide extends StatefulWidget {
  const MultiTextSlide({super.key});

  @override
  State<MultiTextSlide> createState() => _MultiTextSlideState();
}

class _MultiTextSlideState extends State<MultiTextSlide>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  List contentsList = ["awesome", "creative", "beautiful", "fabulous"];

  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  Future<void> _startAnimation() async {
    while (mounted) {
      changeSetUp(currentIndex);
      await Future.delayed(Duration(seconds: 3));
      if (mounted) {
        final currentWord = contentsList[currentIndex];
        final wordLength = currentWord.length;
        if (_animations.length == wordLength && mounted) {
          await performAnimation();
          setState(() {
            if (currentIndex == contentsList.length - 1) {
              currentIndex = 0;
            } else {
              currentIndex++;
            }
          });
          changeSetUp(currentIndex, isEntry: true);
          final newWord = contentsList[currentIndex];
          final newWordLength = newWord.length;
          if (_animations.length == newWordLength) {
            await performAnimation();
          }
        }
      }
    }
  }

  Future<void> performAnimation() async {
    final currentWord = contentsList[currentIndex];
    final wordLength = currentWord.length;
    for (int i = 0; i < wordLength; i++) {
      if (mounted) {
        if (mounted) {
          _controllers[i]
            ..reset()
            ..forward();
        }
        final milliseconds = 100 + (i * 50);
        await Future.delayed(Duration(milliseconds: milliseconds));
      } else {
        continue;
      }
    }
  }

  void changeSetUp(int index, {bool isEntry = false}) {
    if (mounted) {
      _controllers = [];
      _animations = [];
      final currentWord = contentsList[index];
      final wordLength = currentWord.length;
      _controllers = List.generate(
        wordLength,
        (_) => AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 200),
        ),
      );
      _animations = List.generate(wordLength, (index) {
        return (isEntry
                ? Tween<double>(begin: -40.0, end: 0.0)
                : Tween<double>(begin: 0.0, end: 40.0))
            .animate(_controllers[index]);
      });
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final eachController in _controllers) {
      eachController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(_controllers),
      builder: (context, child) {
        return ClipRRect(
          child:
              _animations.isEmpty
                  ? Container()
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Flutter animation is ",
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                      for (
                        int i = 0;
                        i < contentsList[currentIndex].length;
                        i++
                      )
                        Transform(
                          transform:
                              Matrix4.identity()
                                ..translate(0.0, _animations[i].value, 0.0),
                          child: Text(
                            contentsList[currentIndex][i],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
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
