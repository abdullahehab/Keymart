import 'dart:collection';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/ui/chat/chat_screen.dart';
import 'package:kaymarts/ui/deliveryAddress/delivery_address_profile_screen.dart';
import 'package:kaymarts/ui/orders/details_order_screen.dart';
import 'package:kaymarts/ui/user/edit_profile_user_screen.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:kaymarts/widgets/otp_dialog.dart';
import 'package:kaymarts/widgets/sign_out.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kaymarts/services/api_services.dart';
import 'package:kaymarts/models/order_model.dart';

List<dynamic> resultNew = [];
List<dynamic> resultHistory = [];

class ProfileUserScreen extends StatefulWidget {
  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  Future<List<FetchMyOrderModel>> futureMyOrderModelNew;
  Future<List<FetchMyOrderModel>> futureMyOrderModelHistory;
  @override
  void initState() {
    super.initState();
    futureMyOrderModelNew = getMyOrdersNew();
    futureMyOrderModelHistory = getMyOrdersHistory();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: appBar(context, "Profile", arrow: true, map: false),
      bottomSheet: authProvider.userModel.status == 0
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  otpCodeDialogBuild(context);
                },
                child: Text(AppLocalizations.of(context)
                    .translate("This user is not verified, verify now?")),
              ),
            )
          : SizedBox(),
      bottomNavigationBar: bottomAnimation(context),
      body: Stack(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(150),
                    child: Container(
                      color: Colors.blue[900],
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(60 / 2)),
                                    border: Border.all(
                                      color: Theme.of(context).iconTheme.color,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/user.png',
                                      image: authProvider.userModel.photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  authProvider.userModel.displayName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFontFamily.jetBrainsMono,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  authProvider.userModel.phoneNumber,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFontFamily.jetBrainsMono,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.userEdit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EditProfileScreen()));
                                    }),
                              ),
                            ),
                            Expanded(child: Container()),
                            TabBar(
                              indicatorColor: Colors.white,
                              indicatorWeight: 5.0,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("Orders"),
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("Options"),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[myOrders(context), options(context)],
                  ),
                ),
              ),
            ))
      ]),
    );
  }

  Widget options(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate("Contact with admins"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryAddressProfileScreen()));
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.solidAddressCard,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate("Delivery addresses"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Card(
                child: ListTile(
                    onTap: () {
                      confirmSignOut(context);
                    },
                    leading: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("Sign out"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Widget myOrders(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  backgroundColor: Colors.deepOrangeAccent,
                  automaticallyImplyLeading: false,
                  bottom: TabBar(
                      indicatorColor: Colors.white,
                      isScrollable: true,
                      tabs: [
                        Text(
                          AppLocalizations.of(context).translate("New orders"),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("History orders"),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              )),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: myOrderNew(),
              ),
              Container(
                child: myOrderHistory(),
              )
            ],
          ),
        ));
  }

  Future<List<FetchMyOrderModel>> getMyOrdersNew() async {
    final response = await http.get(
        ApiRoutesUpdate().getLink(ApiRoutes.fetchMyNewOrders),
        headers: ApiServices.headersData);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['orders'] == ""
          ? []
          : jsonDecode(response.body)['data']['orders'] as List;
      List ordersNumber = [];
      data.forEach((element) {
        ordersNumber.add(element['order_number']);
      });
      resultNew = LinkedHashSet<dynamic>.from(ordersNumber).toList();
      return data.map((order) => FetchMyOrderModel.fromJson(order)).toList();
    } else {
      return [];
    }
  }

  Widget myOrderNew() {
    return Scaffold(
        body: FutureBuilder<List<FetchMyOrderModel>>(
            future: futureMyOrderModelNew,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context)
                      .translate("There are no new orders available"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: loadingPage(context));
              } else if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context)
                      .translate("There are no new orders available"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              }
              return Container(
                  child: ListView.builder(
                      itemCount: resultNew.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<FetchMyOrderModel> orders = snapshot.data;
                        return Card(
                          child: ExpansionTile(
                            title: Row(children: <Widget>[
                              Text(
                                  AppLocalizations.of(context)
                                      .translate("Order Id : "),
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                AppLocalizations.of(context).translate("#") +
                                    resultNew[index].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ]),
                            children: orders.map((row) {
                              if (resultNew[index].toString() ==
                                  row.orderNumber.toString()) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailsOrderScreen(
                                                  imageUrl: orders[0].photo,
                                                  name: orders[0].productName,
                                                  price: orders[0]
                                                      .totalPrice
                                                      .toString(),
                                                  quantity: orders[0]
                                                      .quantity
                                                      .toString(),
                                                  status: orders[0].status,
                                                  dateTime:
                                                      orders[0].date.toString(),
                                                  marketName: orders[0]
                                                      .marketName
                                                      .toString(),
                                                )));
                                  },
                                  leading: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/shopping.png',
                                    image: row.photo,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                  title: Text(
                                    row.productName,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }).toList(),
                          ),
                        );
                      }));
            }));
  }

  Future<List<FetchMyOrderModel>> getMyOrdersHistory() async {
    final response = await http.get(
        ApiRoutesUpdate().getLink(ApiRoutes.fetchMyHistoryOrders),
        headers: ApiServices.headersData);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['orders'] == ""
          ? []
          : jsonDecode(response.body)['data']['orders'] as List;
      List ordersNumber = [];
      data.forEach((element) {
        ordersNumber.add(element['order_number']);
      });
      resultHistory = LinkedHashSet<dynamic>.from(ordersNumber).toList();
      return data.map((order) => FetchMyOrderModel.fromJson(order)).toList();
    } else {
      return [];
    }
  }

  Widget myOrderHistory() {
    return Scaffold(
        body: FutureBuilder<List<FetchMyOrderModel>>(
            future: futureMyOrderModelHistory,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context)
                      .translate("There are no history orders available"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: loadingPage(context));
              } else if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context)
                      .translate("There are no history orders available"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              }
              return Container(
                  child: ListView.builder(
                      itemCount: resultHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<FetchMyOrderModel> orders = snapshot.data;
                        return Card(
                          child: ExpansionTile(
                            title: Row(children: <Widget>[
                              Text(
                                  AppLocalizations.of(context)
                                      .translate("Order Id : "),
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                AppLocalizations.of(context).translate("#") +
                                    resultHistory[index].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ]),
                            children: orders.map((row) {
                              if (resultHistory[index].toString() ==
                                  row.orderNumber.toString()) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailsOrderScreen(
                                                  imageUrl: orders[0].photo,
                                                  name: orders[0].productName,
                                                  price: orders[0]
                                                      .totalPrice
                                                      .toString(),
                                                  quantity: orders[0]
                                                      .quantity
                                                      .toString(),
                                                  status: orders[0].status,
                                                  dateTime:
                                                      orders[0].date.toString(),
                                                  marketName: orders[0]
                                                      .marketName
                                                      .toString(),
                                                )));
                                  },
                                  leading: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/shopping.png',
                                    image: row.photo,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                  title: Text(
                                    row.productName,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }).toList(),
                          ),
                        );
                      }));
            }));
  }
}
