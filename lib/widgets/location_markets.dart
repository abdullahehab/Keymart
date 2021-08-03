import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/functions/my_location.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/ui/location/map_detect_location_screen.dart';

Widget locationField(BuildContext context) {
  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MapDetectLocationScreen(arrow: true),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xffEFEFEF), borderRadius: BorderRadius.circular(13)),
        child: Row(
          children: <Widget>[
            Icon(Icons.location_on),
            SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context).translate("Detect location..."),
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () async {
                await getLocationUser(context, root: true);
              },
            ),
          ],
        ),
      ));
}
