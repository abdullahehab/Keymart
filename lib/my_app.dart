import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/services/data_app_api.dart';
import 'package:kaymarts/services/get_base_url.dart';
import 'package:kaymarts/ui/auth/check_auth.dart';
import 'package:kaymarts/ui/location/map_detect_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'app_localizations.dart';
import 'constants/app_themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'functions/my_location.dart';
import 'functions/pusher_message_notification.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'routes.dart';

String lang;
int showMap = 0;

class MyApp extends StatefulWidget {
  const MyApp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    SharedPreferenceHelper().appLocale.then((value) {
      lang = value;
      languageProvider.updateLanguageCode(value);
    });
    SharedPreferenceHelper().getShowMap().then((value) {
      print(value);
      setState(() {
        showMap = value;
      });
    });
    Future.delayed(Duration(seconds: 0), () async {
      await getBaseUrlApp(context);
      await getDataApp(context);
      await getLocationUser(context);
      await initPusher();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initPusher();
    } else if (state == AppLifecycleState.inactive) {
      initPusher();
    } else if (state == AppLifecycleState.paused) {
      initPusher();
    } else if (state == AppLifecycleState.detached) {
      initPusher();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        return Consumer<LanguageProvider>(
          builder: (_, languageProviderRef, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: languageProviderRef.appLocale,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ar', 'EG'),
              ],
              builder: (context, child) {
                return Directionality(
                  textDirection: languageProviderRef.appLocale == Locale('en')
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: child,
                );
              },
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              title: widget.title,
              routes: Routes.routes,
              theme: languageProviderRef.appLocale == Locale('en')
                  ? AppThemes.lightThemeEn
                  : AppThemes.lightThemeAr,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeProviderRef.isDarkModeOn
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: SplashScreen(
                  seconds: 5,
                  image: Image.asset(
                    'assets/images/logo.png',
                  ),
                  backgroundColor: Colors.blue[900],
                  photoSize: 200.0,
                  loaderColor: Colors.deepOrangeAccent,
                  navigateAfterSeconds: showMap == 0
                      ? MapDetectLocationScreen(arrow: true)
                      : CheckAuth(
                          title: widget.title,
                        )),
            );
          },
        );
      },
    );
  }
}
