import 'package:flutter/material.dart';
import 'package:learn_play_animations/main.dart';

class MyAnimatedList extends StatefulWidget {
  const MyAnimatedList({super.key});

  @override
  State<MyAnimatedList> createState() => _MyAnimatedListState();
}

class _MyAnimatedListState extends State<MyAnimatedList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  bool isAnimated = false;
  int itemCount = 10;
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: itemCount + 1,
      itemBuilder: (context, index, animation) {
        if (index == itemCount) {
          return InkWell(
            onTap: () {
              setState(() {
                ++itemCount;
              });
              _listKey.currentState?.insertItem(itemCount - 1);
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
              _listKey.currentState?.removeItem(
                index,
                (context, animation) => buildItem(index, animation),
              );
            },
            child: buildItem(index, animation),
          ),
        );
      },
    );
  }
}
