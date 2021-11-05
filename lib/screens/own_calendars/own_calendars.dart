import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/screens/calendar_view/calendar_view.dart';
import 'package:flutter_advent_calender/services/http.dart';
import 'package:flutter_advent_calender/services/local_database_handler.dart';
import 'package:flutter_advent_calender/widgets/loader.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OwnCalendars extends StatefulWidget {
  const OwnCalendars({Key? key}) : super(key: key);

  @override
  _OwnCalendarsState createState() => _OwnCalendarsState();
}

class _OwnCalendarsState extends State<OwnCalendars>
    with AutomaticKeepAliveClientMixin {
  String ngrokUrl = "http://6c9b-84-191-202-87.ngrok.io";
  final TextEditingController _textFieldController = TextEditingController();

  bool _isLoading = false;

  showAddAlert(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kalender hinzufügen'),
          content: TextField(
            onChanged: (value) {},
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Kalender-Code"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                //DO ALLE THE STUFF HERE
                try {
                  CalendarModel c = await HttpHelper()
                      .getCalendarFromServer(_textFieldController.text.trim());
                  await DatabaseHandler().insertCalendar(c);
                  print(await DatabaseHandler().getCalendars());

                  //TODO: Rebuild the grid view
                } catch (e) {
                  print(e);
                }
                setState(() {
                  _isLoading = false;
                });
              },
              child: const Text(
                "Hinzufügen",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  // dbTest() async {
  // print("db test");
  // DatabaseHandler db = DatabaseHandler();
  // await db.initializeDB();
  // print("initialized");
  // await db.insertCalendar(
  //     CalendarModel(title: "TESTTITEL", id: "TESTID2", msg: "TESTMSG"));
  // print("inserted");
  //   print(await db.getCalendars());
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meine Kalender",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            onPressed: () {
              showAddAlert(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const CalendarView()));
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Christina",
                              style: TextStyle(fontSize: 32),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Du kannst ein neues Türchen öffnen",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 30,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            "assets/present.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const CalendarView()));
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Christina",
                              style: TextStyle(fontSize: 32),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Du hast bisher alle Türchen geöffnet",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 30,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            "assets/present.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const CalendarView()));
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Christina",
                              style: TextStyle(fontSize: 32),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Du kannst zwei neue Türchen öffnen",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 30,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            "assets/present.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: _isLoading
                ? Loader(
                    loadingTxt: "Kalender wird geladen...",
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
