//Imports for pubspec Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Models
import '../models/category.dart';
import '../models/product.dart';
import '../models/user_detail.dart';

//Imports for Providers
import '../provider/get_current_location.dart';

//Imports for Screens
import '../screens/filtered_prod_screen.dart';

class MotorFilterScreen extends StatefulWidget {
  final String catName;
  final String subCatType;

  MotorFilterScreen({
    this.catName,
    this.subCatType,
  });
  @override
  _MotorFilterScreenState createState() => _MotorFilterScreenState();
}

class CatNameCount {
  String catName;
  int count;
  bool value;

  CatNameCount({
    this.catName,
    this.count,
    this.value = false,
  });
}

class SubCatNameCount {
  String subCatName;
  String catName;
  int count;
  bool value;

  SubCatNameCount({
    this.subCatName,
    this.catName,
    this.count,
    this.value = false,
  });
}

class MakeCount {
  String make;
  int count;
  bool value;

  MakeCount({
    this.make,
    this.count,
    this.value = false,
  });
}

class ModelCount {
  String model;
  String make;
  int count;
  bool value;

  ModelCount({
    this.model,
    this.make,
    this.count,
    this.value = false,
  });
}

class SubCatTypeCount {
  String subCatType;
  String subCatDocId;
  int count;
  bool value;

  SubCatTypeCount({
    this.subCatType,
    this.subCatDocId,
    this.count,
    this.value = false,
  });
}

class EngineCount {
  String engine;
  int count;
  bool value;

  EngineCount({
    this.engine,
    this.count,
    this.value = false,
  });
}

class TransmissionCount {
  String transmission;
  int count;
  bool value;

  TransmissionCount({
    this.transmission,
    this.count,
    this.value = false,
  });
}

class DriveTypeCount {
  String driveType;
  int count;
  bool value;

  DriveTypeCount({
    this.driveType,
    this.count,
    this.value = false,
  });
}

class BodyTypeCount {
  String bodyType;
  int count;
  bool value;

  BodyTypeCount({
    this.bodyType,
    this.count,
    this.value = false,
  });
}

class NumberOfCylindersCount {
  String numberOfCylinders;
  int count;
  bool value;

  NumberOfCylindersCount({
    this.numberOfCylinders,
    this.count,
    this.value = false,
  });
}

class ExteriorColorCount {
  String exteriorColor;
  int count;
  bool value;

  ExteriorColorCount({
    this.exteriorColor,
    this.count,
    this.value = false,
  });
}

class InteriorColorCount {
  String interiorColor;
  int count;
  bool value;

  InteriorColorCount({
    this.interiorColor,
    this.count,
    this.value = false,
  });
}

class ForSaleByCount {
  String forSaleBy;
  int count;
  bool value;

  ForSaleByCount({
    this.forSaleBy,
    this.count,
    this.value = false,
  });
}

class TypeOfAdCount {
  String typeOfAd;
  int count;
  bool value;

  TypeOfAdCount({
    this.typeOfAd,
    this.count,
    this.value = false,
  });
}

class ListingStatusCount {
  String listingStatus;
  int count;
  bool value;

  ListingStatusCount({
    this.listingStatus,
    this.count,
    this.value = false,
  });
}

class ProdConditionCount {
  String prodCondition;
  int count;
  bool value;

  ProdConditionCount({
    this.prodCondition,
    this.count,
    this.value = false,
  });
}

class FuelTypeCount {
  String fuelType;
  int count;
  bool value;

  FuelTypeCount({
    this.fuelType,
    this.count,
    this.value = false,
  });
}

class MileageCount {
  String mileage;
  int count;
  bool value;

  MileageCount({
    this.mileage,
    this.count,
    this.value = false,
  });
}

class _MotorFilterScreenState extends State<MotorFilterScreen> {
  GlobalKey<FormState> formKeyPrice = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyYear = GlobalKey<FormState>();
  TextEditingController _controllerMinPrice = TextEditingController();
  TextEditingController _controllerMaxPrice = TextEditingController();
  TextEditingController _controllerMinYear = TextEditingController();
  TextEditingController _controllerMaxYear = TextEditingController();

  List<DropdownMenuItem<String>> _catNames, _subCatNames = [];
  List<CatNameCount> _catNameCounts = [];

  List<SubCatNameCount> _subCatNameCounts = [];

  List<EngineCount> _engineCounts = [];
  List<EngineCount> _engineCountsTrue = [];
  List<String> _engineCountsTrueString = [];

  List<TransmissionCount> _transmissionCounts = [];
  List<TransmissionCount> _transmissionCountsTrue = [];
  List<String> _transmissionCountsTrueString = [];

  List<DriveTypeCount> _driveTypeCounts = [];
  List<DriveTypeCount> _driveTypeCountsTrue = [];
  List<String> _driveTypeCountsTrueString = [];

  List<BodyTypeCount> _bodyTypeCounts = [];
  List<BodyTypeCount> _bodyTypeCountsTrue = [];
  List<String> _bodyTypeCountsTrueString = [];

  List<NumberOfCylindersCount> _numberOfCylindersCounts = [];
  List<NumberOfCylindersCount> _numberOfCylindersCountsTrue = [];
  List<String> _numberOfCylindersCountsTrueString = [];

  List<ExteriorColorCount> _exteriorColorCounts = [];
  List<ExteriorColorCount> _exteriorColorCountsTrue = [];
  List<String> _exteriorColorCountsTrueString = [];

  List<InteriorColorCount> _interiorColorCounts = [];
  List<InteriorColorCount> _interiorColorCountsTrue = [];
  List<String> _interiorColorCountsTrueString = [];

  List<ForSaleByCount> _forSaleByCounts = [];
  List<ForSaleByCount> _forSaleByCountsTrue = [];
  List<String> _forSaleByCountsTrueString = [];

  List<TypeOfAdCount> _typeOfAdCounts = [];
  List<TypeOfAdCount> _typeOfAdCountsTrue = [];
  List<String> _typeOfAdCountsTrueString = [];

  List<ListingStatusCount> _listingStatusCounts = [];
  List<ListingStatusCount> _listingStatusCountsTrue = [];
  List<String> _listingStatusCountsTrueString = [];

  List<ProdConditionCount> _prodConditionCounts = [];
  List<ProdConditionCount> _prodConditionCountsTrue = [];
  List<String> _prodConditionCountsTrueString = [];

  List<FuelTypeCount> _fuelTypeCounts = [];
  List<FuelTypeCount> _fuelTypeCountsTrue = [];
  List<String> _fuelTypeCountsTrueString = [];

  List<MileageCount> _mileageCounts = [];
  List<MileageCount> _mileageCountsTrue = [];
  List<String> _mileageCountsTrueString = [];

  List<MakeCount> _makeCounts = [];
  List<MakeCount> _makeCountsTrue = [];
  List<String> _makeCountsTrueString = [];

  List<ModelCount> _modelCounts = [];
  List<ModelCount> _modelCountsTrue = [];
  List<String> _modelCountsTrueString = [];

  // List<SubCatTypeCount> _subCatTypeCounts = [];
  // List<SubCatTypeCount> _subCatTypeCountsTrue = [];
  // List<String> _subCatTypeCountsTrueString = [];

  List<Product> products, productsBySelectedCat, productsPro = [];
  List<Category> categories = [];
  List<SubCategory> subCategories = [];

  List<String> queriedProdId, queriedProdIdPro = [];

  List<CtmSpecialInfo> ctmSpecialInfos,
      ctmSpecialInfosBySelectedCat,
      ctmSpecialInfosPro = [];

  List<String> filterFields = [];
  int selectedValue = 0;
  String _selectedCategory = '';
  String _selectedSubCategory = '';
  bool _vehicleCategory = false;
  bool _specialVehicle = false;
  String _initialCategory = 'Unspecified';
  String minPrice = '';
  String maxPrice = '';
  String minYear = '';
  String maxYear = '';
  String _countryCode = "";
  String userId = "";
  UserDetail userData = UserDetail();
  bool _isInitialLoad = false;

  @override
  void initState() {
    _selectedCategory = widget.catName;
    _selectedSubCategory = widget.subCatType;
    print('_selectedSubCategory - $_selectedSubCategory');
    if (_selectedCategory == 'Vehicle') {
      _vehicleCategory = true;
    } else {
      _vehicleCategory = false;
    }
    if (_selectedSubCategory == 'Cars' ||
        _selectedSubCategory == 'Trucks' ||
        _selectedSubCategory == 'Caravans') {
      _specialVehicle = true;
    } else {
      _specialVehicle = false;
    }
    _isInitialLoad = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      userId = "";
    } else {
      userId = user.uid;
      List<UserDetail> userDetails = Provider.of<List<UserDetail>>(context);
      userData = UserDetail();
      if (userDetails.length > 0 && user != null) {
        userDetails = userDetails
            .where((e) => e.userDetailDocId.trim() == userId.trim())
            .toList();
        if (userDetails.length > 0) {
          userData = userDetails[0];
          _countryCode = userData.buyingCountryCode;
        }
      }
    }

    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    if (_countryCode.isEmpty) {
      _countryCode = getCurrentLocation.countryCode;
    }

    products = Provider.of<List<Product>>(context);
    if (products != null) {
      products = products
          .where((e) =>
              e.status == 'Verified' &&
              e.listingStatus == 'Available' &&
              e.countryCode == _countryCode)
          .toList();
    }
    categories = Provider.of<List<Category>>(context);
    subCategories = Provider.of<List<SubCategory>>(context);
    ctmSpecialInfos = Provider.of<List<CtmSpecialInfo>>(context);
    if (products.length > 0 &&
        categories.length > 0 &&
        subCategories.length > 0 &&
        ctmSpecialInfos.length > 0) {
      _isInitialLoad = true;
    } else {
      _isInitialLoad = false;
    }

    _buildCatNameCount();
    _buildSubCatNameCount();
    super.didChangeDependencies();
  }

  void _buildCatNameCount() {
    if (categories != null) {
      _catNameCounts = [];

      for (var i = 0; i < categories.length; i++) {
        var cnt = products
            .where((e) =>
                e.catName.trim().toLowerCase() ==
                categories[i].catName.trim().toLowerCase())
            .toList()
            .length;
        if (cnt > 0) {
          CatNameCount _catNameCount = CatNameCount();
          _catNameCount.catName = categories[i].catName;

          _catNameCount.count = cnt;

          _catNameCounts.add(_catNameCount);
        }
      }

      _catNames = [];
      if (_catNameCounts != null) {
        for (CatNameCount _catNameCount in _catNameCounts) {
          _catNames.add(
            DropdownMenuItem(
              value: _catNameCount.catName,
              child: Text('${_catNameCount.catName} (${_catNameCount.count})'),
            ),
          );
        }
      }
    }
  }

  void _buildCatWiseQueryData(String category, String subCategory) {
    ctmSpecialInfosBySelectedCat = [];
    productsBySelectedCat = [];

    initializeFieldCount();

    productsBySelectedCat = products
        .where((p) =>
            (p.catName.trim() == category.trim()) &&
            (p.subCatType.trim() == subCategory.trim()))
        .toList();

    if (productsBySelectedCat.length > 0) {
      queriedProdId = [];
      for (var i = 0; i < productsBySelectedCat.length; i++) {
        queriedProdId.add(productsBySelectedCat[i].prodDocId);

        if (ctmSpecialInfos.length > 0) {
          if (_selectedCategory.trim() == 'Vehicle' &&
              !_selectedSubCategory.contains('Accessories') &&
              !_selectedSubCategory.contains('Others')) {
            var ctmSInfoTemp = ctmSpecialInfos
                .where((e) =>
                    e.prodDocId.trim() == productsBySelectedCat[i].prodDocId)
                .toList();

            ctmSpecialInfosBySelectedCat.add(ctmSInfoTemp[0]);
          }
        }
      }

      setState(() {
        queriedProdIdPro = queriedProdId;

        productsPro = productsBySelectedCat;

        if (ctmSpecialInfosBySelectedCat.length > 0) {
          ctmSpecialInfosPro = ctmSpecialInfosBySelectedCat;
        } else {
          ctmSpecialInfosPro = [];
        }
      });

      _prepareProdCount();
    }
  }

  void _buildSubCatNameCount() {
    var subCatTypes = Provider.of<List<SubCategory>>(context, listen: false);

    if (subCatTypes.length > 0) {
      subCatTypes = subCatTypes
          .where((e) =>
              e.catName.toLowerCase().trim() ==
              _selectedCategory.toLowerCase().trim())
          .toList();

      if (subCatTypes != null) {
        _subCatNameCounts = [];

        for (var i = 0; i < subCatTypes.length; i++) {
          var cnt = products
              .where((e) =>
                  e.subCatType.trim().toLowerCase() ==
                  subCatTypes[i].subCatType.trim().toLowerCase())
              .toList()
              .length;
          if (cnt > 0) {
            SubCatNameCount _subCatNameCount = SubCatNameCount();
            _subCatNameCount.catName = subCatTypes[i].catName;
            _subCatNameCount.subCatName = subCatTypes[i].subCatType;

            _subCatNameCount.count = cnt;

            _subCatNameCounts.add(_subCatNameCount);
          }
        }

        _subCatNames = [];
        if (_subCatNameCounts != null) {
          _selectedSubCategory = _subCatNameCounts[0].subCatName;
          for (SubCatNameCount _subCatNameCount in _subCatNameCounts) {
            _subCatNames.add(
              DropdownMenuItem(
                value: _subCatNameCount.subCatName,
                child: Text(
                    '${_subCatNameCount.subCatName} (${_subCatNameCount.count})'),
              ),
            );
          }
        }
      }
    }
  }

  void _prepareProdCount() {
    if (queriedProdIdPro.length > 0) {
      if (_selectedCategory.trim() == 'Vehicle' ||
          _selectedCategory.trim() == 'Electronics' ||
          _selectedCategory.trim() == 'Home Appliances') {
        _buildMakeCount();
        _buildModelCount();
      }
      // _buildSubCatTypeCount();
      _buildForSaleByCount();
      _buildListingStatusCount();
      _buildProdConditionCount();
      _buildTypeOfAdCount();

      if (_selectedCategory.trim() == 'Vehicle' &&
          !_selectedSubCategory.contains('Accessories') &&
          !_selectedSubCategory.contains('Others')) {
        _buildMileageCount();
        _buildExteriorColorCount();

        if (_specialVehicle) {
          _buildEngineCount();
          _buildTransmissionCount();
          _buildDriveTypeCount();
          _buildBodyTypeCount();
          _buildFuelTypeCount();
          _buildNumberOfCylindersCount();
          _buildInteriorColorCount();
        }
      }
    }
  }

  void _prepareAllFilters() {
    queriedProdIdPro = queriedProdId;

    productsPro = productsBySelectedCat;

    if (_selectedCategory.trim() == 'Vehicle'.trim() &&
        !_selectedSubCategory.contains('Accessories') &&
        !_selectedSubCategory.contains('Others')) {
      ctmSpecialInfosPro = ctmSpecialInfosBySelectedCat;
    } else {
      ctmSpecialInfosPro = [];
    }

    if (filterFields.length > 0) {
      for (var i = 0; i < filterFields.length; i++) {
        _prepareFilters(filterFields[i]);
      }
    } else {
      initializeFieldCount();
    }
  }

  void initializeFieldCount() {
    filterFields = [];

    _makeCountsTrue = [];
    _makeCountsTrueString = [];

    _modelCountsTrue = [];
    _modelCountsTrueString = [];

    // _subCatTypeCountsTrue = [];
    // _subCatTypeCountsTrueString = [];

    _mileageCountsTrue = [];
    _mileageCountsTrueString = [];

    _engineCountsTrue = [];
    _engineCountsTrueString = [];

    _transmissionCountsTrue = [];
    _transmissionCountsTrueString = [];

    _driveTypeCountsTrue = [];
    _driveTypeCountsTrueString = [];

    _bodyTypeCountsTrue = [];
    _bodyTypeCountsTrueString = [];

    _fuelTypeCountsTrue = [];
    _fuelTypeCountsTrueString = [];

    _numberOfCylindersCountsTrue = [];
    _numberOfCylindersCountsTrueString = [];

    _exteriorColorCountsTrue = [];
    _exteriorColorCountsTrueString = [];

    _interiorColorCountsTrue = [];
    _interiorColorCountsTrueString = [];

    _forSaleByCountsTrue = [];
    _forSaleByCountsTrueString = [];

    _typeOfAdCountsTrue = [];
    _typeOfAdCountsTrueString = [];

    _listingStatusCountsTrue = [];
    _listingStatusCountsTrueString = [];

    _prodConditionCountsTrue = [];
    _prodConditionCountsTrueString = [];
  }

  void _prepareFilters(String selectionField) {
    if (queriedProdIdPro.length > 0) {
      switch (selectionField) {
        case 'make':
          _buildMakeQueryData();
          break;
        case 'model':
          _buildModelQueryData();
          break;
        // case 'subCatType':
        //   _buildSubCatTypeQueryData();
        //   break;
        case 'engine':
          _buildEngineQueryData();
          break;
        case 'price':
          _buildPriceQueryData();
          break;
        case 'year':
          _buildYearQueryData();
          break;
        case 'transmission':
          _buildTransmissionQueryData();
          break;
        case 'driveType':
          _buildDriveTypeQueryData();
          break;
        case 'bodyType':
          _buildBodyTypeQueryData();
          break;
        case 'fuelType':
          _buildFuelTypeQueryData();
          break;
        case 'numberOfCylinders':
          _buildNumberOfCylindersQueryData();
          break;
        case 'exteriorColor':
          _buildExteriorColorQueryData();
          break;
        case 'interiorColor':
          _buildInteriorColorQueryData();
          break;
        case 'forSaleBy':
          _buildForSaleByQueryData();
          break;

        case 'typeOfAd':
          _buildTypeOfAdQueryData();
          break;
        case 'listingStatus':
          _buildListingStatusQueryData();
          break;
        case 'prodCondition':
          _buildProdConditionQueryData();
          break;
        case 'mileage':
          _buildMileageQueryData();
          break;
        default:
      }
    }
  }

  void _buildFilters(String selectionField) {
    if (queriedProdIdPro.length > 0) {
      if (selectionField != 'make') {
        _buildMakeCount();
      } else {
        if (filterFields.any((e) => e == 'make')) {
        } else {
          _makeCountsTrue = [];
          _makeCountsTrueString = [];
          _buildMakeCount();
        }
      }

      if (selectionField != 'model') {
        _buildModelCount();
      } else {
        if (filterFields.any((e) => e == 'model')) {
        } else {
          _modelCountsTrue = [];
          _modelCountsTrueString = [];
          _buildModelCount();
        }
      }

      if (selectionField != 'engine') {
        _buildEngineCount();
      } else {
        if (filterFields.any((e) => e == 'engine')) {
        } else {
          _engineCountsTrue = [];
          _engineCountsTrueString = [];
          _buildEngineCount();
        }
      }
      if (selectionField != 'transmission') {
        _buildTransmissionCount();
      } else {
        if (filterFields.any((e) => e == 'transmission')) {
        } else {
          _transmissionCountsTrue = [];
          _transmissionCountsTrueString = [];
          _buildTransmissionCount();
        }
      }
      if (selectionField != 'driveType') {
        _buildDriveTypeCount();
      } else {
        if (filterFields.any((e) => e == 'driveType')) {
        } else {
          _driveTypeCountsTrue = [];
          _driveTypeCountsTrueString = [];
          _buildDriveTypeCount();
        }
      }
      if (selectionField != 'bodyType') {
        _buildBodyTypeCount();
      } else {
        if (filterFields.any((e) => e == 'bodyType')) {
        } else {
          _bodyTypeCountsTrue = [];
          _bodyTypeCountsTrueString = [];
          _buildBodyTypeCount();
        }
      }
      if (selectionField != 'fuelType') {
        _buildFuelTypeCount();
      } else {
        if (filterFields.any((e) => e == 'fuelType')) {
        } else {
          _fuelTypeCountsTrue = [];
          _fuelTypeCountsTrueString = [];
          _buildFuelTypeCount();
        }
      }
      if (selectionField != 'numberOfCylinders') {
        _buildNumberOfCylindersCount();
      } else {
        if (filterFields.any((e) => e == 'numberOfCylinders')) {
        } else {
          _numberOfCylindersCountsTrue = [];
          _numberOfCylindersCountsTrueString = [];
          _buildNumberOfCylindersCount();
        }
      }
      if (selectionField != 'exteriorColor') {
        _buildExteriorColorCount();
      } else {
        if (filterFields.any((e) => e == 'exteriorColor')) {
        } else {
          _exteriorColorCountsTrue = [];
          _exteriorColorCountsTrueString = [];
          _buildExteriorColorCount();
        }
      }
      if (selectionField != 'interiorColor') {
        _buildInteriorColorCount();
      } else {
        if (filterFields.any((e) => e == 'interiorColor')) {
        } else {
          _interiorColorCountsTrue = [];
          _interiorColorCountsTrueString = [];
          _buildInteriorColorCount();
        }
      }
      if (selectionField != 'forSaleBy') {
        _buildForSaleByCount();
      } else {
        if (filterFields.any((e) => e == 'forSaleBy')) {
        } else {
          _forSaleByCountsTrue = [];
          _forSaleByCountsTrueString = [];
          _buildForSaleByCount();
        }
      }
      if (selectionField != 'typeOfAd') {
        _buildTypeOfAdCount();
      } else {
        if (filterFields.any((e) => e == 'typeOfAd')) {
        } else {
          _typeOfAdCountsTrue = [];
          _typeOfAdCountsTrueString = [];
          _buildTypeOfAdCount();
        }
      }
      if (selectionField != 'listingStatus') {
        _buildListingStatusCount();
      } else {
        if (filterFields.any((e) => e == 'listingStatus')) {
        } else {
          _listingStatusCountsTrue = [];
          _listingStatusCountsTrueString = [];
          _buildListingStatusCount();
        }
      }
      if (selectionField != 'prodCondition') {
        _buildProdConditionCount();
      } else {
        if (filterFields.any((e) => e == 'prodCondition')) {
        } else {
          _prodConditionCountsTrue = [];
          _prodConditionCountsTrueString = [];
          _buildProdConditionCount();
        }
      }
      if (selectionField != 'mileage') {
        _buildMileageCount();
      } else {
        if (filterFields.any((e) => e == 'mileage')) {
        } else {
          _mileageCountsTrue = [];
          _mileageCountsTrueString = [];
          _buildMileageCount();
        }
      }
    }
  }

  void _buildMakeCount() {
    if (productsPro.length > 0) {
      var oldMake = '';

      _makeCounts = [];

      productsPro.sort((a, b) {
        var aMake = a.make;
        var bMake = b.make;
        return aMake.compareTo(bMake);
      });

      for (var i = 0; i < productsPro.length; i++) {
        if (oldMake != productsPro[i].make) {
          oldMake = productsPro[i].make;

          var cnt = productsPro
              .where((e) => e.make.toLowerCase() == oldMake.toLowerCase())
              .toList()
              .length;

          MakeCount _makeCount = MakeCount();
          _makeCount.make = productsPro[i].make;
          _makeCount.count = cnt;
          if (_makeCountsTrue.any((e) => e.make == productsPro[i].make)) {
            _makeCount.value = true;
          }

          _makeCounts.add(_makeCount);
        }
      }
    }
  }

  void _buildModelCount() {
    if (productsPro.length > 0) {
      var oldModel = '';

      _modelCounts = [];

      productsPro.sort((a, b) {
        var aModel = a.make + a.model;
        var bModel = b.make + b.model;
        return aModel.compareTo(bModel);
      });

      for (var i = 0; i < productsPro.length; i++) {
        if (oldModel != productsPro[i].model) {
          oldModel = productsPro[i].model;

          var cnt = productsPro
              .where((e) => e.model.toLowerCase() == oldModel.toLowerCase())
              .toList()
              .length;

          ModelCount _modelCount = ModelCount();
          _modelCount.model = productsPro[i].model;
          _modelCount.make = productsPro[i].make;
          if (_modelCountsTrue.any((e) => e.model == productsPro[i].model)) {
            _modelCount.value = true;
          }
          _modelCount.count = cnt;

          _modelCounts.add(_modelCount);
        }
      }
    }
  }

  void _buildEngineCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldEngine = '';

        _engineCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var aEngine = a.engine;
          var bEngine = b.engine;
          return aEngine.compareTo(bEngine);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldEngine != ctmSpecialInfosPro[i].engine.trim()) {
            oldEngine = ctmSpecialInfosPro[i].engine.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) => e.engine.trim() == oldEngine.trim())
                .toList()
                .length;

            EngineCount _engineCount = EngineCount();
            _engineCount.engine = ctmSpecialInfosPro[i].engine.trim();
            _engineCount.count = cnt;
            if (_engineCountsTrue.any((e) =>
                e.engine.trim() == ctmSpecialInfosPro[i].engine.trim())) {
              _engineCount.value = true;
            }

            _engineCounts.add(_engineCount);
          }
        }
      }
    }
  }

  void _buildTransmissionCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldTransmission = '';

        _transmissionCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var atransmission = a.transmission;
          var btransmission = b.transmission;
          return atransmission.compareTo(btransmission);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldTransmission != ctmSpecialInfosPro[i].transmission.trim()) {
            oldTransmission = ctmSpecialInfosPro[i].transmission.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) => e.transmission.trim() == oldTransmission.trim())
                .toList()
                .length;

            TransmissionCount _transmissionCount = TransmissionCount();
            _transmissionCount.transmission =
                ctmSpecialInfosPro[i].transmission.trim();
            _transmissionCount.count = cnt;
            if (_transmissionCountsTrue.any((e) =>
                e.transmission.trim() ==
                ctmSpecialInfosPro[i].transmission.trim())) {
              _transmissionCount.value = true;
            }

            _transmissionCounts.add(_transmissionCount);
          }
        }
      }
    }
  }

  void _buildDriveTypeCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldDriveType = '';

        _driveTypeCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var aDriveType = a.driveType;
          var bDriveType = b.driveType;
          return aDriveType.compareTo(bDriveType);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldDriveType != ctmSpecialInfosPro[i].driveType.trim()) {
            oldDriveType = ctmSpecialInfosPro[i].driveType.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) => e.driveType.trim() == oldDriveType.trim())
                .toList()
                .length;

            DriveTypeCount _driveTypeCount = DriveTypeCount();
            _driveTypeCount.driveType = ctmSpecialInfosPro[i].driveType.trim();
            _driveTypeCount.count = cnt;
            if (_driveTypeCountsTrue.any((e) =>
                e.driveType.trim() == ctmSpecialInfosPro[i].driveType.trim())) {
              _driveTypeCount.value = true;
            }

            _driveTypeCounts.add(_driveTypeCount);
          }
        }
      }
    }
  }

  void _buildBodyTypeCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldbodyType = '';

        _bodyTypeCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var abodyType = a.bodyType;
          var bbodyType = b.bodyType;
          return abodyType.compareTo(bbodyType);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldbodyType != ctmSpecialInfosPro[i].bodyType.trim()) {
            oldbodyType = ctmSpecialInfosPro[i].bodyType.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) => e.bodyType.trim() == oldbodyType.trim())
                .toList()
                .length;

            BodyTypeCount _bodyTypeCount = BodyTypeCount();
            _bodyTypeCount.bodyType = ctmSpecialInfosPro[i].bodyType.trim();
            _bodyTypeCount.count = cnt;
            if (_bodyTypeCountsTrue.any((e) =>
                e.bodyType.trim() == ctmSpecialInfosPro[i].bodyType.trim())) {
              _bodyTypeCount.value = true;
            }

            _bodyTypeCounts.add(_bodyTypeCount);
          }
        }
      }
    }
  }

  void _buildFuelTypeCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldfuelType = '';

        _fuelTypeCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var afuelType = a.fuelType;
          var bfuelType = b.fuelType;
          return afuelType.compareTo(bfuelType);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldfuelType != ctmSpecialInfosPro[i].fuelType.trim()) {
            oldfuelType = ctmSpecialInfosPro[i].fuelType.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) => e.fuelType.trim() == oldfuelType.trim())
                .toList()
                .length;

            FuelTypeCount _fuelTypeCount = FuelTypeCount();
            _fuelTypeCount.fuelType = ctmSpecialInfosPro[i].fuelType.trim();
            _fuelTypeCount.count = cnt;
            if (_fuelTypeCountsTrue.any((e) =>
                e.fuelType.trim() == ctmSpecialInfosPro[i].fuelType.trim())) {
              _fuelTypeCount.value = true;
            }

            _fuelTypeCounts.add(_fuelTypeCount);
          }
        }
      }
    }
  }

  void _buildNumberOfCylindersCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldnumberOfCylinders = '';

        _numberOfCylindersCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var aNumberOfCylinders = a.numberOfCylinders;
          var bNumberOfCylinders = b.numberOfCylinders;

          return aNumberOfCylinders.compareTo(bNumberOfCylinders);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldnumberOfCylinders !=
              ctmSpecialInfosPro[i].numberOfCylinders.trim()) {
            oldnumberOfCylinders =
                ctmSpecialInfosPro[i].numberOfCylinders.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) =>
                    e.numberOfCylinders.trim() == oldnumberOfCylinders.trim())
                .toList()
                .length;

            NumberOfCylindersCount _numberOfCylindersCount =
                NumberOfCylindersCount();
            _numberOfCylindersCount.numberOfCylinders =
                ctmSpecialInfosPro[i].numberOfCylinders.trim();
            _numberOfCylindersCount.count = cnt;
            if (_numberOfCylindersCountsTrue.any((e) =>
                e.numberOfCylinders.trim() ==
                ctmSpecialInfosPro[i].numberOfCylinders.trim())) {
              _numberOfCylindersCount.value = true;
            }

            _numberOfCylindersCounts.add(_numberOfCylindersCount);
          }
        }
      }
    }
  }

  void _buildExteriorColorCount() {
    if (ctmSpecialInfosPro.length > 0) {
      var oldexteriorColor = '';

      _exteriorColorCounts = [];

      ctmSpecialInfosPro.sort((a, b) {
        var aexteriorColor = a.exteriorColor;
        var bexteriorColor = b.exteriorColor;

        return aexteriorColor.compareTo(bexteriorColor);
      });

      for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
        if (oldexteriorColor != ctmSpecialInfosPro[i].exteriorColor.trim()) {
          oldexteriorColor = ctmSpecialInfosPro[i].exteriorColor.trim();

          var cnt = ctmSpecialInfosPro
              .where((e) => e.exteriorColor.trim() == oldexteriorColor.trim())
              .toList()
              .length;

          ExteriorColorCount _exteriorColorCount = ExteriorColorCount();
          _exteriorColorCount.exteriorColor =
              ctmSpecialInfosPro[i].exteriorColor.trim();
          _exteriorColorCount.count = cnt;
          if (_exteriorColorCountsTrue.any((e) =>
              e.exteriorColor.trim() ==
              ctmSpecialInfosPro[i].exteriorColor.trim())) {
            _exteriorColorCount.value = true;
          }

          _exteriorColorCounts.add(_exteriorColorCount);
        }
      }
    }
  }

  void _buildInteriorColorCount() {
    if (ctmSpecialInfosPro.length > 0) {
      if (_specialVehicle) {
        var oldinteriorColor = '';

        _interiorColorCounts = [];

        ctmSpecialInfosPro.sort((a, b) {
          var ainteriorColor = a.interiorColor;
          var binteriorColor = b.interiorColor;

          return ainteriorColor.compareTo(binteriorColor);
        });

        for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
          if (oldinteriorColor != ctmSpecialInfosPro[i].interiorColor.trim()) {
            oldinteriorColor = ctmSpecialInfosPro[i].interiorColor.trim();

            var cnt = ctmSpecialInfosPro
                .where((e) => e.interiorColor.trim() == oldinteriorColor.trim())
                .toList()
                .length;

            InteriorColorCount _interiorColorCount = InteriorColorCount();
            _interiorColorCount.interiorColor =
                ctmSpecialInfosPro[i].interiorColor.trim();
            _interiorColorCount.count = cnt;
            if (_interiorColorCountsTrue.any((e) =>
                e.interiorColor.trim() ==
                ctmSpecialInfosPro[i].interiorColor.trim())) {
              _interiorColorCount.value = true;
            }

            _interiorColorCounts.add(_interiorColorCount);
          }
        }
      }
    }
  }

  void _buildForSaleByCount() {
    if (productsPro.length > 0) {
      var oldforSaleBy = '';

      _forSaleByCounts = [];

      productsPro.sort((a, b) {
        var aforSaleBy = a.forSaleBy;
        var bforSaleBy = b.forSaleBy;

        return aforSaleBy.compareTo(bforSaleBy);
      });

      for (var i = 0; i < productsPro.length; i++) {
        if (oldforSaleBy != productsPro[i].forSaleBy.trim()) {
          oldforSaleBy = productsPro[i].forSaleBy.trim();

          var cnt = productsPro
              .where((e) => e.forSaleBy.trim() == oldforSaleBy.trim())
              .toList()
              .length;

          ForSaleByCount _forSaleByCount = ForSaleByCount();
          _forSaleByCount.forSaleBy = productsPro[i].forSaleBy.trim();
          _forSaleByCount.count = cnt;
          if (_forSaleByCountsTrue.any(
              (e) => e.forSaleBy.trim() == productsPro[i].forSaleBy.trim())) {
            _forSaleByCount.value = true;
          }

          _forSaleByCounts.add(_forSaleByCount);
        }
      }
    }
  }

  void _buildTypeOfAdCount() {
    if (productsPro.length > 0) {
      var oldtypeOfAd = '';

      _typeOfAdCounts = [];

      productsPro.sort((a, b) {
        var atypeOfAd = a.typeOfAd;
        var btypeOfAd = b.typeOfAd;

        return atypeOfAd.compareTo(btypeOfAd);
      });

      for (var i = 0; i < productsPro.length; i++) {
        if (oldtypeOfAd != productsPro[i].typeOfAd.trim()) {
          oldtypeOfAd = productsPro[i].typeOfAd.trim();

          var cnt = productsPro
              .where((e) => e.typeOfAd.trim() == oldtypeOfAd.trim())
              .toList()
              .length;

          TypeOfAdCount _typeOfAdCount = TypeOfAdCount();
          _typeOfAdCount.typeOfAd = productsPro[i].typeOfAd.trim();
          _typeOfAdCount.count = cnt;
          if (_typeOfAdCountsTrue.any(
              (e) => e.typeOfAd.trim() == productsPro[i].typeOfAd.trim())) {
            _typeOfAdCount.value = true;
          }

          _typeOfAdCounts.add(_typeOfAdCount);
        }
      }
    }
  }

  void _buildListingStatusCount() {
    if (productsPro.length > 0) {
      var oldListingStatus = '';

      _listingStatusCounts = [];

      productsPro.sort((a, b) {
        var aListingStatus = a.listingStatus;
        var bListingStatus = b.listingStatus;

        return aListingStatus.compareTo(bListingStatus);
      });

      for (var i = 0; i < productsPro.length; i++) {
        if (oldListingStatus != productsPro[i].listingStatus.trim()) {
          oldListingStatus = productsPro[i].listingStatus.trim();

          var cnt = productsPro
              .where((e) => e.listingStatus.trim() == oldListingStatus.trim())
              .toList()
              .length;

          ListingStatusCount _listingStatusCount = ListingStatusCount();
          _listingStatusCount.listingStatus =
              productsPro[i].listingStatus.trim();
          _listingStatusCount.count = cnt;
          if (_listingStatusCountsTrue.any((e) =>
              e.listingStatus.trim() == productsPro[i].listingStatus.trim())) {
            _listingStatusCount.value = true;
          }

          _listingStatusCounts.add(_listingStatusCount);
        }
      }
    }
  }

  void _buildProdConditionCount() {
    if (productsPro.length > 0) {
      var oldprodCondition = '';

      _prodConditionCounts = [];

      productsPro.sort((a, b) {
        var aprodCondition = a.prodCondition;
        var bprodCondition = b.prodCondition;

        return aprodCondition.compareTo(bprodCondition);
      });

      for (var i = 0; i < productsPro.length; i++) {
        if (oldprodCondition != productsPro[i].prodCondition.trim()) {
          oldprodCondition = productsPro[i].prodCondition.trim();

          var cnt = productsPro
              .where((e) => e.prodCondition.trim() == oldprodCondition.trim())
              .toList()
              .length;

          ProdConditionCount _prodConditionCount = ProdConditionCount();
          _prodConditionCount.prodCondition =
              productsPro[i].prodCondition.trim();
          _prodConditionCount.count = cnt;
          if (_prodConditionCountsTrue.any((e) =>
              e.prodCondition.trim() == productsPro[i].prodCondition.trim())) {
            _prodConditionCount.value = true;
          }

          _prodConditionCounts.add(_prodConditionCount);
        }
      }
    }
  }

  void _buildMileageCount() {
    if (ctmSpecialInfosPro.length > 0) {
      var oldmileage = '';

      _mileageCounts = [];

      ctmSpecialInfosPro.sort((a, b) {
        var amileage = a.mileage;
        var bmileage = b.mileage;
        return amileage.compareTo(bmileage);
      });

      for (var i = 0; i < ctmSpecialInfosPro.length; i++) {
        if (oldmileage != ctmSpecialInfosPro[i].mileage.trim()) {
          oldmileage = ctmSpecialInfosPro[i].mileage.trim();

          var cnt = ctmSpecialInfosPro
              .where((e) => e.mileage.trim() == oldmileage.trim())
              .toList()
              .length;

          MileageCount _mileageCount = MileageCount();
          _mileageCount.mileage = ctmSpecialInfosPro[i].mileage.trim();
          _mileageCount.count = cnt;
          if (_mileageCountsTrue.any((e) =>
              e.mileage.trim() == ctmSpecialInfosPro[i].mileage.trim())) {
            _mileageCount.value = true;
          }

          _mileageCounts.add(_mileageCount);
        }
      }
    }
  }

  void _buildMakeQueryData() {
    _makeCountsTrue = [];
    _makeCountsTrueString = [];

    _makeCountsTrue = _makeCounts.where((c) => c.value == true).toList();

    if (_makeCountsTrue.length > 0) {
      List<Product> productsQueryMake = [];

      List<CtmSpecialInfo> ctmSpecialInfosQueryMake = [];

      for (var i = 0; i < _makeCountsTrue.length; i++) {
        _makeCountsTrueString.add(_makeCountsTrue[i].make);
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          var ctmSpecialInfosTempMake = ctmSpecialInfosPro
              .where((p) => p.make == _makeCountsTrue[i].make)
              .toList();
          ctmSpecialInfosQueryMake =
              ctmSpecialInfosQueryMake + ctmSpecialInfosTempMake;
        }

        var productsTempMake = productsPro
            .where((p) => p.make == _makeCountsTrue[i].make)
            .toList();
        productsQueryMake = productsQueryMake + productsTempMake;
      }

      List<String> queriedProdIdMake = [];
      for (var i = 0; i < productsQueryMake.length; i++) {
        queriedProdIdMake.add(productsQueryMake[i].prodDocId);
      }
      setState(() {
        productsPro = productsQueryMake;

        queriedProdIdPro = queriedProdIdMake;
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryMake;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    }
  }

  void _buildModelQueryData() {
    _modelCountsTrue = [];
    _modelCountsTrueString = [];

    _modelCountsTrue = _modelCounts.where((c) => c.value == true).toList();

    if (_modelCountsTrue.length > 0) {
      List<Product> productsQueryModel = [];
      List<CtmSpecialInfo> ctmSpecialInfosQueryModel = [];
      for (var i = 0; i < _modelCountsTrue.length; i++) {
        _modelCountsTrueString.add(_modelCountsTrue[i].model);
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          var ctmSpecialInfosTempModel = ctmSpecialInfosPro
              .where((p) => p.model == _modelCountsTrue[i].model)
              .toList();
          ctmSpecialInfosQueryModel =
              ctmSpecialInfosQueryModel + ctmSpecialInfosTempModel;
        }

        var productsTempModel = productsPro
            .where((p) => p.model == _modelCountsTrue[i].model)
            .toList();
        productsQueryModel = productsQueryModel + productsTempModel;
      }

      List<String> queriedProdIdModel = [];
      for (var i = 0; i < productsQueryModel.length; i++) {
        queriedProdIdModel.add(productsQueryModel[i].prodDocId);
      }
      setState(() {
        productsPro = productsQueryModel;
        queriedProdIdPro = queriedProdIdModel;
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryModel;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    }
  }

  void _buildEngineQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _engineCountsTrue = [];
      _engineCountsTrueString = [];

      _engineCountsTrue = _engineCounts.where((c) => c.value == true).toList();

      if (_engineCountsTrue.length > 0) {
        List<Product> productsQueryEngine = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryEngine = [];
        for (var i = 0; i < _engineCountsTrue.length; i++) {
          _engineCountsTrueString.add(_engineCountsTrue[i].engine);
          var ctmSpecialInfosTempEngine = ctmSpecialInfosPro
              .where(
                  (p) => p.engine.trim() == _engineCountsTrue[i].engine.trim())
              .toList();
          ctmSpecialInfosQueryEngine =
              ctmSpecialInfosQueryEngine + ctmSpecialInfosTempEngine;
        }

        for (var i = 0; i < ctmSpecialInfosQueryEngine.length; i++) {
          var productsTempEngine = productsPro
              .where(
                  (p) => p.prodDocId == ctmSpecialInfosQueryEngine[i].prodDocId)
              .toList();
          productsQueryEngine.add(productsTempEngine[0]);
        }

        List<String> queriedProdIdEngine = [];
        for (var i = 0; i < productsQueryEngine.length; i++) {
          queriedProdIdEngine.add(productsQueryEngine[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryEngine;
          productsPro = productsQueryEngine;
          queriedProdIdPro = queriedProdIdEngine;
        });
      }
    }
  }

  void _buildTransmissionQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _transmissionCountsTrue = [];
      _transmissionCountsTrueString = [];

      _transmissionCountsTrue =
          _transmissionCounts.where((c) => c.value == true).toList();

      if (_transmissionCountsTrue.length > 0) {
        List<Product> productsQueryTransmission = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryTransmission = [];
        for (var i = 0; i < _transmissionCountsTrue.length; i++) {
          _transmissionCountsTrueString
              .add(_transmissionCountsTrue[i].transmission);
          var ctmSpecialInfosTempTransmission = ctmSpecialInfosPro
              .where((p) =>
                  p.transmission.trim() ==
                  _transmissionCountsTrue[i].transmission.trim())
              .toList();
          ctmSpecialInfosQueryTransmission = ctmSpecialInfosQueryTransmission +
              ctmSpecialInfosTempTransmission;
        }

        for (var i = 0; i < ctmSpecialInfosQueryTransmission.length; i++) {
          var productsTempTransmission = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryTransmission[i].prodDocId)
              .toList();
          productsQueryTransmission.add(productsTempTransmission[0]);
        }

        List<String> queriedProdIdTransmission = [];
        for (var i = 0; i < productsQueryTransmission.length; i++) {
          queriedProdIdTransmission.add(productsQueryTransmission[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryTransmission;
          productsPro = productsQueryTransmission;
          queriedProdIdPro = queriedProdIdTransmission;
        });
      }
    }
  }

  void _buildDriveTypeQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _driveTypeCountsTrue = [];
      _driveTypeCountsTrueString = [];

      _driveTypeCountsTrue =
          _driveTypeCounts.where((c) => c.value == true).toList();

      if (_driveTypeCountsTrue.length > 0) {
        List<Product> productsQueryDriveType = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryDriveType = [];
        for (var i = 0; i < _driveTypeCountsTrue.length; i++) {
          _driveTypeCountsTrueString.add(_driveTypeCountsTrue[i].driveType);
          var ctmSpecialInfosTempDriveType = ctmSpecialInfosPro
              .where((p) =>
                  p.driveType.trim() ==
                  _driveTypeCountsTrue[i].driveType.trim())
              .toList();
          ctmSpecialInfosQueryDriveType =
              ctmSpecialInfosQueryDriveType + ctmSpecialInfosTempDriveType;
        }

        for (var i = 0; i < ctmSpecialInfosQueryDriveType.length; i++) {
          var productsTempDriveType = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryDriveType[i].prodDocId)
              .toList();
          productsQueryDriveType.add(productsTempDriveType[0]);
        }

        List<String> queriedProdIdDriveType = [];
        for (var i = 0; i < productsQueryDriveType.length; i++) {
          queriedProdIdDriveType.add(productsQueryDriveType[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryDriveType;
          productsPro = productsQueryDriveType;
          queriedProdIdPro = queriedProdIdDriveType;
        });
      }
    }
  }

  void _buildBodyTypeQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _bodyTypeCountsTrue = [];
      _bodyTypeCountsTrueString = [];

      _bodyTypeCountsTrue =
          _bodyTypeCounts.where((c) => c.value == true).toList();

      if (_bodyTypeCountsTrue.length > 0) {
        List<Product> productsQueryBodyType = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryBodyType = [];
        for (var i = 0; i < _bodyTypeCountsTrue.length; i++) {
          _bodyTypeCountsTrueString.add(_bodyTypeCountsTrue[i].bodyType);
          var ctmSpecialInfosTempBodyType = ctmSpecialInfosPro
              .where((p) =>
                  p.bodyType.trim() == _bodyTypeCountsTrue[i].bodyType.trim())
              .toList();
          ctmSpecialInfosQueryBodyType =
              ctmSpecialInfosQueryBodyType + ctmSpecialInfosTempBodyType;
        }

        for (var i = 0; i < ctmSpecialInfosQueryBodyType.length; i++) {
          var productsTempBodyType = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryBodyType[i].prodDocId)
              .toList();
          productsQueryBodyType.add(productsTempBodyType[0]);
        }

        List<String> queriedProdIdBodyType = [];
        for (var i = 0; i < productsQueryBodyType.length; i++) {
          queriedProdIdBodyType.add(productsQueryBodyType[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryBodyType;
          productsPro = productsQueryBodyType;
          queriedProdIdPro = queriedProdIdBodyType;
        });
      }
    }
  }

  void _buildFuelTypeQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _fuelTypeCountsTrue = [];
      _fuelTypeCountsTrueString = [];

      _fuelTypeCountsTrue =
          _fuelTypeCounts.where((c) => c.value == true).toList();

      if (_fuelTypeCountsTrue.length > 0) {
        List<Product> productsQueryFuelType = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryFuelType = [];
        for (var i = 0; i < _fuelTypeCountsTrue.length; i++) {
          _fuelTypeCountsTrueString.add(_fuelTypeCountsTrue[i].fuelType);
          var ctmSpecialInfosTempFuelType = ctmSpecialInfosPro
              .where((p) =>
                  p.fuelType.trim() == _fuelTypeCountsTrue[i].fuelType.trim())
              .toList();
          ctmSpecialInfosQueryFuelType =
              ctmSpecialInfosQueryFuelType + ctmSpecialInfosTempFuelType;
        }

        for (var i = 0; i < ctmSpecialInfosQueryFuelType.length; i++) {
          var productsTempFuelType = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryFuelType[i].prodDocId)
              .toList();
          productsQueryFuelType.add(productsTempFuelType[0]);
        }

        List<String> queriedProdIdFuelType = [];
        for (var i = 0; i < productsQueryFuelType.length; i++) {
          queriedProdIdFuelType.add(productsQueryFuelType[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryFuelType;
          productsPro = productsQueryFuelType;
          queriedProdIdPro = queriedProdIdFuelType;
        });
      }
    }
  }

  void _buildNumberOfCylindersQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _numberOfCylindersCountsTrue = [];
      _numberOfCylindersCountsTrueString = [];

      _numberOfCylindersCountsTrue =
          _numberOfCylindersCounts.where((c) => c.value == true).toList();

      if (_numberOfCylindersCountsTrue.length > 0) {
        List<Product> productsQueryNumberOfCylinders = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryNumberOfCylinders = [];
        for (var i = 0; i < _numberOfCylindersCountsTrue.length; i++) {
          _numberOfCylindersCountsTrueString
              .add(_numberOfCylindersCountsTrue[i].numberOfCylinders);
          var ctmSpecialInfosTempNumberOfCylinders = ctmSpecialInfosPro
              .where((p) =>
                  p.numberOfCylinders.trim() ==
                  _numberOfCylindersCountsTrue[i].numberOfCylinders.trim())
              .toList();
          ctmSpecialInfosQueryNumberOfCylinders =
              ctmSpecialInfosQueryNumberOfCylinders +
                  ctmSpecialInfosTempNumberOfCylinders;
        }

        for (var i = 0; i < ctmSpecialInfosQueryNumberOfCylinders.length; i++) {
          var productsTempNumberOfCylinders = productsPro
              .where((p) =>
                  p.prodDocId ==
                  ctmSpecialInfosQueryNumberOfCylinders[i].prodDocId)
              .toList();
          productsQueryNumberOfCylinders.add(productsTempNumberOfCylinders[0]);
        }

        List<String> queriedProdIdNumberOfCylinders = [];
        for (var i = 0; i < productsQueryNumberOfCylinders.length; i++) {
          queriedProdIdNumberOfCylinders
              .add(productsQueryNumberOfCylinders[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryNumberOfCylinders;
          productsPro = productsQueryNumberOfCylinders;
          queriedProdIdPro = queriedProdIdNumberOfCylinders;
        });
      }
    }
  }

  void _buildExteriorColorQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _exteriorColorCountsTrue = [];
      _exteriorColorCountsTrueString = [];

      _exteriorColorCountsTrue =
          _exteriorColorCounts.where((c) => c.value == true).toList();

      if (_exteriorColorCountsTrue.length > 0) {
        List<Product> productsQueryExteriorColor = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryExteriorColor = [];
        for (var i = 0; i < _exteriorColorCountsTrue.length; i++) {
          _exteriorColorCountsTrueString
              .add(_exteriorColorCountsTrue[i].exteriorColor);
          var ctmSpecialInfosTempExteriorColor = ctmSpecialInfosPro
              .where((p) =>
                  p.exteriorColor.trim() ==
                  _exteriorColorCountsTrue[i].exteriorColor.trim())
              .toList();
          ctmSpecialInfosQueryExteriorColor =
              ctmSpecialInfosQueryExteriorColor +
                  ctmSpecialInfosTempExteriorColor;
        }

        for (var i = 0; i < ctmSpecialInfosQueryExteriorColor.length; i++) {
          var productsTempExteriorColor = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryExteriorColor[i].prodDocId)
              .toList();
          productsQueryExteriorColor.add(productsTempExteriorColor[0]);
        }

        List<String> queriedProdIdExteriorColor = [];
        for (var i = 0; i < productsQueryExteriorColor.length; i++) {
          queriedProdIdExteriorColor
              .add(productsQueryExteriorColor[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryExteriorColor;
          productsPro = productsQueryExteriorColor;
          queriedProdIdPro = queriedProdIdExteriorColor;
        });
      }
    }
  }

  void _buildInteriorColorQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _interiorColorCountsTrue = [];
      _interiorColorCountsTrueString = [];

      _interiorColorCountsTrue =
          _interiorColorCounts.where((c) => c.value == true).toList();

      if (_interiorColorCountsTrue.length > 0) {
        List<Product> productsQueryInteriorColor = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryInteriorColor = [];
        for (var i = 0; i < _interiorColorCountsTrue.length; i++) {
          _interiorColorCountsTrueString
              .add(_interiorColorCountsTrue[i].interiorColor);
          var ctmSpecialInfosTempInteriorColor = ctmSpecialInfosPro
              .where((p) =>
                  p.interiorColor.trim() ==
                  _interiorColorCountsTrue[i].interiorColor.trim())
              .toList();
          ctmSpecialInfosQueryInteriorColor =
              ctmSpecialInfosQueryInteriorColor +
                  ctmSpecialInfosTempInteriorColor;
        }

        for (var i = 0; i < ctmSpecialInfosQueryInteriorColor.length; i++) {
          var productsTempInteriorColor = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryInteriorColor[i].prodDocId)
              .toList();
          productsQueryInteriorColor.add(productsTempInteriorColor[0]);
        }

        List<String> queriedProdIdInteriorColor = [];
        for (var i = 0; i < productsQueryInteriorColor.length; i++) {
          queriedProdIdInteriorColor
              .add(productsQueryInteriorColor[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryInteriorColor;
          productsPro = productsQueryInteriorColor;
          queriedProdIdPro = queriedProdIdInteriorColor;
        });
      }
    }
  }

  void _buildForSaleByQueryData() {
    _forSaleByCountsTrue = [];
    _forSaleByCountsTrueString = [];

    _forSaleByCountsTrue =
        _forSaleByCounts.where((c) => c.value == true).toList();

    if (_forSaleByCountsTrue.length > 0) {
      List<Product> productsQueryForSaleBy = [];
      List<CtmSpecialInfo> ctmSpecialInfosQueryForSaleBy = [];
      for (var i = 0; i < _forSaleByCountsTrue.length; i++) {
        _forSaleByCountsTrueString.add(_forSaleByCountsTrue[i].forSaleBy);
        var productsTempForSaleBy = productsPro
            .where((p) =>
                p.forSaleBy.trim() == _forSaleByCountsTrue[i].forSaleBy.trim())
            .toList();
        productsQueryForSaleBy = productsQueryForSaleBy + productsTempForSaleBy;
      }

      if (_selectedCategory.trim() == 'Vehicle'.trim() &&
          !_selectedSubCategory.contains('Accessories') &&
          !_selectedSubCategory.contains('Others')) {
        for (var i = 0; i < productsQueryForSaleBy.length; i++) {
          var ctmSpecialInfosTempForSaleBy = ctmSpecialInfosPro
              .where((p) => p.prodDocId == productsQueryForSaleBy[i].prodDocId)
              .toList();
          ctmSpecialInfosQueryForSaleBy.add(ctmSpecialInfosTempForSaleBy[0]);
        }
      }

      List<String> queriedProdIdForSaleBy = [];
      for (var i = 0; i < productsQueryForSaleBy.length; i++) {
        queriedProdIdForSaleBy.add(productsQueryForSaleBy[i].prodDocId);
      }
      setState(() {
        productsPro = productsQueryForSaleBy;
        queriedProdIdPro = queriedProdIdForSaleBy;

        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryForSaleBy;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    }
  }

  void _buildTypeOfAdQueryData() {
    _typeOfAdCountsTrue = [];
    _typeOfAdCountsTrueString = [];

    _typeOfAdCountsTrue =
        _typeOfAdCounts.where((c) => c.value == true).toList();

    if (_typeOfAdCountsTrue.length > 0) {
      List<Product> productsQueryTypeOfAd = [];
      List<CtmSpecialInfo> ctmSpecialInfosQueryTypeOfAd = [];
      for (var i = 0; i < _typeOfAdCountsTrue.length; i++) {
        _typeOfAdCountsTrueString.add(_typeOfAdCountsTrue[i].typeOfAd);
        var productsTempTypeOfAd = productsPro
            .where((p) =>
                p.typeOfAd.trim() == _typeOfAdCountsTrue[i].typeOfAd.trim())
            .toList();
        productsQueryTypeOfAd = productsQueryTypeOfAd + productsTempTypeOfAd;
      }

      if (_selectedCategory.trim() == 'Vehicle'.trim() &&
          !_selectedSubCategory.contains('Accessories') &&
          !_selectedSubCategory.contains('Others')) {
        for (var i = 0; i < productsQueryTypeOfAd.length; i++) {
          var ctmSpecialInfosTempTypeOfAd = ctmSpecialInfosPro
              .where((p) => p.prodDocId == productsQueryTypeOfAd[i].prodDocId)
              .toList();
          ctmSpecialInfosQueryTypeOfAd.add(ctmSpecialInfosTempTypeOfAd[0]);
        }
      }

      List<String> queriedProdIdTypeOfAd = [];
      for (var i = 0; i < productsQueryTypeOfAd.length; i++) {
        queriedProdIdTypeOfAd.add(productsQueryTypeOfAd[i].prodDocId);
      }
      setState(() {
        productsPro = productsQueryTypeOfAd;
        queriedProdIdPro = queriedProdIdTypeOfAd;

        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryTypeOfAd;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    }
  }

  void _buildListingStatusQueryData() {
    _listingStatusCountsTrue = [];
    _listingStatusCountsTrueString = [];

    _listingStatusCountsTrue =
        _listingStatusCounts.where((c) => c.value == true).toList();

    if (_listingStatusCountsTrue.length > 0) {
      List<Product> productsQueryListingStatus = [];
      List<CtmSpecialInfo> ctmSpecialInfosQueryListingStatus = [];
      for (var i = 0; i < _listingStatusCountsTrue.length; i++) {
        _listingStatusCountsTrueString
            .add(_listingStatusCountsTrue[i].listingStatus);
        var productsTempListingStatus = productsPro
            .where((p) =>
                p.listingStatus.trim() ==
                _listingStatusCountsTrue[i].listingStatus.trim())
            .toList();
        productsQueryListingStatus =
            productsQueryListingStatus + productsTempListingStatus;
      }

      if (_selectedCategory.trim() == 'Vehicle'.trim() &&
          !_selectedSubCategory.contains('Accessories') &&
          !_selectedSubCategory.contains('Others')) {
        for (var i = 0; i < productsQueryListingStatus.length; i++) {
          var ctmSpecialInfosTempListingStatus = ctmSpecialInfosPro
              .where(
                  (p) => p.prodDocId == productsQueryListingStatus[i].prodDocId)
              .toList();
          ctmSpecialInfosQueryListingStatus
              .add(ctmSpecialInfosTempListingStatus[0]);
        }
      }

      List<String> queriedProdIdListingStatus = [];
      for (var i = 0; i < productsQueryListingStatus.length; i++) {
        queriedProdIdListingStatus.add(productsQueryListingStatus[i].prodDocId);
      }
      setState(() {
        productsPro = productsQueryListingStatus;
        queriedProdIdPro = queriedProdIdListingStatus;
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryListingStatus;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    }
  }

  void _buildProdConditionQueryData() {
    _prodConditionCountsTrue = [];
    _prodConditionCountsTrueString = [];

    _prodConditionCountsTrue =
        _prodConditionCounts.where((c) => c.value == true).toList();

    if (_prodConditionCountsTrue.length > 0) {
      List<Product> productsQueryProdCondition = [];
      List<CtmSpecialInfo> ctmSpecialInfosQueryProdCondition = [];
      for (var i = 0; i < _prodConditionCountsTrue.length; i++) {
        _prodConditionCountsTrueString
            .add(_prodConditionCountsTrue[i].prodCondition);
        var productsTempProdCondition = productsPro
            .where((p) =>
                p.prodCondition.trim() ==
                _prodConditionCountsTrue[i].prodCondition.trim())
            .toList();
        productsQueryProdCondition =
            productsQueryProdCondition + productsTempProdCondition;
      }

      if (_selectedCategory.trim() == 'Vehicle'.trim() &&
          !_selectedSubCategory.contains('Accessories') &&
          !_selectedSubCategory.contains('Others')) {
        for (var i = 0; i < productsQueryProdCondition.length; i++) {
          var ctmSpecialInfosTempProdCondition = ctmSpecialInfosPro
              .where(
                  (p) => p.prodDocId == productsQueryProdCondition[i].prodDocId)
              .toList();
          ctmSpecialInfosQueryProdCondition
              .add(ctmSpecialInfosTempProdCondition[0]);
        }
      }

      List<String> queriedProdIdProdCondition = [];
      for (var i = 0; i < productsQueryProdCondition.length; i++) {
        queriedProdIdProdCondition.add(productsQueryProdCondition[i].prodDocId);
      }
      setState(() {
        productsPro = productsQueryProdCondition;
        queriedProdIdPro = queriedProdIdProdCondition;
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryProdCondition;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    }
  }

  void _buildMileageQueryData() {
    if (ctmSpecialInfosPro.length > 0) {
      _mileageCountsTrue = [];
      _mileageCountsTrueString = [];

      _mileageCountsTrue =
          _mileageCounts.where((c) => c.value == true).toList();

      if (_mileageCountsTrue.length > 0) {
        List<Product> productsQueryMileage = [];
        List<CtmSpecialInfo> ctmSpecialInfosQueryMileage = [];
        for (var i = 0; i < _mileageCountsTrue.length; i++) {
          _mileageCountsTrueString.add(_mileageCountsTrue[i].mileage);
          var ctmSpecialInfosTempMileage = ctmSpecialInfosPro
              .where((p) =>
                  p.mileage.trim() == _mileageCountsTrue[i].mileage.trim())
              .toList();
          ctmSpecialInfosQueryMileage =
              ctmSpecialInfosQueryMileage + ctmSpecialInfosTempMileage;
        }

        for (var i = 0; i < ctmSpecialInfosQueryMileage.length; i++) {
          var productsTempMileage = productsPro
              .where((p) =>
                  p.prodDocId == ctmSpecialInfosQueryMileage[i].prodDocId)
              .toList();
          productsQueryMileage.add(productsTempMileage[0]);
        }

        List<String> queriedProdIdMileage = [];
        for (var i = 0; i < productsQueryMileage.length; i++) {
          queriedProdIdMileage.add(productsQueryMileage[i].prodDocId);
        }
        setState(() {
          ctmSpecialInfosPro = ctmSpecialInfosQueryMileage;
          productsPro = productsQueryMileage;
          queriedProdIdPro = queriedProdIdMileage;
        });
      }
    }
  }

  void _buildPriceQueryData() {
    List<Product> productsQueryPrice = [];

    if (minPrice.isEmpty) {
      setState(() {
        minPrice = '1';
      });
    }

    if (maxPrice.isEmpty) {
      setState(() {
        maxPrice = '99999999';
      });
    }

    productsQueryPrice = productsPro
        .where((e) =>
            double.parse(e.price) >= double.parse(minPrice) &&
            double.parse(e.price) <= double.parse(maxPrice))
        .toList();

    if (productsQueryPrice.length > 0) {
      List<String> queriedProdIdPrice = [];

      List<CtmSpecialInfo> ctmSpecialInfosQueryPrice = [];

      for (var i = 0; i < productsQueryPrice.length; i++) {
        queriedProdIdPrice.add(productsQueryPrice[i].prodDocId);

        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          var ctmSpecialInfosTempPrice = ctmSpecialInfosPro
              .where((p) => p.prodDocId == productsQueryPrice[i].prodDocId)
              .toList();
          ctmSpecialInfosQueryPrice.add(ctmSpecialInfosTempPrice[0]);
        }
      }
      setState(() {
        productsPro = productsQueryPrice;
        queriedProdIdPro = queriedProdIdPrice;

        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryPrice;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    } else if (productsQueryPrice.length == 0) {
      setState(() {
        ctmSpecialInfosPro = [];
        productsPro = [];
        queriedProdIdPro = [];
      });
    }
  }

  void _buildYearQueryData() {
    List<Product> productsQueryYear = [];

    if (minYear.isEmpty) {
      setState(() {
        minYear = '1790';
      });
    }

    if (maxYear.isEmpty) {
      setState(() {
        maxYear = Timestamp.now().toDate().year.toString();
      });
    }

    productsQueryYear = productsPro
        .where((e) =>
            double.parse(e.year) >= double.parse(minYear) &&
            double.parse(e.year) <= double.parse(maxYear))
        .toList();

    if (productsQueryYear.length > 0) {
      List<String> queriedProdIdYear = [];

      List<CtmSpecialInfo> ctmSpecialInfosQueryYear = [];

      for (var i = 0; i < productsQueryYear.length; i++) {
        queriedProdIdYear.add(productsQueryYear[i].prodDocId);
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          var ctmSpecialInfosTempYear = ctmSpecialInfosPro
              .where((p) => p.prodDocId == productsQueryYear[i].prodDocId)
              .toList();
          ctmSpecialInfosQueryYear.add(ctmSpecialInfosTempYear[0]);
        }
      }
      setState(() {
        productsPro = productsQueryYear;
        queriedProdIdPro = queriedProdIdYear;
        if (_selectedCategory.trim() == 'Vehicle'.trim() &&
            !_selectedSubCategory.contains('Accessories') &&
            !_selectedSubCategory.contains('Others')) {
          ctmSpecialInfosPro = ctmSpecialInfosQueryYear;
        } else {
          ctmSpecialInfosPro = [];
        }
      });
    } else if (productsQueryYear.length == 0) {
      setState(() {
        ctmSpecialInfosPro = [];
        productsPro = [];
        queriedProdIdPro = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoad) {
      print('inital one time load');
      // if (products.length > 0) {
      _buildCatWiseQueryData(_selectedCategory, _selectedSubCategory);
      _isInitialLoad = false;
      // }
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: bDisabledColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
        title: const Text(
          'Filters',
          style: const TextStyle(
            color: bDisabledColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: bBackgroundColor,
      ),
      body: Stack(
        // return Container(
        //   child: Stack(
        children: [
          Container(
            color: Colors.grey[300],
            child: SingleChildScrollView(
              // child: Column(
              //   children: [
              // child: Container(
              //   color: Colors.grey[300],
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(left: 10),
                    color: bBackgroundColor,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Select Category',
                      ),
                    ),
                  ),
                  Container(
                    color: bBackgroundColor,
                    child: DropdownButtonFormField<String>(
                      items: _catNames,
                      elevation: 0,
                      decoration: const InputDecoration(
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) async {
                        if (value != _selectedCategory) {
                          setState(() {
                            _selectedCategory = value;
                            if (_selectedCategory == 'Vehicle') {
                              _vehicleCategory = true;
                            } else {
                              _vehicleCategory = false;
                            }
                          });
                          print(
                              'select category - $_selectedCategory, $_selectedSubCategory');
                          _buildSubCatNameCount();
                          _buildCatWiseQueryData(
                              _selectedCategory, _selectedSubCategory);
                        }
                      },
                      value: _selectedCategory == ''
                          ? _initialCategory
                          : _selectedCategory,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //sub category
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(left: 10),
                    color: bBackgroundColor,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Select Sub Category',
                      ),
                    ),
                  ),
                  Container(
                    color: bBackgroundColor,
                    child: DropdownButtonFormField<String>(
                      items: _subCatNames,
                      elevation: 0,
                      decoration: const InputDecoration(
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) async {
                        if (value != _selectedSubCategory) {
                          setState(() {
                            _selectedSubCategory = value;
                            if (_selectedSubCategory == 'Cars' ||
                                _selectedSubCategory == 'Trucks' ||
                                _selectedSubCategory == 'Caravans') {
                              _specialVehicle = true;
                            } else {
                              _specialVehicle = false;
                            }
                          });
                          // _buildSubCatNameCount();
                          _buildCatWiseQueryData(
                              _selectedCategory, _selectedSubCategory);
                        }
                      },
                      value: _selectedSubCategory == ''
                          ? _initialCategory
                          : _selectedSubCategory,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (queriedProdIdPro.length > 0)
                    (_selectedCategory.trim() == 'Vehicle'.trim() &&
                            !_selectedSubCategory.contains('Accessories') &&
                            !_selectedSubCategory.contains('Others'))
                        ? carMotor()
                        : commonFilterUI(),
                ],
              ),
              // ),
              // ],
              // ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: bBackgroundColor,
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: queriedProdIdPro.length == 0
                          ? Colors.orange[200]
                          : bPrimaryColor),
                  onPressed: () {
                    if (queriedProdIdPro.length > 0) {
                      print("queriedProdIdPro - ${queriedProdIdPro.length}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) {
                              return FilteredProdScreen(
                                queriedProdIdList: queriedProdIdPro,
                              );
                            },
                            fullscreenDialog: true),
                      );
                    }
                  },
                  child: queriedProdIdPro.length > 0
                      ? Text(queriedProdIdPro.length > 1
                          ? 'See ${queriedProdIdPro.length} Results'
                          : 'See ${queriedProdIdPro.length} Result')
                      : Text('See 0 Results'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Car and Motor UI

  Widget carMotor() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Current search: $_selectedCategory',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _makeCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Make',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _makeCountsTrue.length > 0
                  ? Text(_makeCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _makeDialogWidget(
                            context, setState, _makeCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _modelCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Model',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _modelCountsTrue.length > 0
                  ? Text(_modelCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _modelDialogWidget(
                            context, setState, _modelCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),

        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: 60,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Price',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: minPrice.isNotEmpty
                  ? minYear == '1'
                      ? Text('<= $maxPrice')
                      : maxPrice == '99999999'
                          ? Text('>= $minPrice')
                          : Text('$minPrice - $maxPrice')
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _priceDialogWidget(context, setState);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: 60,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Year',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: minYear.isNotEmpty
                  ? minYear == '1790'
                      ? Text('<= $maxYear')
                      : Text('$minYear - $maxYear')
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _yearDialogWidget(context, setState);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _mileageCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Mileage',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _mileageCountsTrue.length > 0
                  ? Text(_mileageCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _mileageDialogWidget(
                            context, setState, _mileageCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        if (_specialVehicle)

          // Following items in the column are only available for Car/Truck Category
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                // color: bBackgroundColor,
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Engine/Transmission',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _engineCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: Text(
                      'Engine',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _engineCountsTrue.length > 0
                        ? Text(_engineCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _engineDialogWidget(
                                  context, setState, _engineCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 2,
        ),
        if (_specialVehicle)

          // Following items in the column are only available for Car/Truck Category
          Column(
            children: [
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _transmissionCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Transmission',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _transmissionCountsTrue.length > 0
                        ? Text(_transmissionCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _transmissionDialogWidget(
                                  context, setState, _transmissionCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _bodyTypeCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Body Type',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _bodyTypeCountsTrue.length > 0
                        ? Text(_bodyTypeCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _bodyTypeDialogWidget(
                                  context, setState, _bodyTypeCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _driveTypeCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Drive Type',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _driveTypeCountsTrue.length > 0
                        ? Text(_driveTypeCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _driveTypeDialogWidget(
                                  context, setState, _driveTypeCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _fuelTypeCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Fuel Type',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _fuelTypeCountsTrue.length > 0
                        ? Text(_fuelTypeCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _fuelTypeDialogWidget(
                                  context, setState, _fuelTypeCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _numberOfCylindersCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Number of Cylinders',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _numberOfCylindersCountsTrue.length > 0
                        ? Text(_numberOfCylindersCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _numberOfCylindersDialogWidget(
                                  context, setState, _numberOfCylindersCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

        const SizedBox(
          height: 10,
        ),
        Container(
          // color: bBackgroundColor,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Listing Details',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _forSaleByCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: Text(
                'Seller Type',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _forSaleByCountsTrue.length > 0
                  ? Text(_forSaleByCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _forSaleByDialogWidget(
                            context, setState, _forSaleByCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _listingStatusCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Listing Status',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _listingStatusCountsTrue.length > 0
                  ? Text(_listingStatusCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _listingStatusDialogWidget(
                            context, setState, _listingStatusCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        Container(
          // color: bBackgroundColor,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Type of Ad',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _prodConditionCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: Text(
                'Type of Ad',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _typeOfAdCountsTrue.length > 0
                  ? Text(_typeOfAdCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _typeOfAdDialogWidget(
                            context, setState, _typeOfAdCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // color: bBackgroundColor,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Product Condition',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _prodConditionCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Condition',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _prodConditionCountsTrue.length > 0
                  ? Text(_prodConditionCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _prodConditionDialogWidget(
                            context, setState, _prodConditionCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // color: bBackgroundColor,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Color',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _exteriorColorCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Exterior Color',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _exteriorColorCountsTrue.length > 0
                  ? Text(_exteriorColorCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _exteriorColorDialogWidget(
                            context, setState, _exteriorColorCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        if (_specialVehicle)
          const SizedBox(
            height: 2,
          ),
        if (_specialVehicle)
          Container(
            color: bBackgroundColor,
            width: double.infinity,
            height: _interiorColorCountsTrue.length <= 10
                ? MediaQuery.of(context).size.height / 12
                : MediaQuery.of(context).size.height / 8,
            child: Container(
              width: double.infinity,
              child: ListTile(
                title: const Text(
                  'Interior Color',
                  style: const TextStyle(
                    color: bDisabledColor,
                  ),
                ),
                subtitle: _interiorColorCountsTrue.length > 0
                    ? Text(_interiorColorCountsTrueString.join(', '))
                    : const Text(''),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return _interiorColorDialogWidget(
                              context, setState, _interiorColorCounts);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        //Following container to display the last before item in the column
        //as we have stacked a button on top of the last item
        Container(
          height: 50,
        ),
      ],
    );
  }

  // Widget for Common UI

  Widget commonFilterUI() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Current search: $_selectedCategory',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (_selectedCategory.trim() == 'Vehicle'.trim() ||
            _selectedCategory.trim() == 'Electronics'.trim() ||
            _selectedCategory.trim() == 'Home Appliances'.trim())
          Column(
            children: [
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _makeCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Make',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _makeCountsTrue.length > 0
                        ? Text(_makeCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _makeDialogWidget(
                                  context, setState, _makeCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                color: bBackgroundColor,
                width: double.infinity,
                height: _modelCountsTrue.length <= 10
                    ? MediaQuery.of(context).size.height / 12
                    : MediaQuery.of(context).size.height / 8,
                child: Container(
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      'Model',
                      style: const TextStyle(
                        color: bDisabledColor,
                      ),
                    ),
                    subtitle: _modelCountsTrue.length > 0
                        ? Text(_modelCountsTrueString.join(', '))
                        : const Text(''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return _modelDialogWidget(
                                  context, setState, _modelCounts);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
            ],
          ),

        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: 60,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Price',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: minPrice.isNotEmpty
                  ? minYear == '1'
                      ? Text('<= $maxPrice')
                      : maxPrice == '99999999'
                          ? Text('>= $minPrice')
                          : Text('$minPrice - $maxPrice')
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _priceDialogWidget(context, setState);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: 60,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Year',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: minYear.isNotEmpty
                  ? minYear == '1790'
                      ? Text('<= $maxYear')
                      : Text('$minYear - $maxYear')
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _yearDialogWidget(context, setState);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),

        // Type of ad
        const SizedBox(
          height: 10,
        ),
        Container(
          // color: bBackgroundColor,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Type of Ad',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _prodConditionCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Type of Ad',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _typeOfAdCountsTrue.length > 0
                  ? Text(_typeOfAdCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _typeOfAdDialogWidget(
                            context, setState, _typeOfAdCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),

        const SizedBox(
          height: 10,
        ),
        Container(
          // color: bBackgroundColor,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Product Condition',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: bBackgroundColor,
          width: double.infinity,
          height: _prodConditionCountsTrue.length <= 10
              ? MediaQuery.of(context).size.height / 12
              : MediaQuery.of(context).size.height / 8,
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: const Text(
                'Condition',
                style: const TextStyle(
                  color: bDisabledColor,
                ),
              ),
              subtitle: _prodConditionCountsTrue.length > 0
                  ? Text(_prodConditionCountsTrueString.join(', '))
                  : const Text(''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return _prodConditionDialogWidget(
                            context, setState, _prodConditionCounts);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),

        const SizedBox(
          height: 10,
        ),
        //Following container to display the last before item in the column
        //as we have stacked a button on top of the last item
        Container(
          height: 50,
        ),
      ],
    );
  }

  // Make

  Widget _makeDialogWidget(
      BuildContext context, StateSetter setState, List<MakeCount> _makeCounts) {
    return AlertDialog(
      title: const Text('Make'),
      content: Container(
        height: _makeCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _makeCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_makeCounts[index].make} (${_makeCounts[index].count})'),
              value: _makeCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _makeCounts[index].value = value;

                  if (_makeCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'make')) {
                    } else {
                      filterFields.add('make');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'make')) {
                      filterFields.remove('make');
                    } else {}
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('make'),
      ],
    );
  }

  // Model

  Widget _modelDialogWidget(BuildContext context, StateSetter setState,
      List<ModelCount> _modelCounts) {
    return AlertDialog(
      title: const Text('Model'),
      content: Container(
        height: _modelCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _modelCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_modelCounts[index].model} (${_modelCounts[index].count})'),
              value: _modelCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _modelCounts[index].value = value;
                  if (_modelCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'model')) {
                    } else {
                      filterFields.add('model');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'model')) {
                      filterFields.remove('model');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('model'),
      ],
    );
  }

  // Engine

  Widget _engineDialogWidget(BuildContext context, StateSetter setState,
      List<EngineCount> _engineCounts) {
    return AlertDialog(
      title: const Text('Engine'),
      content: Container(
        height: _engineCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _engineCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_engineCounts[index].engine} (${_engineCounts[index].count})'),
              value: _engineCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _engineCounts[index].value = value;
                  if (_engineCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'engine')) {
                    } else {
                      filterFields.add('engine');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'engine')) {
                      filterFields.remove('engine');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('engine'),
      ],
    );
  }

// Transmission

  Widget _transmissionDialogWidget(BuildContext context, StateSetter setState,
      List<TransmissionCount> _transmissionCounts) {
    return AlertDialog(
      title: const Text('Transmission'),
      content: Container(
        height: _transmissionCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _transmissionCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_transmissionCounts[index].transmission} (${_transmissionCounts[index].count})'),
              value: _transmissionCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _transmissionCounts[index].value = value;
                  if (_transmissionCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'transmission')) {
                    } else {
                      filterFields.add('transmission');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'transmission')) {
                      filterFields.remove('transmission');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('transmission'),
      ],
    );
  }

  // bodyType

  Widget _bodyTypeDialogWidget(BuildContext context, StateSetter setState,
      List<BodyTypeCount> _bodyTypeCounts) {
    return AlertDialog(
      title: const Text('Body Type'),
      content: Container(
        height: _bodyTypeCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _bodyTypeCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_bodyTypeCounts[index].bodyType} (${_bodyTypeCounts[index].count})'),
              value: _bodyTypeCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _bodyTypeCounts[index].value = value;
                  if (_bodyTypeCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'bodyType')) {
                    } else {
                      filterFields.add('bodyType');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'bodyType')) {
                      filterFields.remove('bodyType');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('bodyType'),
      ],
    );
  }

  // driveType

  Widget _driveTypeDialogWidget(BuildContext context, StateSetter setState,
      List<DriveTypeCount> _driveTypeCounts) {
    return AlertDialog(
      title: const Text('Drive Type'),
      content: Container(
        height: _driveTypeCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _driveTypeCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_driveTypeCounts[index].driveType} (${_driveTypeCounts[index].count})'),
              value: _driveTypeCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _driveTypeCounts[index].value = value;
                  if (_driveTypeCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'driveType')) {
                    } else {
                      filterFields.add('driveType');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'driveType')) {
                      filterFields.remove('driveType');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('driveType'),
      ],
    );
  }

  // FuelType

  Widget _fuelTypeDialogWidget(BuildContext context, StateSetter setState,
      List<FuelTypeCount> _fuelTypeCounts) {
    return AlertDialog(
      title: const Text('Fuel Type'),
      content: Container(
        height: _fuelTypeCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _fuelTypeCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_fuelTypeCounts[index].fuelType} (${_fuelTypeCounts[index].count})'),
              value: _fuelTypeCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _fuelTypeCounts[index].value = value;
                  if (_fuelTypeCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'fuelType')) {
                    } else {
                      filterFields.add('fuelType');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'fuelType')) {
                      filterFields.remove('fuelType');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('fuelType'),
      ],
    );
  }

  // NumberOfCylinders

  Widget _numberOfCylindersDialogWidget(
      BuildContext context,
      StateSetter setState,
      List<NumberOfCylindersCount> _numberOfCylindersCounts) {
    return AlertDialog(
      title: const Text('Number of Cylinders'),
      content: Container(
        height: _numberOfCylindersCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _numberOfCylindersCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_numberOfCylindersCounts[index].numberOfCylinders} (${_numberOfCylindersCounts[index].count})'),
              value: _numberOfCylindersCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _numberOfCylindersCounts[index].value = value;
                  if (_numberOfCylindersCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'numberOfCylinders')) {
                    } else {
                      filterFields.add('numberOfCylinders');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'numberOfCylinders')) {
                      filterFields.remove('numberOfCylinders');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('numberOfCylinders'),
      ],
    );
  }

  // Exterior Color

  Widget _exteriorColorDialogWidget(BuildContext context, StateSetter setState,
      List<ExteriorColorCount> _exteriorColorCounts) {
    return AlertDialog(
      title: const Text('Exterior Color'),
      content: Container(
        height: _exteriorColorCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _exteriorColorCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_exteriorColorCounts[index].exteriorColor} (${_exteriorColorCounts[index].count})'),
              value: _exteriorColorCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _exteriorColorCounts[index].value = value;
                  if (_exteriorColorCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'exteriorColor')) {
                    } else {
                      filterFields.add('exteriorColor');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'exteriorColor')) {
                      filterFields.remove('exteriorColor');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('exteriorColor'),
      ],
    );
  }

  // Interior Color

  Widget _interiorColorDialogWidget(BuildContext context, StateSetter setState,
      List<InteriorColorCount> _interiorColorCounts) {
    return AlertDialog(
      title: const Text('Interior Color'),
      content: Container(
        height: _interiorColorCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _interiorColorCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_interiorColorCounts[index].interiorColor} (${_interiorColorCounts[index].count})'),
              value: _interiorColorCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _interiorColorCounts[index].value = value;
                  if (_interiorColorCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'interiorColor')) {
                    } else {
                      filterFields.add('interiorColor');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'interiorColor')) {
                      filterFields.remove('interiorColor');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('interiorColor'),
      ],
    );
  }

  // ForSaleBy

  Widget _forSaleByDialogWidget(BuildContext context, StateSetter setState,
      List<ForSaleByCount> _forSaleByCounts) {
    return AlertDialog(
      title: const Text('Seller Type'),
      content: Container(
        height: _forSaleByCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _forSaleByCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_forSaleByCounts[index].forSaleBy} (${_forSaleByCounts[index].count})'),
              value: _forSaleByCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _forSaleByCounts[index].value = value;
                  if (_forSaleByCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'forSaleBy')) {
                    } else {
                      filterFields.add('forSaleBy');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'forSaleBy')) {
                      filterFields.remove('forSaleBy');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('forSaleBy'),
      ],
    );
  }

  // typeOfAd

  Widget _typeOfAdDialogWidget(BuildContext context, StateSetter setState,
      List<TypeOfAdCount> _typeOfAdCounts) {
    return AlertDialog(
      title: const Text('Seller Type'),
      content: Container(
        height: _typeOfAdCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _typeOfAdCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_typeOfAdCounts[index].typeOfAd} (${_typeOfAdCounts[index].count})'),
              value: _typeOfAdCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _typeOfAdCounts[index].value = value;
                  if (_typeOfAdCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'typeOfAd')) {
                    } else {
                      filterFields.add('typeOfAd');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'typeOfAd')) {
                      filterFields.remove('typeOfAd');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('typeOfAd'),
      ],
    );
  }

  // ListingStatus

  Widget _listingStatusDialogWidget(BuildContext context, StateSetter setState,
      List<ListingStatusCount> _listingStatusCounts) {
    return AlertDialog(
      title: const Text('Listing Status'),
      content: Container(
        height: _listingStatusCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _listingStatusCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_listingStatusCounts[index].listingStatus} (${_listingStatusCounts[index].count})'),
              value: _listingStatusCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _listingStatusCounts[index].value = value;
                  if (_listingStatusCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'listingStatus')) {
                    } else {
                      filterFields.add('listingStatus');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'listingStatus')) {
                      filterFields.remove('listingStatus');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('listingStatus'),
      ],
    );
  }

  // prodCondition

  Widget _prodConditionDialogWidget(BuildContext context, StateSetter setState,
      List<ProdConditionCount> _prodConditionCounts) {
    return AlertDialog(
      title: const Text('Condition'),
      content: Container(
        height: _prodConditionCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _prodConditionCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_prodConditionCounts[index].prodCondition} (${_prodConditionCounts[index].count})'),
              value: _prodConditionCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _prodConditionCounts[index].value = value;
                  if (_prodConditionCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'prodCondition')) {
                    } else {
                      filterFields.add('prodCondition');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'prodCondition')) {
                      filterFields.remove('prodCondition');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('prodCondition'),
      ],
    );
  }

  // Mileage

  Widget _mileageDialogWidget(BuildContext context, StateSetter setState,
      List<MileageCount> _mileageCounts) {
    return AlertDialog(
      title: const Text('Mileage'),
      content: Container(
        height: _mileageCounts.length <= 6
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.height,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _mileageCounts.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: bPrimaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                  '${_mileageCounts[index].mileage} (${_mileageCounts[index].count})'),
              value: _mileageCounts[index].value,
              onChanged: (value) {
                setState(() {
                  _mileageCounts[index].value = value;
                  if (_mileageCounts.any((e) => e.value == true)) {
                    if (filterFields.any((e) => e == 'mileage')) {
                    } else {
                      filterFields.add('mileage');
                    }
                  } else {
                    if (filterFields.any((e) => e == 'mileage')) {
                      filterFields.remove('mileage');
                    }
                  }
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        _actionDialogWidget('mileage'),
      ],
    );
  }

  // Price

  Widget _priceDialogWidget(BuildContext context, StateSetter setState) {
    return AlertDialog(
      title: const Text('Price'),
      content: Container(
        height: MediaQuery.of(context).size.height / 4,
        child: Form(
          key: formKeyPrice,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Min',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: bScaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  controller: _controllerMinPrice,
                  key: ValueKey('minPrice'),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controllerMinPrice.clear();
                        minPrice = '';
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value.isEmpty) {
                    //   return 'Please enter Min Price';
                    // }
                    if (value.isNotEmpty) {
                      if (maxPrice.isEmpty) {
                        maxPrice = '99999999';
                      }

                      if (double.parse(value.trim()) >
                          double.parse(maxPrice.trim())) {
                        return 'Please enter Min price less than Max price';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    minPrice = value;
                  },
                  onSaved: (value) {
                    minPrice = value;
                    _controllerMinPrice.text = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Max',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: bScaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  key: ValueKey('maxPrice'),
                  controller: _controllerMaxPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controllerMaxPrice.clear();
                        maxPrice = '';
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value.isEmpty) {
                    //   return 'Please enter Max Price';
                    // }
                    if (value.isNotEmpty) {
                      if (minPrice.isEmpty) {
                        minPrice = '1';
                      }
                      if (double.parse(value.trim()) <
                          double.parse(minPrice.trim())) {
                        return 'Please enter Max price greate than Min price';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    maxPrice = value;
                  },
                  onSaved: (value) {
                    maxPrice = value;
                    _controllerMaxPrice.text = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        _actionDialogWidgetForm('price', formKeyPrice),
      ],
    );
  }

  // Year

  Widget _yearDialogWidget(BuildContext context, StateSetter setState) {
    return AlertDialog(
      title: const Text('Year'),
      content: Container(
        height: MediaQuery.of(context).size.height / 4,
        child: Form(
          key: formKeyYear,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Min',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: bScaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  controller: _controllerMinYear,
                  key: ValueKey('minYear'),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controllerMinYear.clear();
                        minYear = '';
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value.isEmpty) {
                    //   return 'Please enter Min Year';
                    // }
                    if (value.isNotEmpty) {
                      if (maxYear.isEmpty) {
                        maxYear = Timestamp.now().toDate().year.toString();
                      }
                      if (double.parse(value.trim()) >
                          double.parse(maxYear.trim())) {
                        return 'Please enter Min Year less than Max Year';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    minYear = value;
                  },
                  onSaved: (value) {
                    minYear = value;
                    _controllerMinYear.text = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Max',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: bScaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  controller: _controllerMaxYear,
                  key: ValueKey('maxYear'),
                  // initialValue: _controller.text,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controllerMaxYear.clear();
                        maxYear = '';
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value.isEmpty) {
                    //   return 'Please enter Max Year';
                    // }
                    if (value.isNotEmpty) {
                      if (minYear.isEmpty) {
                        minYear = '1790';
                      }
                      if (double.parse(value.trim()) <
                          double.parse(minYear.trim())) {
                        return 'Please enter Max Year greate than Min Year';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    maxYear = value;
                  },
                  onSaved: (value) {
                    maxYear = value;
                    _controllerMaxYear.text = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        _actionDialogWidgetForm('year', formKeyYear),
      ],
    );
  }

  Widget _actionDialogWidgetForm(
      String selectionField, GlobalKey<FormState> formKey) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: bBackgroundColor,
                onPrimary: bDisabledColor,
                side: const BorderSide(
                  color: bPrimaryColor,
                  width: 1,
                ),
                elevation: 0.0,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Cancel'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: bPrimaryColor,
              ),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  if (selectionField == 'price') {
                    if (minPrice.isNotEmpty && maxPrice.isNotEmpty) {
                      if (filterFields.any((e) => e == 'price')) {
                      } else {
                        filterFields.add('price');
                      }
                    } else {
                      if (filterFields.any((e) => e == 'price')) {
                        filterFields.remove('price');
                      }
                    }
                  } else if (selectionField == 'year') {
                    if (minYear.isNotEmpty && maxYear.isNotEmpty) {
                      if (filterFields.any((e) => e == 'year')) {
                      } else {
                        filterFields.add('year');
                      }
                    } else {
                      if (filterFields.any((e) => e == 'year')) {
                        filterFields.remove('year');
                      }
                    }
                  }
                  formKey.currentState.save();
                  setState(() {
                    _prepareAllFilters();
                    _buildFilters(selectionField);
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionDialogWidget(String selectionField) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: bBackgroundColor,
                onPrimary: bDisabledColor,
                side: const BorderSide(
                  color: bPrimaryColor,
                  width: 1,
                ),
                elevation: 0.0,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Cancel'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: bPrimaryColor,
              ),
              onPressed: () {
                setState(() {
                  _prepareAllFilters();
                  _buildFilters(selectionField);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
