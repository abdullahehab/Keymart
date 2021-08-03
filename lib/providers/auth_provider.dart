import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  String _smsCode = "";
  UserModel _userModel;

  UserModel get userModel => _userModel;
  String get getSmsCode => _smsCode;

  void changeUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  void removeUserModel() {
    _userModel = null;
    notifyListeners();
  }

  void changeSmsCode(String smsCode) {
    _smsCode = smsCode;
    notifyListeners();
  }
}
