class ReviewsModel {
  ReviewsModel({
    this.username,
    this.userphoto,
    this.comment,
    this.stars,
    this.date,
  });

  dynamic username;
  dynamic userphoto;
  dynamic comment;
  dynamic stars;
  dynamic date;

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
        username: json["username"] == null ? null : json["username"],
        userphoto: json["userphoto"] == null ? null : json["userphoto"],
        comment: json["comment"] == null ? null : json["comment"],
        stars: json["stars"] == null ? null : json["stars"],
        date: json["date"] == null ? null : json["date"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment == null ? null : comment,
        "stars": stars == null ? null : stars,
      };
}
