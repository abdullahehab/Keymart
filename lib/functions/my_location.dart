import 'package:flutter/material.dart';
import 'package:kaymarts/providers/market_provider.dart';
import 'package:kaymarts/services/markets_api.dart';
import 'package:kaymarts/ui/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../routes.dart';

Future<void> getLocationUser(BuildContext context, {bool root = false}) async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Coordinates coordinates = Coordinates(position.latitude, position.longitude);
  final marketProvider = Provider.of<MarketProvider>(context, listen: false);
  marketProvider.changeMarket(
      getMarkets(lat: position.latitude, long: position.longitude));
  Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) {
    var first = value.first;
    marketProvider.changeLocation("${first.featureName} : ${first.addressLine}",
        position.latitude, position.longitude);
    if (root) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  });
}

Future<void> detectLocation(
    BuildContext context, double lat, double long) async {
  final marketProvider = Provider.of<MarketProvider>(context, listen: false);
  marketProvider.changeMarket(getMarkets(lat: lat, long: long));
  Coordinates coordinates = Coordinates(lat, long);

  Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) {
    var first = value.first;
    marketProvider.changeLocation(
        "${first.featureName} : ${first.addressLine}", lat, long);
    Navigator.of(context).pushReplacementNamed(Routes.home);
  });
}
