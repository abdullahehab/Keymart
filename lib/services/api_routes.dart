import 'package:kaymarts/services/get_base_url.dart';

class ApiRoutes {
  static String registerApi = "api/register";
  static String loginApi = "api/login";
  static String updateApi = "api/profile/update";
  static String otpApi = "api/user/active_code";
  static String logoutApi = "api/logout";
  static String markets = "api/user/location?";
  static String offers = "api/offer/";
  static String cateqories = "api/market/category/";
  static String products = "api/product/";
  static String orders = "api/product/order";
  static String ordersOffer = "api/offer/order";
  static String createDeliveryAddress = "api/user/address/save";
  static String getDeliveryAddress = "api/user/address/all";
  static String deleteDeliveryAddress = "api/user/address/delete/";
  static String fetchMyNewOrders = "api/user/myorders/waiting";
  static String fetchMyHistoryOrders = "api/user/myorders/history";
  static String getReviewsMarket = "api/market/reviews/";
  static String createReviewsMarket = "api/user/evaluation/market/";
  static String getChat = "api/message/index";
  static String postChat = "api/message/store";
  static String searchProducts = "api/search/product/";
  static String emailForgetPassword = "api/user/forgotpassword/code/send/";
  static String otpForgetPassword = "api/user/forgotpassword/code/active/";
  static String newPasswordForgetPassword = "api/user/password/reset/email/";
  static String resendOTP = "api/user/resend_code";
  static String dataApp = "api/setting/application/keys/token/kaymart1102019";
  static String policy = "api/policy";
  static String terms = "api/terms_condition";
}

class ApiRoutesUpdate {
  //static String baseUrl = "https://www.kaymarts.a2hosted.com/";
  getLink(String url) {
    return baseUrl + url;
  }
}
