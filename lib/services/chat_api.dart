import 'package:kaymarts/models/chat_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/services/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createChat(BuildContext context, ChatModel chatModel) async {
  final http.Response response = await http.post(
      ApiRoutesUpdate().getLink(ApiRoutes.postChat),
      headers: ApiServices.headersData,
      body: jsonEncode(chatModel.toJson()));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
  } else {}
}
