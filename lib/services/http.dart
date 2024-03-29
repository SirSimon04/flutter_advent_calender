import 'dart:io';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotFoundException implements Exception {}

class PasswordWrongException implements Exception {}

class NameAlreadyTakenException implements Exception {}

class HttpHelper {
  HttpHelper();
  static String serverBaseUrl = "https://advent4you-nest.you2me.app";

  Future<CalendarModel> getCalendarFromServer({
    required String name,
    required String password,
  }) async {
    final response = await http.get(
        Uri.parse(serverBaseUrl + "/calendar?name=$name&password=$password"));
    if (response.statusCode == 200) {
      return CalendarModel.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw PasswordWrongException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw Exception("Failed to load Calendar");
    }
  }

  Future<CalendarModel> uploadCalendar({
    required CalendarModel newCalendar,
  }) async {
    http.Response res = await http.post(
      Uri.parse('$serverBaseUrl/calendar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newCalendar.toMap()),
    );
    if (res.statusCode == 409) {
      throw NameAlreadyTakenException();
    }
    if (res.statusCode != 201) {
      throw Exception(res.statusCode.toString() + " " + res.body);
    }
    //rest of try catch is one level higher

    CalendarModel uploadedCalendar =
        CalendarModel.fromMap(jsonDecode(res.body));

    return uploadedCalendar;
  }

  Future<void> uploadImages(
      {required List<File?> images,
      required CalendarModel calendarModel}) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
          "$serverBaseUrl/image?password=${calendarModel.password}&name=${calendarModel.name}"),
    );

    final headers = {"Content-type": "multipart/form-data"};
    for (int i = 0; i < 24; i++) {
      request.files.add(
        http.MultipartFile(
          i.toString(),
          images[i]!.readAsBytes().asStream(),
          images[i]!.lengthSync(),
          filename: (calendarModel.name + "_" + i.toString() + ".jpg"),
          // images[i]!.path.split(".").last),
        ),
      );
    }

    request.headers.addAll(headers);
    var res = await request.send();

    if (res.statusCode != 201) throw Exception();
  }
}
