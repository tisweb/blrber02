import 'package:blrber/models/category.dart';
import 'package:blrber/models/user_detail.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/screens/auth_screen.dart';
import 'package:blrber/screens/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:darq/darq.dart';

import '../models/product.dart';

class DisplayProductGrid extends StatefulWidget {
  final String inCatName;

  final String inProdCondition;
  final String inDisplayType;
  final List<String> inqueriedProdIdList;

  DisplayProductGrid({
    @required this.inCatName,
    @required this.inProdCondition,
    @required this.inDisplayType,
    this.inqueriedProdIdList,
  });

  @override
  _DisplayProductGridState createState() => _DisplayProductGridState();
}

class _DisplayProductGridState extends State<DisplayProductGrid> {
  String userId = "";

  bool isFavorite = false;
  bool _subCatTypeSelected = false;
  Icon favoriteIcon = Icon(Icons.favorite_border);

  String _countryCode = "";

  List<Product> productsQuery = [];

  List<UserDetail> userDetails = [];
  List<Product> products = [];
  User user;

  String _subCatDocId = "";
  List<SubCategory> subCategories, availableProdSC = [];
  List<FavoriteProd> favoriteProd = [];

  GetCurrentLocation getCurrentLocation = GetCurrentLocation();

  Future<void> _manageFavorite(String prodId, bool isFav, String userId) async {
    final _firestore = FirebaseFirestore.instance.collection('favoriteProd');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    if (isFav) {
      return _firestore.add({
        'prodDocId': prodId,
        'isFavorite': isFav,
        'userId': userId,
      });
    } else {
      return _firestore
          .where('prodDocId', isEqualTo: prodId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });
        return batch.commit();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initialGetInfo() {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      userId = "";
    } else {
      userId = user.uid;
      userDetails = Provider.of<List<UserDetail>>(context);
      if (userDetails.length > 0 && user != null) {
        var userData = userDetails
            .where((e) => e.userDetailDocId.trim() == userId.trim())
            .toList();
        if (userData.length > 0) {
          _countryCode = userData[0].buyingCountryCode;
        }
      }
    }
    // ProductDistance prodDis = ProductDistance();
    // List<ProductDistance> productDistance = [];
    print('------check1------');
    products = Provider.of<List<Product>>(context);
    print('------check2------');
    subCategories = Provider.of<List<SubCategory>>(context);
    print('------check3------');
    favoriteProd = Provider.of<List<FavoriteProd>>(context);
    getCurrentLocation = Provider.of<GetCurrentLocation>(context);

    if (_countryCode.isEmpty) {
      _countryCode = getCurrentLocation.countryCode;
    }

    if (products != null) {
      products = products
          .where((e) =>
              e.status == 'Verified' &&
              e.listingStatus == 'Available' &&
              e.countryCode == _countryCode)
          .toList();
    }

    if (products != null) {
      if (widget.inDisplayType == "Category") {
        if ((widget.inProdCondition == '') ||
            (widget.inProdCondition == 'ALL')) {
          products =
              products.where((e) => e.catName == widget.inCatName).toList();
        } else {
          products = products
              .where((e) =>
                  (e.catName == widget.inCatName) &&
                  (e.prodCondition == widget.inProdCondition))
              .toList();
        }
      } else if (widget.inDisplayType == "Search") {
        products = products
            .where((e) =>
                (e.catName
                    .toLowerCase()
                    .contains(widget.inCatName.split(" ")[0].toLowerCase())) ||
                (e.prodName
                    .toLowerCase()
                    .contains(widget.inCatName.split(" ")[0].toLowerCase())) ||
                (e.catName
                    .toLowerCase()
                    .contains(widget.inCatName.split(" ")[1].toLowerCase())) ||
                (e.prodName
                    .toLowerCase()
                    .contains(widget.inCatName.split(" ")[1].toLowerCase())) ||
                (e.make
                    .toLowerCase()
                    .contains(widget.inCatName.split(" ")[1].toLowerCase())))
            .toList();
      } else if (widget.inDisplayType == "Results" &&
          widget.inqueriedProdIdList != null) {
        productsQuery = [];
        for (var i = 0; i < widget.inqueriedProdIdList.length; i++) {
          List<Product> prodTemp = [];
          prodTemp = products
              .where((p) =>
                  p.prodDocId.trim() == widget.inqueriedProdIdList[i].trim())
              .toList();
          productsQuery = productsQuery + prodTemp;
        }

        products = productsQuery;
      }

      print('------check4------');
      availableProdSC = [];
      if (products.length > 0) {
        var distinctProductsSC =
            products.distinct((d) => d.subCatDocId.trim()).toList();

        print('prodCountryCode - ${distinctProductsSC.length}');

        if (distinctProductsSC.length > 0 && subCategories.length > 0) {
          for (var item in distinctProductsSC) {
            print('disting cc - ${item.countryCode}');
            SubCategory subCategory = SubCategory();
            print('------check4 1------');
            subCategory = subCategories.firstWhere(
                (e) => e.subCatDocId.trim() == item.subCatDocId.trim());
            print('------check4 2------');
            availableProdSC.add(subCategory);
            print('------check4 3------');
          }
        }

        print('------check5------');
        for (var i = 0; i < products.length; i++) {
          double distanceD = Geolocator.distanceBetween(
                  getCurrentLocation.latitude,
                  getCurrentLocation.longitude,
                  products[i].latitude,
                  products[i].longitude) /
              1000.round();

          String distanceS;
          if (distanceD != null) {
            distanceS = distanceD.round().toString();
          } else {
            distanceS = distanceD.toString();
          }

          products[i].distance = distanceS;
        }
        print('------check6------');

        if (_subCatTypeSelected) {
          products = products
              .where((e) => e.subCatDocId.trim() == _subCatDocId.trim())
              .toList();
        }

        products.sort((a, b) {
          var aDistance = a.distance;
          var bDistance = b.distance;
          return aDistance.compareTo(bDistance);
        });
        print('------check7------');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // call function to convert
  // Future<String> getAmounts(
  //     String prodCurrency, String prodPrice, String currenctCurrency) async {
  //   print('price before double - $prodPrice');
  //   double prodPriceDouble = double.parse(prodPrice);
  //   var amountConverted = await MoneyConverter.convert(
  //       Currency(Currency.INR, amount: prodPriceDouble),
  //       Currency(Currency.SEK));
  //   // setState(() {
  //   return _convertedPrice = amountConverted.toString();
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    _initialGetInfo();
    // final user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   userId = "";
    // } else {
    //   userId = user.uid;
    //   final List<UserDetail> userDetails =
    //       Provider.of<List<UserDetail>>(context);
    //   if (userDetails.length > 0 && user != null) {
    //     userData = userDetails
    //         .firstWhere((e) => e.userDetailDocId.trim() == userId.trim());
    //     if (userData != null) {
    //       _countryCode = userData.buyingCountryCode;
    //       print('userupdate display product grid');
    //     }
    //   }
    // }
    // // ProductDistance prodDis = ProductDistance();
    // // List<ProductDistance> productDistance = [];
    // print('------check1------');
    // List<Product> products = Provider.of<List<Product>>(context);
    // print('------check2------');
    // List<SubCategory> subCategories = Provider.of<List<SubCategory>>(context);
    // print('------check3------');
    // List<FavoriteProd> favoriteProd = Provider.of<List<FavoriteProd>>(context);
    // final getCurrentLocation = Provider.of<GetCurrentLocation>(context);

    // if (_countryCode.isEmpty) {
    //   _countryCode = getCurrentLocation.countryCode;
    // }

    // if (products != null) {
    //   products = products
    //       .where((e) =>
    //           e.status == 'Verified' &&
    //           e.listingStatus == 'Available' &&
    //           e.countryCode == _countryCode)
    //       .toList();
    // }

    // if (products != null) {
    //   if (widget.inDisplayType == "Category") {
    //     if ((widget.inProdCondition == '') ||
    //         (widget.inProdCondition == 'ALL')) {
    //       products =
    //           products.where((e) => e.catName == widget.inCatName).toList();
    //     } else {
    //       products = products
    //           .where((e) =>
    //               (e.catName == widget.inCatName) &&
    //               (e.prodCondition == widget.inProdCondition))
    //           .toList();
    //     }
    //   } else if (widget.inDisplayType == "Search") {
    //     products = products
    //         .where((e) =>
    //             (e.catName.toLowerCase() == widget.inCatName.toLowerCase()) ||
    //             (e.prodName
    //                 .toLowerCase()
    //                 .contains(widget.inCatName.toLowerCase())))
    //         .toList();
    //   } else if (widget.inDisplayType == "Results" &&
    //       widget.inqueriedProdIdList != null) {
    //     productsQuery = [];
    //     for (var i = 0; i < widget.inqueriedProdIdList.length; i++) {
    //       List<Product> prodTemp = [];
    //       prodTemp = products
    //           .where((p) =>
    //               p.prodDocId.trim() == widget.inqueriedProdIdList[i].trim())
    //           .toList();
    //       productsQuery = productsQuery + prodTemp;
    //     }

    //     products = productsQuery;
    //   }

    //   print('------check4------');
    //   availableProdSC = [];
    //   if (products.length > 0) {
    //     var distinctProductsSC =
    //         products.distinct((d) => d.subCatDocId.trim()).toList();

    //     print('prodCountryCode - ${distinctProductsSC.length}');

    //     if (distinctProductsSC.length > 0 && subCategories.length > 0) {
    //       for (var item in distinctProductsSC) {
    //         print('disting cc - ${item.countryCode}');
    //         SubCategory subCategory = SubCategory();
    //         print('------check4 1------');
    //         subCategory = subCategories.firstWhere(
    //             (e) => e.subCatDocId.trim() == item.subCatDocId.trim());
    //         print('------check4 2------');
    //         availableProdSC.add(subCategory);
    //         print('------check4 3------');
    //       }
    //     }

    //     print('------check5------');
    //     for (var i = 0; i < products.length; i++) {
    //       double distanceD = Geolocator.distanceBetween(
    //               getCurrentLocation.latitude,
    //               getCurrentLocation.longitude,
    //               products[i].latitude,
    //               products[i].longitude) /
    //           1000.round();

    //       String distanceS;
    //       if (distanceD != null) {
    //         distanceS = distanceD.round().toString();
    //       } else {
    //         distanceS = distanceD.toString();
    //       }

    //       products[i].distance = distanceS;
    //     }
    //     print('------check6------');

    //     if (_subCatTypeSelected) {
    //       products = products
    //           .where((e) => e.subCatDocId.trim() == _subCatDocId.trim())
    //           .toList();
    //     }

    //     products.sort((a, b) {
    //       var aDistance = a.distance;
    //       var bDistance = b.distance;
    //       return aDistance.compareTo(bDistance);
    //     });
    //     print('------check7------');
    //   }
    // }

    print(' @@@@@@@@@@@ %%%%% selected prod length - ${products.length}');
    return (products.length > 0)
        ? Container(
            // color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  if (availableProdSC.length > 0)
                    if (widget.inDisplayType != "Results" &&
                        widget.inDisplayType != "Search")
                      Flexible(
                        // flex: 3,
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height / 6,
                          // padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (availableProdSC.length > 1)
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        child: Text('All'),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _subCatTypeSelected = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              Flexible(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: availableProdSC.length,
                                    itemBuilder: (BuildContext context, int s) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        // height: double.infinity,

                                        child: GestureDetector(
                                          child: Column(
                                            // direction: Axis.vertical,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                    availableProdSC[s].imageUrl,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                    '${availableProdSC[s].subCatType}'),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _subCatTypeSelected = true;
                                              _subCatDocId = availableProdSC[s]
                                                  .subCatDocId;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  SizedBox(
                    height: 5,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  Flexible(
                    // flex: 9,
                    // height: MediaQuery.of(context).size.height / 2.2,
                    child: GridView.builder(
                      // physics: ClampingScrollPhysics(),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,

                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int j) {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProductDetailScreen.routeName,
                                  arguments: products[j].prodDocId);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Stack(
                                    children: [
                                      // products[j].imageUrlFeatured != null
                                      // ?
                                      FractionallySizedBox(
                                        widthFactor:
                                            1.0, // width w.r.t to parent
                                        heightFactor:
                                            1.0, // height w.r.t to parent
                                        child: ClipRRect(
                                          child: Image(
                                            image: NetworkImage(
                                              products[j].imageUrlFeatured,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      // : Container(
                                      //     child: Center(
                                      //       child: Text('Image Loading...'),
                                      //     ),
                                      //   ),
                                      Positioned(
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              icon: Icon(
                                                (favoriteProd.any((prod) =>
                                                        prod.prodDocId ==
                                                            products[j]
                                                                .prodDocId &&
                                                        prod.userId == userId))
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                color: Colors.redAccent,
                                                size: 27,
                                              ),
                                              color: Colors.redAccent,
                                              onPressed: () {
                                                if ((favoriteProd.any((prod) =>
                                                    prod.prodDocId ==
                                                        products[j].prodDocId &&
                                                    prod.userId == userId))) {
                                                  print('click f');
                                                  isFavorite = false;
                                                } else {
                                                  print('click s');
                                                  isFavorite = true;
                                                }
                                                if (user == null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) {
                                                          return AuthScreen();
                                                        },
                                                        fullscreenDialog: true),
                                                  );
                                                } else {
                                                  print(
                                                      'check fav - $isFavorite');
                                                  if (userId.isEmpty ||
                                                      userId == null) {
                                                    return AuthScreen();
                                                  }

                                                  _manageFavorite(
                                                      products[j].prodDocId,
                                                      isFavorite,
                                                      userId);
                                                }
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      widget.inDisplayType == "Results"
                                          ? Flexible(
                                              child: Text(
                                                products[j].prodName.length > 35
                                                    ? products[j]
                                                            .prodName
                                                            .substring(0, 35) +
                                                        '...'
                                                    : products[j].prodName,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Flexible(
                                              child: Text(
                                                products[j].prodName.length > 15
                                                    ? products[j]
                                                            .prodName
                                                            .substring(0, 15) +
                                                        '...'
                                                    : products[j].prodName,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        text: products[j].currencySymbol,
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' ',
                                          ),
                                          TextSpan(
                                            text: products[j].price,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Distance : ',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: products[j].distance,
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                ),
                                                TextSpan(
                                                  text: 'KM',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.centerLeft,
                                      //   child: RichText(
                                      //     text: TextSpan(
                                      //       text: 'Condition : ',
                                      //       style: TextStyle(
                                      //         color:
                                      //             Theme.of(context).disabledColor,
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.normal,
                                      //       ),
                                      //       children: [
                                      //         TextSpan(
                                      //           text: products[j].prodCondition,
                                      //           style: TextStyle(
                                      //               color: products[j]
                                      //                           .prodCondition
                                      //                           .trim()
                                      //                           .toLowerCase() ==
                                      //                       'new'
                                      //                   ? Colors.green
                                      //                   : Colors.red),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      Flexible(
                                        child: Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            widget.inDisplayType == "Results" ? 1 : 2,
                        childAspectRatio: 4 / 4,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Text('Oops!! Products not found... ');
  }
}
