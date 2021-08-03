import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  int _count = 0;
  double _deliveryPrice = 0.0;
  String _marketId = "";
  double _totalPriceMarket = 0.0;
  int _quantityMarket = 0;

  int get getCount => _count;
  String get getMarketId => _marketId;

  double get getDeliveryPrice => _deliveryPrice;
  double get getTotalPriceMarket => _totalPriceMarket;
  int get getQuantityMarket => _quantityMarket;

  void changeCountValue(int count) {
    _count = count;
    notifyListeners();
  }

  void changeDeliveryPriceValue(double deliveryPrice) {
    _deliveryPrice = deliveryPrice;
    notifyListeners();
  }

  void changeMarketIdValue(String marketId) {
    _marketId = marketId;
    notifyListeners();
  }

  void changetTotalPriceMarket(double totalPriceMarket) {
    _totalPriceMarket = totalPriceMarket;
    notifyListeners();
  }

  void changetQuantityMarket(int quantityMarket) {
    _quantityMarket = quantityMarket;
    notifyListeners();
  }
}
