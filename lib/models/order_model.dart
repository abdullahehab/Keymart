class OrderModel {
  final String orderNumber;
  final List<dynamic> orders;
  final String totalPrice;
  final String editTotalPrice;
  final String status;
  final String deliveryStatus;
  final DateTime pickupDate;
  final DateTime dateTime;
  final String userId;
  final String phoneNumber;
  final String addressId;
  final String offerId;
  final String pharmacyId;
  final String marketId;
  final String type;

  OrderModel(
      {this.orderNumber,
      this.orders,
      this.totalPrice,
      this.editTotalPrice,
      this.status,
      this.deliveryStatus,
      this.pickupDate,
      this.dateTime,
      this.userId,
      this.phoneNumber,
      this.offerId,
      this.addressId,
      this.pharmacyId,
      this.marketId,
      this.type});

  factory OrderModel.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String orderNumber = data['orderNumber'];
    List<dynamic> orders = data['orders'];
    String totalPrice = data['totalPrice'];
    String editTotalPrice = data['editTotalPrice'];
    String status = data['status'];
    String deliveryStatus = data['deliveryStatus'];
    DateTime pickupDate = data['pickupDate'];
    DateTime dateTime = data['dateTime'];
    String userId = data['userId'];
    String addressId = data['addressId'];
    String pharmacyId = data['pharmacyId'];
    String type = data['type'];

    return OrderModel(
      orderNumber: orderNumber,
      orders: orders,
      totalPrice: totalPrice,
      editTotalPrice: editTotalPrice,
      status: status,
      deliveryStatus: deliveryStatus,
      pickupDate: pickupDate,
      dateTime: dateTime,
      userId: userId,
      addressId: addressId,
      pharmacyId: pharmacyId,
      type: type,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,
      'orders': orders.map((i) => i.toJSONEncodable()).toList(),
      'totalPrice': totalPrice,
      'editTotalPrice': totalPrice,
      'status': status,
      'deliveryStatus': deliveryStatus,
      'pickupDate': pickupDate,
      'dateTime': dateTime,
      'userId': userId,
      'addressId': addressId,
      'pharmacyId': pharmacyId,
      'type': type
    };
  }

  Map<String, dynamic> toMapOrder() {
    return {
      'address_id': addressId,
      'product_data': orders,
      'market_id': marketId
    };
  }
}

class FetchMyOrderModel {
  FetchMyOrderModel({
    this.orderNumber,
    this.productName,
    this.photo,
    this.marketName,
    this.price,
    this.quantity,
    this.totalPrice,
    this.status,
    this.date,
  });

  dynamic orderNumber;
  dynamic productName;
  dynamic photo;
  dynamic marketName;
  dynamic price;
  dynamic quantity;
  dynamic totalPrice;
  dynamic status;
  dynamic date;

  factory FetchMyOrderModel.fromJson(Map<String, dynamic> json) =>
      FetchMyOrderModel(
        orderNumber: json["order_number"] == null ? null : json["order_number"],
        productName: json["product_name"] == null ? null : json["product_name"],
        photo: json["photo"] == null ? null : json["photo"],
        marketName: json["market_name"] == null ? null : json["market_name"],
        price: json["price"] == null ? null : json["price"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        totalPrice: json["total_price"] == null ? null : json["total_price"],
        status: json["status"] == null ? null : json["status"],
        date: json["date"] == null ? null : json["date"],
      );
}
