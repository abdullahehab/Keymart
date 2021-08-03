import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/category_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

import '../app_localizations.dart';

Future<List<CategoryModel>> getFAQ(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.cateqories),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["category"];
      return data.map((cateqory) => CategoryModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load data'));
    }
  });
}

Future<List<CategoryModel>> getAppFeedback(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.cateqories),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["category"];
      return data.map((cateqory) => CategoryModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load data'));
    }
  });
}

Future<List<CategoryModel>> getPrivacyPolicy(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.cateqories),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["category"];
      return data.map((cateqory) => CategoryModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load data'));
    }
  });
}

Future<List<CategoryModel>> getTermsUse(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.cateqories),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["category"];
      return data.map((cateqory) => CategoryModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('Failed to load data'));
    }
  });
}
