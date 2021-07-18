//Imports for pubspec Packages
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

//Imports for Models
import '../models/product.dart';
import '../models/user_detail.dart';

//Imports for Providers
import '../provider/get_current_location.dart';

//Imports for Screens
import '../screens/product_detail_screen.dart';

//Imports for Services
import '../services/foundation.dart';

//Imports for Constants
import '../constants.dart';

class UserPostCatalog extends StatefulWidget {
  final UserDetail userData;
  UserPostCatalog({Key key, this.userData}) : super(key: key);

  @override
  _UserPostCatalogState createState() => _UserPostCatalogState();
}

class _UserPostCatalogState extends State<UserPostCatalog> {
  List<Product> products = [];
  String _currencyName = "";
  String _currencySymbol = "";
  @override
  void didChangeDependencies() {
    _getProducts();
    super.didChangeDependencies();
  }

  void _getProducts() {
    products = Provider.of<List<Product>>(context);
    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    _currencyName = getCurrentLocation.currencyCode;
    _currencySymbol = getCurrencySymbolByName(_currencyName);

    if (products != null) {
      products = products
          .where(
            (e) =>
                e.userDetailDocId.trim() ==
                    widget.userData.userDetailDocId.trim() &&
                e.status == 'Verified' &&
                e.listingStatus == 'Available',
          )
          .toList();
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Post Catalog'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: widget.userData.userImageUrl == ""
                    ? AssetImage('assets/images/default_user_image.png')
                    : NetworkImage(
                        widget.userData.userImageUrl,
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  // RichText(
                  //   text: TextSpan(
                  //     text: 'User Name  ',
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //     children: <TextSpan>[
                  //       TextSpan(text: widget.userData.userName),
                  //     ],
                  //   ),
                  // ),
                  // RichText(
                  //   text: TextSpan(
                  //     text: 'User Type  ',
                  //     style: const TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //     children: <TextSpan>[
                  //       TextSpan(text: widget.userData.userType),
                  //     ],
                  //   ),
                  // ),
                  Text(widget.userData.userName,
                      overflow: TextOverflow.ellipsis),
                  Text(widget.userData.userType,
                      overflow: TextOverflow.ellipsis),
                  if (widget.userData.userType == 'Dealer')
                    Column(
                      children: [
                        Text(widget.userData.companyName),
                        Text(widget.userData.licenceNumber),
                      ],
                    )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.userData.companyLogoUrl == ""
                    ? AssetImage('assets/images/default_user_image.png')
                    : NetworkImage(
                        widget.userData.companyLogoUrl,
                      ),
              ),
            ],
          ),
          Expanded(
            child: Scrollbar(
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int j) {
                  return Container(
                    color: bBackgroundColor,
                    padding: EdgeInsets.all(5),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            ProductDetailScreen.routeName,
                            arguments: products[j].prodDocId);
                      },
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              child: products[j].imageUrlFeatured != null
                                  ? Image(
                                      image: NetworkImage(
                                        products[j].imageUrlFeatured,
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : Container(
                                      child: Center(
                                        child: const Text('Image Loading...'),
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[j].prodName.length > 25
                                      ? products[j].prodName.substring(0, 25) +
                                          '...'
                                      : products[j].prodName,
                                  style: TextStyle(
                                      color: bDisabledColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: _currencySymbol,
                                    style: const TextStyle(
                                      color: bDisabledColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: ' ',
                                      ),
                                      TextSpan(
                                        text: products[j].price,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Status : ',
                                    style: const TextStyle(
                                      color: bDisabledColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: products[j].status,
                                        style: TextStyle(
                                          color:
                                              products[j].status == 'Verified'
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 6 / 6,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
