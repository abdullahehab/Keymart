import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';

String appkey;
String mapKey;
String pusherKey;

Future<void> getDataApp(BuildContext context) async {
  return await http
      .get(
    ApiRoutesUpdate().getLink(ApiRoutes.dataApp),
    headers: ApiServices.headersData,
  )
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var data = json["data"];
      appkey = data['app_key'];
      mapKey = data['map_key'];
      pusherKey = data['pusher_key'];
    }
  });
}
