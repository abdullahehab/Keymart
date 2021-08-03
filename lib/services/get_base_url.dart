import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

String baseUrl;

Future<void> getBaseUrlApp(BuildContext context) async {
  return await http
      .get(
    "https://www.kuwait-fencing-team.tk/api/domain",
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      baseUrl = json["domain"];
    }
  });
}
