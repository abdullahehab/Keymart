import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/terms_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';
import '../app_localizations.dart';

Future<List<TermsModel>> getTerms(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.terms),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]["terms"];
      return data.map((cateqory) => TermsModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(
          AppLocalizations.of(context).translate('There are no terms use'));
    }
  });
}
