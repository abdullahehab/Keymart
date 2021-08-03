class SearchModel {
  SearchModel({
    this.id,
    this.name,
    this.mainPrice,
    this.salePrice,
    this.marketId,
    this.marketName,
    this.marketDeliveryPrice,
    this.photo,
    this.endDate,
    this.typeQuantity,
    this.offer,
  });

  int id;
  String name;
  String mainPrice;
  dynamic salePrice;
  int marketId;
  String marketName;
  String marketDeliveryPrice;
  String photo;
  String endDate;
  String typeQuantity;

  int offer;
  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        id: json["id"],
        name: json["name"],
        mainPrice: json["main_price"],
        salePrice: json["sale_price"],
        marketId: json["market_id"],
        marketName: json["market_name"],
        marketDeliveryPrice: json["market_delivery_price"],
        photo: json["photo"],
        endDate: json["end_date"],
        typeQuantity: json["type_quantity"],
        offer: json["offer"],
      );
}
