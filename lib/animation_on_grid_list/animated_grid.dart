import 'package:flutter/material.dart';
import 'package:learn_play_animations/main.dart';

class MyAnimatedGrid extends StatefulWidget {
  const MyAnimatedGrid({super.key});

  @override
  State<MyAnimatedGrid> createState() => _MyAnimatedGridState();
}

class _MyAnimatedGridState extends State<MyAnimatedGrid> {
  final GlobalKey<AnimatedListState> _gridKey = GlobalKey<AnimatedListState>();

  bool isAnimated = false;
  int itemCount = 10;
  @override
  Widget build(BuildContext context) {
    return AnimatedGrid(
      key: _gridKey,
      itemBuilder: (context, index, animation) {
        if (index == itemCount) {
          return InkWell(
            onTap: () {
              setState(() {
                ++itemCount;
              });
              _gridKey.currentState!.insertItem(itemCount - 1);
            },
            child: Icon(Icons.add),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                --itemCount;
              });
              _gridKey.currentState?.removeItem(
                index,
                (context, animation) => buildItem(index, animation),
              );
            },
            child: buildItem(index, animation),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
      ),
      initialItemCount: itemCount + 1,
    );
  }
}
