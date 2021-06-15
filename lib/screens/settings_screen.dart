import 'package:blrber/models/product.dart';
import 'package:blrber/models/user_detail.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/screens/help_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:darq/darq.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settngs_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserDetail userDataUpdated = UserDetail();
  // UserDetail userData = UserDetail();
  User user;
  List<String> availableProdCC = [];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
    final products = Provider.of<List<Product>>(context);

    if (userDetails.length > 0 && user != null) {
      userDetails = userDetails
          .where((e) => e.email.trim() == user.email.trim())
          .toList();
      userDataUpdated = UserDetail();
      if (userDetails.length > 0) {
        userDataUpdated = userDetails[0];
        print('userupdate - setting');
      }
    }

    print('products - ${products.length}');
    var distinctProductsCC = products.distinct((d) => d.countryCode).toList();

    print('prodCountryCode - ${distinctProductsCC.length}');

    availableProdCC = [];
    if (distinctProductsCC.length > 0) {
      for (var item in distinctProductsCC) {
        print('disting cc - ${item.countryCode}');
        availableProdCC.add(item.countryCode);
      }
    }

    super.didChangeDependencies();
  }

  Future<void> _updateBuyingCountry(String countryCode) async {
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userDataUpdated.userDetailDocId.trim())
        .update({
      'buyingCountryCode': countryCode,
    }).then((value) {
      print("User Updated with Selected Buying Country");
    }).catchError((error) =>
            print("Failed to update User\'s Buying Country: $error"));
  }

  @override
  Widget build(BuildContext context) {
    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).disabledColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: Text(
                'Country',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).disabledColor),
              ),
              trailing: Flag(
                getCurrentLocation.countryCode,
                height: 20,
                width: 25,
                fit: BoxFit.fill,
              ),
              onTap: () {},
            ),
            if (availableProdCC.length > 0)
              ListTile(
                leading: Text(
                  'Buying Country',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).disabledColor),
                ),
                trailing: Flag(
                  userDataUpdated != null
                      ? userDataUpdated.buyingCountryCode
                      : getCurrentLocation.countryCode,
                  height: 20,
                  width: 25,
                  fit: BoxFit.fill,
                ),
                onTap: () {
                  showCountryPicker(
                    countryFilter: availableProdCC,
                    context: context,
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      setState(() {
                        _updateBuyingCountry(country.countryCode);
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              leading: Text(
                'Currency',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).disabledColor),
              ),
              trailing: Text(
                getCurrentLocation.currencyCode,
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).disabledColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Text(
                'Language',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).disabledColor),
              ),
              trailing: Text(
                'English',
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).disabledColor),
              ),
              onTap: () {
                print('listtile1');
              },
            ),
            ListTile(
              leading: Text(
                'Help Center',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).disabledColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) {
                        return HelpCenter();
                      },
                      fullscreenDialog: true),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
