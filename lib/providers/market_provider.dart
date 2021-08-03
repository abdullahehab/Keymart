import 'package:kaymarts/models/market_model.dart';
import 'package:kaymarts/services/markets_api.dart';
import 'package:flutter/material.dart';

class MarketProvider extends ChangeNotifier {
  Future<List<MarketModel>> _futureMarket =
      getMarkets(lat: 30.062345299999997, long: 31.479883599999997);
  Future<List<MarketModel>> get getMarket => _futureMarket;
  String _location = "";
  double _lat = 30.062345299999997;
  double _long = 31.479883599999997;

  String get getLocation => _location;
  double get getLat => _lat;
  double get getLong => _long;

  void changeMarket(Future<List<MarketModel>> futureMarket) {
    _futureMarket = futureMarket;
    notifyListeners();
  }

  void changeLocation(String location, double lat, double long) {
    _location = location;
    _lat = lat;
    _long = long;
    notifyListeners();
  }
}
