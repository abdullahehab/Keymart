import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/models/policy_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';
import '../app_localizations.dart';

Future<List<PolicyModel>> getPolicy(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.policy),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]['policy'];
      return data.map((cateqory) => PolicyModel.fromJson(cateqory)).toList();
    } else {
      throw Exception(AppLocalizations.of(context)
          .translate('There are no privacy policy'));
    }
  });
}
