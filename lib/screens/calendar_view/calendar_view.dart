import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/services/local_database_handler.dart';
import 'package:flutter_advent_calender/widgets/calendar_door.dart';
import 'package:provider/provider.dart';

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

  List<List<double>> calculatePositions(BuildContext context) {
    print("calculatePos called");
    List<double> bottomList = [];
    List<double> rightList = [];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double widthOne = width / 9;
    double heightOne = height /
        4 *
        0.3333; // First number is because of 3 rows, so 4 spaces, second number is about how much percent of the screen the door rows will be showed
    print("before for");
    for (int i = 0; i < 24; i++) {
      rightList.add((widthOne * ((i % 8) + 1)));
    }

    for (int i = 0; i < 24; i++) {
      if (widget.calendar.bgId == 1) {
        bottomList.add((heightOne * ((i % 3))) + height * 0.5);
      } else if (widget.calendar.bgId == 0) {
        bottomList.add((heightOne * ((i % 3))) + height * 0.35);
      }
    }

    print("finished calculate");
    return [bottomList, rightList];
  }

  @override
  void initState() {
    super.initState();
    _futureOpenList = getOpenList();
  }

  @override
  Widget build(BuildContext context) {
    List<List<double>> posList = calculatePositions(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.calendar.title),
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
                        child: Image.asset(
                          "assets/background_${widget.calendar.bgId}.jpg",
                        ),
                      ),
                      for (int i = 0; i < 24; i++)
                        Positioned(
                          top: posList[0][i].toDouble(),
                          right: posList[1][i].toDouble(),
                          child: CalendarDoor(
                            iterator: i,
                            imgSrc: "assets/door_${widget.calendar.doorId}.png",
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

  List<double> bottom = <double>[];
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
