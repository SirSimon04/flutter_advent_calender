import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/widgets/calendar_door.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List bottom = [
    280,
    450,
    300,
    350,
    370,
    380,
    290,
    300,
    350,
    290,
    300,
    300,
    290,
    300,
    370,
    290,
    300,
    400,
    380,
    300,
    450,
    360,
    450,
    290
  ];
  List right = [
    100,
    300,
    280,
    300,
    190,
    20,
    80,
    190,
    210,
    60,
    280,
    170,
    60,
    280,
    380,
    340,
    10,
    380,
    270,
    280,
    170,
    70,
    380,
    250,
    250,
    250
  ];
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 24; i++) {
      print(bottom[i].toString());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adventskalender"),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 60,
          child: Stack(
            children: [
              Center(
                child: Image.asset("assets/bg.jpg"),
              ),
              for (int i = 0; i < 24; i++)
                Positioned(
                  bottom: bottom[i].toDouble(),
                  right: right[i].toDouble(),
                  child: CalendarDoor(
                    imgSrc: "assets/door.png",
                    day: "${i + 1}",
                    doorSize: Size(17, 25),
                    isLast: i == 23,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
