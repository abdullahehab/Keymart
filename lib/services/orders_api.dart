import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaymarts/models/order_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/services/api_services.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'package:flutter/material.dart';

Future<void> createOrder(BuildContext context, OrderModel orderModel) async {
  final http.Response response = await http.post(
      ApiRoutesUpdate().getLink(ApiRoutes.orders),
      headers: ApiServices.headersData,
      body: jsonEncode(orderModel.toMapOrder()));
  if (response.statusCode == 200) {
  } else {
    final decoded = jsonDecode(response.body) as Map;
    final data = decoded['data'] as Map;
    data.forEach((key, value) {
      showToast(value[0].toString(), Colors.red, context);
    });
  }
}
