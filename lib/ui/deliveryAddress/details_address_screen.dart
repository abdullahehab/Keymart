import 'package:kaymarts/models/delivery_address_model.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import '../../widgets/appbar.dart';
import '../../app_localizations.dart';

class DetailsAddressProfileScreen extends StatelessWidget {
  DetailsAddressProfileScreen({this.addressDeliveryModel});
  final AddressDeliveryModel addressDeliveryModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "Details"),
        bottomNavigationBar: bottomAnimation(context),
        body: SingleChildScrollView(
            child: Card(
          child: Column(children: [
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Address"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  addressDeliveryModel.address,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Phone"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  addressDeliveryModel.phone,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Street name"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  addressDeliveryModel.street,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Building name"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  addressDeliveryModel.buildingName,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Building number"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  addressDeliveryModel.buildingNumber.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Round number"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  addressDeliveryModel.roundNumber.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Famous place"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  addressDeliveryModel.famousPlace,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
          ]),
        )));
  }
}
