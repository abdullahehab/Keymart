import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/product_cart_model.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/cart.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class DetailsOfferScreen extends StatefulWidget {
  DetailsOfferScreen(
      {this.id,
      this.marketId,
      this.marketName,
      this.name,
      this.photo,
      this.mainPrice,
      this.salePrice,
      this.endDate,
      this.deliveryPrice,
      this.description,
      this.categoryName,
      this.typeQuantity});
  final String id;
  final String marketId;
  final String marketName;
  final String name;
  final String photo;
  final String mainPrice;
  final String salePrice;
  final String endDate;
  final String deliveryPrice;
  final String description;
  final String categoryName;
  final String typeQuantity;

  @override
  _DetailsOfferScreenState createState() => _DetailsOfferScreenState();
}

class _DetailsOfferScreenState extends State<DetailsOfferScreen> {
  final LocalStorage storageProducts = LocalStorage('products');
  final LocalStorage storageFavorite = LocalStorage('favorite');
  final ProductCartList list = ProductCartList();
  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.changeQuantityValue(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "Details"),
        bottomNavigationBar: bottomAnimation(context),
        bottomSheet:
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
          return !productProvider.getProductId.contains(widget.id.toString())
              ? SizedBox()
              : Consumer<CartProvider>(builder: (context, cartProvider, _) {
                  return cartWidget(
                    context,
                    widget.marketId,
                    double.parse(widget.deliveryPrice),
                    cartProvider.getTotalPriceMarket.toString(),
                    cartProvider.getQuantityMarket,
                  );
                });
        }),
        persistentFooterButtons: [
          Consumer<ProductProvider>(builder: (context, productProvider, _) {
            return !productProvider.getProductId.contains(widget.id.toString())
                ? addToCart()
                : SizedBox();
          }),
          SizedBox(
            height: 15,
          )
        ],
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/shopping.png',
                image: widget.photo,
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(
              widget.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("Delivery price"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              color: Colors.grey,
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  widget.deliveryPrice +
                      " " +
                      AppLocalizations.of(context).translate("EGP"),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("Main price"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              widget.mainPrice +
                  " " +
                  AppLocalizations.of(context).translate("EGP"),
              style: TextStyle(
                decorationStyle: TextDecorationStyle.double,
                decoration: TextDecoration.lineThrough,
                textBaseline: TextBaseline.ideographic,
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("Discount price"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              color: Colors.grey,
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  widget.salePrice +
                      " " +
                      AppLocalizations.of(context).translate("EGP"),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
              return !productProvider.getProductId
                      .contains(widget.id.toString())
                  ? ListTile(
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
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  onPressed: () {
                                    int quantity = productProvider.getQuantity;
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
                                    int quantity = productProvider.getQuantity;
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
                                  (double.parse(widget.salePrice) *
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
                    )
                  : SizedBox();
            }),
          ),
          Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("Offer from"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              widget.marketName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("Finished At"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              widget.endDate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]));
  }

  Widget addToCart() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
          ),
          child: Text(
            AppLocalizations.of(context).translate("Add To Cart"),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          onPressed: () async {
            final productProvider =
                Provider.of<ProductProvider>(context, listen: false);
            final cartProvider =
                Provider.of<CartProvider>(context, listen: false);
            list.items.clear();
            ProductCartModel productModel = ProductCartModel(
              productId: widget.id.toString(),
              imageName: widget.photo,
              name: widget.name,
              price: widget.salePrice,
              deliveryPrice: widget.deliveryPrice,
              quantity: productProvider.getQuantity.toString(),
              description: widget.name,
              marketId: widget.marketId.toString(),
              marketName: widget.marketName,
              categoryName: widget.categoryName,
              typeQuantity: "number",
            );
            list.items.add(productModel);
            await storageProducts.setItem(
              widget.id.toString(),
              list.toJSONEncodable(),
            );
            saveProductIdsPrefs(widget.id.toString());
            SharedPreferenceHelper().getCountCartPref().then((value) {
              cartProvider
                  .changeCountValue(value + productProvider.getQuantity);
              SharedPreferenceHelper()
                  .setCountCartPref(value + productProvider.getQuantity);
            });
            SharedPreferenceHelper().getTotalPricePref().then((value) {
              double totalPrice = value +
                  (double.parse(widget.salePrice) *
                      productProvider.getQuantity);
              double getTotalPrice = (double.parse(widget.salePrice) *
                      productProvider.getQuantity) +
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
              SharedPreferenceHelper().setQuantityMarketMarketPref(
                  widget.marketId, getQuantityMarket);
              cartProvider.changetQuantityMarket(getQuantityMarket);
            });
            productProvider.changeProductIdsValue(widget.id.toString());
          }),
    );
  }

  void saveProductIdsPrefs(String productId) {
    SharedPreferenceHelper().getProductIdsPrefs().then((value) {
      value.add(productId);
      SharedPreferenceHelper().setProductIdsPrefs(value);
    });
  }
}
