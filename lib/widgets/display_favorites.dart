//Imports for pubspec Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Models
import '../models/product.dart';

//Imports for Screen
import '../screens/product_detail_screen.dart';

class DisplayFavorites extends StatefulWidget {
  @override
  _DisplayFavoritesState createState() => _DisplayFavoritesState();
}

class _DisplayFavoritesState extends State<DisplayFavorites> {
  User user;
  List<Product> products = [];
  List<FavoriteProd> favoriteProd = [];

  @override
  void didChangeDependencies() {
    products = [];
    favoriteProd = [];
    user = FirebaseAuth.instance.currentUser;
    products = Provider.of<List<Product>>(context);

    favoriteProd = Provider.of<List<FavoriteProd>>(context);

    if (favoriteProd != null) {
      favoriteProd = favoriteProd
          .where((e) => e.userId.trim() == user.uid.trim())
          .toList();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return favoriteProd.length > 0
        ? Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: favoriteProd.length,
                itemBuilder: (BuildContext context, int index) {
                  final int prodIndex = products.indexWhere((prod) =>
                      prod.prodDocId == favoriteProd[index].prodDocId);

                  return Container(
                    decoration: BoxDecoration(
                        color: bBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProductDetailScreen.routeName,
                                      arguments: products[prodIndex].prodDocId);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Image(
                                    image: NetworkImage(
                                      products[prodIndex].imageUrlFeatured,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  color: bBackgroundColor,
                                  child: Text(
                                    products[prodIndex].prodName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${products[prodIndex].currencySymbol} - ${products[prodIndex].price}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          )
        : const Center(
            child: Text('Please Add Favorite products!!'),
          );
  }
}
