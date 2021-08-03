class ChatModel {
  ChatModel({
    this.id,
    this.photo,
    this.message,
    this.isAdmin,
    this.seen,
    this.date,
  });

  int id;
  String photo;
  String message;
  int isAdmin;
  int seen;
  String date;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"] == null ? null : json["id"],
        photo: json["photo"] == null ? null : json["photo"],
        message: json["message"] == null ? null : json["message"],
        isAdmin: json["is_admin"] == null ? null : json["is_admin"],
        seen: json["seen"] == null ? null : json["seen"],
        date: json["date"] == null ? null : json["date"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
      };
}
