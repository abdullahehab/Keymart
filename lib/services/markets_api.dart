import 'dart:convert';
import 'package:kaymarts/models/market_model.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:http/http.dart' as http;
import 'package:kaymarts/services/api_services.dart';
import 'package:kaymarts/services/data_app_api.dart';

Future<List<MarketModel>> getMarkets({double lat, double long}) async {
  return await http
      .get(ApiRoutesUpdate().getLink(ApiRoutes.markets + "lat=$lat&long=$long"),
          headers: ApiServices.headersData)
      .then((response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List data = json["data"]['markets'] == "" ? [] : json["data"]['markets'];
      return data.map((market) => MarketModel.fromJson(market)).toList();
    } else {
      var json = jsonDecode(response.body);
      print(appkey);
      print(json);
      return [];
    }
  });
}
