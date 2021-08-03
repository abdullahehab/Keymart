import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/providers/bottom_animation_provider.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/providers/favorite_provider.dart';
import 'package:kaymarts/ui/market/markets_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key key,
    this.title,
    this.user,
  }) : super(key: key);

  final String title;
  final String user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('products');

  void initializationNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  @override
  void initState() {
    super.initState();
    initializationNotification();
    SharedPreferenceHelper().getCountFavoritePref().then((value) {
      final favoriteProvider =
          Provider.of<FavoriteProvider>(context, listen: false);
      favoriteProvider.changeCountValue(value);
    });
    SharedPreferenceHelper().getCountCartPref().then((value) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final cIndexProvider =
          Provider.of<CIndexProvider>(context, listen: false);
      cIndexProvider.changeCIndex(0);
      cartProvider.changeCountValue(value);
    });
  }

  Future<bool> _willPopScope() async {
    Alert(
      context: context,
      type: AlertType.error,
      title: AppLocalizations.of(context).translate("Do you want to exit?"),
      buttons: [
        DialogButton(
          color: Theme.of(context).iconTheme.color,
          child: Text(
            AppLocalizations.of(context).translate("No"),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
        DialogButton(
          color: Theme.of(context).iconTheme.color,
          child: Text(
            AppLocalizations.of(context).translate("Yes"),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
          width: 120,
        )
      ],
    ).show();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopScope,
        child: Scaffold(key: _scaffoldKey, body: MarketsScreen()));
  }
}
