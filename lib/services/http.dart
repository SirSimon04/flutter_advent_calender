import 'dart:io';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class NotFoundException implements Exception {}

class HttpHelper {
  HttpHelper();
  final String ngrokUrl = "http://synologynas-simon.ddns.net:5555";

  Future<CalendarModel> getCalendarFromServer(String id) async {
    final response = await http.get(Uri.parse(ngrokUrl + "/calendar/" + id));
    print(Uri.parse(ngrokUrl + "/calendar/" + id));
    if (response.statusCode == 200) {
      return CalendarModel.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw Exception("Failed to load Calendar");
    }
  }

  Future<String> uploadCalendar({
    required String title,
    required String msg,
    required int bgId,
    required int doorId,
  }) async {
    String newCalId =
        sha256.convert(utf8.encode(DateTime.now().toString())).toString();

    await http.post(
      Uri.parse('$ngrokUrl/calendar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': newCalId,
        "title": title,
        "msg": msg,
        "from": "VON DICH",
        "to": "FÜR MICH",
        "bgId": bgId,
        "doorId": doorId
      }),
    );

    return newCalId;
  }

  Future<void> uploadImages(
      {required List<File?> images, required String newCalId}) async {
    final request = http.MultipartRequest("POST", Uri.parse("$ngrokUrl/image"));

    final headers = {"Content-type": "multipart/form-data"};

    for (int i = 0; i < 24; i++) {
      request.files.add(
        http.MultipartFile(
          i.toString(),
          images[i]!.readAsBytes().asStream(),
          images[i]!.lengthSync(),
          filename: (newCalId + "_" + i.toString() + ".jpg"),
          // images[i]!.path.split(".").last),
        ),
      );
    }

    request.headers.addAll(headers);

    await request.send();
  }
}
