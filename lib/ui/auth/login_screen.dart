import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/models/user_model.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:kaymarts/widgets/forget_password.dart';
import 'package:kaymarts/ui/auth/registeration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String identify, password;
  TextEditingController _identifyController;
  TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _identifyController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _identifyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Text(
            AppLocalizations.of(context).translate('KayMart'),
            style: TextStyle(
              fontFamily: AppFontFamily.jetBrainsMono,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildIdentifyRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _identifyController,
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate("Phone is empty")
            : null,
        onChanged: (value) {
          setState(() {
            identify = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
            ),
            labelText:
                AppLocalizations.of(context).translate('Email or Phone')),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _passwordController,
        obscureText: true,
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate("Password is empty")
            : null,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
          ),
          labelText: AppLocalizations.of(context).translate('Password'),
        ),
      ),
    );
  }

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () {
            openAlertBoxForgetPassword(context);
          },
          child: Text(
            AppLocalizations.of(context).translate("Forgot Password"),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.reset();
                UserModel _userModel = UserModel(
                  identify: _identifyController.text,
                  password: _passwordController.text,
                );
                progressDialog(context);
                await UserApi().loginUser(context, _userModel);
              }
            },
            child: Text(
              AppLocalizations.of(context).translate("Login"),
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate("Login"),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                _buildIdentifyRow(),
                _buildPasswordRow(),
                _buildForgetPasswordButton(),
                SizedBox(height: 15),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterationScreen()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: AppLocalizations.of(context)
                      .translate("Dont have an account? "),
                  style: TextStyle(
                    fontFamily: languageProvider.appLocale == Locale('en')
                        ? AppFontFamily.jetBrainsMono
                        : AppFontFamily.elMessiri,
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).translate('Register'),
                  style: TextStyle(
                    fontFamily: languageProvider.appLocale == Locale('en')
                        ? AppFontFamily.jetBrainsMono
                        : AppFontFamily.elMessiri,
                    color: Theme.of(context).iconTheme.color,
                    fontSize: MediaQuery.of(context).size.height / 50,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xfff2f3f7),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(70),
                          bottomRight: const Radius.circular(70),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLogo(),
                      _buildContainer(),
                      _buildSignUpBtn(),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
