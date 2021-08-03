import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/providers/forget_password_provider.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';

Future<AlertDialog> otpCodeDialogBuild(BuildContext context) async {
  final forgetPasswordProvider =
      Provider.of<ForgetPasswordProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  authProvider.changeSmsCode("");
  CountDown cd = CountDown(Duration(seconds: 60));
  cd.stream.forEach((element) {
    forgetPasswordProvider.changeTimeResend(element.inSeconds);
  });
  return showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(10.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(AppLocalizations.of(context).translate('Enter OTP')),
            content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  authProvider.changeSmsCode(value);
                }),
            actions: <Widget>[
              ElevatedButton(
                  child: Text(AppLocalizations.of(context).translate("Ok")),
                  onPressed: () async {
                    if (authProvider.getSmsCode.isNotEmpty) {
                      progressDialog(context);
                      await UserApi()
                          .validateUser(context, authProvider.getSmsCode);
                    } else {
                      showToast("Code is empty", Colors.red, context);
                    }
                  }),
              Consumer<ForgetPasswordProvider>(
                  builder: (context, forgetPasswordProvider, _) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                    ),
                    child: Text(forgetPasswordProvider.getTimeResend == 0
                        ? AppLocalizations.of(context).translate("Resend")
                        : forgetPasswordProvider.getTimeResend.toString()),
                    onPressed: () async {
                      UserApi().resendOTP(context);
                      CountDown cd = CountDown(Duration(seconds: 60));
                      cd.stream.forEach((element) {
                        forgetPasswordProvider
                            .changeTimeResend(element.inSeconds);
                      });
                    });
              }),
            ]);
      });
}
