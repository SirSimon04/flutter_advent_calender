class CalendarModel {
  final String id;
  final String title;
  final String msg;
  final List<String>? fileNames;

  CalendarModel({
    required this.id,
    required this.msg,
    required this.title,
    this.fileNames,
  });

  CalendarModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        msg = res["msg"],
        fileNames = res["fileNames"];

  Map<String, Object?> toMap() {
    return {"id": id, "title": title, "msg": msg};
  }
}
