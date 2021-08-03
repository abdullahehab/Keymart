import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/providers/market_provider.dart';
import 'package:kaymarts/providers/search_provider.dart';
import 'package:kaymarts/services/categories_api.dart';
import 'package:kaymarts/ui/search/search_screen.dart';
import 'package:kaymarts/widgets/location_markets.dart';
import 'package:kaymarts/widgets/sign_in.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../constants/app_font_family.dart';
import '../providers/language_provider.dart';

List categories = [];
final _formKey = GlobalKey<FormState>();

Widget appBar(BuildContext context, String title,
    {bool search,
    bool arrow,
    bool map,
    bool searchProduct,
    String marketId,
    String categoryId,
    String categoryName,
    List marketsData}) {
  final languageProvider =
      Provider.of<LanguageProvider>(context, listen: false);
  return AppBar(
    backgroundColor: search == null ? Colors.white : Colors.blue[900],
    automaticallyImplyLeading: title == "KayMarts" ? false : true,
    centerTitle: map == null || map == false ? false : true,
    iconTheme: IconThemeData(
      color: Theme.of(context).iconTheme.color,
    ),
    title: search == null || search == false
        ? Text(
            AppLocalizations.of(context).translate(title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: search == null ? null : Colors.white,
              fontFamily: languageProvider.appLocale == Locale('en')
                  ? AppFontFamily.jetBrainsMono
                  : AppFontFamily.elMessiri,
              fontSize: map == null || map == false ? 18 : 16,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context).translate(title),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: search == null ? null : Colors.white,
                    fontFamily: languageProvider.appLocale == Locale('en')
                        ? AppFontFamily.jetBrainsMono
                        : AppFontFamily.jetBrainsMono,
                    fontSize: map == null || map == false ? 18 : 16,
                  ),
                ),
                Consumer<MarketProvider>(builder: (context, marketProvider, _) {
                  return Text(marketProvider.getLocation,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Theme.of(context).iconTheme.color,
                          fontFamily: AppFontFamily.elMessiri));
                }),
              ]),
    elevation: 0.0,
    bottom: search == null
        ? PreferredSize(preferredSize: Size.square(0.0), child: Container())
        : search == true
            ? PreferredSize(
                child: Container(
                    padding: EdgeInsets.only(right: 16, left: 16),
                    child: locationField(context)),
                preferredSize: Size.square(60.0),
              )
            : PreferredSize(
                preferredSize: Size.square(0.0), child: Container()),
    actions: map == false
        ? <Widget>[
            searchProduct != null
                ? IconButton(
                    onPressed: () async {
                      if (search == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SearchProductScreen(
                                      marketId: marketId,
                                      cateqoryId: categoryId,
                                      categoryName: categoryName,
                                    )));
                      } else {
                        openAlertBoxSearch(context, marketsData);
                      }
                    },
                    icon: Icon(
                      Icons.search,
                      color: search == null ? null : Colors.white,
                    ))
                : Container(),
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return authProvider.userModel == null
                  ? IconButton(
                      onPressed: () {
                        confirmSignIn(context);
                      },
                      icon: FlutterBadge(
                        hideZeroCount: true,
                        icon: Icon(
                          FontAwesomeIcons.signInAlt,
                          color: search == null ? null : Colors.white,
                        ),
                        borderRadius: 20.0,
                        itemCount: 0,
                      ))
                  : Container();
            })
          ]
        : <Widget>[
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return authProvider.userModel == null
                  ? IconButton(
                      onPressed: () {
                        confirmSignIn(context);
                      },
                      icon: FlutterBadge(
                        hideZeroCount: true,
                        icon: Icon(
                          FontAwesomeIcons.signInAlt,
                          color: search == null ? null : Colors.white,
                        ),
                        borderRadius: 20.0,
                        itemCount: 0,
                      ))
                  : Container();
            })
          ],
  );
}

openAlertBoxSearch(BuildContext context, List marketsData) {
  final searchProvider = Provider.of<SearchProvider>(context, listen: false);
  searchProvider.changeMarketId(null);
  searchProvider.changeCategoryId(null);
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
            content: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Consumer<SearchProvider>(
                        builder: (context, searchProvider, _) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: DropDownFormField(
                          filled: false,
                          titleText:
                              AppLocalizations.of(context).translate('Markets'),
                          hintText: AppLocalizations.of(context)
                              .translate('Please choose one'),
                          value: searchProvider.marketId,
                          validator: (value) {
                            if (value == null) {
                              return AppLocalizations.of(context)
                                  .translate("Market is empty");
                            }
                            return null;
                          },
                          onChanged: (value) {
                            searchProvider.clearCategories();
                            searchProvider.changeMarketId(value.toString());

                            getCategories(context, value)
                                .then((data) => data.forEach((element) {
                                      searchProvider.changeCategories({
                                        'display': element.name,
                                        'value': element.id.toString()
                                      });
                                    }));
                          },
                          dataSource: marketsData,
                          textField: 'display',
                          valueField: 'value',
                        ),
                      );
                    }),
                    Consumer<SearchProvider>(
                        builder: (context, searchProvider, _) {
                      return Container(
                          padding: EdgeInsets.all(16),
                          child: DropDownFormField(
                            filled: false,
                            titleText: AppLocalizations.of(context)
                                .translate('Market categories'),
                            hintText: AppLocalizations.of(context)
                                .translate('Please choose one'),
                            value: searchProvider.categoryId,
                            validator: (value) {
                              if (value == null) {
                                return AppLocalizations.of(context)
                                    .translate("Category is empty");
                              }
                              return null;
                            },
                            onChanged: (value) {
                              searchProvider.changeCategoryId(value.toString());

                              searchProvider.getCategories.map((e) {
                                if (e['value'] == value.toString()) {
                                  searchProvider
                                      .changeCategoryName(e['display']);
                                }
                              }).toList();
                            },
                            dataSource: searchProvider.getCategories,
                            textField: 'display',
                            valueField: 'value',
                          ));
                    }),
                    Consumer<SearchProvider>(
                        builder: (context, searchProvider, _) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Theme.of(context).iconTheme.color,
                            ),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("Search"),
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SearchProductScreen(
                                            marketId: searchProvider.marketId,
                                            cateqoryId:
                                                searchProvider.categoryId,
                                            categoryName:
                                                searchProvider.categoryName)));
                              }
                            }),
                      );
                    })
                  ]),
            ));
      });
}
