import 'package:blrber/models/product.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/provider/motor_form_sqldb_provider.dart';
import 'package:blrber/provider/prod_images_sqldb_provider.dart';
import 'package:blrber/screens/edit_post.dart';
import 'package:blrber/screens/generate_post.dart';
import 'package:blrber/screens/product_detail_screen.dart';
import 'package:blrber/services/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class DisplayProductCatalog extends StatefulWidget {
  final String adminUserPermission;
  DisplayProductCatalog({Key key, this.adminUserPermission}) : super(key: key);

  @override
  _DisplayProductCatalogState createState() =>
      new _DisplayProductCatalogState();
}

class _DisplayProductCatalogState extends State<DisplayProductCatalog>
    with SingleTickerProviderStateMixin {
  static const _PANEL_HEADER_HEIGHT = 32.0;

  AnimationController _controller;

  // Initialization for product catalog

  String userId = "";

  bool isGrid = false;
  bool _readyToEdit = false;
  String _prodDeleted = '';
  dynamic motorFormProvider;
  dynamic prodImageProvider;
  GetCurrentLocation getCurrentLocation;
  int _prodFormCount = 0;
  int _totalVerifiedProducts = 0;
  int _totalPendingProducts = 0;
  int _totalSoldProducts = 0;
  int _totalProducts, _totalAvailableProducts, _totalUnavailableProducts = 0;

  List<Product> products, productsAll, productsCurrentUser = [];

  String _currencySymbol = "";
  String _currencyName = "";
  List<Product> productsQuery = [];

  //

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
    // init state for product catalog

    motorFormProvider =
        Provider.of<MotorFormSqlDbProvider>(context, listen: false);
    prodImageProvider =
        Provider.of<ProdImagesSqlDbProvider>(context, listen: false);

    //
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // functions for product catalog
  Future<void> _deleteProduct(String prodId, String category) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return await FirebaseFirestore.instance
        .collection('products')
        .doc(prodId)
        .delete()
        .then((value) async {
      if (category.toLowerCase().trim() == 'car'.trim() ||
          category.toLowerCase().trim() == 'truck'.trim() ||
          category.toLowerCase().trim() == 'motorbike'.trim()) {
        await FirebaseFirestore.instance
            .collection('CtmSpecialInfo')
            .where('prodDocId', isEqualTo: prodId)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            batch.delete(document.reference);
          });
          return batch.commit().catchError((error) => print(
              "Failed to delete products in CtmSpecialInfo batch: $error"));
        }).catchError((error) =>
                print("Failed to get product in CtmSpecialInfo: $error"));
      }

      batch = FirebaseFirestore.instance.batch();

      await FirebaseFirestore.instance
          .collection('ProdImages')
          .where('prodDocId', isEqualTo: prodId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });
        setState(() {
          _prodDeleted = 'true';
        });
        return batch.commit().catchError((error) =>
            print("Failed to delete products in ProdImages: $error"));
      });

      batch = FirebaseFirestore.instance.batch();

      await FirebaseFirestore.instance
          .collection('favoriteProd')
          .where('prodDocId', isEqualTo: prodId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });
        return batch.commit().catchError((error) =>
            print("Failed to delete products in favoriteProd: $error"));
      });
    }).catchError((error) => print("Failed to delete product: $error"));
  }

  Future<void> _deleteMotorFormAll() async {
    int count = await motorFormProvider.countMotorForm();
    setState(() {
      _prodFormCount = count;
    });

    if (_prodFormCount > 0) {
      await motorFormProvider.deleteMotorFormAll();
    }
  }

  Future<void> _saveMotorForm(MotorFormSqlDb motorFormSqlDb) async {
    await motorFormProvider.addMotorForm(motorFormSqlDb);
  }

  Future<void> _saveImage(ProdImagesSqlDb prodImageSqlDb) async {
    await prodImageProvider.addImages(prodImageSqlDb);
  }

  Future<void> _deleteImageAll() async {
    int countE = await prodImageProvider.countEProdImages();
    int countI = await prodImageProvider.countIProdImages();
    int count = countE + countI;
    if (count > 0) {
      await prodImageProvider.deleteImagesAll();
    }
  }

  Future<bool> _editProduct(String prodId) async {
    _readyToEdit = false;

    await _deleteMotorFormAll();
    await _deleteImageAll();

    MotorFormSqlDb motorFormSqlDb = MotorFormSqlDb();

    await FirebaseFirestore.instance
        .collection('products')
        .doc(prodId)
        .get()
        .then((DocumentSnapshot productDoc) async {
      if (productDoc.exists) {
        if (productDoc.data()["catName"].toLowerCase().trim() == 'car'.trim() ||
            productDoc.data()["catName"].toLowerCase().trim() ==
                'truck'.trim() ||
            productDoc.data()["catName"].toLowerCase().trim() ==
                'motorbike'.trim()) {
          await FirebaseFirestore.instance
              .collection('CtmSpecialInfo')
              .where('prodDocId', isEqualTo: prodId)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((ctmSpecialInfoDoc) async {
              motorFormSqlDb.catName = productDoc.data()["catName"];
              motorFormSqlDb.subCatDocId = productDoc.data()["subCatDocId"];
              motorFormSqlDb.prodDes = productDoc.data()["prodDes"];
              motorFormSqlDb.sellerNotes = productDoc.data()["sellerNotes"];
              motorFormSqlDb.prodCondition = productDoc.data()["prodCondition"];
              motorFormSqlDb.price = productDoc.data()["price"];
              motorFormSqlDb.imageUrlFeatured =
                  productDoc.data()["imageUrlFeatured"];
              motorFormSqlDb.deliveryInfo = productDoc.data()["deliveryInfo"];
              motorFormSqlDb.year = productDoc.data()["year"];
              motorFormSqlDb.make = productDoc.data()["make"];
              motorFormSqlDb.model = productDoc.data()["model"];
              motorFormSqlDb.vehicleType =
                  ctmSpecialInfoDoc.data()["vehicleType"];
              motorFormSqlDb.mileage = ctmSpecialInfoDoc.data()["mileage"];
              motorFormSqlDb.vin = ctmSpecialInfoDoc.data()["vin"];
              motorFormSqlDb.engine = ctmSpecialInfoDoc.data()["engine"];
              motorFormSqlDb.fuelType = ctmSpecialInfoDoc.data()["fuelType"];
              motorFormSqlDb.options = ctmSpecialInfoDoc.data()["options"];
              motorFormSqlDb.subModel = ctmSpecialInfoDoc.data()["subModel"];
              motorFormSqlDb.numberOfCylinders =
                  ctmSpecialInfoDoc.data()["numberOfCylinders"];
              motorFormSqlDb.safetyFeatures =
                  ctmSpecialInfoDoc.data()["safetyFeatures"];
              motorFormSqlDb.driveType = ctmSpecialInfoDoc.data()["driveType"];
              motorFormSqlDb.interiorColor =
                  ctmSpecialInfoDoc.data()["interiorColor"];
              motorFormSqlDb.bodyType = ctmSpecialInfoDoc.data()["bodyType"];
              motorFormSqlDb.exteriorColor =
                  ctmSpecialInfoDoc.data()["exteriorColor"];
              motorFormSqlDb.forSaleBy = ctmSpecialInfoDoc.data()["forSaleBy"];
              motorFormSqlDb.warranty = ctmSpecialInfoDoc.data()["warranty"];
              motorFormSqlDb.trim = ctmSpecialInfoDoc.data()["trim"];
              motorFormSqlDb.transmission =
                  ctmSpecialInfoDoc.data()["transmission"];
              motorFormSqlDb.steeringLocation =
                  ctmSpecialInfoDoc.data()["steeringLocation"];
              motorFormSqlDb.vehicleTypeYear =
                  ctmSpecialInfoDoc.data()["vehicleTypeYear"];
              motorFormSqlDb.editPost = 'true';
              _saveMotorForm(motorFormSqlDb);
            });
          }).catchError((error) =>
                  print("Failed to get product in CtmSpecialInfo: $error"));
        } else {
          motorFormSqlDb.catName = productDoc.data()["catName"];
          motorFormSqlDb.subCatDocId = productDoc.data()["subCatDocId"];
          motorFormSqlDb.prodDes = productDoc.data()["prodDes"];
          motorFormSqlDb.sellerNotes = productDoc.data()["sellerNotes"];
          motorFormSqlDb.prodCondition = productDoc.data()["prodCondition"];
          motorFormSqlDb.price = productDoc.data()["price"];
          motorFormSqlDb.imageUrlFeatured =
              productDoc.data()["imageUrlFeatured"];
          motorFormSqlDb.deliveryInfo = productDoc.data()["deliveryInfo"];
          motorFormSqlDb.year = productDoc.data()["year"];
          motorFormSqlDb.make = productDoc.data()["make"];
          motorFormSqlDb.model = productDoc.data()["model"];
          motorFormSqlDb.editPost = 'true';

          await _saveMotorForm(motorFormSqlDb);
        }

        await FirebaseFirestore.instance
            .collection('ProdImages')
            .where('prodDocId', isEqualTo: prodId.trim())
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            ProdImagesSqlDb prodImageSqlDb = ProdImagesSqlDb();

            if (document.data()["featuredImage"] == true) {
              prodImageSqlDb.featuredImage = 'true';
            } else {
              prodImageSqlDb.featuredImage = 'false';
            }

            prodImageSqlDb.imageType = document.data()["imageType"];

            prodImageSqlDb.imageUrl = document.data()["imageUrl"];

            _saveImage(prodImageSqlDb);

            _readyToEdit = true;
          });
        });
      } else {
        print("Product data not exist for - $prodId");
      }
    }).catchError((error) => print("Failed to get product: $error"));

    return _readyToEdit;
  }

  void _showDeleteDialog(String prodDocId, String prodName, String catName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Product?"),
          content: Container(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(prodName),
                  Text('Do you want to Delete this Item?'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  _prodDeleted = 'false';
                });

                _deleteProduct(prodDocId, catName).then((value) {
                  print('product deleted successfully1111! - $_prodDeleted');
                  Navigator.of(context).pop();
                  if (_prodDeleted == 'true') {
                    print('product deleted successfully!');
                    setState(() {
                      _prodDeleted = '';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product Deleted!'),
                      ),
                    );
                  }
                });
                if (_prodDeleted == 'false') {
                  print('product deleted successfully!');
                  setState(() {
                    _prodDeleted = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleting Product...'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unable to Edit!!"),
          content: Container(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Not able to edit this Item?'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //

  // did change and functions for product catalog

  @override
  void didChangeDependencies() {
    _getProducts();
    super.didChangeDependencies();
  }

  void _getProducts() {
    print('check loc1 - product catalog');
    final user = FirebaseAuth.instance.currentUser;

    productsAll = Provider.of<List<Product>>(context);
    getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    _currencyName = getCurrentLocation.currencyCode;
    _currencySymbol = getCurrencySymbolByName(_currencyName);

    if (productsAll != null) {
      if (widget.adminUserPermission == 'edit' ||
          widget.adminUserPermission == 'view') {
      } else {
        productsAll = productsAll
            .where((e) => e.userDetailDocId.trim() == user.uid.trim())
            .toList();
      }

      products = productsAll;

      _totalVerifiedProducts = 0;
      _totalPendingProducts = 0;
      _totalSoldProducts = 0;
      _totalProducts = 0;
      _totalAvailableProducts = 0;
      _totalUnavailableProducts = 0;

      setState(() {
        if (products.any((e) => e.status.trim() == 'Verified')) {
          _totalVerifiedProducts =
              products.where((e) => e.status.trim() == 'Verified').length;
        }
        if (products.any((e) => e.status.trim() == 'Pending')) {
          _totalPendingProducts =
              products.where((e) => e.status.trim() == 'Pending').length;
        }
        if (products.any((e) => e.listingStatus.trim() == 'Sold')) {
          _totalSoldProducts =
              products.where((e) => e.listingStatus.trim() == 'Sold').length;
        }
        if (products.any((e) => e.listingStatus.trim() == 'Available')) {
          _totalAvailableProducts = products
              .where((e) => e.listingStatus.trim() == 'Available')
              .length;
        }
        if (products.any((e) => e.listingStatus.trim() == 'Unavailable')) {
          _totalUnavailableProducts = products
              .where((e) => e.listingStatus.trim() == 'Unavailable')
              .length;
        }
        _totalProducts = products.length;
      });

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

      products.sort((a, b) {
        var aDistance = a.distance;
        var bDistance = b.distance;
        return aDistance.compareTo(bDistance);
      });
    }
  }

  void _getProductsForAdmin(String adminViewFlag) {
    setState(() {
      products = productsAll;
    });
    if (adminViewFlag == 'Verified') {
      setState(() {
        products =
            products.where((e) => e.status.trim() == 'Verified').toList();
      });
    } else if (adminViewFlag == 'Pending') {
      setState(() {
        products = products.where((e) => e.status.trim() == 'Pending').toList();
      });
    } else if (adminViewFlag == 'Sold') {
      setState(() {
        products =
            products.where((e) => e.listingStatus.trim() == 'Sold').toList();
      });
    } else if (adminViewFlag == 'Available') {
      setState(() {
        products = products
            .where((e) => e.listingStatus.trim() == 'Available')
            .toList();
      });
    } else if (adminViewFlag == 'Unavailable') {
      setState(() {
        products = products
            .where((e) => e.listingStatus.trim() == 'Unavailable')
            .toList();
      });
    }

    if (products.length > 0) {
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

      products.sort((a, b) {
        var aStatus = a.status;
        var bStatus = b.status;
        return aStatus.compareTo(bStatus);
      });
    }
  }

  Future<void> _updateStatus(String prodDocId, String status) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(prodDocId)
        .update({'status': status})
        .then((value) => print("product Status Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  Future<void> _updateListingStatus(
      String prodDocId, String listingStatus) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(prodDocId)
        .update({'listingStatus': listingStatus})
        .then((value) => print("product Listing Status Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  //

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);

    return new Container(
      color: theme.primaryColor,
      width: double.infinity,
      child: new Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _getProductsForAdmin('Verified');
                                  });

                                  _controller.fling(
                                      velocity: _isPanelVisible ? -1.0 : 1.0);
                                },
                                title: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text('Verified'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_totalVerifiedProducts.toString()),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: 20,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                color: Colors.green,
                                child: Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _getProductsForAdmin('Pending');
                                  });

                                  _controller.fling(
                                      velocity: _isPanelVisible ? -1.0 : 1.0);
                                },
                                title: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text('Pending'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_totalPendingProducts.toString()),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: 20,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                color: Colors.yellow,
                                child: Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _getProductsForAdmin('Sold');
                                  });

                                  _controller.fling(
                                      velocity: _isPanelVisible ? -1.0 : 1.0);
                                },
                                title: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text('Sold'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_totalSoldProducts.toString()),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: 20,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                color: Colors.red,
                                child: Icon(
                                  FontAwesomeIcons.accessibleIcon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _getProductsForAdmin('Available');
                                  });

                                  _controller.fling(
                                      velocity: _isPanelVisible ? -1.0 : 1.0);
                                },
                                title: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text('Available'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_totalAvailableProducts.toString()),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: 20,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                color: Colors.green,
                                child: Icon(
                                  FontAwesomeIcons.accessibleIcon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _getProductsForAdmin('Unavailable');
                                  });

                                  _controller.fling(
                                      velocity: _isPanelVisible ? -1.0 : 1.0);
                                },
                                title: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text('Unavailable'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          _totalUnavailableProducts.toString()),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: 20,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                color: Colors.orange,
                                child: Icon(
                                  FontAwesomeIcons.accessibleIcon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _getProductsForAdmin('All');
                                  });

                                  _controller.fling(
                                      velocity: _isPanelVisible ? -1.0 : 1.0);
                                },
                                title: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text('All'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_totalProducts.toString()),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: 20,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                color: Colors.blue,
                                child: Icon(
                                  FontAwesomeIcons.accessibleIcon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          new PositionedTransition(
            rect: animation,
            child: new Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0)),
              elevation: 12.0,
              child: new Column(children: <Widget>[
                new Container(
                  height: _PANEL_HEADER_HEIGHT,
                  child: Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: !isGrid
                          ? IconButton(
                              icon: Icon(Icons.grid_on),
                              onPressed: () {
                                setState(() {
                                  isGrid = true;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.list_outlined),
                              onPressed: () {
                                setState(() {
                                  isGrid = false;
                                });
                              },
                            ),
                    ),
                  ),
                ),
                (products.length > 0)
                    ? Expanded(
                        child: Scrollbar(
                          child: isGrid
                              ? GridView.builder(
                                  padding: const EdgeInsets.all(10.0),
                                  itemCount: products.length,
                                  itemBuilder: (BuildContext context, int j) {
                                    return Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(5),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ProductDetailScreen.routeName,
                                              arguments: products[j].prodDocId);
                                        },
                                        title: Column(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                child: products[j]
                                                            .imageUrlFeatured !=
                                                        null
                                                    ? Image(
                                                        image: NetworkImage(
                                                          products[j]
                                                              .imageUrlFeatured,
                                                        ),
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Container(
                                                        child: Center(
                                                          child: Text(
                                                              'Image Loading...'),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    products[j]
                                                                .prodName
                                                                .length >
                                                            25
                                                        ? products[j]
                                                                .prodName
                                                                .substring(
                                                                    0, 25) +
                                                            '...'
                                                        : products[j].prodName,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Row(
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: _currencySymbol,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: ' ',
                                                            ),
                                                            TextSpan(
                                                              text: products[j]
                                                                  .price,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'Status : ',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: products[j]
                                                                  .status,
                                                              style: TextStyle(
                                                                color: products[j]
                                                                            .status ==
                                                                        'Verified'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(products[j]
                                                          .listingStatus)
                                                    ],
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Created at :',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: ' ',
                                                        ),
                                                        TextSpan(
                                                          text: products[j]
                                                              .createdAt
                                                              .toDate()
                                                              .month
                                                              .toString(),
                                                        ),
                                                        TextSpan(
                                                          text: '-',
                                                        ),
                                                        TextSpan(
                                                          text: products[j]
                                                              .createdAt
                                                              .toDate()
                                                              .day
                                                              .toString(),
                                                        ),
                                                        TextSpan(
                                                          text: '-',
                                                        ),
                                                        TextSpan(
                                                          text: products[j]
                                                              .createdAt
                                                              .toDate()
                                                              .year
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (widget.adminUserPermission ==
                                                          'edit' ||
                                                      widget.adminUserPermission ==
                                                          'view')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Status:'),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          child:
                                                              CustomRadioButton(
                                                            enableButtonWrap:
                                                                true,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4.5,
                                                            // horizontal: true,
                                                            unSelectedColor:
                                                                Theme.of(
                                                                        context)
                                                                    .canvasColor,
                                                            buttonLables: [
                                                              'Verified',
                                                              'Pending',
                                                            ],
                                                            buttonValues: [
                                                              "Verified",
                                                              "Pending",
                                                            ],
                                                            defaultSelected:
                                                                products[j]
                                                                    .status,
                                                            radioButtonValue:
                                                                (value) {
                                                              setState(() {
                                                                _updateStatus(
                                                                    products[j]
                                                                        .prodDocId,
                                                                    value);
                                                              });
                                                            },
                                                            selectedColor:
                                                                Colors.blue,
                                                            unSelectedBorderColor:
                                                                Colors.grey,
                                                            selectedBorderColor:
                                                                Colors.blue,
                                                            elevation: 0.0,
                                                            enableShape: false,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Listing Status:'),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1,
                                                        child:
                                                            CustomRadioButton(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          unSelectedColor:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          buttonLables: [
                                                            'Available',
                                                            'Sold',
                                                            'Unavailable',
                                                          ],
                                                          buttonValues: [
                                                            "Available",
                                                            "Sold",
                                                            "Unavailable",
                                                          ],
                                                          defaultSelected:
                                                              products[j]
                                                                  .listingStatus,
                                                          radioButtonValue:
                                                              (value) {
                                                            setState(() {
                                                              _updateListingStatus(
                                                                  products[j]
                                                                      .prodDocId,
                                                                  value);
                                                            });
                                                          },
                                                          selectedColor:
                                                              Colors.blue,
                                                          unSelectedBorderColor:
                                                              Colors.grey,
                                                          selectedBorderColor:
                                                              Colors.blue,
                                                          elevation: 0.0,
                                                          enableShape: false,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Theme.of(context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _editProduct(products[
                                                                      j]
                                                                  .prodDocId)
                                                              .then((edit) {
                                                            if (edit == true) {
                                                              // Navigator
                                                              //     .pushReplacement(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //       builder:
                                                              //           (_) {
                                                              //         return EditPost(
                                                              //             prodId:
                                                              //                 products[j].prodDocId);
                                                              //       },
                                                              //       fullscreenDialog:
                                                              //           true),
                                                              // );
                                                              Navigator
                                                                  .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) {
                                                                      return GeneratePost();
                                                                    },
                                                                    fullscreenDialog:
                                                                        true),
                                                              );
                                                            } else {
                                                              _showEditDialog();
                                                            }
                                                          });
                                                        },
                                                        icon: Icon(Icons.edit),
                                                        label: Text('Edit'),
                                                      ),
                                                      SizedBox(
                                                        width: 25,
                                                      ),
                                                      if (widget.adminUserPermission ==
                                                              'edit' ||
                                                          widget.adminUserPermission ==
                                                              'view')
                                                        ElevatedButton.icon(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                              Colors.red,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _showDeleteDialog(
                                                                products[j]
                                                                    .prodDocId,
                                                                products[j]
                                                                    .prodName,
                                                                products[j]
                                                                    .catName);
                                                          },
                                                          icon: Icon(
                                                              Icons.delete),
                                                          label: Text('Delete'),
                                                        )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 6 / 6,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: products.length,
                                  itemBuilder: (BuildContext context, int j) {
                                    return Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.all(5),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  ProductDetailScreen.routeName,
                                                  arguments:
                                                      products[j].prodDocId);
                                            },
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 120,
                                                      width: 120,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: products[j]
                                                                    .imageUrlFeatured !=
                                                                null
                                                            ? Image(
                                                                image:
                                                                    NetworkImage(
                                                                  products[j]
                                                                      .imageUrlFeatured,
                                                                ),
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : Container(
                                                                child: Center(
                                                                  child: Text(
                                                                      'Image Loading...'),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            products[j]
                                                                        .prodName
                                                                        .length >
                                                                    18
                                                                ? products[j]
                                                                        .prodName
                                                                        .substring(
                                                                            0,
                                                                            18) +
                                                                    '...'
                                                                : products[j]
                                                                    .prodName,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Row(
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      _currencySymbol,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: ' ',
                                                                    ),
                                                                    TextSpan(
                                                                      text: products[
                                                                              j]
                                                                          .price,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      'Status : ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: products[
                                                                              j]
                                                                          .status,
                                                                      style:
                                                                          TextStyle(
                                                                        color: products[j].status ==
                                                                                'Verified'
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(products[j]
                                                                  .listingStatus)
                                                            ],
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Created at :',
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: ' ',
                                                                ),
                                                                TextSpan(
                                                                  text: products[
                                                                          j]
                                                                      .createdAt
                                                                      .toDate()
                                                                      .month
                                                                      .toString(),
                                                                ),
                                                                TextSpan(
                                                                  text: '-',
                                                                ),
                                                                TextSpan(
                                                                  text: products[
                                                                          j]
                                                                      .createdAt
                                                                      .toDate()
                                                                      .day
                                                                      .toString(),
                                                                ),
                                                                TextSpan(
                                                                  text: '-',
                                                                ),
                                                                TextSpan(
                                                                  text: products[
                                                                          j]
                                                                      .createdAt
                                                                      .toDate()
                                                                      .year
                                                                      .toString(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              ElevatedButton
                                                                  .icon(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              Color>(
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  _editProduct(products[
                                                                              j]
                                                                          .prodDocId)
                                                                      .then(
                                                                          (edit) {
                                                                    if (edit ==
                                                                        true) {
                                                                      Navigator
                                                                          .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder:
                                                                                (_) {
                                                                              return GeneratePost();
                                                                            },
                                                                            fullscreenDialog:
                                                                                true),
                                                                      );
                                                                      // Navigator
                                                                      //     .pushReplacement(
                                                                      //   context,
                                                                      //   MaterialPageRoute(
                                                                      //       builder:
                                                                      //           (_) {
                                                                      //         return EditPost(prodId: products[j].prodDocId);
                                                                      //       },
                                                                      //       fullscreenDialog:
                                                                      //           true),
                                                                      // );
                                                                    } else {
                                                                      _showEditDialog();
                                                                    }
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                    Icons.edit),
                                                                label: Text(
                                                                    'Edit'),
                                                              ),
                                                              SizedBox(
                                                                width: 25,
                                                              ),
                                                              if (widget.adminUserPermission ==
                                                                      'edit' ||
                                                                  widget.adminUserPermission ==
                                                                      'view')
                                                                ElevatedButton
                                                                    .icon(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<
                                                                            Color>(
                                                                      Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    _showDeleteDialog(
                                                                        products[j]
                                                                            .prodDocId,
                                                                        products[j]
                                                                            .prodName,
                                                                        products[j]
                                                                            .catName);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .delete),
                                                                  label: Text(
                                                                      'Delete'),
                                                                )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (widget.adminUserPermission ==
                                                        'edit' ||
                                                    widget.adminUserPermission ==
                                                        'view')
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Status:'),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child:
                                                            CustomRadioButton(
                                                          enableButtonWrap:
                                                              true,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4.5,
                                                          unSelectedColor:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          buttonLables: [
                                                            'Verified',
                                                            'Pending',
                                                          ],
                                                          buttonValues: [
                                                            "Verified",
                                                            "Pending",
                                                          ],
                                                          defaultSelected:
                                                              products[j]
                                                                  .status,
                                                          radioButtonValue:
                                                              (value) {
                                                            setState(() {
                                                              _updateStatus(
                                                                  products[j]
                                                                      .prodDocId,
                                                                  value);
                                                            });
                                                          },
                                                          selectedColor:
                                                              Colors.blue,
                                                          unSelectedBorderColor:
                                                              Colors.grey,
                                                          selectedBorderColor:
                                                              Colors.blue,
                                                          elevation: 0.0,
                                                          enableShape: false,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Listing Status:'),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1,
                                                      child: CustomRadioButton(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4,
                                                        unSelectedColor:
                                                            Theme.of(context)
                                                                .canvasColor,
                                                        buttonLables: [
                                                          'Available',
                                                          'Sold',
                                                          'Unavailable',
                                                        ],
                                                        buttonValues: [
                                                          "Available",
                                                          "Sold",
                                                          "Unavailable",
                                                        ],
                                                        defaultSelected:
                                                            products[j]
                                                                .listingStatus,
                                                        radioButtonValue:
                                                            (value) {
                                                          setState(() {
                                                            _updateListingStatus(
                                                                products[j]
                                                                    .prodDocId,
                                                                value);
                                                          });
                                                        },
                                                        selectedColor:
                                                            Colors.blue,
                                                        unSelectedBorderColor:
                                                            Colors.grey,
                                                        selectedBorderColor:
                                                            Colors.blue,
                                                        elevation: 0.0,
                                                        enableShape: false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        )
                                      ],
                                    );
                                  },
                                ),
                        ),
                      )
                    : Center(
                        child: Text('Oops!! Products not found... '),
                      ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text('Product Dashboard'),
        centerTitle: true,
        leading: Row(
          children: [
            Expanded(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            Expanded(
              child: new IconButton(
                onPressed: () {
                  _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                },
                icon: new AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _controller.view,
                ),
              ),
            ),
          ],
        ),
      ),
      body: new LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
