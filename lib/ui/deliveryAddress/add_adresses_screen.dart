import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/models/delivery_address_model.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/services/data_app_api.dart';
import 'package:kaymarts/services/delivery_addresses_api.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: mapKey);
GlobalKey<ScaffoldState> _globalKey = GlobalKey();

class AddAdressesScreen extends StatefulWidget {
  AddAdressesScreen({this.root});
  final String root;

  @override
  _AddAdressesScreenState createState() => _AddAdressesScreenState();
}

class _AddAdressesScreenState extends State<AddAdressesScreen> {
  String fullName,
      address,
      streetName,
      statusLocation,
      phone,
      anotherPhone,
      buildingName,
      roundNumber,
      buildingNumber,
      famousPlace,
      location;
  Mode _mode = Mode.overlay;
  double latitude = 0.0;
  double longitude = 0.0;

  TextEditingController fullNameController;
  TextEditingController phoneController;
  TextEditingController anotherPhoneController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController buildingNameController = TextEditingController();
  TextEditingController roundNumberController = TextEditingController();
  TextEditingController buildingNumberController = TextEditingController();
  TextEditingController famousPlaceController = TextEditingController();

  @override
  void initState() {
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    Future.delayed(Duration(seconds: 0), () async {
      await getLocationUser();
    });

    super.initState();
  }

  Future<void> getLocationUser() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Coordinates coordinates =
        new Coordinates(position.latitude, position.longitude);
    Geocoder.local.findAddressesFromCoordinates(coordinates).then((value) {
      var first = value.first;
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        location = "${first.featureName} : ${first.addressLine}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
        key: _globalKey,
        bottomNavigationBar: bottomAnimation(context),
        appBar: appBar(context, "Add delivery address"),
        body: Form(
            key: _formKey,
            child: CardSettings(children: <CardSettingsSection>[
              CardSettingsSection(
                  header: CardSettingsHeader(
                    labelAlign: languageProvider.appLocale == Locale('en')
                        ? TextAlign.left
                        : TextAlign.right,
                    label: AppLocalizations.of(context)
                        .translate('Details address'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsText(
                      enabled: false,
                      initialValue: authProvider.userModel.displayName,
                      label:
                          AppLocalizations.of(context).translate('Full name'),
                      onSaved: (value) => fullName = value,
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.phone,
                      enabled: false,
                      initialValue: authProvider.userModel.phoneNumber,
                      label: AppLocalizations.of(context).translate('Phone'),
                      onSaved: (value) => phone = value,
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.phone,
                      label: AppLocalizations.of(context)
                          .translate('Another phone'),
                      maxLength: 11,
                      controller: anotherPhoneController,
                      onSaved: (value) => anotherPhone = value,
                    ),
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    labelAlign: languageProvider.appLocale == Locale('en')
                        ? TextAlign.left
                        : TextAlign.right,
                    label: AppLocalizations.of(context)
                        .translate('Detect location'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsText(
                      enabled: false,
                      numberOfLines: 3,
                      label: AppLocalizations.of(context).translate('Location'),
                      initialValue: location,
                      contentOnNewLine: true,
                    ),
                    CardSettingsButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context)
                            .translate("Detect another location"),
                        onPressed: () async {
                          await _handlePressButton();
                        }),
                    CardSettingsText(
                      keyboardType: TextInputType.text,
                      controller: streetNameController,
                      label:
                          AppLocalizations.of(context).translate('Street name'),
                      maxLength: 100,
                      contentOnNewLine: true,
                      onSaved: (value) => streetName = value,
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.text,
                      controller: buildingNameController,
                      label: AppLocalizations.of(context)
                          .translate('Building name'),
                      maxLength: 100,
                      onSaved: (value) => buildingName = value,
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.number,
                      controller: buildingNumberController,
                      label: AppLocalizations.of(context)
                          .translate('Building number'),
                      onSaved: (value) => buildingNumber = value,
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.number,
                      controller: roundNumberController,
                      label: AppLocalizations.of(context)
                          .translate('Round number'),
                      onSaved: (value) => roundNumber = value,
                    ),
                    CardSettingsParagraph(
                      keyboardType: TextInputType.text,
                      controller: famousPlaceController,
                      label: AppLocalizations.of(context)
                          .translate('Famous place'),
                      maxLength: 500,
                      contentOnNewLine: true,
                      onSaved: (value) => famousPlace = value,
                    ),
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    labelAlign: languageProvider.appLocale == Locale('en')
                        ? TextAlign.left
                        : TextAlign.right,
                    label: AppLocalizations.of(context).translate('Actions'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context)
                            .translate("Add Address"),
                        onPressed: () async {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            progressDialog(context);
                            AddressDeliveryModel deliveryAddressModel =
                                AddressDeliveryModel(
                                    phone: anotherPhoneController.text.isEmpty
                                        ? authProvider.userModel.phoneNumber
                                        : anotherPhoneController.text,
                                    address: location,
                                    street: streetNameController.text,
                                    buildingName: buildingNameController.text,
                                    buildingNumber: roundNumberController.text,
                                    roundNumber: buildingNumberController.text,
                                    famousPlace: famousPlaceController.text);
                            await AddressDeliveryApi().createAddressDelivery(
                                context, deliveryAddressModel, widget.root);
                            anotherPhoneController.clear();
                            streetNameController.clear();
                            buildingNameController.clear();
                            roundNumberController.clear();
                            buildingNumberController.clear();
                            famousPlaceController.clear();
                            setState(() {
                              location = "";
                            });
                          }
                        }),
                    CardSettingsButton(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context).translate("Reset"),
                        onPressed: () {
                          _formKey.currentState.reset();
                          anotherPhoneController.clear();
                          streetNameController.clear();
                          buildingNameController.clear();
                          roundNumberController.clear();
                          buildingNumberController.clear();
                          famousPlaceController.clear();
                          setState(() {
                            location = "";
                          });
                        }),
                  ])
            ])));
  }

  Future<void> _handlePressButton() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: mapKey,
      onError: onError,
      mode: _mode,
      language: "ar",
      components: [Component(Component.country, "eg")],
    );

    displayPrediction(p, _globalKey.currentState);
    setState(() {
      location = p.description == null ? "" : p.description;
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    // ignore: deprecated_member_use
    _globalKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      setState(() {
        latitude = lat;
        longitude = lng;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.teal,
            content: Text(
              "${p.description == null ? "" : p.description} - $lat/$lng",
              style: TextStyle(color: Colors.white),
            )),
      );
    }
  }
}
