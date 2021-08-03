import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/product_cart_model.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/providers/favorite_provider.dart';
import 'package:kaymarts/providers/product_provider.dart';
import 'package:kaymarts/ui/products/SingleProduct/clipper.dart';
import 'package:kaymarts/ui/products/SingleProduct/gredients.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/cart.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_localizations.dart';

class SingleProductScreen extends StatefulWidget {
  SingleProductScreen(
      {this.id,
      this.marketId,
      this.marketName,
      this.categoryName,
      this.name,
      this.photo,
      this.price,
      this.deliveryPrice,
      this.description,
      this.typeQuantity});
  final String id;
  final String marketId;
  final String marketName;
  final String categoryName;
  final String name;
  final String photo;
  final String price;
  final String deliveryPrice;
  final String description;
  final String typeQuantity;

  @override
  _SingleProductScreenState createState() => new _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen>
    with TickerProviderStateMixin {
  final LocalStorage storageProducts = LocalStorage('products');
  final LocalStorage storageFavorite = LocalStorage('favorite');
  final ProductCartList list = ProductCartList();

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.changeQuantityValue(1);
    });
    getProductIds();
    SharedPreferenceHelper().getFavoriteIdsPrefs().then((value) {
      favoriteProvider.clearFavoriteIds();
      value.forEach((element) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          favoriteProvider.changeFavoriteIdsValue(element);
          productProvider.changeQuantityValue(1);
        });
      });
    });
    SharedPreferenceHelper()
        .getTotalPriceMarketPref(widget.marketId)
        .then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cartProvider.changetTotalPriceMarket(value);
      });
    });
    SharedPreferenceHelper()
        .getQuantityMarketMarketPref(widget.marketId)
        .then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(value);
        cartProvider.changetQuantityMarket(value);
      });
    });
  }

  Future<void> getProductIds() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    List<String> list = _sharedPreferences.getStringList("productIds") == null
        ? []
        : _sharedPreferences.getStringList("productIds");
    productProvider.clearProductIds();
    list.forEach((element) {
      productProvider.changeProductIdsValue(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "Details"),
        bottomNavigationBar: bottomAnimation(context),
        bottomSheet:
            Consumer<CartProvider>(builder: (context, cartProvider, _) {
          return cartProvider.getTotalPriceMarket > 0.0
              ? cartWidget(
                  context,
                  widget.marketId,
                  double.parse(widget.deliveryPrice),
                  cartProvider.getTotalPriceMarket.toString(),
                  cartProvider.getQuantityMarket,
                )
              : SizedBox();
        }),
        persistentFooterButtons: [
          Consumer<ProductProvider>(builder: (context, productProvider, _) {
            return !productProvider.getProductId.contains(widget.id)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            addToCart();
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            child: Container(
                              color: Theme.of(context).iconTheme.color,
                              height: 60.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 48.0),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("Add To Cart"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.blue[900],
                                  shape: BoxShape.circle,
                                ),
                                child: Consumer<ProductProvider>(
                                    builder: (context, productProvider, _) {
                                  return InkWell(
                                    onTap: () {
                                      addToCart();
                                    },
                                    child: FlutterBadge(
                                      hideZeroCount: true,
                                      icon: Icon(
                                        Icons.add_shopping_cart,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      borderRadius: 20.0,
                                      itemCount: productProvider.getQuantity,
                                    ),
                                  );
                                })))
                      ],
                    ),
                  )
                : SizedBox();
          })
        ],
        body: ListView(
          children: <Widget>[
            Container(
              height: 280.0,
              child: Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: ArcClipper(),
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(gradient: bgGradient),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/images/shopping.png',
                              image: widget.photo,
                              width: 140,
                              height: 140,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    width: 70.0,
                                    height: 30.0,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(widget.categoryName,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text(
                                          widget.typeQuantity == "number"
                                              ? ""
                                              : widget.typeQuantity,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ]),
                                  InkWell(
                                      onTap: () {
                                        addToFavorite();
                                      },
                                      child: Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                            color: Colors.blue[900],
                                            shape: BoxShape.circle),
                                        child: Consumer<FavoriteProvider>(
                                            builder:
                                                (context, favoriteProvider, _) {
                                          return !favoriteProvider.getFavoriteId
                                                  .contains(widget.id)
                                              ? Icon(
                                                  Icons.favorite_border,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                )
                                              : Icon(
                                                  Icons.favorite,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                );
                                        }),
                                      ))
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate("Market name"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.marketName,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                widget.deliveryPrice +
                    " " +
                    AppLocalizations.of(context).translate("EGP Delivery"),
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
              return !productProvider.getProductId.contains(widget.id)
                  ? Column(children: <Widget>[
                      ListTile(
                        title: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      int quantity =
                                          productProvider.getQuantity;
                                      productProvider
                                          .changeQuantityValue(quantity + 1);
                                    }),
                                Consumer<ProductProvider>(
                                    builder: (context, productProvider, _) {
                                  return Text(
                                    productProvider.getQuantity.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  );
                                }),
                                IconButton(
                                    icon: Icon(
                                      Icons.remove_circle,
                                      size: 30,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    onPressed: () {
                                      int quantity =
                                          productProvider.getQuantity;
                                      if (quantity > 1) {
                                        productProvider
                                            .changeQuantityValue(quantity - 1);
                                      }
                                    }),
                              ],
                            )),
                        trailing: Container(
                            color: Colors.grey,
                            height: 55,
                            width: 150,
                            child: Center(
                              child: Consumer<ProductProvider>(
                                  builder: (context, productProvider, _) {
                                return Text(
                                    (double.parse(widget.price) *
                                                productProvider.getQuantity)
                                            .toString() +
                                        " " +
                                        AppLocalizations.of(context)
                                            .translate("EGP"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ));
                              }),
                            )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ])
                  : SizedBox();
            }),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate("Description")),
              subtitle: Text(widget.name,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ));
  }

  void saveProductIdsPrefs(String productId) {
    SharedPreferenceHelper().getProductIdsPrefs().then((value) {
      value.add(productId);
      SharedPreferenceHelper().setProductIdsPrefs(value);
    });
  }

  addToCart() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    list.items.clear();
    ProductCartModel productModel = ProductCartModel(
      productId: widget.id,
      imageName: widget.photo,
      name: widget.name,
      price: widget.price,
      deliveryPrice: widget.deliveryPrice.toString(),
      quantity: productProvider.getQuantity.toString(),
      description: widget.description,
      marketId: widget.marketId,
      marketName: widget.marketName,
      typeQuantity: widget.typeQuantity,
    );
    list.items.add(productModel);
    storageProducts.setItem(
      widget.id,
      list.toJSONEncodable(),
    );
    saveProductIdsPrefs(widget.id);
    SharedPreferenceHelper().getCountCartPref().then((value) {
      cartProvider.changeCountValue(value + productProvider.getQuantity);
      SharedPreferenceHelper()
          .setCountCartPref(value + productProvider.getQuantity);
    });
    SharedPreferenceHelper().getTotalPricePref().then((value) {
      double totalPrice =
          value + (double.parse(widget.price) * productProvider.getQuantity);
      double getTotalPrice =
          (double.parse(widget.price) * productProvider.getQuantity) +
              cartProvider.getTotalPriceMarket;
      SharedPreferenceHelper()
          .setTotalPriceMarketPref(widget.marketId, getTotalPrice);
      cartProvider.changetTotalPriceMarket(getTotalPrice);
      SharedPreferenceHelper().setTotalPricePref(totalPrice);
    });
    SharedPreferenceHelper()
        .getQuantityMarketMarketPref(widget.marketId)
        .then((value) {
      int getQuantityMarket =
          cartProvider.getQuantityMarket + productProvider.getQuantity;
      SharedPreferenceHelper()
          .setQuantityMarketMarketPref(widget.marketId, getQuantityMarket);
      cartProvider.changetQuantityMarket(getQuantityMarket);
    });
    SharedPreferenceHelper().setCheckButtonCartPref(widget.id, true);
    productProvider.changecheckCartValue(true);
    productProvider.changeProductIdsValue(widget.id);
  }

  addToFavorite() {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    if (!favoriteProvider.getFavoriteId.contains(widget.id)) {
      ProductCartModel productModel = ProductCartModel(
        productId: widget.id,
        imageName: widget.photo,
        name: widget.name,
        price: widget.price,
        deliveryPrice: widget.deliveryPrice.toString(),
        quantity: "1",
        description: widget.description,
        marketId: widget.marketId,
        marketName: widget.marketName,
        typeQuantity: widget.typeQuantity,
      );

      list.items.clear();
      list.items.add(productModel);
      storageFavorite.setItem(
        widget.id,
        list.toJSONEncodable(),
      );
      favoriteProvider.changeFavoriteIdsValue(widget.id);

      SharedPreferenceHelper().setFavoriteIdsPrefs(widget.id);
      SharedPreferenceHelper().getCountFavoritePref().then((value) {
        favoriteProvider.changeCountValue(value + 1);
        SharedPreferenceHelper().setCountFavoritePref(value + 1);
      });
    } else {
      favoriteProvider.removeFavoriteIdValue(widget.id);
      storageFavorite.deleteItem(widget.id);
      SharedPreferenceHelper().getCountFavoritePref().then((value) {
        favoriteProvider.changeCountValue(value - 1);
        SharedPreferenceHelper().setCountFavoritePref(value - 1);
        SharedPreferenceHelper().removeFavoriteIdsPrefs(widget.id);
        favoriteProvider.removeFavoriteIdValue(widget.id);
      });
    }
  }
}
