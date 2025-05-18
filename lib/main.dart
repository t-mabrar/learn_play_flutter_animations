import 'package:flutter/material.dart';
import 'package:learn_play_animations/animation_on_grid_list/animated_grid.dart';
import 'package:learn_play_animations/animation_on_grid_list/animated_list.dart';
import 'package:learn_play_animations/animation_on_grid_list/custom_animation_list.dart';
import 'package:learn_play_animations/basic_screen/basic_screen.dart';
import 'package:learn_play_animations/black_screen/black_screen.dart';
import 'package:learn_play_animations/blue_screen/blue_screen.dart';
import 'package:learn_play_animations/drawer_animation/drawer_animation_screen.dart';
import 'package:learn_play_animations/grey_screen/grey_screen.dart';
import 'package:learn_play_animations/nuemorphic_screen/nuemorphic_screen.dart';
import 'package:learn_play_animations/white_screen/white_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeColorProvider(), child: MyApp()),
  );
}

class ThemeColorProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  Color get backgroundColor => _isDark ? Colors.blueGrey : Colors.amber;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  bool isAnimated = false;
  int itemCount = 10;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    // _controller.forward();
    // _controller.repeat(reverse: true);
  }

  void makeAnimation() {
    !isAnimated ? _controller.forward() : _controller.reverse();
    setState(() {
      isAnimated = !isAnimated;
      // ++itemCount;
      // _gridKey.currentState!.insertItem(itemCount - 1);
    });
  }

  Color tweenFirstColor = Colors.red;
  Color tweenSecondColor = Colors.blue;

  Widget _basicAnimationWidget() => Center(
    child: SingleChildScrollView(
      child: Stack(
        children: [
          TweenAnimationBuilder(
            curve: Curves.ease,
            tween: ColorTween(begin: tweenFirstColor, end: tweenSecondColor),
            onEnd: () {
              setState(() {
                tweenSecondColor = Colors.red;
                tweenFirstColor = Colors.blue;
              });
            },
            duration: Duration(seconds: 2),
            builder:
                (context, color, child) =>
                    Container(color: color, width: 200.0, height: 200.0),
          ),
          AnimatedPositioned(
            top: isAnimated ? 50.0 : 0.0,
            left: isAnimated ? 50.0 : 0.0,
            right: 0.0,
            duration: Duration(seconds: 2),
            child: ColoredBox(
              color: Colors.yellow,
              child: Text("Animated Position"),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  makeAnimation();
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_home,
                  progress: _animation,
                ),
              ),
              SizedBox(
                width: 300.0,
                height: 500.0,
                child: AnimatedModalBarrier(
                  color: ColorTween(
                    begin: Colors.orange,
                    end: Colors.green,
                  ).animate(_controller),
                ),
              ),
              AnimatedCrossFade(
                firstCurve: Curves.ease,
                secondCurve: Curves.ease,
                firstChild: Text("First child"),
                secondChild: Text("Second child"),
                crossFadeState:
                    isAnimated
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                duration: Duration(seconds: 1),
                reverseDuration: Duration(seconds: 1),
              ),
              AnimatedAlign(
                alignment:
                    !isAnimated ? Alignment.center : Alignment.centerRight,
                duration: Duration(seconds: 2),
                child: Text("Animating using alignment"),
              ),
              AnimatedContainer(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !isAnimated ? Colors.blue : Colors.red,
                ),
                width: !isAnimated ? 200.0 : 400.0,
                height: !isAnimated ? 200.0 : 800.0,
                duration: Duration(seconds: 2),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Text(_animation.value.toString()),
              ),
              SizedBox(
                height: 500.0,
                width: 500.0,
                child: ColoredBox(
                  color: Colors.blue,
                  child: AnimatedFractionallySizedBox(
                    alignment:
                        isAnimated
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    duration: Duration(seconds: 2),
                    widthFactor: isAnimated ? 0.25 : 0.75,
                    heightFactor: isAnimated ? 0.75 : 0.25,
                    child: ColoredBox(
                      color: Colors.red,
                      child: Center(
                        child: Text("AnimatedFractionallySizedBox"),
                      ),
                    ),
                  ),
                ),
              ),

              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 20.0,
                  color: isAnimated ? Colors.black : Colors.red,
                ),
                duration: Duration(seconds: 2),
                child: Text("Wow new text style with animation"),
              ),

              // ElevatedButton(
              //   onPressed: () {

              //   },
              //   child: Text("Show popup"),
              // ),
              ElevatedButton(onPressed: () {}, child: Text("Animate Now")),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeColorProvider>(context);
    return MaterialApp(
      // themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: themeProvider.isDark ? Brightness.dark : Brightness.light,
      ),
      home: DefaultTabController(
        length: 11,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Animationsl'),
            bottom: TabBar(
              tabs: [
                Tab(text: "Basic 1"),
                Tab(text: "Basic 2"),
                Tab(text: "Grid"),
                Tab(text: "List"),
                Tab(text: "Custom Animated List"),
                Tab(text: "Neumorphic Screen"),
                Tab(text: "White Screen"),
                Tab(text: "Black Screen"),
                Tab(text: "Grey Screen"),
                Tab(text: "Blue Screen"),
                Tab(text: "Drawer Animation"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _basicAnimationWidget(),
              BasicScreen(),
              MyAnimatedGrid(),
              MyAnimatedList(),
              CustomAnimationList(),
              NuemorphicScreen(),
              WhiteScreen(),
              BlackScreen(),
              GreyScreen(),
              BlueScreen(),
              DrawerAnimationScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildItem(int item, Animation<double> animation) {
  return ScaleTransition(
    scale: CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.bounceInOut,
    ),
    child: Container(
      margin: EdgeInsets.all(8),
      color: Colors.amber,
      child: Center(child: Text('${item + 1}')),
    ),
  );
}
