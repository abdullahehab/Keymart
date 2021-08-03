import 'dart:typed_data';
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/models/user_model.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/appbar.dart';

GlobalKey<ScaffoldState> _globalKey = GlobalKey();

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String fullName, phone;
  Uint8List imageBytes;
  TextEditingController fullNameController;
  TextEditingController phoneController;
  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    fullNameController =
        TextEditingController(text: authProvider.userModel.displayName);
    phoneController =
        TextEditingController(text: authProvider.userModel.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
        key: _globalKey,
        appBar: appBar(context, "Edit profile"),
        bottomNavigationBar: bottomAnimation(context),
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
                      controller: fullNameController,
                      label:
                          AppLocalizations.of(context).translate('Full name'),
                      onSaved: (value) => fullName = value,
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      label: AppLocalizations.of(context).translate('Phone'),
                      onSaved: (value) => phone = value,
                    ),
                    CardSettingsFilePicker(
                      initialValue: imageBytes,
                      onSaved: (value) => imageBytes = value,
                      onChanged: (value) => imageBytes = value,
                      label: AppLocalizations.of(context).translate('Photo'),
                    ),
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: AppLocalizations.of(context).translate('Actions'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context).translate("Edit"),
                        onPressed: () async {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            progressDialog(context);

                            UserModel userModel = UserModel(
                                displayName: fullNameController.text,
                                phoneNumber: phoneController.text,
                                file: null);
                            await UserApi()
                                .updateUser(context, userModel, imageBytes);
                          }
                        }),
                    CardSettingsButton(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context).translate("Reset"),
                        onPressed: () {
                          _formKey.currentState.reset();
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);

                          fullNameController = TextEditingController(
                              text: authProvider.userModel.displayName);
                          phoneController = TextEditingController(
                              text: authProvider.userModel.phoneNumber);
                          setState(() {
                            fullName = authProvider.userModel.displayName;
                            phone = authProvider.userModel.phoneNumber;
                          });
                        }),
                  ])
            ])));
  }
}
