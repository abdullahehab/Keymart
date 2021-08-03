import 'package:flutter/material.dart';
import 'package:kaymarts/models/delivery_address_model.dart';
import 'package:kaymarts/services/delivery_addresses_api.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import '../../widgets/appbar.dart';
import '../../app_localizations.dart';
import 'add_adresses_screen.dart';
import '../../constants/app_font_family.dart';
import 'details_address_screen.dart';

class DeliveryAddressProfileScreen extends StatefulWidget {
  @override
  _DeliveryAddressProfileScreenState createState() =>
      _DeliveryAddressProfileScreenState();
}

class _DeliveryAddressProfileScreenState
    extends State<DeliveryAddressProfileScreen> {
  Future<List<AddressDeliveryModel>> futureAddressDeliveryModel;
  @override
  void initState() {
    super.initState();
    futureAddressDeliveryModel =
        AddressDeliveryApi().getAddressDelivery(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Delivery addresses"),
      bottomNavigationBar: bottomAnimation(context),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).iconTheme.color,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddAdressesScreen(
                          root: 'profile',
                        )));
          }),
      body: FutureBuilder<List<AddressDeliveryModel>>(
          future: futureAddressDeliveryModel,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: loadingPage(context));
              default:
                List<AddressDeliveryModel> addressDeliveryModel = snapshot.data;
                if (addressDeliveryModel == null) {
                  return Center(
                    child: Text(AppLocalizations.of(context)
                        .translate("Not available addresses")),
                  );
                }
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: addressDeliveryModel.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailsAddressProfileScreen(
                                      addressDeliveryModel:
                                          addressDeliveryModel[index])));
                        },
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                              title: Text(
                                addressDeliveryModel[index].address,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFontFamily.elMessiri,
                                    fontSize: 13),
                              ),
                              subtitle: Text(
                                addressDeliveryModel[index].phone,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              )),
                        ),
                      );
                    });
            }
          }),
    );
  }
}
