import 'package:countdown/countdown.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/providers/forget_password_provider.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';

final _formKey = GlobalKey<FormState>();

openAlertBoxForgetPassword(BuildContext context) {
  final forgetPasswordProvider =
      Provider.of<ForgetPasswordProvider>(context, listen: false);
  forgetPasswordProvider.changeResetToken(null);
  forgetPasswordProvider.changeOtpValue(null);
  forgetPasswordProvider.changeEmailValue(null);
  forgetPasswordProvider.changeError(null);
  CountDown cd = CountDown(Duration(seconds: 20));
  cd.stream.forEach((element) {
    forgetPasswordProvider.changeTimeResend(element.inSeconds);
  });
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Consumer<ForgetPasswordProvider>(
                        builder: (context, forgetPasswordProvider, _) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  onPressed: () async {
                                    progressDialog(context);
                                    await UserApi()
                                        .sendEmailForgetPassword(context);
                                  }),
                              hintText: AppLocalizations.of(context)
                                  .translate('Enter your email')),
                          validator: (value) {
                            if (value == null) {
                              return AppLocalizations.of(context)
                                  .translate("Email is empty");
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            forgetPasswordProvider.changeEmailValue(value);
                          },
                        ),
                      );
                    }),
                    Consumer<ForgetPasswordProvider>(
                        builder: (context, forgetPasswordProvider, _) {
                      return forgetPasswordProvider.getResetToken != null
                          ? Container(
                              padding: EdgeInsets.all(16),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('Enter OTP')),
                                validator: (value) {
                                  if (value == null) {
                                    return AppLocalizations.of(context)
                                        .translate("OTP is empty");
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  forgetPasswordProvider
                                      .changeOtpValue(value.toString());
                                },
                              ))
                          : Container();
                    }),
                    Consumer<ForgetPasswordProvider>(
                        builder: (context, forgetPasswordProvider, _) {
                      return forgetPasswordProvider.getResetToken != null
                          ? Container(
                              padding:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Theme.of(context).iconTheme.color,
                                  ),
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("Submit"),
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      progressDialog(context);
                                      await UserApi()
                                          .sendOTPForgetPassword(context);
                                    }
                                  }),
                            )
                          : Container();
                    }),
                    SizedBox(
                      height: 10,
                    )
                  ]),
            ));
      });
}
