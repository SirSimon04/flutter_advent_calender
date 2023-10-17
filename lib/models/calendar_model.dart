class CalendarModel {
  final String id;
  final String title;
  final String msg;
  final int bgId;
  final int doorId;
  final String name;
  final String? password;

  CalendarModel(
      {required this.id,
      required this.msg,
      required this.title,
      required this.bgId,
      required this.doorId,
      required this.name,
      this.password});

  CalendarModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        msg = res["christmasMessage"],
        bgId = res["bgId"],
        doorId = res["doorId"],
        name = res["name"],
        password = res["password"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "christmasMessage": msg,
      "doorId": doorId,
      "bgId": bgId,
      "name": name,
      "password": password
    };
  }
}
