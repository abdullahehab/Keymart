import 'package:kaymarts/providers/forget_password_provider.dart';
import 'package:kaymarts/ui/auth/forget_password_screen.dart';
import 'package:kaymarts/ui/user/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/user_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/routes.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/services/api_services.dart';
import 'package:kaymarts/widgets/otp_dialog.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaymarts/ui/auth/check_auth.dart';

class UserApi {
  Future<void> createUser(BuildContext context, UserModel userModel) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(ApiRoutes.registerApi),
        headers: ApiServices.headersDataRegister,
        body: jsonEncode(userModel.toMapRegister()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['user']['original'];
      print(data);
      tokenId = data['access_token'];
      UserModel _userModel = UserModel(
          uid: data['id'].toString(),
          displayName: data['fullname'],
          email: data['email'],
          phoneNumber: data['phone'],
          password: data['id'].toString(),
          photoUrl: data['photo'],
          tokenId: data['access_token'],
          status: data['status']);
      authProvider.changeUserModel(_userModel);
      SharedPreferenceHelper().setUserPref(_userModel);
      Navigator.of(context).pop();
      otpCodeDialogBuild(context);
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);
    } else {
      Navigator.of(context).pop();
      final decoded = jsonDecode(response.body) as Map;
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }

  Future<void> validateUser(BuildContext context, String otp) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final http.Response response = await http.post(
      ApiRoutesUpdate().getLink(ApiRoutes.otpApi),
      headers: ApiServices.headersData,
      body: jsonEncode(<String, String>{
        'code': otp,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['user'];
      UserModel _userModel = UserModel(
          uid: authProvider.userModel.uid,
          displayName: authProvider.userModel.displayName,
          email: authProvider.userModel.email,
          phoneNumber: authProvider.userModel.phoneNumber,
          password: authProvider.userModel.password,
          photoUrl: authProvider.userModel.photoUrl,
          tokenId: authProvider.userModel.tokenId,
          status: data['status']);
      authProvider.changeUserModel(_userModel);
      SharedPreferenceHelper().setUserPref(_userModel);
      if (data['status'] == 1) {
        showToast(jsonDecode(response.body)["message"],
            Theme.of(context).iconTheme.color, context);
        Navigator.of(context).pushReplacementNamed(Routes.home);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        showToast(jsonDecode(response.body)["message"], Colors.red, context);
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final decoded = jsonDecode(response.body) as Map;
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }

  Future<void> loginUser(BuildContext context, UserModel userModel) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(ApiRoutes.loginApi),
        headers: ApiServices.headersData,
        body: jsonEncode(userModel.toMapLogin()));
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      final data = jsonDecode(response.body)['data']['user']['original'];
      print(data);
      tokenId = data['access_token'];
      UserModel _userModel = UserModel(
          uid: data['id'].toString(),
          displayName: data['fullname'],
          email: data['email'],
          phoneNumber: data['phone'],
          password: data['id'].toString(),
          photoUrl: data['photo'],
          tokenId: data['access_token'],
          status: data['status']);
      authProvider.changeUserModel(_userModel);
      SharedPreferenceHelper().setUserPref(_userModel);
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      Navigator.of(context).pop();
      showToast(jsonDecode(response.body)["message"], Colors.red, context);
    }
  }

  Future<void> updateUser(
      BuildContext context, UserModel userModel, var byte) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Uri uri = Uri.parse(ApiRoutesUpdate().getLink(ApiRoutes.updateApi));
    var request;
    if (byte == null) {
      request = http.MultipartRequest("POST", uri)
        ..headers.addAll(ApiServices.headersDataUpdateUser)
        ..fields['fullname'] = userModel.displayName
        ..fields['phone'] = userModel.phoneNumber;
    } else {
      request = http.MultipartRequest("POST", uri)
        ..headers.addAll(ApiServices.headersDataUpdateUser)
        ..fields['fullname'] = userModel.displayName
        ..fields['phone'] = userModel.phoneNumber
        ..files.add(http.MultipartFile.fromBytes('photo', byte,
            filename: '${authProvider.userModel.phoneNumber}.jpg'));
    }
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);
    var dataUser = jsonDecode(responseString)['data']['user'];
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      UserModel _userModel = UserModel(
          uid: authProvider.userModel.uid,
          displayName: dataUser['fullname'],
          phoneNumber: dataUser['phone'],
          email: authProvider.userModel.email,
          password: authProvider.userModel.uid,
          photoUrl: dataUser['photo'],
          tokenId: authProvider.userModel.tokenId,
          status: authProvider.userModel.status);
      authProvider.changeUserModel(_userModel);
      SharedPreferenceHelper().setUserPref(_userModel);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ProfileUserScreen()));

      showToast(data["message"], Theme.of(context).iconTheme.color, context);
    } else {
      Navigator.of(context).pop();

      showToast(data["message"], Colors.red, context);
    }
  }

  Future<void> exitUser(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(ApiRoutes.logoutApi),
        headers: ApiServices.headersData);
    if (response.statusCode == 200) {
      authProvider.removeUserModel();
      SharedPreferenceHelper().removeUserPref();
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);
    } else {
      Navigator.of(context).pop();
      showToast(jsonDecode(response.body)["message"], Colors.red, context);
    }
  }

  Future<void> sendEmailForgetPassword(BuildContext context) async {
    final forgetPasswordProvider =
        Provider.of<ForgetPasswordProvider>(context, listen: false);
    final http.Response response = await http.get(
        ApiRoutesUpdate().getLink(
            ApiRoutes.emailForgetPassword + forgetPasswordProvider.getEmail),
        headers: ApiServices.headersDataRegister);
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      final data = jsonDecode(response.body)['data']['user'];
      if (data != "") {
        forgetPasswordProvider.changeResetToken(data['email']);
      } else {
        forgetPasswordProvider.changeResetToken(null);
        forgetPasswordProvider
            .changeError(jsonDecode(response.body)["message"]);
      }
      print(data);
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context,
          location: true);
    } else {
      Navigator.of(context).pop();
      final decoded = jsonDecode(response.body) as Map;
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }

  Future<void> sendOTPForgetPassword(BuildContext context) async {
    final forgetPasswordProvider =
        Provider.of<ForgetPasswordProvider>(context, listen: false);
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(
            ApiRoutes.otpForgetPassword + forgetPasswordProvider.getEmail),
        headers: ApiServices.headersDataRegister,
        body: jsonEncode(<String, String>{
          'code': forgetPasswordProvider.getOtp,
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['user'];
      Navigator.of(context, rootNavigator: true).pop();

      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);

      print(data);
      if (data != "") {
        forgetPasswordProvider.changeResetToken(data['reset_token']);
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen()));
      } else {}
    } else {
      Navigator.of(context).pop();
      final decoded = jsonDecode(response.body) as Map;
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }

  Future<void> newPasswordForgetPassword(BuildContext context) async {
    final forgetPasswordProvider =
        Provider.of<ForgetPasswordProvider>(context, listen: false);
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(ApiRoutes.newPasswordForgetPassword +
            forgetPasswordProvider.getEmail +
            "/token/" +
            forgetPasswordProvider.getResetToken),
        headers: ApiServices.headersDataRegister,
        body: jsonEncode(<String, String>{
          'password': forgetPasswordProvider.getPassword,
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['user'];
      print(data);

      Navigator.of(context, rootNavigator: true).pop();
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);
      Navigator.of(context).pushReplacementNamed(Routes.login);
    } else {
      final data = jsonDecode(response.body);
      print(data);
      // Navigator.of(context).pop();
      // final decoded = jsonDecode(response.body) as Map;
      // final data = decoded['data'] as Map;
      // data.forEach((key, value) {
      //   showToast(value[0].toString(), Colors.red, context);
      // });
    }
  }

  Future<void> resendOTP(BuildContext context) async {
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(ApiRoutes.resendOTP),
        headers: ApiServices.headersData);
    if (response.statusCode == 200) {
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context,
          location: true);
      print(jsonDecode(response.body));
    } else {
      final decoded = jsonDecode(response.body) as Map;
      print(decoded);
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }
}
