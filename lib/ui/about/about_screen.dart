import 'package:flutter/material.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/functions/my_location.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/functions/url_launcher.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/providers/market_provider.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:provider/provider.dart';
import '../../my_app.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);

    return Scaffold(
        appBar: appBar(context, "About us"),
        bottomNavigationBar: bottomAnimation(context),
        bottomSheet: Container(
            color: Colors.blueGrey[50],
            child: ListTile(
                onTap: () {
                  launchURL("https://kayholdingeg.com/");
                },
                leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/company.png"),
                          fit: BoxFit.cover,
                        ))),
                trailing: Text(
                  "v 1.0.3",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    fontFamily: AppFontFamily.jetBrainsMono,
                    color: Colors.grey[700],
                  ),
                ),
                title: Row(children: [
                  Text(
                    AppLocalizations.of(context).translate('deveolped by:'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(" "),
                  Text(
                    "KayHolding",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontSize: 14,
                        fontFamily: AppFontFamily.jetBrainsMono),
                  )
                ]))),
        body: SingleChildScrollView(
            child: Column(children: [
          InkWell(
            onTap: () {
              final newRouteName = "/privacyPolicyScreen";
              bool isNewRouteSameAsCurrent = false;
              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });
              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName);
              }
            },
            child: Card(
                child: ListTile(
              title: Text(
                AppLocalizations.of(context).translate('Privacy policy'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color),
            )),
          ),
          InkWell(
            onTap: () {
              final newRouteName = "/termsUseScreen";
              bool isNewRouteSameAsCurrent = false;
              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });
              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName);
              }
            },
            child: Card(
                child: ListTile(
              title: Text(
                AppLocalizations.of(context).translate('Terms of use'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color),
            )),
          ),
          Card(
            child: ExpansionTile(
              children: <Widget>[
                ListTile(
                    onTap: () {
                      progressDialog(context);
                      Future.delayed(Duration(seconds: 2), () async {
                        languageProvider.updateLanguage('en');
                        setState(() {
                          lang = 'en';
                        });
                        await detectLocation(context, marketProvider.getLat,
                            marketProvider.getLong);
                      });
                    },
                    title: Text(
                      AppLocalizations.of(context)
                          .translate("English Language"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                ListTile(
                    onTap: () {
                      progressDialog(context);
                      Future.delayed(Duration(seconds: 2), () async {
                        languageProvider.updateLanguage('ar');
                        setState(() {
                          lang = 'ar';
                        });
                        await detectLocation(context, marketProvider.getLat,
                            marketProvider.getLong);
                      });
                    },
                    title: Text(
                      AppLocalizations.of(context).translate("Arabic Language"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
              title: Text(
                AppLocalizations.of(context).translate("Language"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.language,
                  color: Theme.of(context).iconTheme.color),
            ),
          ),
          SizedBox(height: 100),
          InkWell(
            onTap: () {
              launchURL("https://www.facebook.com/KayMarts-101911775249634");
            },
            child: Card(
                child: ListTile(
              title: Text(
                AppLocalizations.of(context).translate('Facebook'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color),
            )),
          ),
          // InkWell(
          //   onTap: () {},
          //   child: Card(
          //       child: ListTile(
          //     title: Text(
          //       AppLocalizations.of(context).translate('Twitter'),
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     trailing: Icon(Icons.arrow_forward,
          //         color: Theme.of(context).iconTheme.color),
          //   )),
          // ),
          // InkWell(
          //   onTap: () {},
          //   child: Card(
          //       child: ListTile(
          //           title: Text(
          //             AppLocalizations.of(context).translate('Instagram'),
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           trailing: Icon(Icons.arrow_forward,
          //               color: Theme.of(context).iconTheme.color))),
          // ),
        ])));
  }
}
