import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../app_localizations.dart';

void showToast(String msg, Color color, BuildContext context, {bool location}) {
  Toast.show(
    AppLocalizations.of(context).translate(msg),
    context,
    duration: 5,
    gravity: Toast.TOP,
    backgroundColor: color,
    textColor: Colors.white,
  );
}

alertCheckout(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.success,
    title: AppLocalizations.of(context).translate("Success"),
    buttons: [
      DialogButton(
        color: Theme.of(context).iconTheme.color,
        child: Text(
          AppLocalizations.of(context).translate("OK"),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        width: 120,
      )
    ],
  ).show();
}
