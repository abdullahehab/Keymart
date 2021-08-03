import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

confirmSignIn(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate("Alert"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
              AppLocalizations.of(context)
                  .translate("This will login. Are you sure?"),
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate("Cancel"),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate("Yes"),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            ),
          ],
        );
      });
}
