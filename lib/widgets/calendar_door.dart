import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/widgets/plain_door.dart';

class CalendarDoor extends StatelessWidget {
  const CalendarDoor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          const Center(
            child: PlainDoor(
              imgSrc: "assets/door.png",
              size: Size(170, 250),
              isShadow: true,
            ),
          ),
          Center(
            child: Image.asset(
              "assets/present.png",
              width: 80,
              height: 80,
            ),
          ),
          Center(
            child: PlainDoor(
              animSec: 1,
              func: (bool check, AnimationController? ct) async {
                if (ct == null) return;
                if (ct.isAnimating) return;
                if (ct.isCompleted) {
                  ct.reverse();
                  return;
                }
                ct.forward();
                return;
              },
              size: Size(170, 250),
              imgSrc: "assets/door.png",
            ),
          ),
        ],
      ),
    );
  }
}
