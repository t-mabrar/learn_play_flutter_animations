import 'dart:math' show pi;

import 'package:flutter/material.dart';

class DrawerAnimationScreen extends StatefulWidget {
  const DrawerAnimationScreen({super.key});

  @override
  State<DrawerAnimationScreen> createState() => _DrawerAnimationScreenState();
}

class _DrawerAnimationScreenState extends State<DrawerAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _xControllerForScaffold;
  late Animation<double> _yRotationForScaffold;

  late AnimationController _xControllerForDrawer;
  late Animation<double> _yRotationForDrawer;

  final double screenWidth = 400.0;
  final double screenHeight = 800.0;
  late double maxDrag;

  @override
  void initState() {
    super.initState();
    maxDrag = screenWidth * 0.8;
    _xControllerForScaffold = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yRotationForScaffold = Tween<double>(
      begin: 0.0,
      end: -(pi / 2),
    ).animate(_xControllerForScaffold);
    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _yRotationForDrawer = Tween<double>(
      begin: pi / 2.7,
      end: 0.0,
    ).animate(_xControllerForDrawer);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _xControllerForScaffold,
            _xControllerForDrawer,
          ]),
          builder: (context, childs) {
            return Stack(
              children: [
                ColoredBox(color: Colors.red, child: Container()),
                Transform(
                  alignment: Alignment.centerLeft,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..translate(_xControllerForScaffold.value * maxDrag)
                        ..rotateY(_yRotationForScaffold.value),
                  child: AppScaffold(
                    openDrawer: () {
                      _xControllerForDrawer.forward();
                      _xControllerForScaffold.forward();
                    },
                  ),
                ),
                Transform(
                  alignment: Alignment.centerRight,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..translate(
                          -screenWidth +
                              (_xControllerForDrawer.value * maxDrag),
                        )
                        ..rotateY(_yRotationForDrawer.value),
                  child: AppDrawer(
                    onClose: () {
                      _xControllerForDrawer.reverse();
                      _xControllerForScaffold.reverse();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final void Function() onClose;
  const AppDrawer({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.orange.shade600,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20.0,
            children: [
              IconButton(onPressed: onClose, icon: Icon(Icons.clear)),
              ...List.generate(
                35,
                (index) => index,
              ).map((value) => Center(child: Text((value + 1).toString()))),
            ],
          ),
        ),
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  final void Function() openDrawer;
  const AppScaffold({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        leading: IconButton(onPressed: openDrawer, icon: Icon(Icons.menu)),
        title: Text("Drawer Animation"),
        backgroundColor: Colors.transparent,
        elevation: 10.0,
      ),
    );
  }
}
