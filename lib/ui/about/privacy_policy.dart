import 'package:flutter/material.dart';
import 'package:kaymarts/models/policy_model.dart';
import 'package:kaymarts/services/policy_api.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import '../../app_localizations.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  Future<List<PolicyModel>> futurePolicy;
  @override
  void initState() {
    super.initState();
    futurePolicy = getPolicy(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Privacy policy"),
      body: FutureBuilder<List<PolicyModel>>(
        future: futurePolicy,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PolicyModel> policyModel = snapshot.data;
            return ListView.builder(
                padding: EdgeInsets.all(12.0),
                itemCount: policyModel.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 0, top: 5),
                      child: Card(
                        shape: Border.all(color: Colors.grey[200], width: 1),
                        elevation: 0,
                        color: Colors.grey[50],
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.only(left: 12, right: 12),
                          expandedAlignment: Alignment.centerRight,
                          backgroundColor: Colors.white,
                          title: Text(
                            policyModel[index].title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          children: [
                            Text(
                              policyModel[index].description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]);
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)
                  .translate("There are no privacy policy")),
            );
          }
          return Center(child: loadingPage(context));
        },
      ),
    );
  }
}
