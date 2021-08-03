import 'package:flutter/material.dart';
import 'package:kaymarts/models/category_model.dart';
import 'package:kaymarts/services/categories_api.dart';
import 'package:kaymarts/ui/products/show_products_market_screen.dart';
import 'package:kaymarts/widgets/appbar.dart';
import 'package:kaymarts/widgets/bottom_animation.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import '../../app_localizations.dart';
import '../../my_app.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({this.marketId, this.deliveryPrice});
  final String marketId;
  final double deliveryPrice;

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future<List<CategoryModel>> futureCategories;
  @override
  void initState() {
    super.initState();
    print(lang);
    futureCategories = getCategories(context, widget.marketId);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5.1;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: appBar(context, "Categories"),
      bottomNavigationBar: bottomAnimation(context),
      body: FutureBuilder<List<CategoryModel>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CategoryModel> cateqoriesModel = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  childAspectRatio: (itemWidth / itemHeight),
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: List.generate(cateqoriesModel.length, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ShowProductsMarketScreen(
                                    cateqoriesModel[index].name,
                                    widget.marketId,
                                    cateqoriesModel[index].id.toString(),
                                    cateqoriesModel[index].name,
                                    widget.deliveryPrice)));
                      },
                      child: Container(
                        color: Theme.of(context).iconTheme.color,
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/shopping.png',
                                image: cateqoriesModel[index].photo,
                                height: 100,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ),
                            Text(
                              cateqoriesModel[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)
                  .translate("There are no categories available")),
            );
          }
          return Center(child: loadingPage(context));
        },
      ),
    );
  }
}
