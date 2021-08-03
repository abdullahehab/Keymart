import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool _status = false;

  bool get getStatus => _status;

  void changeStatusValue(bool status) {
    _status = status;
    notifyListeners();
  }
}
