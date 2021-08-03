import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  int _quantity = 1;
  int _count = 0;

  double _discount = 1;
  int get getCount => _count;

  bool _checkCart = false;
  String _orderNumber;
  List<String> productIds = [];

  int get getQuantity => _quantity;
  double get getDiscount => _discount;
  List<String> get getProductId => productIds;

  bool get getcheckCart => _checkCart;
  String get getOrderNumber => _orderNumber;

  void changeQuantityValue(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  void changeCountValue(int count) {
    _count = count;
    notifyListeners();
  }

  void changeOrderNumberValue(String orderNumber) {
    _orderNumber = orderNumber;
    notifyListeners();
  }

  void changeDiscountValue(double discount) {
    _discount = discount;
    notifyListeners();
  }

  void changecheckCartValue(bool checkCart) {
    _checkCart = checkCart;
    notifyListeners();
  }

  void changeProductIdsValue(String productId) {
    productIds.add(productId);
    notifyListeners();
  }

  void removeProductIdValue(String productId) {
    productIds.remove(productId);
    notifyListeners();
  }

  void clearProductIds() {
    productIds.clear();
    notifyListeners();
  }
}
