import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {
  HttpHelper();

  final String ngrokUrl = "http://6c9b-84-191-202-87.ngrok.io";

  Future<CalendarModel> getCalendarFromServer(String id) async {
    final response = await http.get(Uri.parse(ngrokUrl + "/calendar/" + id));

    if (response.statusCode == 200) {
      return CalendarModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Calendar");
    }
  }
}
