import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/reviews_model.dart';
import 'package:kaymarts/services/reviews_api.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:kaymarts/widgets/rate_icons.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:readmore/readmore.dart';
import '../../app_localizations.dart';

class AllReviewsMarketScreen extends StatefulWidget {
  const AllReviewsMarketScreen({this.marketId});
  final String marketId;

  @override
  _AllReviewsMarketScreenState createState() => _AllReviewsMarketScreenState();
}

class _AllReviewsMarketScreenState extends State<AllReviewsMarketScreen> {
  Future<List<ReviewsModel>> futureReviews;
  @override
  void initState() {
    super.initState();
    futureReviews = getReviewsMarket(context, widget.marketId, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, "All reviews"),
        bottomNavigationBar: bottomAnimation(context),
        body: FutureBuilder<List<ReviewsModel>>(
          future: futureReviews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: loadingPage(context));
            if (snapshot.data.length == 0) {
              return Center(
                  child: Text(AppLocalizations.of(context)
                      .translate("There are no reviews available")));
            }
            if (snapshot.hasData) {
              List<ReviewsModel> data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  padding: EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
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
                                    image: data[index].userphoto,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(data[index].username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StarRating(
                                    color: Colors.amber,
                                    rating: double.parse(
                                        data[index].stars.toString()),
                                    position: "left",
                                    size: 15,
                                  ),
                                  Text(data[index].date,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFontFamily.jetBrainsMono,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.brown)),
                                  ReadMoreText(
                                    data[index].comment,
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
                  });
            } else if (snapshot.hasError) {
              return Text(AppLocalizations.of(context)
                  .translate("There are no reviews available"));
            }
            return Center(child: loadingPage(context));
          },
        ));
  }
}
