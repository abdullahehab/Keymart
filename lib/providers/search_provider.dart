import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _searchValue;
  bool _search = false;
  bool _marketSearch = false;
  String _marketId = "";
  String _categoryId = "";
  String _categoryName = "";

  List _categories = [];

  SearchProvider() {
    _searchValue = "";
  }

  String get getSearchValue {
    return _searchValue;
  }

  bool get search => _search;
  bool get marketSearch => _marketSearch;
  String get marketId => _marketId;
  String get categoryId => _categoryId;
  String get categoryName => _categoryName;

  List get getCategories => _categories;

  void changeSearchValue(var searchValue) {
    _searchValue = searchValue;
    notifyListeners();
  }

  void changeSearch(bool search) {
    _search = search;
    notifyListeners();
  }

  void changeMarketSearch(bool marketSearch) {
    _marketSearch = marketSearch;
    notifyListeners();
  }

  void changeMarketId(String marketId) {
    _marketId = marketId;
    notifyListeners();
  }

  void changeCategoryId(String categoryId) {
    _categoryId = categoryId;
    notifyListeners();
  }

  void changeCategoryName(String categoryName) {
    _categoryName = categoryName;
    notifyListeners();
  }

  void changeCategories(var categorey) {
    _categories.add(categorey);
    notifyListeners();
  }

  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }
}
