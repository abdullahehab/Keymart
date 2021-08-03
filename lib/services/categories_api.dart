import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/category_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

import '../app_localizations.dart';

Future<List<CategoryModel>> getCategories(
    BuildContext context, String marketId) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.cateqories + "$marketId"),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["category"];
      return data.map((cateqory) => CategoryModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load cateqory'));
    }
  });
}
