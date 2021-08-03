import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/search_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

import '../app_localizations.dart';

Future<List<SearchModel>> getProductsSearch(BuildContext context,
    String marketId, String categoryId, String search) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.searchProducts +
        "market/$marketId" +
        "/category/$categoryId?search=$search"),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["product"];
      print(data);
      return data.map((cateqory) => SearchModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load products'));
    }
  });
}
