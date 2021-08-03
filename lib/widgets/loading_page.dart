import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingPage(BuildContext context) {
  return SpinKitHourGlass(
    color: Theme.of(context).iconTheme.color,
    size: 50.0,
  );
}
