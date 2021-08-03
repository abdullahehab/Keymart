import 'package:flutter/material.dart';
import 'package:kaymarts/models/delivery_address_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/services/api_services.dart';
import 'package:kaymarts/ui/checkout/delivery_address_screen.dart';
import 'package:kaymarts/ui/deliveryAddress/delivery_address_profile_screen.dart';
import 'package:kaymarts/widgets/show_toast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_localizations.dart';

class AddressDeliveryApi {
  Future<void> createAddressDelivery(BuildContext context,
      AddressDeliveryModel addressDeliveryModel, String root) async {
    final http.Response response = await http.post(
        ApiRoutesUpdate().getLink(ApiRoutes.createDeliveryAddress),
        headers: ApiServices.headersData,
        body: jsonEncode(addressDeliveryModel.toJson()));
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      if (root == "profile") {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => DeliveryAddressProfileScreen()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => DeliveryAddressScreen()));
      }
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);
    } else {
      final decoded = jsonDecode(response.body) as Map;
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }

  Future<List<AddressDeliveryModel>> getAddressDelivery(
      BuildContext context) async {
    return await http
        .get(
      ApiRoutesUpdate().getLink(ApiRoutes.getDeliveryAddress),
      headers: ApiServices.headersData,
    )
        .then((response) {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (jsonDecode(response.body)['data']['address_delivery'] != "") {
          List data = json["data"]["address_delivery"];
          return data
              .map((cateqory) => AddressDeliveryModel.fromJson(cateqory))
              .toList();
        } else {
          return null;
        }
      } else {
        throw Exception(AppLocalizations.of(context)
            .translate('Failed to load address delivery'));
      }
    });
  }

  Future<void> deleteAddressDelivery(
      BuildContext context, String addressId) async {
    final http.Response response = await http.put(
      ApiRoutesUpdate().getLink(ApiRoutes.deleteDeliveryAddress + addressId),
      headers: ApiServices.headersData,
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      showToast(jsonDecode(response.body)["message"],
          Theme.of(context).iconTheme.color, context);
    } else {
      Navigator.of(context).pop();
      final decoded = jsonDecode(response.body) as Map;
      final data = decoded['data'] as Map;
      data.forEach((key, value) {
        showToast(value[0].toString(), Colors.red, context);
      });
    }
  }
}
