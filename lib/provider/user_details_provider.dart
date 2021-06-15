import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_detail.dart';

class UserDetailsProvider with ChangeNotifier {
  UserDetail _userData;

  UserDetailsProvider() {
    _userData = UserDetail();
  }
  UserDetail get userData => _userData;

  set userData(UserDetail userData) {
    _userData = userData;
    notifyListeners();
  }

  Future<void> getUserDetail(String userId) async {
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId.trim())
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        print(
            "Get user Successfull @ userdetail provider! - ${documentSnapshot.data()["userName"]}");

        _userData.userName = documentSnapshot.data()["userName"];
        _userData.email = documentSnapshot.data()["email"];
        _userData.userImageUrl = documentSnapshot.data()["userImageUrl"];
        _userData.displayName = documentSnapshot.data()["displayName"];
        _userData.addressLocation = documentSnapshot.data()["addressLocation"];
        _userData.countryCode = documentSnapshot.data()["countryCode"];
        _userData.buyingCountryCode =
            documentSnapshot.data()["buyingCountryCode"];
        _userData.latitude = documentSnapshot.data()["latitude"];
        _userData.longitude = documentSnapshot.data()["longitude"];
        _userData.phoneNumber = documentSnapshot.data()["phoneNumber"];
        _userData.alternateNumber = documentSnapshot.data()["alternateNumber"];
        _userData.userType = documentSnapshot.data()["userType"];
        _userData.licenceNumber = documentSnapshot.data()["licenceNumber"];
        _userData.userDetailDocId = documentSnapshot.id;
      } else {
        print("User data not exist!!");
      }
    }).catchError((error) {
      print("Failed to get user: $error");
    });
  }
}
