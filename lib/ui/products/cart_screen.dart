import 'dart:async';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/product_cart_model.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/providers/product_provider.dart';
import 'package:kaymarts/ui/checkout/checkout_orders_screen.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/ui/products/single_product_screen.dart';
import 'package:kaymarts/widgets/alert_login.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/otp_dialog.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  CartScreen(this.marketId, this.deliveryPrice);
  final String marketId;
  final double deliveryPrice;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final LocalStorage storage = LocalStorage('products');
  final LocalStorage storageFavorite = LocalStorage('favorite');
  final ProductCartList list = ProductCartList();
  StreamController listProducts = StreamController<List<ProductCartModel>>();
  List<ProductCartModel> dataList = [];
  List<ProductCartModel> dataListOrders = [];
  List marketIds = [];
  double totalPriceMarket = 0.0;
  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper()
        .getTotalPriceMarketPref(widget.marketId)
        .then((value) {
      setState(() {
        totalPriceMarket = value;
      });
    });
    getProductsCart();
  }

  @override
  void dispose() {
    super.dispose();
    listProducts.close();
  }

  void getProductsCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    SharedPreferenceHelper().getProductIdsPrefs().then((value) {
      cartProvider.changeDeliveryPriceValue(0.0);
      for (var element in value) {
        storage.ready.then((data) {
          var items = storage.getItem(element);
          if (widget.marketId == items[0]['marketId']) {
            dataList.add(
              ProductCartModel(
                  productId: items[0]['productId'],
                  imageName: items[0]['imageName'],
                  name: items[0]['name'],
                  price: items[0]['price'],
                  deliveryPrice: items[0]['deliveryPrice'],
                  quantity: items[0]['quantity'],
                  description: items[0]['description'],
                  marketId: items[0]['marketId'],
                  marketName: items[0]['marketName'],
                  categoryName: items[0]['categoryName'],
                  typeQuantity: items[0]['typeQuantity']),
            );
            dataListOrders.add(ProductCartModel(
                productId: items[0]['productId'],
                imageName: items[0]['imageName'],
                name: items[0]['name'],
                price: items[0]['price'],
                deliveryPrice: items[0]['deliveryPrice'],
                quantity: items[0]['quantity'],
                description: items[0]['description'],
                marketId: items[0]['marketId'],
                marketName: items[0]['marketName'],
                categoryName: items[0]['categoryName'],
                typeQuantity: items[0]['typeQuantity']));
            listProducts.add(dataList);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
        appBar: appBar(context, "Cart", arrow: true),
        bottomNavigationBar: bottomAnimation(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: totalPriceMarket > 0.0
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                    ),
                    child: Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                      return FlutterBadge(
                        hideZeroCount: true,
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: 25,
                          color: Colors.white,
                        ),
                        borderRadius: 20.0,
                        itemCount: cartProvider.getQuantityMarket,
                      );
                    })))
            : SizedBox(),
        body: Container(
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints.expand(),
            child: StreamBuilder<List<ProductCartModel>>(
              stream: listProducts.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).translate(
                          "There are no products available in the cart"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).translate(
                            "There are no products available in the cart"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  List<ProductCartModel> data = snapshot.data;
                  return Column(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (contex, index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SingleProductScreen(
                                                  id: data[index]
                                                      .productId
                                                      .toString(),
                                                  marketId: data[index]
                                                      .marketId
                                                      .toString(),
                                                  marketName:
                                                      data[index].marketName,
                                                  categoryName:
                                                      data[index].categoryName,
                                                  name: data[index].name,
                                                  photo: data[index].imageName,
                                                  price: data[index].price,
                                                  deliveryPrice:
                                                      data[index].deliveryPrice,
                                                  description: data[index].name,
                                                  typeQuantity:
                                                      data[index].typeQuantity,
                                                )));
                                  },
                                  child: Container(
                                      child: Card(
                                          elevation: 2,
                                          child: Container(
                                              child: Column(children: <Widget>[
                                            ListTile(
                                                leading: Image.network(
                                                  data[index].imageName,
                                                  height: 70,
                                                  width: 70,
                                                ),
                                                title: Text(
                                                    data[index].typeQuantity ==
                                                            "number"
                                                        ? data[index].name
                                                        : data[index].name +
                                                            " - " +
                                                            data[index]
                                                                .typeQuantity,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12)),
                                                trailing: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      openAlertBox(
                                                        context,
                                                        index,
                                                        data[index].productId,
                                                        int.parse(data[index]
                                                            .quantity),
                                                        double.parse(
                                                            data[index].price),
                                                      );
                                                    })),
                                            Divider(
                                              thickness: 1.0,
                                              color: Colors.grey,
                                              indent: 16,
                                              endIndent: 16,
                                            ),
                                            ListTile(
                                                title: Container(
                                                    padding: EdgeInsets.all(4),
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        IconButton(
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              size: 30,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              final update = dataList
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .productId ==
                                                                      data[index]
                                                                          .productId);

                                                              update.quantity =
                                                                  (int.parse(data[index]
                                                                              .quantity) +
                                                                          1)
                                                                      .toString();
                                                              SharedPreferenceHelper()
                                                                  .getQuantityMarketMarketPref(
                                                                      widget
                                                                          .marketId)
                                                                  .then(
                                                                      (value) {
                                                                int getQuantityMarket =
                                                                    cartProvider
                                                                            .getQuantityMarket +
                                                                        1;
                                                                SharedPreferenceHelper()
                                                                    .setQuantityMarketMarketPref(
                                                                        widget
                                                                            .marketId,
                                                                        getQuantityMarket);
                                                                cartProvider
                                                                    .changetQuantityMarket(
                                                                        getQuantityMarket);
                                                              });

                                                              SharedPreferenceHelper()
                                                                  .getCountCartPref()
                                                                  .then(
                                                                      (value) {
                                                                cartProvider
                                                                    .changeCountValue(
                                                                        value +
                                                                            1);
                                                                SharedPreferenceHelper()
                                                                    .setCountCartPref(
                                                                        value +
                                                                            1);
                                                              });
                                                              listProducts.add(
                                                                  dataList);
                                                              list.items.add(
                                                                  dataList
                                                                      .elementAt(
                                                                          index));
                                                              setTotalPrice(
                                                                  double.parse(
                                                                      data[index]
                                                                          .price),
                                                                  true);
                                                              await storage.setItem(
                                                                  data[index]
                                                                      .productId,
                                                                  list.toJSONEncodable());
                                                            }),
                                                        Text(
                                                          data[index].quantity,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                        IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              size: 30,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (int.parse(data[
                                                                          index]
                                                                      .quantity) >
                                                                  1) {
                                                                final update = dataList.firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .productId ==
                                                                        data[index]
                                                                            .productId);
                                                                update.quantity =
                                                                    (int.parse(data[index].quantity) -
                                                                            1)
                                                                        .toString();
                                                                SharedPreferenceHelper()
                                                                    .getQuantityMarketMarketPref(
                                                                        widget
                                                                            .marketId)
                                                                    .then(
                                                                        (value) {
                                                                  int getQuantityMarket =
                                                                      cartProvider
                                                                              .getQuantityMarket -
                                                                          1;
                                                                  SharedPreferenceHelper()
                                                                      .setQuantityMarketMarketPref(
                                                                          widget
                                                                              .marketId,
                                                                          getQuantityMarket);
                                                                  cartProvider
                                                                      .changetQuantityMarket(
                                                                          getQuantityMarket);
                                                                });

                                                                SharedPreferenceHelper()
                                                                    .getCountCartPref()
                                                                    .then(
                                                                        (value) {
                                                                  cartProvider
                                                                      .changeCountValue(
                                                                          value -
                                                                              1);
                                                                  SharedPreferenceHelper()
                                                                      .setCountCartPref(
                                                                          value -
                                                                              1);
                                                                  productProvider
                                                                      .changeQuantityValue(
                                                                          int.parse(
                                                                              update.quantity));
                                                                });

                                                                listProducts.add(
                                                                    dataList);
                                                                list.items.add(
                                                                    dataList.elementAt(
                                                                        index));
                                                                await storage.setItem(
                                                                    data[index]
                                                                        .productId,
                                                                    list.toJSONEncodable());
                                                                setTotalPrice(
                                                                    double.parse(
                                                                        data[index]
                                                                            .price),
                                                                    false);
                                                              }
                                                            }),
                                                      ],
                                                    )),
                                                trailing: Container(
                                                    color: Colors.grey,
                                                    height: 55,
                                                    width: 150,
                                                    child: Center(
                                                        child: Text(
                                                            (double.parse(data[index]
                                                                            .price) *
                                                                        (int.parse(data[index]
                                                                            .quantity)))
                                                                    .toString() +
                                                                " " +
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        "EGP"),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            )))))
                                          ])))));
                            })),
                    GridView.count(
                        childAspectRatio: 3,
                        crossAxisSpacing: 3,
                        shrinkWrap: true,
                        crossAxisCount:
                            MediaQuery.of(context).size.width <= 400.0
                                ? 2
                                : MediaQuery.of(context).size.width >= 1000.0
                                    ? 2
                                    : 2,
                        children: [
                          Container(
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Theme.of(context).iconTheme.color,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("Checkout"),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    final authProvider =
                                        Provider.of<AuthProvider>(context,
                                            listen: false);
                                    if (authProvider.userModel == null) {
                                      alertLogin(context);
                                    } else {
                                      if (authProvider.userModel.status == 0) {
                                        otpCodeDialogBuild(context);
                                      } else {
                                        if (totalPriceMarket > 20.0) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CheckoutOrdersScreen(
                                                        orders: dataListOrders,
                                                        deliveryPrice: widget
                                                            .deliveryPrice,
                                                        totalPriceMarket:
                                                            totalPriceMarket,
                                                        marketId:
                                                            widget.marketId,
                                                      )));
                                        } else {
                                          showToast(
                                              "total price must be grater than 20 EGP",
                                              Colors.red,
                                              context);
                                        }
                                      }
                                    }
                                  })),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Colors.blue[900],
                              ),
                              child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                    Text(
                                        (totalPriceMarket).toString() +
                                            " " +
                                            AppLocalizations.of(context)
                                                .translate("EGP"),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ))
                                  ])),
                              onPressed: () {}),
                        ]),
                    SizedBox(
                      height: 15,
                    )
                  ]);
                }
              },
            )));
  }

  void setTotalPrice(double price, bool status) {
    SharedPreferenceHelper().getTotalPricePref().then((value) {
      if (status) {
        double totalPrice = value + price;
        setState(() {
          totalPriceMarket = totalPriceMarket + price;
        });
        SharedPreferenceHelper()
            .setTotalPriceMarketPref(widget.marketId, totalPriceMarket);
        SharedPreferenceHelper().setTotalPricePref(totalPrice);
      } else {
        double totalPrice = value - price;
        setState(() {
          totalPriceMarket = totalPriceMarket - price;
        });
        SharedPreferenceHelper().setTotalPricePref(totalPrice);
        SharedPreferenceHelper()
            .setTotalPriceMarketPref(widget.marketId, totalPriceMarket);
        SharedPreferenceHelper().setTotalPricePref(totalPrice);
      }
    });
  }

  void deleteItemFromTotalPrice(
      BuildContext context, String productId, double price, int quantity) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    SharedPreferenceHelper().getTotalPricePref().then((value) {
      double totalPrice = value - price;
      setState(() {
        totalPriceMarket = totalPriceMarket - (price * quantity);
      });
      SharedPreferenceHelper().setTotalPricePref(totalPrice);
      SharedPreferenceHelper()
          .setTotalPriceMarketPref(widget.marketId, totalPriceMarket);
      cartProvider.changetTotalPriceMarket(totalPriceMarket);
      SharedPreferenceHelper().setTotalPricePref(totalPrice);
    });
  }

  openAlertBox(BuildContext context, int index, String productId, int quantity,
      double price) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("Delete this Product?"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await storage.deleteItem(productId);
                          dataList.removeAt(index);
                          listProducts.add(dataList);
                          deleteItemFromTotalPrice(
                              context, productId, price, quantity);

                          final productProvider = Provider.of<ProductProvider>(
                              context,
                              listen: false);
                          SharedPreferenceHelper()
                              .getCountCartPref()
                              .then((value) {
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            cartProvider.changeCountValue(value - quantity);
                            SharedPreferenceHelper()
                                .getQuantityMarketMarketPref(widget.marketId)
                                .then((value) {
                              int getQuantityMarket =
                                  cartProvider.getQuantityMarket - quantity;
                              SharedPreferenceHelper()
                                  .setQuantityMarketMarketPref(
                                      widget.marketId, getQuantityMarket);
                              cartProvider
                                  .changetQuantityMarket(getQuantityMarket);
                            });
                            SharedPreferenceHelper()
                                .setCountCartPref(value - quantity);
                          });
                          SharedPreferenceHelper()
                              .getProductIdsPrefs()
                              .then((value) {
                            value.remove(productId);
                            SharedPreferenceHelper().setProductIdsPrefs(value);
                          });
                          productProvider.removeProductIdValue(productId);
                        },
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.743,
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).iconTheme.color,
                                borderRadius:
                                    languageProvider.appLocale == Locale('en')
                                        ? BorderRadius.only(
                                            bottomLeft: Radius.circular(30.0),
                                          )
                                        : BorderRadius.only(
                                            bottomRight: Radius.circular(30.0),
                                          )),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate("Yes"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.743,
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    languageProvider.appLocale == Locale('en')
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(30.0),
                                          )
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(30.0),
                                          )),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate("No"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
