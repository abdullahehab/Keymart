import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:kaymarts/providers/cart_provider.dart';
import 'package:kaymarts/ui/checkout/delivery_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../caches/sharedpref/shared_preference_helper.dart';
import '../../models/product_cart_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/appbar.dart';

GlobalKey<ScaffoldState> _globalKey = GlobalKey();

class CheckoutOrdersScreen extends StatefulWidget {
  CheckoutOrdersScreen(
      {this.orders, this.deliveryPrice, this.totalPriceMarket, this.marketId});
  final List<ProductCartModel> orders;
  final double deliveryPrice;
  final double totalPriceMarket;
  final String marketId;

  @override
  _CheckoutOrdersScreenState createState() => _CheckoutOrdersScreenState();
}

class _CheckoutOrdersScreenState extends State<CheckoutOrdersScreen> {
  double productsPrice = 0.0;
  double totalPrice = 0.0;
  String addressId;
  List<String> addresses = [];
  List<String> addressesId = [];
  final LocalStorage storage = LocalStorage('products');
  ProductCartModel productModel = ProductCartModel();

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartProvider.changeMarketIdValue(widget.marketId);
    });
    getTotalPrice();
  }

  void getTotalPrice() {
    SharedPreferenceHelper()
        .getTotalPriceMarketPref(widget.marketId)
        .then((value) {
      setState(() {
        totalPrice = widget.totalPriceMarket + widget.deliveryPrice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
        key: _globalKey,
        bottomNavigationBar: bottomAnimation(context),
        appBar: appBar(context, "Checkout"),
        body: Form(
            key: _formKey,
            child: CardSettings(children: <CardSettingsSection>[
              CardSettingsSection(
                  header: CardSettingsHeader(
                    labelAlign: languageProvider.appLocale == Locale('en')
                        ? TextAlign.left
                        : TextAlign.right,
                    label: AppLocalizations.of(context)
                        .translate('Personal Information'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsText(
                      enabled: false,
                      initialValue: authProvider.userModel.displayName,
                      label:
                          AppLocalizations.of(context).translate('Full name'),
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.phone,
                      enabled: false,
                      initialValue: authProvider.userModel.phoneNumber,
                      label: AppLocalizations.of(context).translate('Phone'),
                    ),
                  ]),
              CardSettingsSection(
                header: CardSettingsHeader(
                  labelAlign: languageProvider.appLocale == Locale('en')
                      ? TextAlign.left
                      : TextAlign.right,
                  label:
                      AppLocalizations.of(context).translate('Details orders'),
                ),
                children: <CardSettingsWidget>[
                  CardSettingsText(
                      enabled: false,
                      label: AppLocalizations.of(context)
                          .translate('Products number'),
                      initialValue: widget.orders.length == 0
                          ? 1
                          : widget.orders.length.toString()),
                  CardSettingsText(
                    enabled: false,
                    label: AppLocalizations.of(context)
                        .translate('Products price'),
                    initialValue: widget.totalPriceMarket.toString() +
                        " " +
                        AppLocalizations.of(context).translate("EGP"),
                  ),
                  CardSettingsText(
                    enabled: false,
                    label: AppLocalizations.of(context)
                        .translate('Delivery price'),
                    initialValue: widget.deliveryPrice.toString() +
                        " " +
                        AppLocalizations.of(context).translate("EGP"),
                  ),
                  CardSettingsText(
                    enabled: false,
                    label:
                        AppLocalizations.of(context).translate('Total price'),
                    initialValue: totalPrice.toString() +
                        " " +
                        AppLocalizations.of(context).translate("EGP"),
                  ),
                ],
              ),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    labelAlign: languageProvider.appLocale == Locale('en')
                        ? TextAlign.left
                        : TextAlign.right,
                    label: AppLocalizations.of(context).translate('Actions'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Colors.white,
                        label:
                            AppLocalizations.of(context).translate("Confirm"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DeliveryAddressScreen()));
                        }),
                  ])
            ])));
  }
}
