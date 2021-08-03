import 'package:flutter/cupertino.dart';
import 'package:mailto/mailto.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_localizations.dart';

launchCaller(BuildContext context, String phone) async {
  if (await canLaunch(phone)) {
    await launch(phone);
  } else {
    throw AppLocalizations.of(context).translate('could not launch') + '$phone';
  }
}

launchLocation(
  BuildContext context,
  double latitude,
  double longitude,
  String title,
  String description,
) async {
  if (await MapLauncher.isMapAvailable(MapType.google)) {
    await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(latitude, longitude),
        title: title,
        description: description);
  } else {
    throw AppLocalizations.of(context).translate("could not launch location");
  }
}

void funcOpenMailComposer(BuildContext context, String email) async {
  final mailtoLink = Mailto(
    to: ['$email'],
    subject: '',
    body: '',
  );
  if (await canLaunch('$mailtoLink')) {
    await launch('$mailtoLink');
  } else {
    throw AppLocalizations.of(context).translate('could not launch') + '$email';
  }
}
