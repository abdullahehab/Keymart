class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.photo,
  });

  int id;
  String name;
  String photo;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        photo: json["photo"] == null ? null : json["photo"],
      );
}
