import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'http.dart' as local_http;

class FileService {
  Future<void> saveImageFromName(String name) async {
    final response = await http
        .get(Uri.parse("https://advent4you.you2me.app/image/" + name));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    print(response);
    File file = File(join(documentDirectory.path, name));

    await file.writeAsBytes(response.bodyBytes);
  }

  Future<void> deleteImageFromName(String name) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    File file = File(join(documentDirectory.path, name));

    await file.delete();
  }
}
