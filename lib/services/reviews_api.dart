import 'dart:convert';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/reviews_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

import '../app_localizations.dart';

Future<List<ReviewsModel>> getReviewsMarket(
    BuildContext context, String marketId, int take) async {
  return await http
      .get(ApiRoutesUpdate().getLink(ApiRoutes.getReviewsMarket + "$marketId"),
          headers: ApiServices.headersData)
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]['review'] == "" ? [] : json["data"]['review'];
      return take == 10
          ? data
              .take(10)
              .map((review) => ReviewsModel.fromJson(review))
              .toList()
          : data.map((review) => ReviewsModel.fromJson(review)).toList();
    } else
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load reviews'));
  });
}

Future<void> createReviewMarket(
    BuildContext context, String marketId, ReviewsModel reviewsModel) async {
  final http.Response response = await http.post(
      ApiRoutesUpdate().getLink(ApiRoutes.createReviewsMarket + marketId),
      headers: ApiServices.headersData,
      body: jsonEncode(reviewsModel.toJson()));
  if (response.statusCode == 200) {
    SharedPreferenceHelper().setReviewMarket(marketId);
    showToast(jsonDecode(response.body)["message"],
        Theme.of(context).iconTheme.color, context);
  } else {
    final decoded = jsonDecode(response.body) as Map;
    final data = decoded['data'] as Map;
    data.forEach((key, value) {
      showToast(value[0].toString(), Colors.red, context);
    });
  }
}
