import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/services/local_database_handler.dart';
import 'package:flutter_advent_calender/widgets/calendar_door.dart';

class CalendarView extends StatefulWidget {
  final CalendarModel calendar;
  const CalendarView({
    Key? key,
    required this.calendar,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DatabaseHandler db = DatabaseHandler();

  late Future<List<Map<String, dynamic>>> _futureOpenList;

  Future<List<Map<String, dynamic>>> getOpenList() async =>
      await db.getOpenDayEntries(widget.calendar.id);

  @override
  void initState() {
    super.initState();
    _futureOpenList = getOpenList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adventskalender"),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _futureOpenList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return InteractiveViewer(
                  maxScale: 60,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset("assets/background.jpg"),
                      ),
                      for (int i = 0; i < 24; i++)
                        Positioned(
                          bottom: bottom[23 - i].toDouble(),
                          right: right[23 - i].toDouble(),
                          child: CalendarDoor(
                            iterator: i,
                            imgSrc: "assets/törchen.png",
                            day: "${i + 1}",
                            doorSize: const Size(17, 25),
                            isLast: i == 23,
                            calendar: widget.calendar,
                            isDoorOpen: snapshot.data![i]["open"] == 1,
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  List bottom = [
    350,
    350,
    350,
    350,
    350,
    350,
    350,
    350,
    400,
    400,
    400,
    400,
    400,
    400,
    400,
    400,
    450,
    450,
    450,
    450,
    450,
    450,
    450,
    450,
  ];
  List right = [
    20,
    70,
    120,
    170,
    220,
    270,
    320,
    370,
    20,
    70,
    120,
    170,
    220,
    270,
    320,
    370,
    20,
    70,
    120,
    170,
    220,
    270,
    320,
    370,
  ];
}
