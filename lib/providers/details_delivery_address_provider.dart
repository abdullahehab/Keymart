import 'package:flutter/material.dart';

class DetailsDeliveryAddressProvider extends ChangeNotifier {
  int _groupValue = 0;
  String _addressId = "";

  int get getGroupValue => _groupValue;
  String get getAddressId => _addressId;

  void changeGroupValue(int groupValue) {
    _groupValue = groupValue;
    notifyListeners();
  }

  void changeAddressIdValue(String addressId) {
    _addressId = addressId;
    notifyListeners();
  }
}
