class CalendarModel {
  final String id;
  final String title;
  final String msg;
  final int bgId;
  final int doorId;

  CalendarModel({
    required this.id,
    required this.msg,
    required this.title,
    required this.bgId,
    required this.doorId,
  });

  CalendarModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        msg = res["christmasMessage"],
        bgId = res["bgId"],
        doorId = res["doorId"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "christmasMessage": msg,
      "doorId": doorId,
      "bgId": bgId
    };
  }
}
