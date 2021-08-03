import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:kaymarts/ui/products/cart_screen.dart';
import '../app_localizations.dart';

Widget cartWidget(BuildContext context, String marketId, double deliveryPrice,
    String totalPrice, int quantity) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CartScreen(marketId, deliveryPrice)));
    },
    child: Container(
        height: 60,
        color: Colors.blue[900],
        child: Column(children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlutterBadge(
                hideZeroCount: true,
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                borderRadius: 20.0,
                itemCount: quantity,
              ),
              Text(
                AppLocalizations.of(context).translate("Show Basket"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                totalPrice +
                    " " +
                    AppLocalizations.of(context).translate("EGP"),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ])),
  );
}
