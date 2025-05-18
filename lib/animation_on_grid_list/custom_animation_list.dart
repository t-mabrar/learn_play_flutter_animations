import 'package:flutter/material.dart';

class CustomAnimationList extends StatefulWidget {
  const CustomAnimationList({super.key});

  @override
  State<CustomAnimationList> createState() => _CustomAnimationListState();
}

class _CustomAnimationListState extends State<CustomAnimationList>
    with TickerProviderStateMixin {
  final int itemCount = 20;
  final Duration itemDuration = Duration(milliseconds: 200);
  final double triggerOffset = 100.0;

  late ScrollController _scrollController;
  late List<AnimationController?> _controllers;
  late List<Animation<Offset>?> _animations;
  late List<bool> _animatedItems;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _controllers = List.filled(itemCount, null);
    _animations = List.filled(itemCount, null);
    _animatedItems = List.filled(itemCount, false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final scrollPosition = _scrollController.offset;
    debugPrint(scrollPosition.toString());
    final screenHeight = MediaQuery.of(context).size.height;
    int count = 0;
    for (int i = 0; i < itemCount; i++) {
      if (_animatedItems[i]) continue;
      final itemOffset = i * 132.0;
      if (itemOffset < scrollPosition + screenHeight - triggerOffset) {
        Future.delayed(Duration(milliseconds: (count * 100)), () {
          if (mounted) _triggerAnimation(i);
        });
        count++;
      } else {
        count = 0;
        break;
      }
    }
  }

  void _triggerAnimation(int index) {
    if (_animatedItems[index]) return;
    final controller = AnimationController(vsync: this, duration: itemDuration);
    final animation = Tween<Offset>(
      begin: Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    _controllers[index] = controller;
    _animations[index] = animation;
    _animatedItems[index] = true;
    controller.forward();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scroll Animation List")),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final controller = _controllers[index];
          final animation = _animations[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child:
                controller != null
                    ? SlideTransition(
                      position: animation!,
                      child: buildItem(index),
                    )
                    : Container(),
          );
        },
      ),
    );
  }

  Widget buildItem(int index) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Colors.black12),
        ],
      ),
      child: Text('Item ${index + 1}', style: TextStyle(fontSize: 20)),
    );
  }
}
