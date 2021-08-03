import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  bool _favorite = false;
  int _count = 0;
  List<String> favoriteIds = [];

  bool get getFavorite => _favorite;
  int get getCount => _count;
  List<String> get getFavoriteId => favoriteIds;

  void changeFavoriteValue(bool favorite) {
    _favorite = favorite;
    notifyListeners();
  }

  void changeCountValue(int count) {
    _count = count;
    notifyListeners();
  }

  void changeFavoriteIdsValue(String favoriteId) {
    favoriteIds.add(favoriteId);
    notifyListeners();
    print(favoriteIds);
  }

  void removeFavoriteIdValue(String favoriteId) {
    favoriteIds.remove(favoriteId);
    notifyListeners();
    print(favoriteIds);
  }

  void clearFavoriteIds() {
    favoriteIds.clear();
    notifyListeners();
  }
}
