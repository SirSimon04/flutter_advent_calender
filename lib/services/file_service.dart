import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<void> saveImage() async {
    print("trying to save file");
    final response = await http
        .get(Uri.parse("https://8d26-91-49-177-26.ngrok.io/image/test.jpg"));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(join(documentDirectory.path, 'imagetest.png'));
    await file.writeAsBytes(response.bodyBytes);
    print("Saved file");
  }
}
