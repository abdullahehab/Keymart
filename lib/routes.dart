import 'package:kaymarts/ui/about/about_screen.dart';
import 'package:kaymarts/ui/about/privacy_policy.dart';
import 'package:kaymarts/ui/about/terms_use_screen.dart';
import 'package:kaymarts/ui/auth/login_screen.dart';
import 'package:kaymarts/ui/deliveryAddress/delivery_address_profile_screen.dart';
import 'package:kaymarts/ui/location/map_detect_location_screen.dart';
import 'package:kaymarts/ui/products/categories_screen.dart';
import 'package:kaymarts/ui/user/edit_profile_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/ui/auth/check_auth.dart';
import 'ui/auth/registeration_screen.dart';
import 'ui/home/home.dart';
import 'ui/products/favorite_screen.dart';
import 'ui/user/profile_screen.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String categories = '/categories';
  static const String searchScreen = '/searchScreen';
  static const String favoriteScreen = '/favoriteScreen';
  static const String notificationsScreen = '/notificationsScreen';
  static const String profileScreen = '/profileScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String newOrdersScreen = '/newOrdersScreen';
  static const String historyOrdersScreen = '/historyOrdersScreen';
  static const String deliveryAddressProfileScreen =
      '/deliveryAddressProfileScreen';
  static const String checkAuth = '/checkAuth';
  static const String mapDetectLocationScreen = "/mapDetectLocationScreen";
  static const String aboutScreen = "/aboutScreen";
  static const String faqScreen = "/faqScreen";
  static const String privacyPolicyScreen = "/privacyPolicyScreen";

  static const String termsUseScreen = "/termsUseScreen";

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    register: (BuildContext context) => RegisterationScreen(),
    home: (BuildContext context) => HomeScreen(),
    categories: (BuildContext context) => CategoriesScreen(),
    deliveryAddressProfileScreen: (BuildContext context) =>
        DeliveryAddressProfileScreen(),
    favoriteScreen: (BuildContext context) => FavoriteScreen(),
    profileScreen: (BuildContext context) => ProfileUserScreen(),
    editProfileScreen: (BuildContext context) => EditProfileScreen(),
    checkAuth: (BuildContext context) => CheckAuth(),
    mapDetectLocationScreen: (BuildContext context) =>
        MapDetectLocationScreen(),
    aboutScreen: (BuildContext context) => AboutScreen(),
    privacyPolicyScreen: (BuildContext context) => PrivacyPolicyScreen(),
    termsUseScreen: (BuildContext context) => TermsUseScreen(),
  };
}
