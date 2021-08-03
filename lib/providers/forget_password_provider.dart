import 'package:flutter/material.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  String _email;
  String _otp;
  String _resetToken;

  String _password;
  String _error;
  int _timeResend = 60;

  String get getEmail => _email;
  String get getOtp => _otp;
  String get getResetToken => _resetToken;
  String get getPassword => _password;
  String get getError => _error;
  int get getTimeResend => _timeResend;

  void changeEmailValue(String email) {
    _email = email;
    notifyListeners();
  }

  void changeOtpValue(String otp) {
    _otp = otp;
    notifyListeners();
  }

  void changeResetToken(String resetToken) {
    _resetToken = resetToken;
    notifyListeners();
  }

  void changePassword(String password) {
    _password = password;
    notifyListeners();
  }

  void changeError(String error) {
    _error = error;
    notifyListeners();
  }

  void changeTimeResend(int timeResend) {
    _timeResend = timeResend;
    notifyListeners();
  }
}
