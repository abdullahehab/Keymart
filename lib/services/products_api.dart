import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/product_model.dart';
import 'package:kaymarts/providers/product_provider.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';

Future<List<ProductModel>> getProducts(
    BuildContext context, String marketId, String categoryId, int page) async {
  final productProvider = Provider.of<ProductProvider>(context, listen: false);

  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.products +
        "market/$marketId/category/$categoryId" +
        "?page=$page"),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["product"] == "" ? [] : json["data"]["product"];
      productProvider.changeCountValue(json["meta"]["last_page"]);
      return data.map((product) => ProductModel.fromJson(product)).toList();
    } else
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load products'));
  });
}
