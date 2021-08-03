import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/providers/details_delivery_address_provider.dart';
import 'package:kaymarts/providers/product_provider.dart';
import 'package:kaymarts/ui/home/home.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/delivery_address_model.dart';
import 'package:kaymarts/services/delivery_addresses_api.dart';
import 'package:kaymarts/services/orders_api.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../caches/sharedpref/shared_preference_helper.dart';
import '../../constants/app_font_family.dart';
import '../../models/product_cart_model.dart';
import '../../models/order_model.dart';
import '../../widgets/appbar.dart';
import '../deliveryAddress/add_adresses_screen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final LocalStorage storage = LocalStorage('products');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProductCartModel productModel = ProductCartModel();
  Future<List<AddressDeliveryModel>> futureAddressDeliveryModel;
  List productData = [];

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    futureAddressDeliveryModel =
        AddressDeliveryApi().getAddressDelivery(context);
    SharedPreferenceHelper().getProductIdsPrefs().then((value) {
      for (var element in value) {
        var items = storage.getItem(element);
        if (cartProvider.getMarketId == items[0]['marketId']) {
          productData.add({
            'product_id': items[0]['productId'],
            'price': items[0]['price'],
            'quantity': items[0]['quantity'],
            'total_price': double.parse(items[0]['price']) *
                int.parse(items[0]['quantity']),
          });
        }
      }
    });
    final detailsDeliveryAddressProvider =
        Provider.of<DetailsDeliveryAddressProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailsDeliveryAddressProvider.changeAddressIdValue("");
      detailsDeliveryAddressProvider.changeGroupValue(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailsDeliveryAddressProvider =
        Provider.of<DetailsDeliveryAddressProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: appBar(context, "Delivery address"),
      bottomNavigationBar: bottomAnimation(context),
      key: _scaffoldKey,
      persistentFooterButtons: [
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context).translate("Confirm"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () async {
                  if (detailsDeliveryAddressProvider.getAddressId.isNotEmpty) {
                    progressDialog(context);
                    OrderModel orderModel = OrderModel(
                        orders: productData,
                        addressId: detailsDeliveryAddressProvider.getAddressId,
                        marketId: cartProvider.getMarketId);
                    await createOrder(
                      context,
                      orderModel,
                    );

                    storage.clear();
                    cartProvider.changeCountValue(0);
                    cartProvider.changetQuantityMarket(0);
                    cartProvider.changetTotalPriceMarket(0.0);
                    SharedPreferenceHelper().setCountCartPref(0);
                    SharedPreferenceHelper().setTotalPricePref(0.0);
                    SharedPreferenceHelper()
                        .removeTotalPriceMarketPref(cartProvider.getMarketId);
                    SharedPreferenceHelper().removeQuantityMarketMarketPref(
                        cartProvider.getMarketId);
                    SharedPreferenceHelper().removeProducts();
                    productProvider.clearProductIds();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                    alertCheckout(context);
                  } else {
                    showToast(
                        "Please select delivery address", Colors.red, context);
                  }
                })),
        SizedBox(
          height: 10,
        ),
      ],
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
                          root: 'order',
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
                      return Card(
                          elevation: 2,
                          child: Consumer<DetailsDeliveryAddressProvider>(
                              builder:
                                  (context, detailsDeliveryAddressProvider, _) {
                            return RadioListTile(
                                onChanged: (value) {
                                  detailsDeliveryAddressProvider
                                      .changeGroupValue(value);
                                  detailsDeliveryAddressProvider
                                      .changeAddressIdValue(
                                          addressDeliveryModel[index]
                                              .id
                                              .toString());
                                },
                                value: index + 1,
                                groupValue: detailsDeliveryAddressProvider
                                    .getGroupValue,
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
                                ));
                          }));
                    });
            }
          }),
    );
  }
}
