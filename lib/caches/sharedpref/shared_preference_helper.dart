import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

class SharedPreferenceHelper {
  Future<SharedPreferences> _sharedPreference;
  static const String is_dark_mode = "is_dark_mode";
  static const String language_code = "language_code";

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  //Theme module
  Future<void> changeTheme(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(is_dark_mode, value);
    });
  }

  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(is_dark_mode) ?? false;
    });
  }

  //Locale module
  Future<String> get appLocale {
    return _sharedPreference.then((prefs) {
      return prefs.getString(language_code) ?? null;
    });
  }

  Future<void> changeLanguage(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(language_code, value);
    });
  }

  Future<UserModel> getUserPref() {
    return _sharedPreference.then((prefs) {
      return UserModel(
          uid: prefs.getString("UID"),
          displayName: prefs.getString("Name"),
          email: prefs.getString("Email"),
          phoneNumber: prefs.getString("Phone"),
          photoUrl: prefs.getString("PhotoUrl"),
          status: prefs.getInt("status"),
          tokenId: prefs.getString("tokenId"));
    });
  }

  Future<void> setUserPref(UserModel userModel) {
    return _sharedPreference.then((prefs) {
      prefs.setString("UID", userModel.uid);
      prefs.setString("Name", userModel.displayName);
      prefs.setString("Email", userModel.email);
      prefs.setString("Phone", userModel.phoneNumber);
      prefs.setString("PhotoUrl", userModel.photoUrl);
      prefs.setInt("status", userModel.status);
      prefs.setString("tokenId", userModel.tokenId);
    });
  }

  Future<void> removeUserPref() {
    return _sharedPreference.then((prefs) {
      prefs.remove("UID");
      prefs.remove("Name");
      prefs.remove("Email");
      prefs.remove("Phone");
      prefs.remove("PhotoUrl");
      prefs.remove("status");
      prefs.remove("tokenId");
    });
  }

  Future<double> getTotalPricePref() {
    return _sharedPreference.then((prefs) {
      return prefs.getDouble("totalPrice") == null
          ? 0.0
          : prefs.getDouble("totalPrice");
    });
  }

  Future<void> setTotalPricePref(double totalPrice) async {
    return _sharedPreference.then((prefs) {
      prefs.setDouble("totalPrice", totalPrice);
    });
  }

  Future<double> getTotalPriceMarketPref(String id) {
    return _sharedPreference.then((prefs) {
      return prefs.getDouble("market$id") == null
          ? 0.0
          : prefs.getDouble("market$id");
    });
  }

  Future<void> setTotalPriceMarketPref(String id, double totalPrice) async {
    return _sharedPreference.then((prefs) {
      prefs.setDouble("market$id", totalPrice);
    });
  }

  Future<void> removeTotalPriceMarketPref(String id) async {
    return _sharedPreference.then((prefs) {
      prefs.remove("market$id");
    });
  }

  Future<int> getQuantityMarketMarketPref(String id) {
    return _sharedPreference.then((prefs) {
      return prefs.getInt("Quantitymarket$id") == null
          ? 0
          : prefs.getInt("Quantitymarket$id");
    });
  }

  Future<void> setQuantityMarketMarketPref(String id, int quantity) async {
    return _sharedPreference.then((prefs) {
      prefs.setInt("Quantitymarket$id", quantity);
    });
  }

  Future<void> removeQuantityMarketMarketPref(String id) async {
    return _sharedPreference.then((prefs) {
      prefs.remove("Quantitymarket$id");
    });
  }

  Future<int> getCountCartPref() {
    return _sharedPreference.then((prefs) {
      return prefs.getInt("countCart") == null ? 0 : prefs.getInt("countCart");
    });
  }

  Future<void> setCheckButtonCartPref(String productId, bool status) async {
    return _sharedPreference.then((prefs) {
      prefs.setBool("checkCart$productId", status);
    });
  }

  Future<bool> getCheckButtonCartPref(String productId) {
    return _sharedPreference.then((prefs) {
      return prefs.getBool("checkCart$productId") == null
          ? false
          : prefs.getBool("checkCart$productId");
    });
  }

  Future<void> setCountCartPref(int countCart) async {
    return _sharedPreference.then((prefs) {
      prefs.setInt("countCart", countCart);
    });
  }

  Future<List<String>> getProductIdsPrefs() {
    return _sharedPreference.then((prefs) {
      return prefs.getStringList("productIds") == null
          ? []
          : prefs.getStringList("productIds");
    });
  }

  Future<void> setProductIdsPrefs(List<String> productIds) {
    return _sharedPreference.then((prefs) {
      prefs.setStringList("productIds", productIds);
    });
  }

  Future<void> removeProducts() {
    return _sharedPreference.then((prefs) {
      prefs.remove("productIds");
    });
  }

  Future<List<String>> getFavoriteIdsPrefs() {
    return _sharedPreference.then((prefs) {
      return prefs.getStringList("favoriteIds") == null
          ? []
          : prefs.getStringList("favoriteIds");
    });
  }

  Future<void> setFavoriteIdsPrefs(String productId) {
    return _sharedPreference.then((prefs) {
      List<String> favoriteIds = prefs.getStringList("favoriteIds") == null
          ? []
          : prefs.getStringList("favoriteIds");
      favoriteIds.add(productId);
      prefs.setStringList("favoriteIds", favoriteIds);
    });
  }

  Future<void> removeFavoriteIdsPrefs(String productId) {
    return _sharedPreference.then((prefs) {
      List<String> favoriteIds = prefs.getStringList("favoriteIds") == null
          ? []
          : prefs.getStringList("favoriteIds");
      favoriteIds.remove(productId);
      prefs.setStringList("favoriteIds", favoriteIds);
    });
  }

  Future<List<String>> getNotificationIdsPrefs() {
    return _sharedPreference.then((prefs) {
      return prefs.getStringList("notificationIds") == null
          ? []
          : prefs.getStringList("notificationIds");
    });
  }

  Future<void> setNotificationIdsPrefs(List<String> notificationIds) {
    return _sharedPreference.then((prefs) {
      prefs.setStringList("notificationIds", notificationIds);
    });
  }

  Future<int> getQuantityProductPrefs(String productId) {
    return _sharedPreference.then((prefs) {
      return prefs.getInt("quantity$productId") == null
          ? 1
          : prefs.getInt("quantity$productId");
    });
  }

  Future<void> setQuantityProductPrefs(String productId, int quantity) {
    return _sharedPreference.then((prefs) {
      prefs.setInt("quantity$productId", quantity);
    });
  }

  Future<int> getCountFavoritePref() async {
    return _sharedPreference.then((prefs) {
      return prefs.getInt("countFavorite") == null
          ? 0
          : prefs.getInt("countFavorite");
    });
  }

  Future<void> setCountFavoritePref(int countFavorite) async {
    return _sharedPreference.then((prefs) {
      prefs.setInt("countFavorite", countFavorite);
    });
  }

  Future<bool> getcheckFavoritePref(String productId) async {
    return _sharedPreference.then((prefs) {
      return prefs.getBool("checkFavorite$productId") == null
          ? false
          : prefs.getBool("checkFavorite$productId");
    });
  }

  Future<void> setCheckFavoritePref(
      String productId, bool checkFavorite) async {
    return _sharedPreference.then((prefs) {
      prefs.setBool("checkFavorite$productId", checkFavorite);
    });
  }

  Future<int> getCountNotificationPref() {
    return _sharedPreference.then((prefs) {
      return prefs.getInt("countNotifications") == null
          ? 0
          : prefs.getInt("countNotifications");
    });
  }

  Future<void> setCountNotificationPref(int countNotifications) {
    return _sharedPreference.then((prefs) {
      prefs.setInt("countNotifications", countNotifications);
    });
  }

  Future<List<String>> getCodeDiscountPricePref() {
    return _sharedPreference.then((prefs) {
      return prefs.getStringList("code");
    });
  }

  Future<void> setCodeDiscountPricePref(String code) {
    return _sharedPreference.then((prefs) {
      List<String> listCode = prefs.getStringList("code");
      listCode.add(code);
      prefs.setStringList("code", listCode);
    });
  }

  Future<void> setTokenId(String tokenId) {
    return _sharedPreference.then((prefs) {
      prefs.setString("tokenId", tokenId);
    });
  }

  Future<String> getTokenId() {
    return _sharedPreference.then((prefs) {
      return prefs.getString("tokenId");
    });
  }

  Future<List<String>> getReviewMarket() {
    return _sharedPreference.then((prefs) {
      return prefs.getStringList("marketReview") == null
          ? []
          : prefs.getStringList("marketReview");
    });
  }

  Future<void> setReviewMarket(String marketId) {
    return _sharedPreference.then((prefs) {
      List<String> marketIds = prefs.getStringList("marketReview") == null
          ? []
          : prefs.getStringList("marketReview");
      marketIds.add(marketId);
      prefs.setStringList("marketReview", marketIds);
    });
  }

  Future<void> setMarketId(String marketId) {
    return _sharedPreference.then((prefs) {
      prefs.setString("marketId", marketId);
    });
  }

  Future<String> getMarketId(String marketId) {
    return _sharedPreference.then((prefs) {
      return prefs.getString("marketId") == null
          ? marketId
          : prefs.getString("marketId");
    });
  }

  Future<int> getShowMap() {
    return _sharedPreference.then((prefs) {
      return prefs.getInt("showMap") == null ? 0 : prefs.getInt("showMap");
    });
  }

  Future<void> setShowMap(int showMap) {
    return _sharedPreference.then((prefs) {
      prefs.setInt("showMap", showMap);
    });
  }
}
