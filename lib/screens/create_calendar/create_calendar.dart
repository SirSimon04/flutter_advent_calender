import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/widgets/fill_outlined_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class CreateCalendar extends StatefulWidget {
  const CreateCalendar({Key? key}) : super(key: key);

  @override
  _CreateCalendarState createState() => _CreateCalendarState();
}

class _CreateCalendarState extends State<CreateCalendar>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _titleController;
  late TextEditingController _msgController;

  late String newCalId;

  String ngrokUrl = "http://6c9b-84-191-202-87.ngrok.io";

  Future<void> uploadCalendar() async {
    newCalId =
        sha256.convert(utf8.encode(DateTime.now().toString())).toString();

    http.post(
      Uri.parse('http://fc2c-84-191-198-24.ngrok.io/calendar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': newCalId,
        "title": _titleController.text.trim(),
        "msg": _msgController.text.trim(),
        "from": "VON DICH",
        "to": "FÜR MICH"
      }),
    );
  }

  Future<void> uploadImages() async {
    final request = http.MultipartRequest("POST", Uri.parse("$ngrokUrl/image"));

    final headers = {"Content-type": "multipart/form-data"};

    for (int i = 0; i < 24; i++) {
      request.files.add(http.MultipartFile(i.toString(),
          images[i]!.readAsBytes().asStream(), images[i]!.lengthSync(),
          filename: (newCalId +
              "_" +
              i.toString() +
              "." +
              images[i]!.path.split(".").last)));
    }

    request.headers.addAll(headers);

    final response = await request.send();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _msgController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _msgController.dispose();
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
      body: SingleChildScrollView(
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
              "Tippe auf einen Tag, um für diesen ein Bild auszuwählen",
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  onPressed: () async {
                    uploadCalendar();
                    uploadImages();
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
