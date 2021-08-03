import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  int _count = 0;
  int get getCount => _count;

  void changeCountValue(int count) {
    _count = count;
    notifyListeners();
  }
}
