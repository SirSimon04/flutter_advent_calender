class CalendarModel {
  final String id;
  final String title;
  final String msg;

  CalendarModel({
    required this.id,
    required this.msg,
    required this.title,
  });

  CalendarModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["name"],
        msg = res["age"];

  Map<String, Object?> toMap() {
    return {"id": id, "title": title, "msg": msg};
  }
}
