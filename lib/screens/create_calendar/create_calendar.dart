import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/services/http.dart';
import 'package:flutter_advent_calender/services/toast_service.dart';
import 'package:flutter_advent_calender/widgets/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clipboard/clipboard.dart';

class CreateCalendar extends StatefulWidget {
  const CreateCalendar({Key? key}) : super(key: key);

  @override
  _CreateCalendarState createState() => _CreateCalendarState();
}

class _CreateCalendarState extends State<CreateCalendar>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _titleController;
  late TextEditingController _msgController;
  late ScrollController _scrollController;
  late String newCalId;

  bool _isLoading = false;

  List<bool> selectedBg = [
    true,
    false,
  ];

  List<bool> selectedDoors = [
    true,
    false,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _msgController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _msgController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Erstelle einen neuen Kalender",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Titel',
                    ),
                    controller: _titleController,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
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
                    "Bilderauswahl",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "Tippe auf einen Tag, um f??r diesen ein Bild auszuw??hlen",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                        // ignore: deprecated_member_use
                        PickedFile? pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            images[index] = File(pickedFile.path);
                          });
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
                  "Tippe auf ein Hintergrundbild, um es auszuw??hlen",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                        List<bool> newList = [];
                        for (int i = 0; i < 2; i++) {
                          if (i == index) {
                            newList.add(true);
                          } else {
                            newList.add(false);
                          }
                        }
                        setState(() {
                          selectedBg = newList;
                        });
                      },
                      child: Opacity(
                        opacity: selectedBg[index] ? 1 : 0.5,
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
                    "T??rchen",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "Tippe auf eine T??r, um sie auszuw??hlen",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                        List<bool> newList = [];
                        for (int i = 0; i < 2; i++) {
                          if (i == index) {
                            newList.add(true);
                          } else {
                            newList.add(false);
                          }
                        }
                        setState(() {
                          selectedDoors = newList;
                        });
                      },
                      child: Opacity(
                        opacity: selectedDoors[index] ? 1 : 0.5,
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
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).primaryColor,
                    child: MaterialButton(
                      onPressed: (_titleController.text.trim().isEmpty ||
                              _msgController.text.trim().isEmpty ||
                              images.contains(null))
                          ? () {
                              ToastService.showLongToast(
                                  "Es sind nicht alle Textfelder ausgef??llt oder du hast noch nicht alle Fotos hochgeladen");
                            }
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              HttpHelper http = HttpHelper();
                              newCalId = await http.uploadCalendar(
                                msg: _msgController.text.trim(),
                                title: _titleController.text.trim(),
                                bgId: selectedBg.indexOf(true),
                                doorId: selectedDoors.indexOf(true),
                              );
                              await http.uploadImages(
                                images: images,
                                newCalId: newCalId,
                              );
                              _msgController.clear();
                              _titleController.clear();
                              List<File?> newImages = [];
                              for (int i = 0; i < 24; i++) {
                                newImages.add(null);
                              }
                              setState(() {
                                images = newImages;
                                _isLoading = false;
                              });
                              _scrollController.jumpTo(0);
                              showDialog(
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                      "Dein Kalender wurde erfolgreich erstellt"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Schicke diese Id an deine Freunde",
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Text(
                                          newCalId,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Center(
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            FlutterClipboard.copy(newCalId)
                                                .then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Erfolgreich kopiert!"),
                                                ),
                                              );
                                            });
                                          },
                                          icon: const Icon(Icons.copy),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                context: context,
                              );
                            },
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
                        "Dein Kalender wird erstellt. Dieser Vorgang kann einige Zeit in Anspruch nehmen, da alle Bilder hochgeladen werden m??ssen. Bitte verbleibe dabei in dieser Ansicht",
                  )
                : Container(),
          ),
        ],
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
}
