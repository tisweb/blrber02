// Model for Product table
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String prodName;
  String catName;
  String subCatDocId;
  String prodDes;
  String sellerNotes;
  String year; // Can be Auto generated from API
  String make; // Can be Auto generated from API
  String model; // Can be Auto generated from API
  String prodCondition;
  String price;
  String currencyName;
  String currencySymbol;
  String imageUrlFeatured;
  String addressLocation;
  String countryCode;
  double latitude;
  double longitude;
  String prodDocId;
  String userDetailDocId;
  String deliveryInfo;
  String distance;
  String status;
  String forSaleBy;
  String listingStatus;
  Timestamp createdAt;

  Product({
    this.prodName,
    this.catName,
    this.subCatDocId,
    this.prodDes,
    this.sellerNotes,
    this.year, // Can be Auto generated from API
    this.make, // Can be Auto generated from API
    this.model, // Can be Auto generated from API
    this.prodCondition,
    this.price,
    this.currencyName,
    this.currencySymbol,
    this.imageUrlFeatured,
    this.addressLocation,
    this.countryCode,
    this.latitude,
    this.longitude,
    this.prodDocId,
    this.userDetailDocId,
    this.deliveryInfo,
    this.distance,
    this.status,
    this.forSaleBy,
    this.listingStatus,
    this.createdAt,
  });
}

// Model to store product details with distance for internal distance calculation
class ProductDistance {
  String prodName;
  String catName;
  String subCatDocId;
  String prodDes;
  String sellerNotes;
  String year; // Can be Auto generated from API
  String make; // Can be Auto generated from API
  String model; // Can be Auto generated from API
  String prodCondition;
  String price;
  String currencyName;
  String currencySymbol;
  String imageUrlFeatured;
  String addressLocation;
  String countryCode;
  double latitude;
  double longitude;
  String prodDocId;
  String userDetailDocId;
  String deliveryInfo;
  String distance;
  String status;
  String forSaleBy;
  String listingStatus;
  Timestamp createdAt;

  ProductDistance({
    this.prodName,
    this.catName,
    this.subCatDocId,
    this.prodDes,
    this.sellerNotes,
    this.year, // Can be Auto generated from API
    this.make, // Can be Auto generated from API
    this.model, // Can be Auto generated from API
    this.prodCondition,
    this.price,
    this.currencyName,
    this.currencySymbol,
    this.imageUrlFeatured,
    this.addressLocation,
    this.countryCode,
    this.latitude,
    this.longitude,
    this.prodDocId,
    this.userDetailDocId,
    this.deliveryInfo,
    this.distance,
    this.status,
    this.forSaleBy,
    this.listingStatus,
    this.createdAt,
  });
}

// Model for Car/Truck/Motor special information

class CtmSpecialInfo {
  String prodDocId;
  String year; // Can be Auto generated from API
  String make; // Can be Auto generated from API
  String model; // Can be Auto generated from API
  String vehicleType; // Can be Auto generated from API
  String mileage;
  String vin;
  String engine; // Can be Auto generated from API
  String fuelType; // Can be Auto generated from API
  String options;
  String subModel;
  String numberOfCylinders; // Can be Auto generated from API
  String safetyFeatures; // Can be Auto generated from API
  String driveType; // Can be Auto generated from API
  String interiorColor;
  String bodyType; // Can be Auto generated from API
  String forSaleBy;
  String warranty;
  String exteriorColor;
  String trim; // Can be Auto generated from API
  String transmission; // Can be Auto generated from API
  String steeringLocation; // Can be Auto generated from API
  String ctmSpecialInfoDocId;

  CtmSpecialInfo({
    this.prodDocId,
    this.year, // Can be Auto generated from API
    this.make, // Can be Auto generated from API
    this.model, // Can be Auto generated from API
    this.vehicleType, // Can be Auto generated from API
    this.mileage,
    this.vin,
    this.engine, // Can be Auto generated from API
    this.fuelType, // Can be Auto generated from API
    this.options,
    this.subModel,
    this.numberOfCylinders, // Can be Auto generated from API
    this.safetyFeatures, // Can be Auto generated from API
    this.driveType, // Can be Auto generated from API
    this.interiorColor,
    this.bodyType, // Can be Auto generated from API
    this.forSaleBy,
    this.warranty,
    this.exteriorColor,
    this.trim, // Can be Auto generated from API
    this.transmission, // Can be Auto generated from API
    this.steeringLocation, // Can be Auto generated from API
    this.ctmSpecialInfoDocId,
  });
}

// Model to store temp product data

class TempProd {
  String userId;
  String catName;
  String imageUrl;
  String validation;

  TempProd({
    this.userId,
    this.catName,
    this.imageUrl,
    this.validation,
  });
}

class FavoriteProd {
  String prodDocId;
  bool isFavorite;
  String userId;

  FavoriteProd({
    this.prodDocId,
    this.isFavorite,
    this.userId,
  });
}

// Model to store product images in Firestore

class ProdImages {
  String prodDocId;
  String imageUrl;
  String imageType;
  bool featuredImage;

  ProdImages({
    this.prodDocId,
    this.imageUrl,
    this.imageType,
    this.featuredImage,
  });
}

// Model to store product condition
class ProductCondition {
  String prodCondition;

  ProductCondition({
    this.prodCondition,
  });
}

// Model to store delivery info
class DeliveryInfo {
  String deliveryInfo;

  DeliveryInfo({
    this.deliveryInfo,
  });
}

// Model to store forSaleBy
class ForSaleBy {
  String forSaleBy;

  ForSaleBy({
    this.forSaleBy,
  });
}

// Model to store fuelType
class FuelType {
  String fuelType;

  FuelType({
    this.fuelType,
  });
}

// Model to store year
class Year {
  String year;

  Year({
    this.year,
  });
}

// Model to store make
class Make {
  String make;

  Make({
    this.make,
  });
}

// Model to store prod model
class Model {
  String model;

  Model({
    this.model,
  });
}

// Model to store product images in Firestore

class ProdImagesSqlDb {
  String id;
  String imageUrl;
  String imageType;
  String featuredImage;

  ProdImagesSqlDb({
    this.id,
    this.imageUrl,
    this.imageType,
    this.featuredImage,
  });
}

// Model for Motor Form
class MotorFormSqlDb {
  String id;
  String catName;
  String subCatDocId;
  String prodDes;
  String sellerNotes;
  String prodCondition;
  String price;
  String imageUrlFeatured;
  String deliveryInfo;
  String year; // Can be Auto generated from API
  String make; // Can be Auto generated from API
  String model; // Can be Auto generated from API
  String vehicleType; // Can be Auto generated from API
  String mileage;
  String vin;
  String engine; // Can be Auto generated from API
  String fuelType; // Can be Auto generated from API
  String options;
  String subModel;
  String numberOfCylinders; // Can be Auto generated from API
  String safetyFeatures; // Can be Auto generated from API
  String driveType; // Can be Auto generated from API
  String interiorColor;
  String bodyType; // Can be Auto generated from API
  String exteriorColor;
  String forSaleBy;
  String warranty;
  String trim; // Can be Auto generated from API
  String transmission; // Can be Auto generated from API
  String steeringLocation; // Can be Auto generated from API
  String vehicleTypeYear;
  String editPost;

  MotorFormSqlDb({
    this.id,
    this.catName,
    this.subCatDocId,
    this.prodDes,
    this.sellerNotes,
    this.prodCondition,
    this.price,
    this.imageUrlFeatured,
    this.deliveryInfo,
    this.year, // Can be Auto generated from API
    this.make, // Can be Auto generated from API
    this.model, // Can be Auto generated from API
    this.vehicleType, // Can be Auto generated from API
    this.mileage,
    this.vin,
    this.engine, // Can be Auto generated from API
    this.fuelType, // Can be Auto generated from API
    this.options,
    this.subModel,
    this.numberOfCylinders, // Can be Auto generated from API
    this.safetyFeatures, // Can be Auto generated from API
    this.driveType, // Can be Auto generated from API
    this.interiorColor,
    this.bodyType, // Can be Auto generated from API
    this.exteriorColor,
    this.forSaleBy,
    this.warranty,
    this.trim, // Can be Auto generated from API
    this.transmission, // Can be Auto generated from API
    this.steeringLocation, // Can be Auto generated from API
    this.vehicleTypeYear,
    this.editPost,
  });
}
