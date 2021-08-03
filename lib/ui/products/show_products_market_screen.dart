import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/offer_model.dart';
import 'package:kaymarts/providers/favorite_provider.dart';
import 'package:kaymarts/providers/product_provider.dart';
import 'package:kaymarts/services/offers_api.dart';
import 'package:kaymarts/ui/offers/details_offer_screen.dart';
import 'package:kaymarts/ui/products/single_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/product_cart_model.dart';
import 'package:kaymarts/models/product_model.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/services/products_api.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/cart.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProductsMarketScreen extends StatefulWidget {
  ShowProductsMarketScreen(this.title, this.marketId, this.categoryId,
      this.categoryName, this.deliveryPrice);
  final String title;
  final String marketId;
  final String categoryId;
  final String categoryName;
  final double deliveryPrice;

  @override
  _ShowProductsMarketScreenState createState() =>
      _ShowProductsMarketScreenState();
}

class _ShowProductsMarketScreenState extends State<ShowProductsMarketScreen> {
  final LocalStorage storageProducts = LocalStorage('products');
  final LocalStorage storageFavorite = LocalStorage('favorite');
  final ProductCartList list = ProductCartList();
  Future<List<ProductModel>> futureProduct;
  Future<List<OfferModel>> futureOffers;
  int page = 1;
  bool search = false;
  double totalPriceMarket = 0.0;

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.changeCountValue(1);
    });
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    getProductIds();
    futureProduct =
        getProducts(context, widget.marketId, widget.categoryId, page);
    futureOffers = getOffers(context, widget.marketId, widget.categoryId);
    SharedPreferenceHelper().getFavoriteIdsPrefs().then((value) {
      print(value);
      favoriteProvider.clearFavoriteIds();
      value.forEach((element) {
        print(element);
        favoriteProvider.changeFavoriteIdsValue(element);
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
        appBar: appBar(context, widget.title,
            searchProduct: true,
            marketId: widget.marketId,
            map: false,
            categoryId: widget.categoryId,
            categoryName: widget.categoryName),
        bottomNavigationBar: bottomAnimation(context),
        bottomSheet:
            Consumer<CartProvider>(builder: (context, cartProvider, _) {
          return cartProvider.getTotalPriceMarket > 0.0
              ? cartWidget(
                  context,
                  widget.marketId,
                  widget.deliveryPrice,
                  cartProvider.getTotalPriceMarket.toString(),
                  cartProvider.getQuantityMarket,
                )
              : SizedBox();
        }),
        floatingActionButton:
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
          return productProvider.getCount != page
              ? FloatingActionButton(
                  backgroundColor: Colors.blue[900],
                  onPressed: () {
                    setState(() {
                      page++;
                      futureProduct = getProducts(
                          context, widget.marketId, widget.categoryId, page);
                    });
                  },
                  child: Text(
                    "page" + (page + 1).toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ))
              : SizedBox();
        }),
        body: SingleChildScrollView(
            child: Column(children: [
          FutureBuilder<List<OfferModel>>(
            future: futureOffers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OfferModel> data = snapshot.data;
                return Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: SizedBox(
                        height: 230.0,
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Swiper(
                              autoplay: true,
                              itemCount: data.length,
                              containerHeight: 230.0,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  DetailsOfferScreen(
                                                    id: data[index]
                                                        .id
                                                        .toString(),
                                                    marketId: data[index]
                                                        .marketId
                                                        .toString(),
                                                    marketName:
                                                        data[index].marketName,
                                                    name: data[index].name,
                                                    photo: data[index].photo,
                                                    mainPrice:
                                                        data[index].mainPrice,
                                                    salePrice:
                                                        data[index].salePrice,
                                                    endDate: data[index]
                                                        .endDate
                                                        .toString(),
                                                    deliveryPrice: data[index]
                                                        .marketDeliveryPrice,
                                                    description:
                                                        data[index].name,
                                                    categoryName:
                                                        widget.categoryName,
                                                    typeQuantity: data[index]
                                                        .typeQuantity,
                                                  )));
                                    },
                                    child: Image.network(
                                      data[index].photo,
                                      fit: BoxFit.fill,
                                      width: 200,
                                      height: 200,
                                    ));
                              },
                              pagination: SwiperPagination(),
                              control: SwiperControl(
                                  color: Theme.of(context).iconTheme.color),
                            ))));
              } else if (snapshot.hasError) {}
              return Container();
            },
          ),
          FutureBuilder<List<ProductModel>>(
            future: futureProduct,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ProductModel> productModel = snapshot.data;
                if (productModel.length == 0) {
                  return Container(
                    height: 600,
                    child: Center(
                        child: Text(AppLocalizations.of(context)
                            .translate("There are no products available"))),
                  );
                }
                return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.65,
                    padding: EdgeInsets.all(15),
                    children: List.generate(productModel.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SingleProductScreen(
                                        id: productModel[index].id.toString(),
                                        marketId: productModel[index]
                                            .marketId
                                            .toString(),
                                        marketName:
                                            productModel[index].marketName,
                                        categoryName: widget.categoryName,
                                        name: productModel[index].name,
                                        photo: productModel[index].photo,
                                        price: productModel[index].price,
                                        deliveryPrice: productModel[index]
                                            .marketDeliveryPrice,
                                        description: productModel[index].name,
                                        typeQuantity:
                                            productModel[index].typeQuantity,
                                      )));
                        },
                        child: Container(
                            child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productModel[index].price +
                                          " " +
                                          AppLocalizations.of(context)
                                              .translate("EGP"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey[700]),
                                    ),
                                    Text(
                                      productModel[index].typeQuantity ==
                                              "number"
                                          ? ""
                                          : productModel[index].typeQuantity,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.brown),
                                    ),
                                    Consumer<FavoriteProvider>(builder:
                                        (context, favoriteProvider, _) {
                                      return !favoriteProvider.getFavoriteId
                                              .contains(productModel[index]
                                                  .id
                                                  .toString())
                                          ? InkWell(
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              onTap: () {
                                                addToFavorite(
                                                    widget.marketId,
                                                    productModel[index]
                                                        .marketName,
                                                    productModel[index]
                                                        .id
                                                        .toString(),
                                                    productModel[index].photo,
                                                    productModel[index].name,
                                                    double.parse(
                                                        productModel[index]
                                                            .price),
                                                    double.parse(productModel[
                                                            index]
                                                        .marketDeliveryPrice),
                                                    productModel[index].name,
                                                    productModel[index]
                                                        .typeQuantity);
                                              },
                                            )
                                          : InkWell(
                                              child: Icon(
                                                Icons.favorite,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              onTap: () {
                                                favoriteProvider
                                                    .removeFavoriteIdValue(
                                                        productModel[index]
                                                            .id
                                                            .toString());

                                                deleteToFavorite(
                                                    widget.marketId,
                                                    productModel[index]
                                                        .marketName,
                                                    productModel[index]
                                                        .id
                                                        .toString(),
                                                    productModel[index].photo,
                                                    productModel[index].name,
                                                    double.parse(
                                                        productModel[index]
                                                            .price),
                                                    double.parse(productModel[
                                                            index]
                                                        .marketDeliveryPrice),
                                                    productModel[index].name,
                                                    productModel[index]
                                                        .typeQuantity);
                                              });
                                    })
                                  ],
                                ),
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage.assetNetwork(
                                      width: 150,
                                      height: 150,
                                      placeholder: 'assets/images/shopping.png',
                                      image: productModel[index].photo)),
                              Text(
                                productModel[index].name.length > 20
                                    ? productModel[index]
                                            .name
                                            .substring(1, 20) +
                                        "..."
                                    : productModel[index].name,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFontFamily.elMessiri),
                              ),
                              Consumer<ProductProvider>(
                                  builder: (context, productProvider, _) {
                                return !productProvider.getProductId.contains(
                                        productModel[index].id.toString())
                                    ? addToCart(
                                        widget.marketId,
                                        productModel[index].marketName,
                                        productModel[index].id.toString(),
                                        productModel[index].photo,
                                        productModel[index].name,
                                        double.parse(productModel[index].price),
                                        double.parse(productModel[index]
                                            .marketDeliveryPrice),
                                        productModel[index].name,
                                        productModel[index].typeQuantity)
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.grey,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("Add To Cart"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        onPressed: () async {});
                              })
                            ],
                          ),
                        )),
                      );
                    }));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container(
                  height: 600, child: Center(child: loadingPage(context)));
            },
          ),
          SizedBox(
            height: 40,
          )
        ])));
  }

  void saveProductIdsPrefs(String productId) {
    SharedPreferenceHelper().getProductIdsPrefs().then((value) {
      value.add(productId);
      SharedPreferenceHelper().setProductIdsPrefs(value);
    });
  }

  Widget addToCart(
      String marketId,
      String marketName,
      String productId,
      String image,
      String name,
      double price,
      double deliveryPrice,
      String description,
      String typeQuantity) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
        ),
        child: Text(
          AppLocalizations.of(context).translate("Add To Cart"),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        onPressed: () async {
          final productProvider =
              Provider.of<ProductProvider>(context, listen: false);
          list.items.clear();
          ProductCartModel productModel = ProductCartModel(
            productId: productId,
            imageName: image,
            name: name,
            price: price.toString(),
            deliveryPrice: deliveryPrice.toString(),
            quantity: "1",
            description: description,
            marketId: marketId,
            marketName: marketName,
            categoryName: widget.categoryName,
            typeQuantity: typeQuantity,
          );
          list.items.add(productModel);
          await storageProducts.setItem(
            productId,
            list.toJSONEncodable(),
          );
          saveProductIdsPrefs(productId);
          SharedPreferenceHelper().getCountCartPref().then((value) {
            final cartProvider =
                Provider.of<CartProvider>(context, listen: false);

            cartProvider.changeCountValue(value + 1);
            SharedPreferenceHelper().setCountCartPref(value + 1);
          });
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          SharedPreferenceHelper().getTotalPricePref().then((value) {
            double totalPrice = value + price;
            double getTotalPrice = price + cartProvider.getTotalPriceMarket;
            SharedPreferenceHelper()
                .setTotalPriceMarketPref(widget.marketId, getTotalPrice);
            cartProvider.changetTotalPriceMarket(getTotalPrice);
            setState(() {
              totalPrice = totalPriceMarket + price;
            });
            SharedPreferenceHelper().setTotalPricePref(totalPrice);
          });
          SharedPreferenceHelper()
              .getQuantityMarketMarketPref(widget.marketId)
              .then((value) {
            int getQuantityMarket = cartProvider.getQuantityMarket + 1;
            SharedPreferenceHelper().setQuantityMarketMarketPref(
                widget.marketId, getQuantityMarket);
            cartProvider.changetQuantityMarket(getQuantityMarket);
          });
          SharedPreferenceHelper().setCheckButtonCartPref(productId, true);
          productProvider.changecheckCartValue(true);
          productProvider.changeProductIdsValue(productId);
        });
  }

  addToFavorite(
      String marketId,
      String marketName,
      String productId,
      String image,
      String name,
      double price,
      double deliveryPrice,
      String description,
      String typeQuantity) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    ProductCartModel productModel = ProductCartModel(
      productId: productId,
      imageName: image,
      name: name,
      price: price.toString(),
      deliveryPrice: deliveryPrice.toString(),
      quantity: "1",
      description: description,
      marketId: marketId,
      marketName: marketName,
      categoryName: widget.categoryName,
      typeQuantity: typeQuantity,
    );
    list.items.clear();
    list.items.add(productModel);
    storageFavorite.setItem(
      productId,
      list.toJSONEncodable(),
    );
    favoriteProvider.changeFavoriteIdsValue(productId);
    SharedPreferenceHelper().setFavoriteIdsPrefs(productId);
    SharedPreferenceHelper().getCountFavoritePref().then((value) {
      favoriteProvider.changeCountValue(value + 1);
      SharedPreferenceHelper().setCountFavoritePref(value + 1);
    });
  }

  deleteToFavorite(
      String marketId,
      String marketName,
      String productId,
      String image,
      String name,
      double price,
      double deliveryPrice,
      String description,
      String typeQuantity) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    storageFavorite.deleteItem(productId);
    SharedPreferenceHelper().getCountFavoritePref().then((value) {
      favoriteProvider.changeCountValue(value - 1);
      SharedPreferenceHelper().setCountFavoritePref(value - 1);
      SharedPreferenceHelper().removeFavoriteIdsPrefs(productId);
    });
  }
}
