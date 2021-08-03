class ProductCartModel {
  String productId;
  String imageName;
  String name;
  String quantity;
  String price;
  String deliveryPrice;
  String description;
  String marketId;
  String marketName;
  String categoryName;
  String typeQuantity;

  ProductCartModel(
      {this.productId,
      this.imageName,
      this.name,
      this.price,
      this.deliveryPrice,
      this.quantity,
      this.description,
      this.marketId,
      this.marketName,
      this.categoryName,
      this.typeQuantity});

  toJSONEncodable() {
    Map<String, dynamic> m = Map();
    m['productId'] = productId;
    m['imageName'] = imageName;
    m['name'] = name;
    m['price'] = price;
    m['deliveryPrice'] = deliveryPrice;
    m['quantity'] = quantity;
    m['description'] = description;
    m['marketId'] = marketId;
    m['marketName'] = marketName;
    m['categoryName'] = categoryName;
    m['typeQuantity'] = typeQuantity;

    return m;
  }
}

class ProductCartList {
  List<ProductCartModel> items;

  ProductCartList() {
    items = [];
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
