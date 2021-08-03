import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/functions/progress_dialog.dart';
import 'package:kaymarts/models/user_model.dart';
import 'package:kaymarts/services/user_api.dart';
import 'package:flutter/material.dart';
import '../../app_localizations.dart';

class RegisterationScreen extends StatefulWidget {
  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  String fullname, email, phone, password, confirmPassword;
  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _phoneController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            AppLocalizations.of(context).translate('KayMart'),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.jetBrainsMono,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNameRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _fullNameController,
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate("Name is empty")
            : null,
        onChanged: (value) {
          setState(() {
            fullname = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
            ),
            labelText: AppLocalizations.of(context).translate('Name')),
      ),
    );
  }

  Widget _buildPhoneRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: _phoneController,
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate("Phone is empty")
            : value.length != 11
                ? AppLocalizations.of(context)
                    .translate("Phone number is equal to 11")
                : null,
        onChanged: (value) {
          setState(() {
            phone = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
            ),
            labelText: AppLocalizations.of(context).translate('Phone')),
      ),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate("Email is empty")
            : null,
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
            ),
            labelText: AppLocalizations.of(context).translate('Email')),
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
            : value.length < 8
                ? AppLocalizations.of(context)
                    .translate("Password must be grater than or equal 8")
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

  Widget _buildConfirmPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _confirmPasswordController,
        obscureText: true,
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate("Password is empty")
            : value != _passwordController.text
                ? AppLocalizations.of(context)
                    .translate("Confirm password is not equal password")
                : null,
        onChanged: (value) {
          setState(() {
            confirmPassword = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
          ),
          labelText: AppLocalizations.of(context).translate('Confirm password'),
        ),
      ),
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
                UserModel _userModel = UserModel(
                  displayName: _fullNameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                  password: _passwordController.text,
                );
                progressDialog(context);
                await UserApi().createUser(context, _userModel);
                _formKey.currentState.reset();
                _fullNameController.clear();
                _emailController.clear();
                _phoneController.clear();
                _passwordController.clear();
                _confirmPasswordController.clear();
              }
            },
            child: Text(
              AppLocalizations.of(context).translate("Register"),
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
            height: MediaQuery.of(context).size.height * 0.8,
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
                      AppLocalizations.of(context).translate("Register"),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ],
                ),
                _buildNameRow(),
                _buildEmailRow(),
                _buildPhoneRow(),
                _buildPasswordRow(),
                _buildConfirmPasswordRow(),
                SizedBox(height: 30),
                _buildLoginButton(),
                Wrap(children: [
                  Text(
                      AppLocalizations.of(context)
                          .translate("By creating an account you agree to the"),
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text(" "),
                  InkWell(
                    onTap: () {
                      final newRouteName = "/privacyPolicyScreen";
                      bool isNewRouteSameAsCurrent = false;
                      Navigator.popUntil(context, (route) {
                        if (route.settings.name == newRouteName) {
                          isNewRouteSameAsCurrent = true;
                        }
                        return true;
                      });
                      if (!isNewRouteSameAsCurrent) {
                        Navigator.pushNamed(context, newRouteName);
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("privacy policy"),
                        style: TextStyle(
                            color: Colors.deepOrangeAccent, fontSize: 14)),
                  ),
                  Text(AppLocalizations.of(context).translate("and to the"),
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  InkWell(
                    onTap: () {
                      final newRouteName = "/termsUseScreen";
                      bool isNewRouteSameAsCurrent = false;
                      Navigator.popUntil(context, (route) {
                        if (route.settings.name == newRouteName) {
                          isNewRouteSameAsCurrent = true;
                        }
                        return true;
                      });
                      if (!isNewRouteSameAsCurrent) {
                        Navigator.pushNamed(context, newRouteName);
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context).translate("terms of use"),
                        style: TextStyle(
                            color: Colors.deepOrangeAccent, fontSize: 14)),
                  )
                ])
              ],
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.blue[900],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          resizeToAvoidBottomInset: true,
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
                      SizedBox(height: 50),
                      _buildContainer(),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
