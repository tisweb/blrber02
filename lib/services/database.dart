import 'package:blrber/models/company_detail.dart';
import 'package:blrber/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../models/user_detail.dart';
import '../models/chat_detail.dart';

class Database {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<List<Product>> get products {
    return _fireStore
        .collection('products')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Product(
                  prodName: documentSnapshot.data()["prodName"],
                  catName: documentSnapshot.data()["catName"],
                  subCatDocId: documentSnapshot.data()["subCatDocId"],
                  prodDes: documentSnapshot.data()["prodDes"],
                  sellerNotes: documentSnapshot.data()["sellerNotes"],
                  year: documentSnapshot.data()["year"],
                  make: documentSnapshot.data()["make"],
                  model: documentSnapshot.data()["model"],
                  prodCondition: documentSnapshot.data()["prodCondition"],
                  price: documentSnapshot.data()["price"],
                  currencyName: documentSnapshot.data()["currencyName"],
                  currencySymbol: documentSnapshot.data()["currencySymbol"],
                  imageUrlFeatured: documentSnapshot.data()["imageUrlFeatured"],
                  addressLocation: documentSnapshot.data()["addressLocation"],
                  countryCode: documentSnapshot.data()["countryCode"],
                  latitude: documentSnapshot.data()["latitude"],
                  longitude: documentSnapshot.data()["longitude"],
                  prodDocId: documentSnapshot.id,
                  userDetailDocId: documentSnapshot.data()["userDetailDocId"],
                  deliveryInfo: documentSnapshot.data()["deliveryInfo"],
                  distance: '',
                  status: documentSnapshot.data()["status"],
                  forSaleBy: documentSnapshot.data()["forSaleBy"],
                  listingStatus: documentSnapshot.data()["listingStatus"],
                  createdAt: documentSnapshot.data()["createdAt"],
                ))
            .toList());
  }

  Stream<List<CtmSpecialInfo>> get ctmSpecialInfos {
    return _fireStore
        .collection('CtmSpecialInfo')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => CtmSpecialInfo(
                  prodDocId: documentSnapshot.data()["prodDocId"],
                  year: documentSnapshot.data()["year"],
                  make: documentSnapshot.data()["make"],
                  model: documentSnapshot.data()["model"],
                  vehicleType: documentSnapshot.data()["vehicleType"],
                  mileage: documentSnapshot.data()["mileage"],
                  vin: documentSnapshot.data()["vin"],
                  engine: documentSnapshot.data()["engine"],
                  fuelType: documentSnapshot.data()["fuelType"],
                  options: documentSnapshot.data()["options"],
                  subModel: documentSnapshot.data()["subModel"],
                  numberOfCylinders:
                      documentSnapshot.data()["numberOfCylinders"],
                  safetyFeatures: documentSnapshot.data()["safetyFeatures"],
                  driveType: documentSnapshot.data()["driveType"],
                  interiorColor: documentSnapshot.data()["interiorColor"],
                  bodyType: documentSnapshot.data()["bodyType"],
                  forSaleBy: documentSnapshot.data()["forSaleBy"],
                  warranty: documentSnapshot.data()["warranty"],
                  exteriorColor: documentSnapshot.data()["exteriorColor"],
                  trim: documentSnapshot.data()["trim"],
                  transmission: documentSnapshot.data()["transmission"],
                  steeringLocation: documentSnapshot.data()["steeringLocation"],
                  ctmSpecialInfoDocId: documentSnapshot.id,
                ))
            .toList());
  }

  Stream<List<ProdImages>> get prodImages {
    return _fireStore
        .collection('ProdImages')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => ProdImages(
                  prodDocId: documentSnapshot.data()["prodDocId"],
                  imageUrl: documentSnapshot.data()["imageUrl"],
                  imageType: documentSnapshot.data()["imageType"],
                ))
            .toList());
  }

  Stream<List<UserDetail>> get userDetails {
    return _fireStore
        .collection('userDetails')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => UserDetail(
                  userName: documentSnapshot.data()["userName"],
                  email: documentSnapshot.data()["email"],
                  userImageUrl: documentSnapshot.data()["userImageUrl"],
                  displayName: documentSnapshot.data()["displayName"],
                  addressLocation: documentSnapshot.data()["addressLocation"],
                  countryCode: documentSnapshot.data()["countryCode"],
                  buyingCountryCode:
                      documentSnapshot.data()["buyingCountryCode"],
                  latitude: documentSnapshot.data()["latitude"],
                  longitude: documentSnapshot.data()["longitude"],
                  phoneNumber: documentSnapshot.data()["phoneNumber"],
                  alternateNumber: documentSnapshot.data()["alternateNumber"],
                  userType: documentSnapshot.data()["userType"],
                  licenceNumber: documentSnapshot.data()["licenceNumber"],
                  companyName: documentSnapshot.data()["companyName"],
                  companyLogoUrl: documentSnapshot.data()["companyLogoUrl"],
                  userDetailDocId: documentSnapshot.id,
                ))
            .toList());
  }

  Stream<UserDetail> get userDetailSpecific {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _fireStore
          .collection('userDetails')
          .doc(user.uid)
          .snapshots()
          .map((DocumentSnapshot documentSnapshot) => UserDetail(
                userName: documentSnapshot.data()["userName"],
                email: documentSnapshot.data()["email"],
                userImageUrl: documentSnapshot.data()["userImageUrl"],
                displayName: documentSnapshot.data()["displayName"],
                addressLocation: documentSnapshot.data()["addressLocation"],
                countryCode: documentSnapshot.data()["countryCode"],
                buyingCountryCode: documentSnapshot.data()["buyingCountryCode"],
                latitude: documentSnapshot.data()["latitude"],
                longitude: documentSnapshot.data()["longitude"],
                phoneNumber: documentSnapshot.data()["phoneNumber"],
                alternateNumber: documentSnapshot.data()["alternateNumber"],
                userType: documentSnapshot.data()["userType"],
                licenceNumber: documentSnapshot.data()["licenceNumber"],
                companyName: documentSnapshot.data()["companyName"],
                companyLogoUrl: documentSnapshot.data()["companyLogoUrl"],
                userDetailDocId: documentSnapshot.id,
              ));
    } else {
      return null;
    }
  }

  Stream<List<CompanyDetail>> get companyDetails {
    return _fireStore
        .collection('companyDetails')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => CompanyDetail(
                  companyName: documentSnapshot.data()["companyName"],
                  email: documentSnapshot.data()["email"],
                  webSite: documentSnapshot.data()["webSite"],
                  address1: documentSnapshot.data()["address1"],
                  address2: documentSnapshot.data()["address2"],
                  countryCode: documentSnapshot.data()["countryCode"],
                  primaryContactNumber:
                      documentSnapshot.data()["primaryContactNumber"],
                  customerCareNumber:
                      documentSnapshot.data()["customerCareNumber"],
                  logoImageUrl: documentSnapshot.data()["logoImageUrl"],
                  companyDetailsDocId: documentSnapshot.id,
                ))
            .toList());
  }

  Stream<List<AdminUser>> get adminUsers {
    return _fireStore
        .collection('adminUsers')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => AdminUser(
                  userName: documentSnapshot.data()["userName"],
                  userId: documentSnapshot.data()["userId"],
                  permission: documentSnapshot.data()["permission"],
                  countryCode: documentSnapshot.data()["countryCode"],
                  adminUserDocId: documentSnapshot.id,
                ))
            .toList());
  }

  Stream<List<ChatDetail>> get chatDetails {
    return _fireStore
        .collection('chats')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => ChatDetail(
                  createdAt: documentSnapshot.data()["createdAt"],
                  text: documentSnapshot.data()["text"],
                  userIdFrom: documentSnapshot.data()["userIdFrom"],
                  userIdTo: documentSnapshot.data()["userIdTo"],
                  userImage: documentSnapshot.data()["userImage"],
                  userNameFrom: documentSnapshot.data()["userNameFrom"],
                  userNameTo: documentSnapshot.data()["userNameTo"],
                  prodName: documentSnapshot.data()["prodName"],
                  chatDetailDocId: documentSnapshot.id,
                ))
            .toList());
  }

  Stream<List<ReceivedMsgCount>> get receivedMsgCounts {
    return _fireStore
        .collection('receivedMsgCount')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => ReceivedMsgCount(
                  receivedMsgCountId: documentSnapshot.id,
                  receivedUserName: documentSnapshot.data()["receivedUserName"],
                  receivedMsgCount: documentSnapshot.data()["receivedMsgCount"],
                  sentUserName: documentSnapshot.data()["sentUserName"],
                  prodName: documentSnapshot.data()["prodName"],
                ))
            .toList());
  }

  Stream<List<Category>> get categories {
    return _fireStore.collection('categories').snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Category(
                catDocId: documentSnapshot.id,
                catName: documentSnapshot.data()["catName"],
                imageUrl: documentSnapshot.data()["imageUrl"],
                iconValue: documentSnapshot.data()["iconValue"]))
            .toList());
  }

  Stream<List<SubCategory>> get subCategories {
    return _fireStore
        .collection('subCategories')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => SubCategory(
                  subCatDocId: documentSnapshot.id,
                  subCatType: documentSnapshot.data()["subCatType"],
                  catName: documentSnapshot.data()["catName"],
                  imageUrl: documentSnapshot.data()["imageUrl"],
                ))
            .toList());
  }

  Stream<List<ProductCondition>> get productConditions {
    return _fireStore
        .collection('productCondition')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => ProductCondition(
                  prodCondition: documentSnapshot.data()["prodCondition"],
                ))
            .toList());
  }

  Stream<List<DeliveryInfo>> get deliveryinfos {
    return _fireStore
        .collection('deliveryInfo')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => DeliveryInfo(
                  deliveryInfo: documentSnapshot.data()["deliveryInfo"],
                ))
            .toList());
  }

  //forSaleBy

  Stream<List<ForSaleBy>> get forSaleBys {
    return _fireStore
        .collection('forSaleBy')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => ForSaleBy(
                  forSaleBy: documentSnapshot.data()["forSaleBy"],
                ))
            .toList());
  }

  //fuelType

  Stream<List<FuelType>> get fuelTypes {
    return _fireStore
        .collection('fuelType')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => FuelType(
                  fuelType: documentSnapshot.data()["fuelType"],
                ))
            .toList());
  }

  Stream<List<Year>> get years {
    return _fireStore
        .collection('years')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Year(
                  year: documentSnapshot.data()["year"],
                ))
            .toList());
  }

  Stream<List<Make>> get makes {
    return _fireStore
        .collection('makes')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Make(
                  make: documentSnapshot.data()["make"],
                ))
            .toList());
  }

  Stream<List<Model>> get models {
    return _fireStore
        .collection('models')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Model(
                  model: documentSnapshot.data()["model"],
                ))
            .toList());
  }

  Stream<List<UserType>> get userTypes {
    return _fireStore
        .collection('userTypes')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => UserType(
                  userType: documentSnapshot.data()["userType"],
                ))
            .toList());
  }

  Stream<List<TempProd>> get tempProd {
    return _fireStore
        .collection('tempproducts')
        // .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => TempProd(
                  userId: documentSnapshot.data()["userId"],
                  catName: documentSnapshot.data()["catName"],
                  imageUrl: documentSnapshot.data()["imageUrl"],
                  validation: documentSnapshot.data()["validation"],
                ))
            .toList());
  }

  Stream<List<FavoriteProd>> get favoriteProd {
    return _fireStore
        .collection('favoriteProd')
        // .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => FavoriteProd(
                  prodDocId: documentSnapshot.data()["prodDocId"],
                  isFavorite: documentSnapshot.data()["isFavorite"],
                  userId: documentSnapshot.data()["userId"],
                ))
            .toList());
  }
}
