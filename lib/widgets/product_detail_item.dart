import 'package:badges/badges.dart';
import 'package:blrber/provider/get_current_location.dart';

import 'package:blrber/screens/gmap_screen.dart';
import 'package:blrber/screens/photos.dart';

import 'package:blrber/screens/user_post_catalog.dart';
import 'package:blrber/screens/view_full_specs.dart';
import 'package:blrber/screens/view_photos.dart';
import 'package:blrber/widgets/chat/to_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share/share.dart';
import '../models/product.dart';
import '../models/user_detail.dart';

import '../services/foundation.dart';

class ProductDetailItem extends StatefulWidget {
  final String productDocId;

  ProductDetailItem({this.productDocId});

  @override
  _ProductDetailItemState createState() => _ProductDetailItemState();
}

class _ProductDetailItemState extends State<ProductDetailItem> {
  String _downloadLink = "download link";
  bool _catCar = false;
  bool dataAvailable = false;

  String _currencySymbol = "";
  String _currencyName = "";
  String userId = "";
  List<CtmSpecialInfo> ctmSpecialInfos = [];

  // List<String> _prodExteriorImages = [];
  // List<String> _prodInteriorImages = [];
  // List<String> _prodImages = [];

  void _socialShare(BuildContext context, String downloadLink) {
    final RenderBox box = context.findRenderObject();
    final String text = downloadLink;
    Share.share(text,
        subject: text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  // Future<void> _listExteriorImages(prodDocId) async {
  //   //   _prodExteriorImages = [];
  //   // _prodInteriorImages = [];

  //   List<ProdImages> prodImages = [];
  //   firebase_storage.ListResult result = await firebase_storage
  //       .FirebaseStorage.instance
  //       .ref('$prodDocId/exterior')
  //       .listAll();

  //   result.items.forEach((firebase_storage.Reference ref) async {
  //     final urlImage = await ref.getDownloadURL();
  //     _prodExteriorImages.add(urlImage);
  //     prodImages.add(urlImage);
  //     print(urlImage);
  //     print('Found file: $ref');
  //   });

  //   // result.prefixes.forEach((firebase_storage.Reference ref) {
  //   //   print('Found directory: $ref');
  //   // });
  // }

  // Future<void> _listInteriorImages(prodDocId) async {
  //   firebase_storage.ListResult result = await firebase_storage
  //       .FirebaseStorage.instance
  //       .ref('$prodDocId/interior')
  //       .listAll();

  //   result.items.forEach((firebase_storage.Reference ref) async {
  //     final urlImage = await ref.getDownloadURL();
  //     _prodInteriorImages.add(urlImage);
  //     _prodImages.add(urlImage);
  //     print(urlImage);
  //     print('Found file: $ref');
  //   });

  //   // result.prefixes.forEach((firebase_storage.Reference ref) {
  //   //   print('Found directory: $ref');
  //   // });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('check loc1 - product detail item');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      userId = "";
    } else {
      userId = user.uid;
    }
    List<Product> allProducts = Provider.of<List<Product>>(context);

    List<ProdImages> prodImages = Provider.of<List<ProdImages>>(context);
    List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    List<ProdImages> prodImagesE = [];
    List<ProdImages> prodImagesI = [];
    List<Product> similarlisting = [];
    List<Product> products = [];
    final getCurrentLocation =
        Provider.of<GetCurrentLocation>(context, listen: false);
    setState(() {
      _currencyName = getCurrentLocation.currencyCode;
      _currencySymbol = getCurrencySymbolByName(_currencyName);
      print("Currency symbol by Name - $_currencySymbol");
    });

    print(widget.productDocId);
    // _listExteriorImages(widget.productDocId);
    // _listInteriorImages(widget.productDocId);

    if (allProducts.length > 0 &&
        userDetails.length > 0 &&
        prodImages.length > 0) {
      products = allProducts
          .where((e) => e.prodDocId.trim() == widget.productDocId.trim())
          .toList();
      similarlisting = allProducts
          .where((e) => e.prodName.trim().toLowerCase().contains(
                products[0].prodName.trim().toLowerCase(),
              ))
          .toList();

      print('check121212 - ${products[0].prodDocId}');
      print('check121212 - ${products[0].userDetailDocId}');
      userDetails = userDetails
          .where((e) =>
              e.userDetailDocId.trim() == products[0].userDetailDocId.trim())
          .toList();
      print('image1 - ${prodImages.length}');
      prodImages = prodImages
          .where((e) => e.prodDocId.trim() == widget.productDocId.trim())
          .toList();
      print('image2 - ${prodImages.length}');

      // if (prodImages.length > 0) {
      prodImagesE = prodImages.where((e) => e.imageType.trim() == "E").toList();

      prodImagesI = prodImages.where((e) => e.imageType.trim() == "I").toList();
      // }
      prodImages = prodImagesE + prodImagesI;
      _catCar = false;
      // if (products[0].catName.toLowerCase() == 'car') {
      ctmSpecialInfos = [];
      if (products[0].catName.trim() == 'Car'.trim() ||
          products[0].catName.trim() == 'Truck'.trim() ||
          products[0].catName.trim() == 'Motorbike'.trim()) {
        ctmSpecialInfos = Provider.of<List<CtmSpecialInfo>>(context);
        if (ctmSpecialInfos.length > 0) {
          if (products[0].catName.trim() == 'Car'.trim()) {
            _catCar = true;
          }

          // if (ctmSpecialInfos != null) {
          ctmSpecialInfos = ctmSpecialInfos
              .where((e) => e.prodDocId.trim() == widget.productDocId.trim())
              .toList();
          // } else {
          //   Text("Loading");
          // }
          // } else if (products[0].catName.toLowerCase() == 'motorbike') {
          //   // if (ctmSpecialInfos != null) {
          //   ctmSpecialInfos = ctmSpecialInfos
          //       .where((e) => e.prodDocId.trim() == widget.productDocId.trim())
          //       .toList();
          //   // } else {
          //   //   Text("Loading");
          //   // }
          // } else {
          //   Text("Loading");
          // }
        } else {
          ctmSpecialInfos = [];
        }
      }
      setState(() {
        dataAvailable = true;
      });
    } else {
      setState(() {
        dataAvailable = false;
      });
    }

    return dataAvailable
        ? CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
                expandedHeight: 200,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: prodImages.length > 0
                      ? Stack(
                          children: [
                            CarouselSlider.builder(
                              itemCount: prodImages.length,
                              options: CarouselOptions(
                                height: MediaQuery.of(context).size.height,
                                // autoPlay: false,
                                // aspectRatio: 2.0,
                                // enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                              ),
                              itemBuilder: (context, index, realIdx) {
                                return Container(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(
                                        //     GalleryScreen.routeName,
                                        //     arguments: prodImages);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) {
                                                return ViewPhotos(
                                                  imageIndex: index,
                                                  imageList: prodImages,
                                                  pageTitle: 'Gallery',
                                                  // heroTitle: "image$index",
                                                );
                                              },
                                              fullscreenDialog: true),
                                        );
                                      },
                                      child: Image.network(
                                        prodImages[index].imageUrl,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              //             child: Image.network(
                              //   products[0].imageUrlFeatured,
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: MediaQuery.of(context).size.width - 50,
                              child: Badge(
                                badgeContent: Text(
                                  prodImages.length.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                badgeColor: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        )
                      : Text(
                          'Image Loading',
                          style: TextStyle(color: Colors.black),
                        ),
                  title: Text(
                    products[0].prodName,
                    style: TextStyle(color: Colors.grey),
                  ),
                  centerTitle: true,
                ),
                //title: Text('My App Bar'),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    return Navigator.of(context).pop();
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  // padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: products[0].prodName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        _socialShare(context, _downloadLink);
                                      },
                                    ),
                                    alignment: PlaceholderAlignment.middle,
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 20,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.favorite_border_outlined),
                                    alignment: PlaceholderAlignment.middle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            RichText(
                              text: WidgetSpan(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 15,
                                ),
                                alignment: PlaceholderAlignment.middle,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(GMapScreen.routeName);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) {
                                          return GMapScreen(
                                            lat: products[0].latitude,
                                            long: products[0].longitude,
                                            addressLocation:
                                                products[0].addressLocation,
                                          );
                                        },
                                        fullscreenDialog: true),
                                  );
                                },
                                child: Text(products[0].addressLocation))
                            // RichText(
                            //   text: TextSpan(
                            //     text: products[0].addressLocation,
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.normal,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: _currencySymbol,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: products[0].price,
                                  ),
                                  TextSpan(
                                    text: ' + Shipping',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      userId.trim() != products[0].userDetailDocId.trim()
                          ? Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                    onPressed: () {},
                                    child: Text('Buy it Now'),
                                    color: Colors.orange,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      print('chat 1');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) {
                                              print('chat 2');
                                              // return ChatScreen();
                                              return ToChat(
                                                  userIdFrom: userId.trim(),
                                                  userIdTo: products[0]
                                                      .userDetailDocId
                                                      .trim(),
                                                  prodName:
                                                      products[0].prodName);
                                            },
                                            fullscreenDialog: true),
                                      );
                                    },
                                    child: Text('Chat with seller'),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Text('This Ad is created by You!!'),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 7,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'About this product',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: products[0].prodDes,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Seller\'s ' 'Notes',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: products[0].sellerNotes,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 7,
                      ),
                      if (prodImagesE.length > 0)
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      _catCar ? 'Exterior ' : 'Product Images ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '(',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextSpan(
                                      text: '${prodImagesE.length}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextSpan(
                                      text: ')',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (prodImagesE.length > 0)
                        SizedBox(
                          height: 5,
                        ),
                      if (prodImagesE.length > 0)
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Container(
                            height: 100,
                            child: GestureDetector(
                              child: ListView.builder(
                                  itemCount: prodImagesE.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 100,
                                      child: Image.network(
                                        prodImagesE[index].imageUrl,
                                        fit: BoxFit.cover,
                                        // width: MediaQuery.of(context).size.width,
                                      ),
                                    );
                                  }),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) {
                                        return Photos(
                                          imageList: prodImages,
                                        );
                                      },
                                      fullscreenDialog: true),
                                );
                              },
                            ),
                          ),
                        ),
                      if (prodImagesE.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (prodImagesE.length > 0)
                        Divider(
                          thickness: 7,
                        ),
                      if (prodImagesI.length > 0)
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Interior ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '(',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextSpan(
                                      text: '${prodImagesI.length}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextSpan(
                                      text: ')',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (prodImagesI.length > 0)
                        SizedBox(
                          height: 5,
                        ),
                      if (prodImagesI.length > 0)
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Container(
                            height: 100,
                            child: ListView.builder(
                                itemCount: prodImagesI.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 100,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) {
                                                return Photos(
                                                  imageList: prodImages,
                                                );
                                              },
                                              fullscreenDialog: true),
                                        );
                                      },
                                      child: Image.network(
                                        prodImagesI[index].imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      if (prodImagesI.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (prodImagesI.length > 0)
                        Divider(
                          thickness: 7,
                        ),
                      if (ctmSpecialInfos.length > 0)
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: _catCar
                                          ? 'Vehicle Specs'
                                          : 'Product Specs',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'VIN',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: RichText(
                                      text: TextSpan(
                                        text: ctmSpecialInfos[0].vin,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: RichText(
                                text: TextSpan(
                                  text: 'For Sale By',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RichText(
                                text: TextSpan(
                                  text: products[0].forSaleBy,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      if (ctmSpecialInfos.length > 0)
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Exterior Color',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: RichText(
                                      text: TextSpan(
                                        text: ctmSpecialInfos[0].exteriorColor,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Mileage',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: RichText(
                                      text: TextSpan(
                                        text: ctmSpecialInfos[0].mileage,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Transmission',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: RichText(
                                      text: TextSpan(
                                        text: ctmSpecialInfos[0].transmission,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          ViewFullSpecs.routeName,
                                          arguments: ctmSpecialInfos);
                                    },
                                    child: Text('View full specs'),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 7,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'User',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: CircleAvatar(
                                radius: 25,
                                child: ClipOval(
                                  // borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    userDetails[0].userImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // backgroundImage:
                                //     NetworkImage(userDetails[0].userImageUrl),
                              ),
                              // child: RichText(
                              //   text: TextSpan(
                              //     text: 'User Name',
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 15,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) {
                                              return UserPostCatalog(
                                                  userData: userDetails[0]);
                                            },
                                            fullscreenDialog: true),
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: userDetails[0].userName,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(userDetails[0].userType)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 7,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Delivery And Payment ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Delivery',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RichText(
                                text: TextSpan(
                                  text: products[0].deliveryInfo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 7,
                      ),
                      if (prodImagesI.length != null)
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      'Explore similar ${products[0].make} listings',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      prodImagesI.length != null
                          ? Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Container(
                                height: 100,
                                child: ListView.builder(
                                    itemCount: prodImagesI.length.compareTo(0),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 100,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) {
                                                    return Photos();
                                                  },
                                                  fullscreenDialog: true),
                                            );
                                          },
                                          child: Image.network(
                                            similarlisting[index]
                                                .imageUrlFeatured,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 7,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );

    // return Stack(
    //   // alignment: Alignment.topLeft,
    //   children: <Widget>[
    //     Container(
    //       // margin: EdgeInsets.all(20),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             Container(
    //               height: MediaQuery.of(context).size.height / 3.5,
    //               width: double.infinity,
    //               child: Image.network(
    //                 products[0].imageUrlFeatured,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               child: Column(
    //                 children: <Widget>[
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text('Product Name'),
    //                       ),
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text(products[0].prodName)),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   // Row(
    //                   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   //   children: <Widget>[
    //                   //     Container(
    //                   //       height: 25,
    //                   //       width: 150,
    //                   //       child: Text('Product ID'),
    //                   //     ),
    //                   //     Container(
    //                   //         height: 25,
    //                   //         width: 150,
    //                   //         child: Text(products[0].prodId)),
    //                   //   ],
    //                   // ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text('Product Status'),
    //                       ),
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text(products[0].prodCondition)),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text('Category'),
    //                       ),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].catName),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text('Description')),
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text(products[0].prodDes)),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text('Price'),
    //                       ),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].price),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 25, width: 150, child: Text('Address')),
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text(products[0].addressLocation)),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text('Product Seller Name')),
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text(userDetails[0].userName)),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text('Seller email '),
    //                       ),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(userDetails[0].email),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text('Seller Phone # ')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(userDetails[0].phoneNumber == null
    //                             ? 'No Phone # shown'
    //                             : userDetails[0].phoneNumber),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 55,
    //                           width: 200,
    //                           child: Text('Product doc id')),
    //                       Container(
    //                         height: 25,
    //                         width: 150,
    //                         child: Text(products[0].prodDocId),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: <Widget>[
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: Text('Social Share : ')),
    //                       Container(
    //                           height: 25,
    //                           width: 150,
    //                           child: IconButton(
    //                               icon: Icon(Icons.share),
    //                               onPressed: () {
    //                                 _socialShare(context, _downloadLink);
    //                               })),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     // IconButton(
    //     //   icon: Icon(
    //     //     Icons.arrow_back,
    //     //     color: Colors.white,
    //     //   ),
    //     //   onPressed: () {
    //     //     Navigator.pop(context);
    //     //   },
    //     // ),
    //     //
    //     Positioned(
    //       top: 0.0,
    //       left: 0.0,
    //       right: 0.0,
    //       child: AppBar(
    //         title: Text(''), // You can add title here
    //         leading: new IconButton(
    //           icon: new Icon(Icons.arrow_back, color: Colors.white),
    //           onPressed: () => Navigator.of(context).pop(),
    //         ),
    //         backgroundColor:
    //             Colors.blue.withOpacity(0.0), //You can make this transparent
    //         elevation: 0.0, //No shadow
    //       ),
    //     ),
    //   ],
    // );
  }
}
