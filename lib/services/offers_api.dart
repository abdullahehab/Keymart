import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/offer_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

import '../app_localizations.dart';

Future<List<OfferModel>> getOffers(
    BuildContext context, String marketId, String categoryId) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(
        ApiRoutes.offers + "market/$marketId" + "/category/$categoryId"),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["product"];
      return data.map((cateqory) => OfferModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load offers'));
    }
  });
}
