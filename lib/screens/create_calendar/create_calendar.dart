import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/services/toast_service.dart';
import 'package:flutter_advent_calender/styles.dart';
import 'package:flutter_advent_calender/widgets/loader.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clipboard/clipboard.dart';

import '../../models/calendar_model.dart';
import '../../services/http.dart';

class CreateCalendar extends StatefulWidget {
  const CreateCalendar({Key? key}) : super(key: key);

  @override
  _CreateCalendarState createState() => _CreateCalendarState();
}

class _CreateCalendarState extends State<CreateCalendar>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _titleController;
  late TextEditingController _msgController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late ScrollController _scrollController;
  late String newCalId;

  bool _isLoading = false;

  int selectedBgIndex = 0;

  int selectedDoorIndex = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _msgController = TextEditingController();
    _scrollController = ScrollController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _msgController.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text("Erstelle einen neuen Kalendar"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      "Informationen",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Setze hier den Titel und die Weihnachts-Nachricht. Der Titel wird in der App angezeigt und die Weihnachtsnachricht wird an Weihcnahten angezeigt.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? PlatformTextField(
                            cupertino: (_, __) => cupertinoTextFieldStyle,
                            hintText: "Titel",
                            controller: _titleController,
                          )
                        : TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Titel',
                            ),
                            controller: _titleController,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? PlatformTextField(
                            cupertino: (_, __) => cupertinoTextFieldStyle,
                            hintText: "Weihnachts-Nachricht",
                            controller: _msgController,
                          )
                        : TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Weihnachts-Nachricht',
                            ),
                            controller: _msgController,
                          ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(
                      thickness: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      "Kalenderzugriff",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Füge einen Namen und ein Passwort hinzu. Der Name darf nur aus Buchstaben bestehen. Beides kannst du anderen geben, um deinen Kalender herunterzuladen. Der Name ist nicht sichtbar und wird nur zum Hinzufügen benutzt. Nach erfolgreichem Hochladen kannst du Name und Passwort kopieren.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? PlatformTextField(
                            cupertino: (_, __) => cupertinoTextFieldStyle,
                            hintText: "Name",
                            controller: _nameController,
                          )
                        : TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                            controller: _nameController,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? PlatformTextField(
                            cupertino: (_, __) => cupertinoTextFieldStyle,
                            hintText: "Passwort",
                            controller: _passwordController,
                          )
                        : TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Passwort',
                            ),
                            controller: _passwordController,
                          ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      "Bilderauswahl",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Tippe auf einen Tag, um für diesen ein Bild auszuwählen",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    shrinkWrap: true,
                    itemCount: 24,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          XFile? pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          // PickedFile? pickedFile = await ImagePicker().getImage(
                          //   source: ImageSource.gallery,
                          //   maxWidth: 1800,
                          //   maxHeight: 1800,
                          // );
                          if (pickedFile != null) {
                            setState(() {
                              // images[index] = File(pickedFile.path);
                              for (int i = 0; i < 24; i++) {
                                images[i] = File(pickedFile.path);
                              }
                            });
                            print(images);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: images[index] != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.file(
                                      images[index] ?? File(""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(
                      thickness: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      "Hintergrundbild",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Tippe auf ein Hintergrundbild, um es auszuwählen",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    shrinkWrap: true,
                    itemCount: 4,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedBgIndex = index;
                          });
                        },
                        child: Opacity(
                          opacity: selectedBgIndex == index ? 1 : 0.5,
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.asset(
                                    "assets/background_$index.jpg",
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(
                      thickness: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      "Türchen",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Tippe auf eine Tür, um sie auszuwählen",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    shrinkWrap: true,
                    itemCount: 2,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedDoorIndex = index;
                          });
                        },
                        child: Opacity(
                          opacity: selectedDoorIndex == index ? 1 : 0.5,
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.asset(
                                    "assets/door_$index.png",
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(
                      thickness: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoButton.filled(
                            child: const Text("Kalender erstellen"),
                            onPressed: () => onCreateButtonPressed(context),
                          )
                        : Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Theme.of(context).primaryColor,
                            child: MaterialButton(
                              onPressed: () => onCreateButtonPressed(context),
                              minWidth: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Text(
                                "Kalender erstellen",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              child: _isLoading
                  ? const Loader(
                      loadingTxt:
                          "Dein Kalender wird erstellt. Dieser Vorgang kann einige Zeit in Anspruch nehmen, da alle Bilder hochgeladen werden müssen. Bitte verbleibe dabei in dieser Ansicht",
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

  List<File?> images = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  onCreateButtonPressed(BuildContext context) async {
    RegExp alphabetic = RegExp(r'^[A-Za-z]+$');
    if (_titleController.text.trim().isEmpty ||
        _msgController.text.trim().isEmpty ||
        images.contains(null) ||
        _nameController.text.isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ToastService.showLongToast(
          "Es sind nicht alle Textfelder ausgefüllt oder du hast noch nicht alle Fotos hochgeladen");
    } else if (_nameController.text.contains(" ")) {
      ToastService.showLongToast(
          "Der Name der Kalenders darf kein Leerzeichen enthalten.");
    } else if (_passwordController.text.contains(" ")) {
      ToastService.showLongToast(
          "Das Passwort darf kein Leerzeichen enthalten.");
    } else if (!alphabetic.hasMatch(_nameController.text)) {
      ToastService.showLongToast("Der Name darf nur auf Buchstaben bestehen.");
    } else {
      setState(() {
        _isLoading = true;
      });
      HttpHelper http = HttpHelper();
      CalendarModel newCalendar = CalendarModel(
        msg: _msgController.text.trim(),
        title: _titleController.text.trim(),
        bgId: selectedBgIndex,
        doorId: selectedDoorIndex,
        name: _nameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      try {
        CalendarModel uploadedCalendar =
            await http.uploadCalendar(newCalendar: newCalendar);
        print("uploaded calendar successfully " + uploadedCalendar.toString());
        await http.uploadImages(
            images: images, calendarModel: uploadedCalendar);
      } on NameAlreadyTakenException {
        ToastService.showLongToast(
            "Dieser Name ist bereits vergeben. Bitte wähle einen anderen Namen zur Identifizierung.");
        setState(() {
          _isLoading = false;
        });
        return;
      } on Exception catch (e) {
        print(e.toString());
        ToastService.showLongToast("Es ist ein Fehler aufgetreten.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String dialogString = "";
      dialogString += "Name: " + _nameController.text + "\n";
      dialogString += "Password: " + _passwordController.text;

      _msgController.clear();
      _titleController.clear();
      _nameController.clear();
      _passwordController.clear();

      List<File?> newImages = [];
      for (int i = 0; i < 24; i++) {
        newImages.add(null);
      }
      setState(() {
        images = newImages;
        _isLoading = false;
      });
      _scrollController.jumpTo(0);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Dein Kalender wurde erfolgreich erstellt"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Schicke diese Daten an deine Freunde",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    dialogString,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text("Daten kopieren"),
                onPressed: () {
                  Navigator.of(context).pop();
                  FlutterClipboard.copy(dialogString).then(
                    (value) {
                      ToastService.showLongToast(
                        "Daten erfolgreich kopiert",
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Dein Kalender wurde erfolgreich erstellt"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Schicke diese Daten an deine Freunde",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    dialogString,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("ID kopieren"),
                onPressed: () {
                  Navigator.of(context).pop();
                  FlutterClipboard.copy(dialogString).then(
                    (value) {
                      ToastService.showLongToast(
                        "Daten erfolgreich kopiert",
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      }
    }
  }
}
