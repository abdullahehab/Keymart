class TermsModel {
  TermsModel({
    this.title,
    this.description,
  });

  String title;
  String description;

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
      );
}
