import 'package:flutter/material.dart';

class CIndexProvider extends ChangeNotifier {
  int _cIndex = 0;
  int get getCIndex => _cIndex;

  void changeCIndex(int cIndex) {
    _cIndex = cIndex;
    notifyListeners();
  }
}
