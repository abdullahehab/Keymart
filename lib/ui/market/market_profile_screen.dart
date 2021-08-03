import 'dart:async';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/market_model.dart';
import 'package:kaymarts/models/reviews_model.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/services/reviews_api.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:kaymarts/ui/market/all_reviews_market_screen.dart';
import 'package:kaymarts/widgets/alert_login.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/otp_dialog.dart';
import 'package:kaymarts/widgets/rate_icons.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:kaymarts/widgets/url_launcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../app_localizations.dart';

class MarketProfileScreen extends StatefulWidget {
  MarketProfileScreen({this.marketData});
  final MarketModel marketData;
  @override
  _MarketProfileScreenState createState() => _MarketProfileScreenState();
}

class _MarketProfileScreenState extends State<MarketProfileScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  StreamController<List<Container>> _streamController =
      StreamController<List<Container>>.broadcast();
  Future<List<ReviewsModel>> futureReviews;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm a");
  TextEditingController _controller = TextEditingController();
  List<Container> list = [];
  var rate = 2.0;

  @override
  void initState() {
    super.initState();
    futureReviews =
        getReviewsMarket(context, widget.marketData.id.toString(), 10)
            .then((value) => value.map((e) {
                  list.add(Container(
                    child: Column(children: [
                      ListTile(
                        leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60 / 2)),
                              border: Border.all(
                                color: Colors.blue[900],
                                width: 4.0,
                              ),
                            ),
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/user.png',
                                image: e.userphoto,
                                fit: BoxFit.cover,
                              ),
                            )),
                        title: Text(e.username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StarRating(
                              color: Colors.amber,
                              rating: double.parse(e.stars.toString()),
                              position: "left",
                              size: 15,
                            ),
                            Text(e.date,
                                style: TextStyle(
                                    fontFamily: AppFontFamily.jetBrainsMono,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.brown)),
                            ReadMoreText(
                              e.comment,
                              trimLines: 2,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              colorClickableText: Colors.orangeAccent,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: AppLocalizations.of(context)
                                  .translate('...Show more'),
                              trimExpandedText: AppLocalizations.of(context)
                                  .translate(' show less'),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        indent: 15,
                        endIndent: 15,
                      )
                    ]),
                  ));
                  _streamController.add(list);
                }).toList());
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        key: _drawerKey,
        appBar: appBar(context, "Profile"),
        bottomNavigationBar: bottomAnimation(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (authProvider.userModel == null) {
              alertLogin(context);
            } else {
              if (authProvider.userModel.status == 0) {
                UserApi().resendOTP(context);
                otpCodeDialogBuild(context);
              } else {
                SharedPreferenceHelper().getReviewMarket().then((value) {
                  if (value.contains(widget.marketData.id.toString())) {
                    showToast("I have added a comment for this market before",
                        Theme.of(context).iconTheme.color, context);
                  } else {
                    openAlertBox(context);
                  }
                });
              }
            }
          },
          child: Icon(
            Icons.rate_review,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).iconTheme.color,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Card(
              child: Column(children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/market.png',
              image: widget.marketData.photo,
              height: 250,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => launchCaller(
                          context, "tel:${widget.marketData.phone}"),
                      icon: Icon(
                        Icons.call,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => launchLocation(
                          context,
                          double.parse(widget.marketData.lat),
                          double.parse(widget.marketData.long),
                          widget.marketData.name,
                          widget.marketData.name),
                      icon: Icon(
                        Icons.my_location,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  widget.marketData.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.elMessiri),
                ),
                subtitle: Text(
                  widget.marketData.location,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.elMessiri,
                      color: Colors.grey[700]),
                )),
            Divider(),
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate("Delivery price"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                color: Theme.of(context).iconTheme.color,
                width: 150,
                height: 50,
                child: Center(
                    child: Text(
                        widget.marketData.priceDelivery +
                            " " +
                            AppLocalizations.of(context).translate("EGP"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate("Delivery time"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                color: Theme.of(context).iconTheme.color,
                width: 150,
                height: 50,
                child: Center(
                    child: Text(widget.marketData.timeDelivery,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
              ),
            ),
            Divider(),
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate("About"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  widget.marketData.about,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.elMessiri,
                      color: Colors.grey[700]),
                )),
            Divider(),
            Container(
                child: Container(
                    child: Column(children: [
              ListTile(
                  trailing: TextButton(
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllReviewsMarketScreen(
                                  marketId: widget.marketData.id.toString()),
                            ));
                      },
                      child: Text(
                        AppLocalizations.of(context).translate("All reviews"),
                        style: TextStyle(color: Colors.white),
                      )),
                  title: Text(
                      AppLocalizations.of(context)
                          .translate("Customer reviews"),
                      style: TextStyle(fontWeight: FontWeight.bold))),
              StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox();
                    }
                    return Container(
                        child: Container(
                            child: Column(children: [
                      SingleChildScrollView(
                          child: Column(children: snapshot.data))
                    ])));
                  })
            ])))
          ]))
        ])));
  }

  openAlertBox(
    BuildContext context,
  ) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate("Rate"),
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SmoothStarRating(
                        rating: rate,
                        isReadOnly: false,
                        color: Colors.amber,
                        borderColor: Colors.amber,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: true,
                        spacing: 2.0,
                        onRated: (value) {
                          print("rating value -> $value");
                          setState(() {
                            rate = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).translate("Comment"),
                        border: InputBorder.none,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_controller.text.isNotEmpty) {
                        Navigator.of(context, rootNavigator: true).pop();

                        list.add(Container(
                          child: Column(children: [
                            ListTile(
                              leading: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/user.png',
                                image: authProvider.userModel.photoUrl,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(authProvider.userModel.displayName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StarRating(
                                    color: Colors.amber,
                                    rating: double.parse(rate.toString()),
                                    position: "left",
                                    size: 15,
                                  ),
                                  Text("${dateFormat.format(DateTime.now())}",
                                      style: TextStyle(
                                          fontFamily:
                                              AppFontFamily.jetBrainsMono,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  ReadMoreText(
                                    _controller.text,
                                    trimLines: 2,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    colorClickableText: Colors.orangeAccent,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText:
                                        AppLocalizations.of(context)
                                            .translate('...Show more'),
                                    trimExpandedText:
                                        AppLocalizations.of(context)
                                            .translate(' show less'),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              indent: 15,
                              endIndent: 15,
                            )
                          ]),
                        ));
                        _streamController.add(list);
                        ReviewsModel reviewsModel = ReviewsModel(
                            stars: rate, comment: _controller.text);
                        createReviewMarket(context,
                            widget.marketData.id.toString(), reviewsModel);
                        _controller.clear();
                        _controller.text = "";
                      } else {
                        showToast("comment is empty", Colors.red, context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).iconTheme.color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate("Rate market"),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
