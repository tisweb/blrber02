import 'package:blrber/models/product.dart';
import 'package:blrber/screens/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayFavorites extends StatefulWidget {
  @override
  _DisplayFavoritesState createState() => _DisplayFavoritesState();
}

class _DisplayFavoritesState extends State<DisplayFavorites> {
  @override
  Widget build(BuildContext context) {
    print('check loc1 - display favorite');
    final user = FirebaseAuth.instance.currentUser;
    List<Product> products = Provider.of<List<Product>>(context);

    List<FavoriteProd> favoriteProd = Provider.of<List<FavoriteProd>>(context);

    if (favoriteProd != null) {
      favoriteProd = favoriteProd
          .where((e) => e.userId.trim() == user.uid.trim())
          .toList();
    }

    return favoriteProd.length > 0
        ? Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: favoriteProd.length,
                itemBuilder: (BuildContext context, int index) {
                  final int prodIndex = products.indexWhere((prod) =>
                      prod.prodDocId == favoriteProd[index].prodDocId);
                  print('prod index- $prodIndex');
                  return Column(
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
                                    BorderRadius.all(Radius.circular(12)),
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
                          flex: 2, child: Text(products[prodIndex].prodName)),
                    ],
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
        : Center(
            child: Text('Please add Favorite products!!'),
          );
  }
}
