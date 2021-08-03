import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/providers/market_provider.dart';
import 'package:kaymarts/ui/market/market_profile_screen.dart';
import 'package:kaymarts/ui/products/categories_screen.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/market_model.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:kaymarts/widgets/rate_icons.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';

class MarketsScreen extends StatefulWidget {
  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  List marketsData = [];
  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    marketsData.clear();
    return SafeArea(
      child: Scaffold(
          appBar: appBar(context, "KayMarts",
              search: true,
              searchProduct: true,
              map: false,
              arrow: true,
              marketsData: marketsData),
          bottomNavigationBar: bottomAnimation(context),
          body: Stack(children: <Widget>[
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
            ),
            Consumer<MarketProvider>(builder: (context, marketProvider, _) {
              return FutureBuilder<List<MarketModel>>(
                future: marketProvider.getMarket,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MarketModel> marketModel = snapshot.data;
                    if (marketModel.length == 0) {
                      return Center(
                          child: Text(
                        AppLocalizations.of(context).translate(
                            "Sorry, there is no market near you now."),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ));
                    }
                    return ListView.builder(
                        padding: EdgeInsets.all(12.0),
                        itemCount: marketModel.length,
                        itemBuilder: (context, index) {
                          marketsData.add({
                            "display": marketModel[index].name,
                            "value": marketModel[index].id.toString()
                          });
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CategoriesScreen(
                                            marketId: marketModel[index]
                                                .id
                                                .toString(),
                                            deliveryPrice: double.parse(
                                                marketModel[index]
                                                    .priceDelivery),
                                          )));
                            },
                            child: Container(
                                child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25)),
                                        side: BorderSide(
                                            width: 1, color: Colors.white)),
                                    child: Column(children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/market.png',
                                            image: marketModel[index].photo,
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.fill,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Text(
                                                marketModel[index].name,
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFontFamily.elMessiri,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Spacer(),
                                              Text(
                                                marketModel[index]
                                                        .priceDelivery +
                                                    " " +
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            "EGP Delivery"),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.brown,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            Row(children: [
                                              Text(
                                                marketModel[index].location,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                  fontFamily:
                                                      AppFontFamily.elMessiri,
                                                ),
                                              ),
                                              Spacer(),
                                              marketModel[index].timeDelivery !=
                                                      ""
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          marketModel[index]
                                                              .timeDelivery,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          languageProvider
                                                                      .appLocale ==
                                                                  Locale('en')
                                                              ? "=>"
                                                              : "<=",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .directions_bike_rounded,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    )
                                                  : Container()
                                            ]),
                                            Row(children: [
                                              StarRating(
                                                color: Colors.amber,
                                                rating: double.parse(
                                                    marketModel[index]
                                                        .stars
                                                        .toString()),
                                                position: 'left',
                                              ),
                                              Text(
                                                "(" +
                                                    " " +
                                                    marketModel[index]
                                                        .countReviews
                                                        .toString() +
                                                    " " +
                                                    AppLocalizations.of(context)
                                                        .translate("reviews") +
                                                    " " +
                                                    ")",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700]),
                                              )
                                            ]),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              MarketProfileScreen(
                                                                marketData:
                                                                    marketModel[
                                                                        index],
                                                              )));
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate("Profile"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]))),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      AppLocalizations.of(context)
                          .translate("Sorry, there is no market near you now."),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
                  }
                  return Center(child: loadingPage(context));
                },
              );
            }),
          ])),
    );
  }
}
