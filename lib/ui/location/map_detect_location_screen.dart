import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/functions/my_location.dart';
import 'package:kaymarts/providers/market_provider.dart';
import 'package:kaymarts/services/data_app_api.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetectLocationScreen extends StatelessWidget {
  MapDetectLocationScreen({this.arrow});
  final bool arrow;
  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);
    return Scaffold(
        appBar: appBar(
            context, "Select the nearest supermarket to your location",
            search: false, map: true, arrow: arrow),
        body: PlacePicker(
          searchingText: AppLocalizations.of(context).translate('Search...'),
          apiKey: mapKey,
          initialPosition:
              LatLng(marketProvider.getLat, marketProvider.getLong),
          useCurrentLocation: true,
          selectInitialPosition: true,
          forceSearchOnZoomChanged: true,
          automaticallyImplyAppBarLeading: false,
          autocompleteLanguage: "ar",
          hintText:
              AppLocalizations.of(context).translate("Detect location..."),
          region: 'eg',
          onPlacePicked: (result) {
            SharedPreferenceHelper().setShowMap(1);
            detectLocation(context, result.geometry.location.lat,
                result.geometry.location.lng);
          },
        ));
  }
}
