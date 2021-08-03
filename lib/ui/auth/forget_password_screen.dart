import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/providers/forget_password_provider.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../widgets/appbar.dart';

GlobalKey<ScaffoldState> _globalKey = GlobalKey();

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String newPassword, confirmPassword;
  TextEditingController newPasswordController;
  TextEditingController confirmPasswordController;
  @override
  void initState() {
    newPasswordController = TextEditingController(text: "");
    confirmPasswordController = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final forgetPasswordProvider =
        Provider.of<ForgetPasswordProvider>(context, listen: false);
    return Scaffold(
        key: _globalKey,
        appBar: appBar(context, "Create new password"),
        body: Form(
            key: _formKey,
            child: CardSettings(children: <CardSettingsSection>[
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: AppLocalizations.of(context)
                        .translate('Create new password'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsPassword(
                      controller: newPasswordController,
                      label: AppLocalizations.of(context)
                          .translate('New password'),
                      onSaved: (value) => newPassword = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('New password is required');
                        }
                        return null;
                      },
                    ),
                    CardSettingsPassword(
                        controller: confirmPasswordController,
                        label: AppLocalizations.of(context)
                            .translate('Confirm password'),
                        onSaved: (value) => newPassword = value,
                        validator: (value) {
                          if (value == null) {
                            return AppLocalizations.of(context)
                                .translate('Confirm password is required');
                          } else if (value != newPasswordController.text) {
                            return AppLocalizations.of(context).translate(
                                'New password is not equal confirm password');
                          }
                          return null;
                        }),
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: AppLocalizations.of(context).translate('Actions'),
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context)
                            .translate("Create password"),
                        onPressed: () async {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            progressDialog(context);
                            forgetPasswordProvider
                                .changePassword(newPasswordController.text);
                            await UserApi().newPasswordForgetPassword(context);
                          }
                        }),
                    CardSettingsButton(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        label: AppLocalizations.of(context).translate("Reset"),
                        onPressed: () {
                          _formKey.currentState.reset();

                          newPasswordController.clear();
                          confirmPasswordController.clear();
                          setState(() {
                            newPassword = "";
                            confirmPassword = "";
                          });
                        }),
                  ])
            ])));
  }
}
