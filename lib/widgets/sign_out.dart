import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/ui/home/home.dart';

confirmSignOut(BuildContext context) {
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
                .translate("This will logout. Are you sure?"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                progressDialog(context);
                await UserApi().exitUser(context);
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
            ),
          ],
        );
      });
}
