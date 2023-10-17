import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'http.dart' as local_http;

class FileService {
  Future<void> loadImageFromServerAndSave(
      {required String name,
      required String password,
      required int number}) async {
    final response = await http.get(Uri.parse(
        local_http.HttpHelper.serverBaseUrl +
            "/image?name=$name&password=$password&number=$number"));

    if (response.statusCode == 403) {
      throw local_http.PasswordWrongException();
    } else if (response.statusCode == 404) {
      throw local_http.NotFoundException();
    } else if (response.statusCode != 200) {
      throw Exception();
    }
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    File file = File(
        join(documentDirectory.path, name + "_" + number.toString() + ".jpg"));

    await file.writeAsBytes(response.bodyBytes);
  }

  Future<void> deleteImageFromName(String name) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    File file = File(join(documentDirectory.path, name));

    await file.delete();
  }
}
