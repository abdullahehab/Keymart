import 'package:flutter/material.dart';

class NumDrugProvider extends ChangeNotifier {
  String _numDrug = "1";

  NumDrugProvider() {
    _numDrug = "1";
  }

  String get getNumDrug {
    return _numDrug;
  }

  void changeNumDrugValue(var numDrug) {
    _numDrug = numDrug;
    notifyListeners();
  }
}
