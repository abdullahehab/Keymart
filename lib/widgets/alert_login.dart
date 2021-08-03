import 'package:kaymarts/ui/auth/login_screen.dart';
import 'package:kaymarts/ui/auth/registeration_screen.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../app_localizations.dart';

alertLogin(context) {
  Alert(
      type: AlertType.warning,
      context: context,
      title: AppLocalizations.of(context).translate("You must login"),
      style: AlertStyle(titleStyle: TextStyle(fontWeight: FontWeight.bold)),
      buttons: [
        DialogButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => RegisterationScreen()));
          },
          child: Text(
            AppLocalizations.of(context).translate("Register"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DialogButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: Text(
            AppLocalizations.of(context).translate("Login"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ]).show();
}
