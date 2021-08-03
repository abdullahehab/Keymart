import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/search_model.dart';
import 'package:kaymarts/services/search_api.dart';
import 'package:kaymarts/ui/offers/details_offer_screen.dart';
import 'package:kaymarts/ui/products/single_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';

import '../../app_localizations.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen(
      {this.marketId, this.cateqoryId, this.categoryName});
  final String marketId;
  final String cateqoryId;
  final String categoryName;

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  Future<List<SearchModel>> futureSearchProduct;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "Search"),
        bottomNavigationBar: bottomAnimation(context),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(
                                Icons.search,
                                color: Colors.black54,
                              ),
                              onTap: () {},
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)
                                      .translate("Enter text here...")),
                              onChanged: (value) async {
                                if (value.isNotEmpty && value.length >= 3) {
                                  setState(() {
                                    futureSearchProduct = getProductsSearch(
                                        context,
                                        widget.marketId,
                                        widget.cateqoryId,
                                        value);
                                  });
                                }
                              },
                            )),
                            GestureDetector(
                              child: Icon(
                                Icons.close,
                                color: Colors.black54,
                              ),
                              onTap: () {
                                _controller.clear();
                              },
                            ),
                          ])))),
          FutureBuilder<List<SearchModel>>(
            future: futureSearchProduct,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                    height: 500,
                    child: Center(
                        child: Text(AppLocalizations.of(context)
                            .translate("There are no products available"))));
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: loadingPage(context));
                default:
                  if (snapshot.data != null) {
                    List<SearchModel> searchModel = snapshot.data;
                    return ListView.builder(
                        itemCount: searchModel.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return InkWell(
                              child: Card(
                                elevation: 2,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/categories.png',
                                        image: searchModel[index].photo,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      searchModel[index].name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: AppFontFamily.elMessiri,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text(
                                      searchModel[index].offer == 0
                                          ? searchModel[index].mainPrice +
                                              " " +
                                              AppLocalizations.of(context)
                                                  .translate("EGP")
                                          : searchModel[index].salePrice +
                                              " " +
                                              AppLocalizations.of(context)
                                                  .translate("EGP"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              onTap: () {
                                if (searchModel[index].offer == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SingleProductScreen(
                                                id: searchModel[index]
                                                    .id
                                                    .toString(),
                                                marketId: searchModel[index]
                                                    .marketId
                                                    .toString(),
                                                marketName: searchModel[index]
                                                    .marketName,
                                                categoryName:
                                                    widget.categoryName,
                                                name: searchModel[index].name,
                                                photo: searchModel[index].photo,
                                                price: searchModel[index]
                                                    .mainPrice,
                                                deliveryPrice:
                                                    searchModel[index]
                                                        .marketDeliveryPrice,
                                                description:
                                                    searchModel[index].name,
                                                typeQuantity: searchModel[index]
                                                    .typeQuantity,
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DetailsOfferScreen(
                                                id: searchModel[index]
                                                    .id
                                                    .toString(),
                                                marketId: searchModel[index]
                                                    .marketId
                                                    .toString(),
                                                marketName: searchModel[index]
                                                    .marketName,
                                                name: searchModel[index].name,
                                                photo: searchModel[index].photo,
                                                mainPrice: searchModel[index]
                                                    .mainPrice,
                                                salePrice: searchModel[index]
                                                    .salePrice,
                                                endDate:
                                                    searchModel[index].endDate,
                                                deliveryPrice:
                                                    searchModel[index]
                                                        .marketDeliveryPrice,
                                                description:
                                                    searchModel[index].name,
                                              )));
                                }
                              });
                        });
                  } else {
                    return Container(
                        height: 500,
                        child: Center(
                            child: Text(AppLocalizations.of(context).translate(
                                "There are no products available"))));
                  }
              }
            },
          ),
        ])));
  }
}
