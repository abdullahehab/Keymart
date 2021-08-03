import 'dart:async';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/product_cart_model.dart';
import 'package:kaymarts/providers/favorite_provider.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/ui/products/single_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final LocalStorage storageFavorite = LocalStorage('favorite');
  final ProductCartList list = ProductCartList();
  StreamController listProducts = StreamController<List<ProductCartModel>>();
  List<ProductCartModel> dataList = [];
  @override
  void initState() {
    super.initState();
    getProductsCart();
  }

  @override
  void dispose() {
    super.dispose();
    listProducts.close();
  }

  void getProductsCart() {
    SharedPreferenceHelper().getFavoriteIdsPrefs().then((value) {
      for (var element in value) {
        storageFavorite.ready.then((data) {
          var items = storageFavorite.getItem(element);
          print(items);
          dataList.add(ProductCartModel(
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "Favorite", arrow: true),
        bottomNavigationBar: bottomAnimation(context),
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
                          "There are no products available in the favorite"),
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
                          "There are no products available in the favorite"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ));
                  }
                  List<ProductCartModel> data = snapshot.data;
                  return Column(
                    children: <Widget>[
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
                                                    width: 50,
                                                    height: 50),
                                                title: Text(data[index].name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            AppFontFamily
                                                                .elMessiri,
                                                        fontSize: 12)),
                                                trailing: IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      openAlertBox(
                                                          context,
                                                          index,
                                                          data[index].productId,
                                                          int.parse(data[index]
                                                              .quantity),
                                                          double.parse(
                                                              data[index]
                                                                  .price));
                                                    })),
                                          ]),
                                        )),
                                  ),
                                );
                              })),
                    ],
                  );
                }
              },
            )));
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
                          await storageFavorite.deleteItem(productId);
                          dataList.removeAt(index);
                          listProducts.add(dataList);
                          SharedPreferenceHelper()
                              .getCountFavoritePref()
                              .then((value) {
                            final favoriteProvider =
                                Provider.of<FavoriteProvider>(context,
                                    listen: false);
                            favoriteProvider.changeCountValue(value - 1);
                            favoriteProvider.removeFavoriteIdValue(productId);
                            SharedPreferenceHelper()
                                .setCountFavoritePref(value - 1);
                            SharedPreferenceHelper()
                                .removeFavoriteIdsPrefs(productId);
                          });
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
