import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../app_localizations.dart';

Future<bool> willPopScopem(BuildContext context) async {
  Alert(
    context: context,
    type: AlertType.error,
    style: AlertStyle(titleStyle: TextStyle(fontWeight: FontWeight.bold)),
    title: AppLocalizations.of(context).translate("Do you want to exit?"),
    buttons: [
      DialogButton(
        color: Theme.of(context).iconTheme.color,
        child: Text(
          AppLocalizations.of(context).translate("No"),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      ),
      DialogButton(
        color: Theme.of(context).iconTheme.color,
        child: Text(
          AppLocalizations.of(context).translate("Yes"),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        onPressed: () {
          SystemNavigator.pop();
        },
        width: 120,
      )
    ],
  ).show();
  return true;
}
