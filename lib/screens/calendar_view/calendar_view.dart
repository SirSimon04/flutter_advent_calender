import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/main.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/services/file_service.dart';
import 'package:flutter_advent_calender/services/local_database_handler.dart';
import 'package:flutter_advent_calender/widgets/calendar_door.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
  FileService fileService = FileService();
  late Future<List<Map<String, dynamic>>> _futureOpenList;

  Future<List<Map<String, dynamic>>> getOpenList() async =>
      await db.getOpenDayEntries(widget.calendar.name);

  Future<void> deleteCalendar() async {
    for (int i = 0; i < 24; i++) {
      await fileService.deleteImageFromName(
          widget.calendar.name + "_" + i.toString() + ".jpg");
      await db.deleteOpened(name: widget.calendar.name, day: i);
    }
    await db.deleteCalendar(widget.calendar.name);
  }

  void showDeleteDialog() {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Wirklich löschen?'),
              content: const Text("Diese Aktion ist nicht zu widerrufen"),
              actions: <Widget>[
                CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Schließen')),
                CupertinoDialogAction(
                  onPressed: () async {
                    await deleteCalendar();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );
                  },
                  child: const Text('Löschen'),
                )
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Wirklich löschen?'),
                  content: const Text("Diese Aktion ist nicht zu widerrufen"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Schließen')),
                    TextButton(
                      onPressed: () async {
                        await deleteCalendar();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                        );
                      },
                      child: const Text('Löschen'),
                    )
                  ],
                ));
  }

  List<List<double>> calculatePositions(BuildContext context) {
    List<double> bottomList = [];
    List<double> rightList = [];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double heightOne = 0;

    double widthOne = width / 9;
    heightOne = height /
        4 *
        0.33333; // First number is because of 3 rows, so 4 spaces, second number is about how much percent of the screen the door rows will be showed
    for (int i = 0; i < 24; i++) {
      rightList.add((widthOne * ((i % 8) + 1)));
    }

    for (int i = 0; i < 24; i++) {
      bottomList.add((heightOne * ((i % 3))) + height * 0.2);
    }

    return [bottomList, rightList];
  }

  @override
  void initState() {
    super.initState();
    _futureOpenList = getOpenList();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.calendar.title),
        trailingActions: [
          GestureDetector(
            onTap: showDeleteDialog,
            child: Icon(context.platformIcons.delete),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureOpenList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return InteractiveViewer(
                maxScale: 60,
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/background_${widget.calendar.bgId}.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.2,
                        ),
                        itemCount: 24,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CalendarDoor(
                            iterator: index,
                            imgSrc: "assets/door_${widget.calendar.doorId}.png",
                            day: "${index + 1}",
                            doorSize: const Size(34, 50),
                            isLast: index == 23,
                            calendar: widget.calendar,
                            isDoorOpen: snapshot.data![index]["open"] == 1,
                          );
                        })
                    // for (int i = 0; i < 24; i++)
                    //   Positioned(
                    //     top: posList[0][i].toDouble(),
                    //     right: posList[1][i].toDouble(),
                    //     child: CalendarDoor(
                    //       iterator: i,
                    //       imgSrc: "assets/door_${widget.calendar.doorId}.png",
                    //       day: "${i + 1}",
                    //       doorSize: const Size(17, 25),
                    //       isLast: i == 23,
                    //       calendar: widget.calendar,
                    //       // isDoorOpen: snapshot.data![i]["open"] == 1,
                    //       isDoorOpen: false,
                    //     ),
                    //   ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
