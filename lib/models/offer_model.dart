class OfferModel {
  OfferModel({
    this.id,
    this.name,
    this.mainPrice,
    this.salePrice,
    this.marketName,
    this.marketId,
    this.marketDeliveryPrice,
    this.photo,
    this.numberDay,
    this.typeQuantity,
    this.endDate,
  });

  int id;
  String name;
  String mainPrice;
  String salePrice;
  String marketName;
  int marketId;
  String marketDeliveryPrice;
  String photo;
  String numberDay;
  String typeQuantity;
  String endDate;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json["id"],
        name: json["name"],
        mainPrice: json["main_price"],
        salePrice: json["sale_price"],
        marketName: json["market_name"],
        marketId: json["market_id"],
        marketDeliveryPrice: json["market_delivery_price"],
        photo: json["photo"],
        numberDay: json["number_day"],
        endDate: json["end_date"],
      );
}
