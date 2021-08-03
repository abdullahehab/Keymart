class MarketModel {
  MarketModel(
      {this.id,
      this.name,
      this.about,
      this.phone,
      this.location,
      this.lat,
      this.long,
      this.photo,
      this.stars,
      this.countReviews,
      this.priceDelivery,
      this.timeDelivery});

  int id;
  String name;
  String about;
  String phone;
  String location;
  String lat;
  String long;
  String photo;
  double stars;
  int countReviews;
  String priceDelivery;
  String timeDelivery;

  factory MarketModel.fromJson(Map<String, dynamic> json) => MarketModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        about: json["about"] == null ? null : json["about"],
        phone: json["phone"] == null ? null : json["phone"],
        location: json["location"] == null ? null : json["location"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        photo: json["photo"] == null ? null : json["photo"],
        stars: json["stars"] == null ? null : json["stars"].toDouble(),
        countReviews:
            json["count_reviews"] == null ? null : json["count_reviews"],
        priceDelivery:
            json["price_delivery"] == null ? null : json["price_delivery"],
        timeDelivery:
            json["time_delivery"] == null ? null : json["time_delivery"],
      );
}
