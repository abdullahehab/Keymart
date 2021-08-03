import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/widgets/loading_page.dart';

Future<void> progressDialog(BuildContext context) async {
  return ArsProgressDialog(context,
          backgroundColor: Colors.blue[900],
          loadingWidget: loadingPage(context),
          dismissable: false)
      .show();
}
