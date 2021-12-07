import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/services/file_service.dart';
import 'package:flutter_advent_calender/services/http.dart';
import 'package:flutter_advent_calender/services/local_database_handler.dart';
import 'package:flutter_advent_calender/services/toast_service.dart';
import 'package:flutter_advent_calender/widgets/calendar_tile.dart';
import 'package:flutter_advent_calender/widgets/loader.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

class OwnCalendars extends StatefulWidget {
  const OwnCalendars({Key? key}) : super(key: key);

  @override
  _OwnCalendarsState createState() => _OwnCalendarsState();
}

class _OwnCalendarsState extends State<OwnCalendars>
    with AutomaticKeepAliveClientMixin {
  String ngrokUrl = "http://6c9b-84-191-202-87.ngrok.io";
  final TextEditingController _textFieldController = TextEditingController();
  final DatabaseHandler db = DatabaseHandler();

  bool _isLoading = false;

  late Future<List<CalendarModel>> _futureCalList;

  HttpHelper httpHelper = HttpHelper();
  DatabaseHandler databaseHandler = DatabaseHandler();
  FileService fileService = FileService();

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
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  //Get calendar by id from Server and save to local db
                  CalendarModel c = await httpHelper
                      .getCalendarFromServer(_textFieldController.text.trim());
                  await databaseHandler.insertCalendar(c);
                  //Update showing calendars
                  setState(() {
                    _futureCalList = getCalList();
                  });

                  //Saving every image on local storage
                  for (int i = 0; i < 24; i++) {
                    await fileService
                        .saveImageFromName(c.id + "_" + i.toString() + ".jpg");
                  }

                  //Datenbankeinträge hinzufügen, ob eine Tür schon geöffnet ist
                  for (int i = 0; i < 24; i++) {
                    await databaseHandler.insertOpened(id: c.id, day: i);
                  }
                  setState(() {
                    _isLoading = false;
                  });
                } on NotFoundException catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  ToastService.showLongToast(
                      "Der Kalender mit der eingegeben Id wurde nicht gefunden");
                } on DatabaseException catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  if (e.isUniqueConstraintError()) {
                    ToastService.showLongToast(
                        "Diser Kalender wurde schon hinzugefügt");
                  } else {
                    ToastService.showLongToast(
                        "Beim Laden des Kalenders ist ein Fehler aufgetreten");
                  }
                } catch (e) {
                  print(e);
                  setState(() {
                    _isLoading = false;
                  });
                  ToastService.showLongToast(
                      "Beim Laden des Kalenders ist ein Fehler aufgetreten");
                }
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

  @override
  void initState() {
    super.initState();
    _futureCalList = getCalList();
  }

  Future<List<CalendarModel>> getCalList() async => await db.getCalendars();

  Future<int> calculateDoorsToOpen(String id) async {
    //TODO: just show the dates after december 1
    DateTime now = DateTime.now();
    if (now.isBefore(DateTime.utc(2021, 12))) {
      return -1;
    } else {
      List openedDoors = await databaseHandler.getOpenededEntries(id);
      return now.day - openedDoors.length;
    }
  }

  showSnackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Der Kalender mit der eingegeben Id wurde nicht gefunden",
        ),
        duration: Duration(
          seconds: 3,
        ),
      ),
    );
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
      body: NotificationListener<ComeBackFromCalendarView>(
        onNotification: (val) {
          setState(() {});
          return true;
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FutureBuilder<List<CalendarModel>>(
                  future: _futureCalList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Du hast noch keine Kalender gespeichert. Du kannst einen Kalender mit dem Plus oben rechts hinzufügen.",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return FutureBuilder<int>(
                              future: calculateDoorsToOpen(
                                  snapshot.data![index].id),
                              builder: (context2, snapshot2) {
                                if (snapshot.hasData) {
                                  return CalendarTile(
                                    calendar: snapshot.data?[index],
                                    doorsToOpen: snapshot2.data ?? 0,
                                  );
                                } else {
                                  return CalendarTile(
                                    calendar: snapshot.data?[index],
                                    doorsToOpen: 0,
                                  );
                                }
                              });
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Du hast noch keine Kalender gespeichert. Du kannst einen Kalender mit dem Plus oben rechts hinzufügen.",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  }),
            ),
            Container(
              child: _isLoading
                  ? const Loader(
                      loadingTxt:
                          "Dein Kalender wird geladen, Dieser Vorgang kann einige Zeit in Anspruch nehmen, da alle Bilder heruntergeladen werden. Bitte verbleibe dabei in dieser Ansicht.",
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
