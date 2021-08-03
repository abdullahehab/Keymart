import 'package:kaymarts/my_app.dart';
import 'package:kaymarts/services/data_app_api.dart';
import 'package:kaymarts/ui/auth/check_auth.dart';

class ApiServices {
  static Map<String, String> get headersDataRegister {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'APP_KEY': appkey,
      'lang': lang
    };
    return headers;
  }

  static Map<String, String> get headersDataUpdateUser {
    Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'APP_KEY': appkey,
      'Authorization': 'bearer $tokenId',
      'lang': lang
    };
    return headers;
  }

  static Map<String, String> get headersData {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'APP_KEY': appkey,
      'Authorization': 'bearer $tokenId',
      'lang': lang
    };
    return headers;
  }
}
