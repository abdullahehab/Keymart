import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import '../../app_localizations.dart';
import '../../constants/app_font_family.dart';
import '../../widgets/appbar.dart';

class DetailsOrderScreen extends StatefulWidget {
  DetailsOrderScreen(
      {this.imageUrl,
      this.name,
      this.price,
      this.quantity,
      this.status,
      this.dateTime,
      this.marketName});
  final String imageUrl;
  final String name;
  final String price;
  final String quantity;
  final String status;
  final String marketName;
  final String dateTime;

  @override
  _DetailsOrderScreenState createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  var format = DateFormat('d/M/yyyy HH:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Details"),
      bottomNavigationBar: bottomAnimation(context),
      body: SingleChildScrollView(
        child: Container(
            child: Card(
                elevation: 2,
                child: Container(
                    child: Column(children: <Widget>[
                  ListTile(
                      leading: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/shopping.png',
                        image: widget.imageUrl,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFontFamily.elMessiri,
                              fontSize: 14))),
                  Divider(
                    color: Colors.grey,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    trailing: Container(
                      color: Colors.grey,
                      width: 150,
                      height: 50,
                      child: Center(
                        child: Text(
                          widget.price +
                              " " +
                              AppLocalizations.of(context).translate("EGP"),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    title: Text(AppLocalizations.of(context).translate('Price'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Divider(
                    color: Colors.grey,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    leading: Text(
                        AppLocalizations.of(context).translate('Quantity'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Container(
                      color: Colors.grey,
                      width: 150,
                      height: 50,
                      child: Center(
                          child: Text(
                        widget.quantity,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                    leading: Text(
                        AppLocalizations.of(context).translate('Status'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Container(
                      color: Colors.grey,
                      width: 150,
                      height: 50,
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context).translate(widget.status),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ListTile(
                      title: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('DateTime'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" : "),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.dateTime.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ])))),
      ),
    );
  }
}
