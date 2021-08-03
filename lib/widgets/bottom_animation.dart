import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/providers/bottom_animation_provider.dart';
import 'package:kaymarts/providers/favorite_provider.dart';
import 'package:kaymarts/widgets/alert_login.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';

Widget bottomAnimation(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  return Consumer<CIndexProvider>(builder: (context, cIndexProvider, _) {
    return BottomNavigationBar(
        currentIndex: cIndexProvider.getCIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[900],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: (value) {
          if (value == 0) {
            cIndexProvider.changeCIndex(value);
            final newRouteName = "/home";
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
          } else if (value == 1) {
            if (authProvider.userModel == null) {
              alertLogin(context);
            } else {
              cIndexProvider.changeCIndex(value);
              final newRouteName = "/profileScreen";
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
            }
          } else if (value == 2) {
            cIndexProvider.changeCIndex(value);
            final newRouteName = "/favoriteScreen";
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
          } else {
            cIndexProvider.changeCIndex(value);
            final newRouteName = "/aboutScreen";
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
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context).translate('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: AppLocalizations.of(context).translate('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, _) {
              return FlutterBadge(
                  hideZeroCount: true,
                  icon: Icon(
                    Icons.favorite,
                  ),
                  borderRadius: 20.0,
                  itemCount: favoriteProvider.getCount);
            }),
            label: AppLocalizations.of(context).translate('Favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: AppLocalizations.of(context).translate('About us'),
          ),
        ]);
  });
}
