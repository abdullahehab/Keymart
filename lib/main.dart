import 'dart:io';
import 'package:kaymarts/providers/bottom_animation_provider.dart';
import 'package:kaymarts/providers/details_delivery_address_provider.dart';
import 'package:kaymarts/providers/forget_password_provider.dart';
import 'package:kaymarts/providers/market_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaymarts/providers/notifications_provider.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/language_provider.dart';
import 'providers/product_provider.dart';
import 'providers/search_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue[900],
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  String title = "KayMarts";
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider(),
          ),
          ChangeNotifierProvider<ChatProvider>(
            create: (context) => ChatProvider(),
          ),
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),
          ),
          ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider(),
          ),
          ChangeNotifierProvider<MarketProvider>(
            create: (context) => MarketProvider(),
          ),
          ChangeNotifierProvider<FavoriteProvider>(
            create: (context) => FavoriteProvider(),
          ),
          ChangeNotifierProvider<NotificationsProvider>(
            create: (context) => NotificationsProvider(),
          ),
          ChangeNotifierProvider<ForgetPasswordProvider>(
            create: (context) => ForgetPasswordProvider(),
          ),
          ChangeNotifierProvider<ProductProvider>(
            create: (context) => ProductProvider(),
          ),
          ChangeNotifierProvider<CIndexProvider>(
            create: (context) => CIndexProvider(),
          ),
          ChangeNotifierProvider<DetailsDeliveryAddressProvider>(
            create: (context) => DetailsDeliveryAddressProvider(),
          ),
        ],
        child: MyApp(title: title),
      ),
    );
  });
}
