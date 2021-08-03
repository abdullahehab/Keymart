class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.price,
    this.marketId,
    this.marketName,
    this.marketDeliveryPrice,
    this.photo,
    this.typeQuantity,
  });

  int id;
  String name;
  String price;
  int marketId;
  String marketName;
  String marketDeliveryPrice;
  String photo;
  String typeQuantity;
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        marketId: json["market_id"],
        marketName: json["market_name"],
        marketDeliveryPrice: json["market_delivery_price"],
        photo: json["photo"],
        typeQuantity: json["type_quantity"],
      );
}
