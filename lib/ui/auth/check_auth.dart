import 'package:flutter/material.dart';
import 'package:kaymarts/caches/sharedpref/shared_preference_helper.dart';
import 'package:kaymarts/models/user_model.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/ui/home/home.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:provider/provider.dart';

String tokenId;

class CheckAuth extends StatelessWidget {
  CheckAuth({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return FutureBuilder<UserModel>(
      future: SharedPreferenceHelper().getUserPref(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: loadingPage(context));
          default:
            if (snapshot.data.uid == null)
              return HomeScreen(title: title);
            else
              WidgetsBinding.instance.addPostFrameCallback((_) {
                authProvider.changeUserModel(snapshot.data);
                tokenId = snapshot.data.tokenId;
              });
            return HomeScreen(title: title, user: snapshot.data.uid);
        }
      },
    );
  }
}
