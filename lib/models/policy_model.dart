class PolicyModel {
  PolicyModel({
    this.title,
    this.description,
  });

  String title;
  String description;

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
      );
}
