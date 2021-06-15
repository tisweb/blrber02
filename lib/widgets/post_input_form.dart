import 'dart:io';

import 'package:blrber/models/category.dart';
import 'package:blrber/models/product.dart';
import 'package:blrber/provider/get_current_location.dart';
import 'package:blrber/provider/motor_form_sqldb_provider.dart';
import 'package:blrber/provider/prod_images_sqldb_provider.dart';
import 'package:blrber/screens/tabs_screen.dart';
import 'package:blrber/services/api_keys.dart';
import 'package:blrber/widgets/display_product_catalog.dart';
import 'package:blrber/widgets/search_place_auto_complete_widget_custom.dart';
import 'package:blrber/widgets/vinc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart' as smp;
import 'package:tflite/tflite.dart';
import 'package:flutter/animation.dart';
import '../services/foundation.dart';

class PostInputForm extends StatefulWidget {
  // final String editPost;
  final String prodId;
  PostInputForm({
    // this.editPost,
    this.prodId,
  });
  @override
  _PostInputFormState createState() => _PostInputFormState();
}

class _PostInputFormState extends State<PostInputForm>
    with SingleTickerProviderStateMixin {
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  // AnimationController _controller;
  // Animation _animation;

  FocusNode _focusNode = FocusNode();
  int _currentStep = 0;
  File pickedImage;
  String imageLabel = "";
  String imageType = "";
  bool _featuredImage = false;
  dynamic motorFormProvider;
  dynamic prodImageProvider;
  int _motorFormCount = 0;
  int _totalImageCount = 0;
  String _addressLocation = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _imageUrl = "";
  String _prodUpdated = '';
  var _prodName = '';
  var _userDetailDocId = '';
  var _prodDocId = '';
  var user;
  // var _prodConditions = [];
  List<DropdownMenuItem<String>> _prodConditions,
      _deliveryInfo,
      _forSaleBy,
      _fuelType = [];
  List<DropdownMenuItem<String>> _catNames, _subCatTypes = [];
  List<DropdownMenuItem<String>> _years = [];
  List<DropdownMenuItem<String>> _makes = [];
  List<DropdownMenuItem<String>> _models = [];
  var _initialSelectedItem = 'Unspecified';
  bool cTA1981 = true;
  bool _enableVinValButton = false;
  bool _vinValidateFlag = false;
  int _eImageCount = 0;
  int _iImageCount = 0;
  String _currencySymbol = "";
  String _currencyName = "";
  String _currencySumbolByName = "";
  String _coordinates = "";
  String _countryCode = "";
  bool _isUpdated = false;

  MotorFormSqlDb motorFormSqlDb = MotorFormSqlDb();

  List<ProdImagesSqlDb> prodImagesSqlDb = [];
  List<ProdImagesSqlDb> prodImagesSqlDbE = [];
  List<ProdImagesSqlDb> prodImagesSqlDbI = [];

  List<Category> catNames = [];

  // create a controller for the TextField
  TextEditingController controllerEC = TextEditingController();
  TextEditingController controllerIC = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    motorFormProvider =
        Provider.of<MotorFormSqlDbProvider>(context, listen: false);
    prodImageProvider =
        Provider.of<ProdImagesSqlDbProvider>(context, listen: false);
    _initialLoadMotorForm();

    // _controller =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     _controller.forward();
    //   } else {
    //     _controller.reverse();
    //   }
    // });
  }

  @override
  void dispose() {
    // _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userDetailDocId = user.uid;
    final getCurrentLocation =
        Provider.of<GetCurrentLocation>(context, listen: false);

    setState(() {
      _currencyName = getCurrentLocation.currencyCode;

      _currencySymbol = getCurrencySymbolByName(_currencyName);
      print("Currency symbol by Name - $_currencySymbol");
      _coordinates = getCurrentLocation.coordinates;
      _countryCode = getCurrentLocation.countryCode;
    });

    // Menu Items for Product Conditions

    List<ProductCondition> productConditions =
        Provider.of<List<ProductCondition>>(context);
    _prodConditions = [];

    if (productConditions != null) {
      for (ProductCondition productCondition in productConditions) {
        _prodConditions.add(
          DropdownMenuItem(
            value: productCondition.prodCondition,
            child: Text(productCondition.prodCondition),
          ),
        );
      }
    }

    // Menu Items for Delivery Info

    List<DeliveryInfo> deliveryInfos = Provider.of<List<DeliveryInfo>>(context);
    _deliveryInfo = [];

    if (deliveryInfos != null) {
      for (DeliveryInfo deliveryInfo in deliveryInfos) {
        _deliveryInfo.add(
          DropdownMenuItem(
            value: deliveryInfo.deliveryInfo,
            child: Text(deliveryInfo.deliveryInfo),
          ),
        );
      }
    }

    //

    // Menu Items for  _forSaleBy

    List<ForSaleBy> forSaleBys = Provider.of<List<ForSaleBy>>(context);
    _forSaleBy = [];

    if (forSaleBys != null) {
      for (ForSaleBy forSaleBy in forSaleBys) {
        _forSaleBy.add(
          DropdownMenuItem(
            value: forSaleBy.forSaleBy,
            child: Text(forSaleBy.forSaleBy),
          ),
        );
      }
    }

    // Menu Items for  _fuelType

    List<FuelType> fuelTypes = Provider.of<List<FuelType>>(context);
    _fuelType = [];

    if (fuelTypes != null) {
      for (FuelType fuelType in fuelTypes) {
        _fuelType.add(
          DropdownMenuItem(
            value: fuelType.fuelType,
            child: Text(fuelType.fuelType),
          ),
        );
      }
    }

    //

    catNames = Provider.of<List<Category>>(context);
    _catNames = [];
    if (catNames != null) {
      for (Category catName in catNames) {
        _catNames.add(
          DropdownMenuItem(
            value: catName.catName,
            child: Text(catName.catName),
          ),
        );
      }
    }
    print('category length - ${_catNames.length}');

// Sub cat type
    if (motorFormSqlDb.catName != null) {
      print('sub type drop down check -------');
      print('check 1 - ${motorFormSqlDb.catName}');
      var subCatTypes = Provider.of<List<SubCategory>>(context);
      if (subCatTypes.length > 0) {
        print('check 2 - ${subCatTypes.length}');
        subCatTypes = subCatTypes
            .where((e) =>
                e.catName.toLowerCase().trim() ==
                motorFormSqlDb.catName.toLowerCase().trim())
            .toList();

        print('check 2 - ${subCatTypes.length}');
        _subCatTypes = [];
        _subCatTypes.add(
          DropdownMenuItem(
            value: _initialSelectedItem,
            child: Text(_initialSelectedItem),
          ),
        );
        if (subCatTypes != null) {
          for (SubCategory subCatType in subCatTypes) {
            _subCatTypes.add(
              DropdownMenuItem(
                value: subCatType.subCatDocId,
                child: Text(subCatType.subCatType),
              ),
            );
          }
        }
      }
    }

    List<Year> years = Provider.of<List<Year>>(context);
    _years = [];
    if (years != null) {
      for (Year year in years) {
        _years.add(
          DropdownMenuItem(
            value: year.year,
            child: Text(year.year),
          ),
        );
      }
    }

    print('check1');
    List<Make> makes = Provider.of<List<Make>>(context);
    print('check2');
    _makes = [];
    if (makes != null) {
      for (Make make in makes) {
        _makes.add(
          DropdownMenuItem(
            value: make.make,
            child: Text(make.make),
          ),
        );
      }
    }
    print('make length - ${_makes.length}');

    print('check3');
    List<Model> models = Provider.of<List<Model>>(context);
    print('check4 length - ${models.length}');
    _models = [];
    if (models != null) {
      for (Model model in models) {
        _models.add(
          DropdownMenuItem(
            value: model.model,
            child: Text(model.model),
          ),
        );
      }
    }
    print('model length - ${_models.length}');
    print('model length1 - ${_models.length}');
    List<Model> getModelSuggestions(String query) => models
        .where((e) => e.model.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print('model length2 - ${_models.length}');

    List<Step> steps = [
      Step(
        title: const Text('Photo'),
        isActive: _currentStep >= 0,
        state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
        content: Form(
          key: formKeys[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Add upto 20 photos'),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlineButton(
                    shape: StadiumBorder(),
                    textColor: Colors.blue,
                    child: Text('Take a photo'),
                    borderSide: BorderSide(
                        color: Colors.blue, style: BorderStyle.solid, width: 1),
                    onPressed: () async {
                      await _pickImage('C');
                    },
                  ),
                  OutlineButton(
                    shape: StadiumBorder(),
                    textColor: Colors.blue,
                    child: Text('Select photos'),
                    borderSide: BorderSide(
                        color: Colors.blue, style: BorderStyle.solid, width: 1),
                    onPressed: () async {
                      await _pickImage('G');
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Column(
                    children: [
                      FutureBuilder(
                        future: Provider.of<ProdImagesSqlDbProvider>(context,
                                listen: false)
                            .fetchAndSetImages('E'),
                        builder: (ctx, snapshot) => snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : Consumer<ProdImagesSqlDbProvider>(
                                child: Center(
                                  child: Text(
                                      'Got no images yet, start adding some!'),
                                ),
                                builder: (ctx, imageData, ch) {
                                  _totalImageCount = imageData.itemsE.length;

                                  if (imageData.itemsE.length > 0) {
                                    prodImagesSqlDbE = imageData.itemsE;

                                    return Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'Exterior (${prodImagesSqlDbE.length})'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 100,
                                          child: ListView.builder(
                                              itemCount:
                                                  prodImagesSqlDbE.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin:
                                                      EdgeInsets.only(right: 3),
                                                  child: Stack(children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      child: prodImagesSqlDbE[
                                                                      index]
                                                                  .imageUrl
                                                                  .substring(
                                                                      0, 5) ==
                                                              'https'
                                                          ? Image.network(
                                                              prodImagesSqlDbE[
                                                                      index]
                                                                  .imageUrl,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(prodImagesSqlDbE[
                                                                      index]
                                                                  .imageUrl),
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          // await _deleteImageAll();
                                                          // await _deleteMotorFormAll();
                                                          await _deleteImage(
                                                              prodImagesSqlDbE[
                                                                      index]
                                                                  .id,
                                                              prodImagesSqlDbE[
                                                                      index]
                                                                  .imageType);
                                                          // print('check drop1');
                                                          // await _dropMotorForm();
                                                          // print('check drop2');
                                                        },
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                );
                                              }),
                                        ),
                                      ],
                                    );
                                  } else
                                    return Container();
                                }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: Provider.of<ProdImagesSqlDbProvider>(context,
                                listen: false)
                            .fetchAndSetImages('I'),
                        builder: (ctx, snapshot) => snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : Consumer<ProdImagesSqlDbProvider>(
                                child: Center(
                                  child: Text(
                                      'Got no images yet, start adding some!'),
                                ),
                                builder: (ctx, imageData, ch) {
                                  _totalImageCount = _totalImageCount +
                                      imageData.itemsI.length;
                                  if (imageData.itemsI.length > 0) {
                                    prodImagesSqlDbI = imageData.itemsI;
                                    return Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'Interior (${prodImagesSqlDbI.length})'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 100,
                                          child: ListView.builder(
                                              itemCount:
                                                  prodImagesSqlDbI.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin:
                                                      EdgeInsets.only(right: 3),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 100,
                                                        child: prodImagesSqlDbI[
                                                                        index]
                                                                    .imageUrl
                                                                    .substring(
                                                                        0, 5) ==
                                                                'https'
                                                            ? Image.network(
                                                                prodImagesSqlDbI[
                                                                        index]
                                                                    .imageUrl,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.file(
                                                                File(prodImagesSqlDbI[
                                                                        index]
                                                                    .imageUrl),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await _deleteImage(
                                                                prodImagesSqlDbI[
                                                                        index]
                                                                    .id,
                                                                prodImagesSqlDbI[
                                                                        index]
                                                                    .imageType);
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    );
                                  } else
                                    return Container();
                                }),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Details'),
        isActive: _currentStep >= 0,
        state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
        content: Container(
          child: SingleChildScrollView(
            child: Form(
              key: formKeys[1],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product Category',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        // height: MediaQuery.of(context).size.height / 15,
                        child: DropdownButtonFormField<String>(
                          items: _catNames,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              motorFormSqlDb.catName = value;
                            });
                            await _updateMotorForm(motorFormSqlDb.id, 'catName',
                                motorFormSqlDb.catName);
                          },
                          onSaved: (value) {
                            motorFormSqlDb.catName = value;
                          },
                          validator: (value) {
                            if (value == 'Unspecified') {
                              return 'Please select prod category!';
                            }
                            return null;
                          },
                          value: _motorFormCount > 0
                              ? motorFormSqlDb.catName
                              : _initialSelectedItem,
                        ),
                      ),
                    ],
                  ),
                  if (motorFormSqlDb.catName != null)
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Product Type',
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: DropdownButtonFormField<String>(
                            items: _subCatTypes,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) async {
                              setState(() {
                                motorFormSqlDb.subCatDocId = value;
                                print(
                                    'motorFormSqlDb.subCatDocId - ${motorFormSqlDb.subCatDocId}');
                              });
                              print(
                                  'sub cat type - ${motorFormSqlDb.subCatDocId}');
                              await _updateMotorForm(motorFormSqlDb.id,
                                  'subCatDocId', motorFormSqlDb.subCatDocId);
                            },
                            onSaved: (value) {
                              motorFormSqlDb.subCatDocId = value;
                            },
                            validator: (value) {
                              if (value == 'Unspecified' || value == null) {
                                return 'Please select prod category!';
                              }
                              return null;
                            },
                            value: _motorFormCount > 0
                                ? motorFormSqlDb.subCatDocId
                                : _initialSelectedItem,
                          ),
                        ),
                      ],
                    ),
                  if (motorFormSqlDb.catName != null)
                    if (motorFormSqlDb.catName.trim() == 'Car'.trim() ||
                        motorFormSqlDb.catName.trim() == 'Motorbike'.trim() ||
                        motorFormSqlDb.catName.trim() == 'Truck'.trim())
                      motorDetailsUI(),
                  if (motorFormSqlDb.catName != null)
                    if (motorFormSqlDb.catName.trim() != 'Car'.trim() &&
                        motorFormSqlDb.catName.trim() != 'Motorbike'.trim() &&
                        motorFormSqlDb.catName.trim() != 'Truck'.trim())
                      commonDetailsUI(),
                ],
              ),
            ),
          ),
        ),
      ),

      Step(
        title: const Text('Spec'),
        isActive: _currentStep >= 0,
        state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
        content: Container(
          child: SingleChildScrollView(
            child: Form(
              key: formKeys[2],
              child: Column(
                children: <Widget>[
                  if (motorFormSqlDb.catName != null)
                    if (motorFormSqlDb.catName.trim() != 'Car'.trim() &&
                        motorFormSqlDb.catName.trim() != 'Motorbike'.trim() &&
                        motorFormSqlDb.catName.trim() != 'Truck'.trim())
                      Column(
                        children: [
                          Text('Please Continue Further!!'),
                        ],
                      ),
                  if (motorFormSqlDb.catName != null)
                    if (motorFormSqlDb.catName.trim() == 'Car'.trim() ||
                        motorFormSqlDb.catName.trim() == 'Motorbike'.trim() ||
                        motorFormSqlDb.catName.trim() == 'Truck'.trim())
                      Column(
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Mileage',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                height: MediaQuery.of(context).size.height / 15,
                                child: TextFormField(
                                  key: ValueKey('mileage'),
                                  initialValue: motorFormSqlDb.mileage,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) async {
                                    motorFormSqlDb.mileage = value;
                                    await _updateMotorForm(motorFormSqlDb.id,
                                        'mileage', motorFormSqlDb.mileage);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter mileage!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    motorFormSqlDb.mileage = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Fuel Type',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // Container(
                              //   color:
                              //       Theme.of(context).scaffoldBackgroundColor,
                              //   height: MediaQuery.of(context).size.height / 15,
                              //   child: TextFormField(
                              //     key: ValueKey('fuelType'),
                              //     initialValue: motorFormSqlDb.fuelType != null
                              //         ? motorFormSqlDb.fuelType
                              //         : ' ',
                              //     decoration: InputDecoration(
                              //       border: OutlineInputBorder(),
                              //     ),
                              //     onChanged: (value) async {
                              //       motorFormSqlDb.fuelType = value;
                              //       await _updateMotorForm(motorFormSqlDb.id,
                              //           'fuelType', motorFormSqlDb.fuelType);
                              //     },
                              //     onSaved: (value) {
                              //       motorFormSqlDb.fuelType = value;
                              //     },
                              //   ),
                              // ),
                              Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                // height:
                                //     MediaQuery.of(context).size.height / 15,
                                child: DropdownButtonFormField<String>(
                                  items: _fuelType,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) async {
                                    setState(() {
                                      motorFormSqlDb.fuelType = value;
                                    });
                                    await _updateMotorForm(motorFormSqlDb.id,
                                        'fuelType', motorFormSqlDb.fuelType);
                                  },
                                  onSaved: (value) {
                                    motorFormSqlDb.fuelType = value;
                                  },
                                  validator: (value) {
                                    if (value == 'Unspecified') {
                                      return 'Please select Fuel Type!';
                                    }
                                    return null;
                                  },
                                  value: motorFormSqlDb.fuelType != null
                                      ? motorFormSqlDb.fuelType
                                      : _initialSelectedItem,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Exterior Color',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                height: MediaQuery.of(context).size.height / 15,
                                child: TextFormField(
                                  key: ValueKey('exteriorColor'),
                                  controller: controllerEC,
                                  // initialValue: motorFormSqlDb.exteriorColor,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) async {
                                    motorFormSqlDb.exteriorColor = value;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter exteriorColor!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) async {
                                    motorFormSqlDb.exteriorColor = value;
                                    await _updateMotorForm(
                                        motorFormSqlDb.id,
                                        'exteriorColor',
                                        motorFormSqlDb.exteriorColor);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //

                          Column(
                            children: [
                              // Row(
                              //   children: [
                              //     Text("Exterior Color: "),
                              //     Text(motorFormSqlDb.exteriorColor != null
                              //         ? motorFormSqlDb.exteriorColor
                              //         : 'Select Color'),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Red";
                                        controllerEC.text = "Red";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Red"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.red[700],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Orange";
                                        controllerEC.text = "Orange";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Orange"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.orange[700],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Yellow";
                                        controllerEC.text = "Yellow";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Yellow"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.yellow[700],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Green";
                                        controllerEC.text = "Green";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Green"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.green[700],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Blue";
                                        controllerEC.text = "Blue";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Blue"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Purple";
                                        controllerEC.text = "Purple";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Purple"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.purple[700],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Black";
                                        controllerEC.text = "Black";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Black"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                                color: Colors.grey[200],
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.black,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Grey";
                                        controllerEC.text = "Grey";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Grey"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.grey[300],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "Brown";
                                        controllerEC.text = "Brown";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "Brown"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.brown[500],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        motorFormSqlDb.exteriorColor = "White";
                                        controllerEC.text = "White";
                                      });
                                      await _updateMotorForm(
                                          motorFormSqlDb.id,
                                          'exteriorColor',
                                          motorFormSqlDb.exteriorColor);
                                    },
                                    child: Text(''),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                        side: motorFormSqlDb.exteriorColor ==
                                                "White"
                                            ? BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                              )
                                            : BorderSide.none,
                                      ),
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (motorFormSqlDb.catName.trim() !=
                              'Motorbike'.trim())
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Vehicle Type',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('vehicleType'),
                                        initialValue:
                                            motorFormSqlDb.vehicleType != null
                                                ? motorFormSqlDb.vehicleType
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.vehicleType = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'vehicleType',
                                              motorFormSqlDb.vehicleType);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter vehicle type!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.vehicleType = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Engine',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('engine'),
                                        initialValue:
                                            motorFormSqlDb.engine != null
                                                ? motorFormSqlDb.engine
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.engine = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'engine',
                                              motorFormSqlDb.engine);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter engine!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.engine = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Options',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: TextFormField(
                                        maxLines: 5,
                                        key: ValueKey('options'),
                                        initialValue: motorFormSqlDb.options,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.options = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'options',
                                              motorFormSqlDb.options);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.options = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Sub Model',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('subModel'),
                                        initialValue: motorFormSqlDb.subModel,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.subModel = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'subModel',
                                              motorFormSqlDb.subModel);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.subModel = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Number of Cylinders',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('numberOfCylinders'),
                                        initialValue: motorFormSqlDb
                                                    .numberOfCylinders !=
                                                null
                                            ? motorFormSqlDb.numberOfCylinders
                                            : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.numberOfCylinders =
                                              value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'numberOfCylinders',
                                              motorFormSqlDb.numberOfCylinders);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.numberOfCylinders =
                                              value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Safety Features',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('safetyFeatures'),
                                        initialValue:
                                            motorFormSqlDb.safetyFeatures !=
                                                    null
                                                ? motorFormSqlDb.safetyFeatures
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.safetyFeatures = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'safetyFeatures',
                                              motorFormSqlDb.safetyFeatures);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.safetyFeatures = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Drive Type',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('driveType'),
                                        initialValue:
                                            motorFormSqlDb.driveType != null
                                                ? motorFormSqlDb.driveType
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.driveType = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'driveType',
                                              motorFormSqlDb.driveType);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.driveType = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Body Type',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              12,
                                      child: TextFormField(
                                        key: ValueKey('bodyType'),
                                        initialValue:
                                            motorFormSqlDb.bodyType != null
                                                ? motorFormSqlDb.bodyType
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.bodyType = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'bodyType',
                                              motorFormSqlDb.bodyType);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.bodyType = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Trim',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              12,
                                      child: TextFormField(
                                        key: ValueKey('trim'),
                                        initialValue:
                                            motorFormSqlDb.trim != null
                                                ? motorFormSqlDb.trim
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.trim = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'trim',
                                              motorFormSqlDb.trim);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.trim = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Transmission',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('transmission'),
                                        initialValue:
                                            motorFormSqlDb.transmission != null
                                                ? motorFormSqlDb.transmission
                                                : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.transmission = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'transmission',
                                              motorFormSqlDb.transmission);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.transmission = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Interior Color',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('interiorColor'),
                                        controller: controllerIC,
                                        // initialValue: motorFormSqlDb.interiorColor,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.interiorColor = value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'interiorColor',
                                              motorFormSqlDb.interiorColor);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter interiorColor!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.interiorColor = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //
                                Column(
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text("Interior Color: "),
                                    //     Text(
                                    //         motorFormSqlDb.interiorColor != null
                                    //             ? motorFormSqlDb.interiorColor
                                    //             : 'Select Color'),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Red";
                                              controllerIC.text = "Red";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Red"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.red[700],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Orange";
                                              controllerIC.text = "Orange";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Orange"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.orange[700],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Yellow";
                                              controllerIC.text = "Yellow";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Yellow"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.yellow[700],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Green";
                                              controllerIC.text = "Green";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Green"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.green[700],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Blue";
                                              controllerIC.text = "Blue";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Blue"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.blue[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Purple";
                                              controllerIC.text = "Purple";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Purple"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.purple[700],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Black";
                                              controllerIC.text = "Black";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Black"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                      color: Colors.grey[200],
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.black,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Grey";
                                              controllerIC.text = "Grey";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Grey"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.grey[300],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "Brown";
                                              controllerIC.text = "Brown";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "Brown"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.brown[500],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              motorFormSqlDb.interiorColor =
                                                  "White";
                                              controllerIC.text = "White";
                                            });
                                            await _updateMotorForm(
                                                motorFormSqlDb.id,
                                                'interiorColor',
                                                motorFormSqlDb.interiorColor);
                                          },
                                          child: Text(''),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(
                                              side: motorFormSqlDb
                                                          .interiorColor ==
                                                      "White"
                                                  ? BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                    )
                                                  : BorderSide.none,
                                            ),
                                            primary: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Steering Location',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: TextFormField(
                                        key: ValueKey('steeringLocation'),
                                        initialValue: motorFormSqlDb
                                                    .steeringLocation !=
                                                null
                                            ? motorFormSqlDb.steeringLocation
                                            : ' ',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) async {
                                          motorFormSqlDb.steeringLocation =
                                              value;
                                          await _updateMotorForm(
                                              motorFormSqlDb.id,
                                              'steeringLocation',
                                              motorFormSqlDb.steeringLocation);
                                        },
                                        onSaved: (value) {
                                          motorFormSqlDb.steeringLocation =
                                              value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          // Column(
                          //   children: [
                          //     Align(
                          //       alignment: Alignment.centerLeft,
                          //       child: Text(
                          //         'For Sale By',
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 5,
                          //     ),
                          //     Container(
                          //       color:
                          //           Theme.of(context).scaffoldBackgroundColor,
                          //       height:
                          //           MediaQuery.of(context).size.height / 15,
                          //       child: TextFormField(
                          //         key: ValueKey('forSaleBy'),
                          //         initialValue: motorFormSqlDb.forSaleBy,
                          //         decoration: InputDecoration(
                          //           border: OutlineInputBorder(),
                          //         ),
                          //         onChanged: (value) async {
                          //           motorFormSqlDb.forSaleBy = value;
                          //           await _updateMotorForm(
                          //               motorFormSqlDb.id,
                          //               'forSaleBy',
                          //               motorFormSqlDb.forSaleBy);
                          //         },
                          //         onSaved: (value) {
                          //           motorFormSqlDb.forSaleBy = value;
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Warranty',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                height: MediaQuery.of(context).size.height / 15,
                                child: TextFormField(
                                  key: ValueKey('warranty'),
                                  initialValue: motorFormSqlDb.warranty,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) async {
                                    motorFormSqlDb.warranty = value;
                                    await _updateMotorForm(motorFormSqlDb.id,
                                        'warranty', motorFormSqlDb.warranty);
                                  },
                                  onSaved: (value) {
                                    motorFormSqlDb.warranty = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
      // if (motorFormSqlDb.catName.trim() != 'Car'.trim() &&
      //     motorFormSqlDb.catName.trim() != 'Motorbike'.trim() &&
      //     motorFormSqlDb.catName.trim() != 'Truck'.trim())
      //   Step(
      //     title: const Text('Spec'),
      //     isActive: _currentStep >= 0,
      //     state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
      //     content: Form(
      //       key: formKeys[3],
      //       child: Column(
      //         children: <Widget>[
      //           Text(
      //               'No Additional Specification is required!! Please continue :)'),
      //         ],
      //       ),
      //     ),
      //   ),
      Step(
        title: const Text('Review'),
        isActive: _currentStep >= 0,
        state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
        content: Form(
          key: formKeys[3],
          child: Column(
            children: <Widget>[
              // SearchMapPlaceWidget(
              //   strictBounds: false,
              //   // location: LatLng(11.3410, 77.7172),
              //   // radius: 100,
              //   hasClearButton: true,
              //   placeType: PlaceType.address,
              //   placeholder: 'Enter the location',
              //   apiKey: placeApiKey,
              //   onSelected: (Place place) async {
              //     setState(() {
              //       _addressLocation = '';
              //       _latitude = 0.0;
              //       _longitude = 0.0;
              //     });
              //     await getCurrentLocation.getselectedPosition(place);

              //     setState(() {
              //       _addressLocation = getCurrentLocation.addressLocation;
              //       _latitude = getCurrentLocation.latitude;
              //       _longitude = getCurrentLocation.longitude;
              //     });
              //   },
              // ),
              Text('Select Location'),
              SearchPlaceAutoCompleteWidgetCustom(
                apiKey: placeApiKey,
                components: _countryCode,
                placeType: smp.PlaceType.address,
                onSelected: (place) async {
                  print(place);
                  setState(() {
                    _addressLocation = '';
                    _latitude = 0.0;
                    _longitude = 0.0;
                  });
                  await getCurrentLocation.getselectedPosition(place);

                  setState(() {
                    _addressLocation = getCurrentLocation.addressLocation;
                    _latitude = getCurrentLocation.latitude;
                    _longitude = getCurrentLocation.longitude;
                  });
                },
              ),
              TextButton.icon(
                onPressed: () async {
                  setState(() {
                    _addressLocation = '';
                    _latitude = 0.0;
                    _longitude = 0.0;
                  });

                  await getCurrentLocation.getCurrentPosition();
                  setState(() {
                    _addressLocation = getCurrentLocation.addressLocation;
                    _latitude = getCurrentLocation.latitude;
                    _longitude = getCurrentLocation.longitude;
                  });
                },
                icon: Icon(Icons.my_location),
                label: Text("Current location"),
              ),
              Text(_addressLocation),
              if (_prodUpdated == 'Start')
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text('Your Ad is being updated... Please wait!!'),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(),
                  ],
                )
            ],
          ),
        ),
      ),
    ];
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              physics: ClampingScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: () async {
                setState(() {
                  // motorFormSqlDb.editPost = widget.editPost;
                  print('motorFormSqlDb.editPost - ${motorFormSqlDb.editPost}');
                  if (_currentStep > 0) {
                    if (formKeys[_currentStep].currentState.validate()) {
                      formKeys[_currentStep].currentState.save();
                      if (_currentStep < steps.length - 1) {
                        _currentStep = _currentStep + 1;
                        print('checking1');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Enter Mandatory Fields!'),
                        ),
                      );
                    }
                    print('checking2');
                    if (_currentStep == 2) {
                      _addressLocation = '';
                      _latitude = 0.0;
                      _longitude = 0.0;
                    }
                    print('checking3');
                  } else if (_currentStep == 0 && _totalImageCount > 0) {
                    _currentStep = _currentStep + 1;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please Select Image!')));
                  }
                });
              },
              onStepCancel: cancel,
              steps: steps,
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row(
                  children: <Widget>[
                    _currentStep < 3
                        ? ElevatedButton(
                            onPressed: onStepContinue,
                            child: Text('Continue'),
                          )
                        : _addressLocation.isNotEmpty
                            ? ElevatedButton(
                                onPressed: () async {
                                  print(
                                      'is edit  Post0 - ${motorFormSqlDb.editPost}');
                                  if (motorFormSqlDb.editPost == 'true') {
                                    print('is edit  Post1');
                                    _deleteProduct(widget.prodId,
                                            motorFormSqlDb.catName)
                                        .then((value) async {
                                      // _updateCategoryCount(false);
                                      setState(() {
                                        _prodUpdated = 'Start';
                                      });
                                      await _postAds().then((value) async {
                                        print('check after postad - $value');
                                        if (value == 'Success') {
                                          await _deleteAndProcess();
                                        }
                                      });
                                    });
                                  } else {
                                    print('post check1');
                                    setState(() {
                                      _prodUpdated = 'Start';
                                    });

                                    await _postAds().then((value) async {
                                      print('check after postad - $value');
                                      if (value == 'Success') {
                                        await _deleteAndProcess();
                                      }
                                    });
                                  }
                                  // // _updateCategoryCount(true);
                                  // print('check post 1****');
                                  // _deleteImageAll();
                                  // print('check post 3****');
                                  // _deleteMotorFormAll().then((value) {
                                  //   // _showPostDialog();
                                  //   print('check post 4****');
                                  //   if (_prodUpdated == 'Success') {
                                  //     print('check post 5****');
                                  //     ScaffoldMessenger.of(context)
                                  //         .showSnackBar(
                                  //       SnackBar(
                                  //         content:
                                  //             Text('Post added successfully!'),
                                  //       ),
                                  //     );
                                  //   }
                                  //   print('check post 6****');
                                  //   Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) {
                                  //           return TabsScreen();
                                  //         },
                                  //         fullscreenDialog: true),
                                  //   );
                                  // });
                                },
                                child: Text('Post Ad'),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                    TextButton(
                      onPressed: onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // UI design Widgets

  Widget motorDetailsUI() {
    return Column(
      children: [
        if (motorFormSqlDb.catName != null)
          if (motorFormSqlDb.catName.trim() == 'Car'.trim() ||
              motorFormSqlDb.catName.trim() == 'Truck'.trim())
            Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Text('What type of vehicle are you selling?'),
                SizedBox(
                  height: 10,
                ),
                CustomRadioButton(
                  horizontal: true,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: [
                    'Car or Truck (Pre 1981)',
                    'Car or Truck (1981 - Today)',
                  ],
                  buttonValues: [
                    "CTB1981",
                    "CTA1981",
                  ],
                  defaultSelected: motorFormSqlDb.vehicleTypeYear,
                  radioButtonValue: (value) async {
                    setState(() {
                      motorFormSqlDb.vehicleTypeYear = value;
                    });
                    await _updateMotorForm(
                        motorFormSqlDb.id, 'vehicleTypeYear', value);
                    if (value == "CTA1981") {
                      setState(() {
                        cTA1981 = true;
                      });
                    } else {
                      setState(() {
                        cTA1981 = false;
                      });
                    }
                    print(value.toString());
                  },
                  selectedColor: Colors.blue[200],
                  unSelectedBorderColor: Colors.grey,
                  selectedBorderColor: Colors.blue[200],
                  elevation: 0.0,
                  enableShape: false,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: ValueKey('vin'),
                  initialValue: motorFormSqlDb.vin,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'VIN'),
                  onChanged: (value) async {
                    print(value);
                    print(value.length);
                    motorFormSqlDb.vin = value;
                    await _updateMotorForm(
                        motorFormSqlDb.id, 'vin', motorFormSqlDb.vin);
                    if (value.length == 17) {
                      setState(() {
                        _enableVinValButton = true;
                      });
                    } else {
                      _enableVinValButton = false;
                    }
                  },
                  validator: (value) {
                    if (motorFormSqlDb.vehicleTypeYear == 'CTA1981') {
                      if (value.isEmpty) {
                        return 'Please enter VIN';
                      } else if (value.length != 17) {
                        return 'Please enter valid VIN, should be 17 letters.';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) async {
                    motorFormSqlDb.vin = value;
                  },
                ),
              ],
            ),
        SizedBox(
          height: 10,
        ),
        if (motorFormSqlDb.vehicleTypeYear == 'CTA1981')
          OutlineButton(
            shape: StadiumBorder(),
            textColor: Colors.blue,
            child: Text('Validate VIN'),
            borderSide: BorderSide(
                color: Colors.grey, style: BorderStyle.solid, width: 1),
            onPressed: () async {
              _vinValidateFlag = false;
              await _validateVIN(motorFormSqlDb.vin).then((value) {
                setState(() {
                  _vinValidateFlag = true;
                });
              });
            },
          ),
        SizedBox(
          height: 10,
        ),
        !_vinValidateFlag &&
                motorFormSqlDb.vehicleTypeYear == 'CTA1981' &&
                motorFormSqlDb.year == null
            ? Container(
                height: 0,
                width: 0,
              )
            : Column(
                children: [
                  // Year
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Year',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: MediaQuery.of(context).size.height / 15,
                        child: TextFormField(
                          key: ValueKey('year'),
                          initialValue: motorFormSqlDb.year != null
                              ? motorFormSqlDb.year
                              : '',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            motorFormSqlDb.year = value;
                            await _updateMotorForm(
                                motorFormSqlDb.id, 'year', motorFormSqlDb.year);
                          },
                          onSaved: (value) {
                            motorFormSqlDb.year = value;
                          },
                          validator: (value) {
                            if (motorFormSqlDb.catName.trim() !=
                                "Motorbike".trim()) {
                              if (value.isNotEmpty) {
                                var yr = num.parse(value.trim());
                                if ((motorFormSqlDb.vehicleTypeYear ==
                                        'CTA1981') &&
                                    yr < 1981) {
                                  return 'Please enter product year greater than 1981';
                                } else if (motorFormSqlDb.vehicleTypeYear ==
                                    'CTB1981') {
                                  if (yr >= 1981) {
                                    return 'Year must be < 1981 or Please select option \"Car or Truck (1981 - Today)" & validate VIN!';
                                  }
                                }
                              }
                            }
                            if (value.isEmpty) {
                              return 'Please enter year!';
                            }

                            return null;
                          },
                        ),
                        // DropdownButtonFormField<String>(
                        //   items: _years,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   onChanged: (value) async {
                        //     setState(() {
                        //       motorFormSqlDb.year = value;
                        //     });
                        //     await _updateMotorForm(motorFormSqlDb.id,
                        //         'year', motorFormSqlDb.year);
                        //   },
                        //   onSaved: (value) {
                        //     motorFormSqlDb.year = value;
                        //   },
                        //   validator: (value) {
                        //     if (value == 'Unspecified') {
                        //       return 'Please select year!';
                        //     }
                        //     return null;
                        //   },
                        //   value: _motorFormCount > 0
                        //       ? motorFormSqlDb.year
                        //       : _initialSelectedItem,
                        // ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Make
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Make',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: MediaQuery.of(context).size.height / 15,
                        child: TextFormField(
                          key: ValueKey('make'),
                          initialValue: motorFormSqlDb.make != null
                              ? motorFormSqlDb.make
                              : '',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            motorFormSqlDb.make = value;
                            await _updateMotorForm(
                                motorFormSqlDb.id, 'make', motorFormSqlDb.make);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter make!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            motorFormSqlDb.make = value;
                          },
                        ),
                        // DropdownButtonFormField<String>(
                        //   items: _makes,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   onChanged: (value) async {
                        //     setState(() {
                        //       motorFormSqlDb.make = value;
                        //     });
                        //     await _updateMotorForm(motorFormSqlDb.id,
                        //         'make', motorFormSqlDb.make);
                        //   },
                        //   onSaved: (value) {
                        //     motorFormSqlDb.make = value;
                        //   },
                        //   validator: (value) {
                        //     if (value == 'Unspecified') {
                        //       return 'Please select make!';
                        //     }
                        //     return null;
                        //   },
                        //   value: _motorFormCount > 0
                        //       ? motorFormSqlDb.make
                        //       : _initialSelectedItem,
                        // ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Model
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Model',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: MediaQuery.of(context).size.height / 15,
                        child: TextFormField(
                          key: ValueKey('model'),
                          initialValue: motorFormSqlDb.model != null
                              ? motorFormSqlDb.model
                              : '',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            motorFormSqlDb.model = value;
                            await _updateMotorForm(motorFormSqlDb.id, 'model',
                                motorFormSqlDb.model);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter model!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            motorFormSqlDb.model = value;
                          },
                        ),
                        // DropdownButtonFormField<String>(
                        //   items: _models,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   onChanged: (value) async {
                        //     setState(() {
                        //       motorFormSqlDb.model = value;
                        //     });
                        //     await _updateMotorForm(motorFormSqlDb.id,
                        //         'model', motorFormSqlDb.model);
                        //   },
                        //   onSaved: (value) {
                        //     motorFormSqlDb.model = value;
                        //   },
                        //   validator: (value) {
                        //     if (value == 'Unspecified') {
                        //       return 'Please select model!';
                        //     }
                        //     return null;
                        //   },
                        //   value: _motorFormCount > 0
                        //       ? motorFormSqlDb.model
                        //       : _initialSelectedItem,
                        // ),
                      ),
                    ],
                  ),

                  // TypeAheadFormField<Model>(
                  //   initialValue: motorFormSqlDb.model.isNotEmpty
                  //       ? motorFormSqlDb.model
                  //       : _initialSelectedItem,
                  //   textFieldConfiguration: TextFieldConfiguration(
                  //       decoration:
                  //           InputDecoration(labelText: 'Model'),
                  //       focusNode: _focusNode),
                  //   onSuggestionSelected:
                  //       (Model modelSuggestion) async {
                  //     setState(() {
                  //       motorFormSqlDb.model = modelSuggestion.model;
                  //       this._typeAheadControllerModel.text =
                  //           motorFormSqlDb.model;
                  //     });

                  //     await _updateMotorForm(motorFormSqlDb.id,
                  //         'model', motorFormSqlDb.model);
                  //   },
                  //   validator: (value) {
                  //     if (value == 'Unspecified') {
                  //       return 'Please select model!';
                  //     }
                  //     return null;
                  //   },
                  //   itemBuilder: (context, Model modelSuggestion) {
                  //     final model = modelSuggestion;
                  //     return Container(
                  //       height: 600,
                  //       child: ListTile(
                  //         title: Text(model.model),
                  //       ),
                  //     );
                  //   },
                  //   suggestionsCallback: getModelSuggestions,
                  //   transitionBuilder: (context, suggestionsBox,
                  //           animationController) =>
                  //       FadeTransition(
                  //     child: suggestionsBox,
                  //     opacity: CurvedAnimation(
                  //         parent: animationController,
                  //         curve: Curves.fastOutSlowIn),
                  //   ),
                  // ),

                  // TextFormField(
                  //   key: ValueKey('make'),
                  //   initialValue: motorFormSqlDb.make,
                  //   decoration: InputDecoration(labelText: 'Make'),
                  //   onChanged: (value) async {
                  //     motorFormSqlDb.make = value;
                  //     await _updateMotorForm(motorFormSqlDb.id,
                  //         'make', motorFormSqlDb.make);
                  //   },
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'Please enter Make';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     motorFormSqlDb.make = value;
                  //   },
                  // ),
                  // TextFormField(
                  //   key: ValueKey('model'),
                  //   initialValue: motorFormSqlDb.model,
                  //   decoration: InputDecoration(labelText: 'Model'),
                  //   onChanged: (value) async {
                  //     motorFormSqlDb.model = value;
                  //     await _updateMotorForm(motorFormSqlDb.id,
                  //         'model', motorFormSqlDb.model);
                  //   },
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'Please enter Model';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     motorFormSqlDb.model = value;
                  //   },
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  // Product Condition
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product Condition',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        // height:
                        //     MediaQuery.of(context).size.height / 15,
                        child: DropdownButtonFormField<String>(
                          items: _prodConditions,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              motorFormSqlDb.prodCondition = value;
                            });
                            await _updateMotorForm(motorFormSqlDb.id,
                                'prodCondition', motorFormSqlDb.prodCondition);
                          },
                          onSaved: (value) {
                            motorFormSqlDb.prodCondition = value;
                          },
                          validator: (value) {
                            if (value == 'Unspecified') {
                              return 'Please select prod condition!';
                            }
                            return null;
                          },
                          value: motorFormSqlDb.prodCondition != null
                              ? motorFormSqlDb.prodCondition
                              : _initialSelectedItem,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Price $_currencySymbol',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: MediaQuery.of(context).size.height / 15,
                        child: TextFormField(
                          key: ValueKey('price'),
                          initialValue: motorFormSqlDb.price,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            motorFormSqlDb.price = value;
                            await _updateMotorForm(motorFormSqlDb.id, 'price',
                                motorFormSqlDb.price);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            motorFormSqlDb.price = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Description',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: TextFormField(
                          maxLines: 5,
                          key: ValueKey('prodDes'),
                          initialValue: motorFormSqlDb.prodDes,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            motorFormSqlDb.prodDes = value;
                            await _updateMotorForm(motorFormSqlDb.id, 'prodDes',
                                motorFormSqlDb.prodDes);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter description!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            motorFormSqlDb.prodDes = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Seller Notes',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: TextFormField(
                          maxLines: 5,
                          key: ValueKey('sellerNotes'),
                          initialValue: motorFormSqlDb.sellerNotes,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          onChanged: (value) async {
                            motorFormSqlDb.sellerNotes = value;
                            await _updateMotorForm(motorFormSqlDb.id,
                                'sellerNotes', motorFormSqlDb.sellerNotes);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter seller notes!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            motorFormSqlDb.sellerNotes = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Delivery Info',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Container(
                      //   color: Theme.of(context).scaffoldBackgroundColor,
                      //   height: MediaQuery.of(context).size.height / 15,
                      //   child: TextFormField(
                      //     key: ValueKey('deliveryInfo'),
                      //     initialValue: motorFormSqlDb.deliveryInfo,
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(),
                      //     ),
                      //     onChanged: (value) async {
                      //       motorFormSqlDb.deliveryInfo = value;
                      //       await _updateMotorForm(motorFormSqlDb.id,
                      //           'deliveryInfo', motorFormSqlDb.deliveryInfo);
                      //     },
                      //     onSaved: (value) {
                      //       motorFormSqlDb.deliveryInfo = value;
                      //     },
                      //   ),
                      // ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        // height:
                        //     MediaQuery.of(context).size.height / 15,
                        child: DropdownButtonFormField<String>(
                          items: _deliveryInfo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              motorFormSqlDb.deliveryInfo = value;
                            });
                            await _updateMotorForm(motorFormSqlDb.id,
                                'deliveryInfo', motorFormSqlDb.deliveryInfo);
                          },
                          onSaved: (value) {
                            motorFormSqlDb.deliveryInfo = value;
                          },
                          validator: (value) {
                            if (value == 'Unspecified') {
                              return 'Please select Delivery Info!';
                            }
                            return null;
                          },
                          value: motorFormSqlDb.deliveryInfo != null
                              ? motorFormSqlDb.deliveryInfo
                              : _initialSelectedItem,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'For Sale By',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Container(
                      //   color: Theme.of(context).scaffoldBackgroundColor,
                      //   height: MediaQuery.of(context).size.height / 15,
                      //   child: TextFormField(
                      //     key: ValueKey('forSaleBy'),
                      //     initialValue: motorFormSqlDb.forSaleBy,
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(),
                      //     ),
                      //     onChanged: (value) async {
                      //       motorFormSqlDb.forSaleBy = value;
                      //       await _updateMotorForm(motorFormSqlDb.id,
                      //           'forSaleBy', motorFormSqlDb.forSaleBy);
                      //     },
                      //     onSaved: (value) {
                      //       motorFormSqlDb.forSaleBy = value;
                      //     },
                      //   ),
                      // ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        // height:
                        //     MediaQuery.of(context).size.height / 15,
                        child: DropdownButtonFormField<String>(
                          items: _forSaleBy,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              motorFormSqlDb.forSaleBy = value;
                            });
                            await _updateMotorForm(motorFormSqlDb.id,
                                'forSaleBy', motorFormSqlDb.forSaleBy);
                          },
                          onSaved: (value) {
                            motorFormSqlDb.forSaleBy = value;
                          },
                          validator: (value) {
                            if (value == 'Unspecified') {
                              return 'Please select ForSaleBy!';
                            }
                            return null;
                          },
                          value: motorFormSqlDb.forSaleBy != null
                              ? motorFormSqlDb.forSaleBy
                              : _initialSelectedItem,
                        ),
                      ),
                    ],
                  )
                ],
              )
      ],
    );
  }

  Widget commonDetailsUI() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Year',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                key: ValueKey('year'),
                initialValue:
                    motorFormSqlDb.year != null ? motorFormSqlDb.year : '',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  motorFormSqlDb.year = value;
                  await _updateMotorForm(
                      motorFormSqlDb.id, 'year', motorFormSqlDb.year);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter year!';
                  }
                  return null;
                },
                onSaved: (value) {
                  motorFormSqlDb.year = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Make
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Make',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                key: ValueKey('make'),
                initialValue:
                    motorFormSqlDb.make != null ? motorFormSqlDb.make : '',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  motorFormSqlDb.make = value;
                  await _updateMotorForm(
                      motorFormSqlDb.id, 'make', motorFormSqlDb.make);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter make!';
                  }
                  return null;
                },
                onSaved: (value) {
                  motorFormSqlDb.make = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),

        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Model',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                key: ValueKey('model'),
                initialValue:
                    motorFormSqlDb.model != null ? motorFormSqlDb.model : '',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  motorFormSqlDb.model = value;
                  await _updateMotorForm(
                      motorFormSqlDb.id, 'model', motorFormSqlDb.model);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter model!';
                  }
                  return null;
                },
                onSaved: (value) {
                  motorFormSqlDb.model = value;
                },
              ),
            ),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        // Product Condition
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Product Condition',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: DropdownButtonFormField<String>(
                items: _prodConditions,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  setState(() {
                    motorFormSqlDb.prodCondition = value;
                  });
                  await _updateMotorForm(motorFormSqlDb.id, 'prodCondition',
                      motorFormSqlDb.prodCondition);
                },
                onSaved: (value) {
                  motorFormSqlDb.prodCondition = value;
                },
                validator: (value) {
                  if (value == 'Unspecified') {
                    return 'Please select prod condition!';
                  }
                  return null;
                },
                value: motorFormSqlDb.prodCondition != null
                    ? motorFormSqlDb.prodCondition
                    : _initialSelectedItem,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Price $_currencySymbol',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                key: ValueKey('price'),
                initialValue: motorFormSqlDb.price,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) async {
                  motorFormSqlDb.price = value;
                  await _updateMotorForm(
                      motorFormSqlDb.id, 'price', motorFormSqlDb.price);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
                onSaved: (value) {
                  motorFormSqlDb.price = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TextFormField(
                maxLines: 5,
                key: ValueKey('prodDes'),
                initialValue: motorFormSqlDb.prodDes,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  motorFormSqlDb.prodDes = value;
                  await _updateMotorForm(
                      motorFormSqlDb.id, 'prodDes', motorFormSqlDb.prodDes);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter product description!';
                  }
                  return null;
                },
                onSaved: (value) {
                  motorFormSqlDb.prodDes = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Seller Notes',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TextFormField(
                maxLines: 5,
                key: ValueKey('sellerNotes'),
                initialValue: motorFormSqlDb.sellerNotes,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) async {
                  motorFormSqlDb.sellerNotes = value;
                  await _updateMotorForm(motorFormSqlDb.id, 'sellerNotes',
                      motorFormSqlDb.sellerNotes);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter seller notes!';
                  }
                  return null;
                },
                onSaved: (value) {
                  motorFormSqlDb.sellerNotes = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Delivery Info',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // Container(
            //   color: Theme.of(context).scaffoldBackgroundColor,
            //   height: MediaQuery.of(context).size.height / 15,
            //   child: TextFormField(
            //     key: ValueKey('deliveryInfo'),
            //     initialValue: motorFormSqlDb.deliveryInfo,
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     onChanged: (value) async {
            //       motorFormSqlDb.deliveryInfo = value;
            //       await _updateMotorForm(motorFormSqlDb.id, 'deliveryInfo',
            //           motorFormSqlDb.deliveryInfo);
            //     },
            //     onSaved: (value) {
            //       motorFormSqlDb.deliveryInfo = value;
            //     },
            //   ),
            // ),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              // height:
              //     MediaQuery.of(context).size.height / 15,
              child: DropdownButtonFormField<String>(
                items: _deliveryInfo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  setState(() {
                    motorFormSqlDb.deliveryInfo = value;
                  });
                  await _updateMotorForm(motorFormSqlDb.id, 'deliveryInfo',
                      motorFormSqlDb.deliveryInfo);
                },
                onSaved: (value) {
                  motorFormSqlDb.deliveryInfo = value;
                },
                validator: (value) {
                  if (value == 'Unspecified') {
                    return 'Please select Delivery Info!';
                  }
                  return null;
                },
                value: motorFormSqlDb.deliveryInfo != null
                    ? motorFormSqlDb.deliveryInfo
                    : _initialSelectedItem,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'For Sale By',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // Container(
            //   color: Theme.of(context).scaffoldBackgroundColor,
            //   height: MediaQuery.of(context).size.height / 15,
            //   child: TextFormField(
            //     key: ValueKey('forSaleBy'),
            //     initialValue: motorFormSqlDb.forSaleBy,
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //     ),
            //     onChanged: (value) async {
            //       motorFormSqlDb.forSaleBy = value;
            //       await _updateMotorForm(
            //           motorFormSqlDb.id, 'forSaleBy', motorFormSqlDb.forSaleBy);
            //     },
            //     onSaved: (value) {
            //       motorFormSqlDb.forSaleBy = value;
            //     },
            //   ),
            // ),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              // height:
              //     MediaQuery.of(context).size.height / 15,
              child: DropdownButtonFormField<String>(
                items: _forSaleBy,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  setState(() {
                    motorFormSqlDb.forSaleBy = value;
                  });
                  await _updateMotorForm(
                      motorFormSqlDb.id, 'forSaleBy', motorFormSqlDb.forSaleBy);
                },
                onSaved: (value) {
                  motorFormSqlDb.forSaleBy = value;
                },
                validator: (value) {
                  if (value == 'Unspecified') {
                    return 'Please select ForSaleBy!';
                  }
                  return null;
                },
                value: motorFormSqlDb.forSaleBy != null
                    ? motorFormSqlDb.forSaleBy
                    : _initialSelectedItem,
              ),
            ),
          ],
        )
      ],
    );
  }

  //Steps Functions

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    print('_currentStep - $_currentStep');
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Future _pickImage(String sourceType) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: sourceType == 'G' ? ImageSource.gallery : ImageSource.camera,
      // imageQuality: 50,
      // maxWidth: 150,
    );
    if (imageFile == null) {
      return null;
    }
    setState(() {
      pickedImage = File(imageFile.path);
    });

    if (pickedImage != null) {
      await runModelOnImage();
    }
  }

  Future runModelOnImage() async {
    print('check run model');
    var output = await Tflite.runModelOnImage(
      path: pickedImage.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      threshold: 0.8,
    );

    print('output length - ${output.length}');
    if (output.length > 0) {
      setState(() {
        imageLabel = output[0]["label"];
        motorFormSqlDb.catName = imageLabel.split(" ")[1];
        motorFormSqlDb.make = imageLabel.split(" ")[2];
        motorFormSqlDb.model = imageLabel.split(" ")[3];
        imageType = imageLabel.split(" ")[4];
      });
    } else {
      imageLabel = 'Unspecified';
      imageType = 'E';
    }
    if (imageLabel.isNotEmpty) {
      await loadImage();
    }
  }

  loadImage() async {
    ProdImagesSqlDb prodImageSqlDb = ProdImagesSqlDb();

    if (_featuredImage == false) {
      _featuredImage = true;
      prodImageSqlDb.featuredImage = 'true';
    } else {
      prodImageSqlDb.featuredImage = 'false';
    }

    if (motorFormSqlDb.catName != 'Car' &&
        motorFormSqlDb.catName != 'Truck' &&
        motorFormSqlDb.catName != 'Home') {
      imageType = 'E';
    }

    prodImageSqlDb.imageType = imageType.substring(0, 1).toUpperCase();

    prodImageSqlDb.imageUrl = pickedImage.path;

    // if (imageType.trim().toLowerCase() == 'exterior') {
    //   // prodImagesSqlDbE.add(prodImageSqlDb);
    //   setState(() {
    //     _eImageCount = _eImageCount + 1;
    //   });
    // } else if (imageType.trim().toLowerCase() == 'interior') {
    //   // prodImagesSqlDbI.add(prodImageSqlDb);
    //   setState(() {
    //     _iImageCount = _iImageCount + 1;
    //   });
    // }

    _saveImage(prodImageSqlDb).then((value) {
      _showDialogImages();
    });
  }

  void _showDialogImages() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Organizing your images"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text('$_eImageCount Exterior'),
                ),
                Center(
                  child: Text('$_iImageCount Interiors'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(
                child: Text('View Images'),
              ),
              onPressed: () async {
                await _initialLoadMotorForm();
                if (_motorFormCount == 0) {
                  // Initial vehicle Type Year
                  if (motorFormSqlDb.catName == 'Car' ||
                      motorFormSqlDb.catName == 'Truck') {
                    motorFormSqlDb.vehicleTypeYear = "CTA1981";
                  }

                  motorFormSqlDb.editPost = 'false';
                  await _saveMotorForm(motorFormSqlDb);
                }
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showPostDialog() {
    String _updating = 'Start';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Posted your add"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: _updating == 'Start'
                      ? TextButton(
                          onPressed: () async {
                            setState(() {
                              _updating = 'Updating';
                            });
                            await _postAds().then((value) async {
                              print('check after postad - $value');
                              if (value == 'Success') {
                                await _deleteAndProcess();
                                setState(() {
                                  _updating = 'Updated';
                                });
                              }
                            });
                          },
                          child: Text('Do you want to continue ?'),
                        )
                      : _updating == 'Updating'
                          ? Text('Your ad is beeing posted....')
                          : Text('Your ad posted Successfully!'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(
                child: Text('Ok'),
              ),
              onPressed: () {
                if (motorFormSqlDb.editPost == 'true') {
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) =>
                  //         DisplayProductCatalog(),
                  //   ),

                  // );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) {
                          return DisplayProductCatalog();
                        },
                        fullscreenDialog: true),
                  );
                } else {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => TabsScreen()));

                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => TabsScreen()));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future _validateVIN(String inVIN) async {
    var vin = VINC(number: inVIN, extended: true);

    // print('WMI: ${vin.wmi}');
    // print('VDS: ${vin.vds}');
    // print('VIS: ${vin.vis}');

    // print("Model year is " + vin.modelYear());
    // print("Serial number is " + vin.serialNumber());
    // print("Assembly plant is " + vin.assemblyPlant());
    // print("Manufacturer is " + vin.getManufacturer());
    // print("Year is " + vin.getYear().toString());

    var year = vin.getYear().toString();
    if (year != null) {
      print("Year is ${year}");
      setState(() {
        motorFormSqlDb.year = year;
      });
      await _updateMotorForm(motorFormSqlDb.id, 'year', motorFormSqlDb.year);
    }
    print("Region is " + vin.getRegion());
    print("VIN string is " + vin.toString());

    // The following calls are to the NHTSA DB, and are carried out asynchronously
    var make = await vin.getMakeAsync();
    print("Make is ${make}");
    if (make != null) {
      setState(() {
        motorFormSqlDb.make = make;
      });
      await _updateMotorForm(motorFormSqlDb.id, 'make', motorFormSqlDb.make);
    }

    var model = await vin.getModelAsync();
    print("Model is ${model}");
    if (model != null) {
      setState(() {
        motorFormSqlDb.model = model;
      });
      await _updateMotorForm(motorFormSqlDb.id, 'model', motorFormSqlDb.model);
    }

    var vehicleType = await vin.getVehicleTypeAsync();
    print("Type is ${vehicleType}");
    if (vehicleType != null) {
      setState(() {
        motorFormSqlDb.vehicleType = vehicleType;
      });
      await _updateMotorForm(
          motorFormSqlDb.id, 'vehicleType', motorFormSqlDb.vehicleType);
    }

    var numberOfCylinders = await vin.getEngineNumberofCylindersAsync();
    print("EngineNumber of Cylinders is ${numberOfCylinders}");
    if (numberOfCylinders != null) {
      setState(() {
        motorFormSqlDb.numberOfCylinders = numberOfCylinders;
      });
      await _updateMotorForm(motorFormSqlDb.id, 'numberOfCylinders',
          motorFormSqlDb.numberOfCylinders);
    }

    var safetyFeatures = await vin.getActiveSafetySystemNoteAsync();
    print("Active Safety SystemNote is ${safetyFeatures}");
    if (safetyFeatures != null) {
      setState(() {
        motorFormSqlDb.safetyFeatures = safetyFeatures;
      });
      await _updateMotorForm(
          motorFormSqlDb.id, 'safetyFeatures', motorFormSqlDb.safetyFeatures);
    }

    var transmission = await vin.getTransmissionStyleAsync();
    print("Transmission Style is ${transmission}");
    if (transmission != null) {
      setState(() {
        motorFormSqlDb.transmission = transmission;
      });
      await _updateMotorForm(
          motorFormSqlDb.id, 'transmission', motorFormSqlDb.transmission);
    }

    var steeringLocation = await vin.getSteeringLocationAsync();
    print("Steering Location is ${steeringLocation}");
    if (steeringLocation != null) {
      setState(() {
        motorFormSqlDb.steeringLocation = steeringLocation;
      });
      await _updateMotorForm(motorFormSqlDb.id, 'steeringLocation',
          motorFormSqlDb.steeringLocation);
    }

    var fuelType = await vin.getFuelTypePrimaryAsync();
    print("Fuel Type Primary is ${fuelType}");
    if (fuelType != null) {
      setState(() {
        motorFormSqlDb.fuelType = fuelType;
      });
      await _updateMotorForm(
          motorFormSqlDb.id, 'fuelType', motorFormSqlDb.fuelType);
    }

    var trim = await vin.getTrimAsync();
    print("Trim is ${trim}");
    if (trim != null) {
      setState(() {
        motorFormSqlDb.trim = trim;
      });
      await _updateMotorForm(motorFormSqlDb.id, 'trim', motorFormSqlDb.trim);
    }

    var driveType = await vin.getDriveTypeAsync();
    print("Drive Type is ${driveType}");
    if (driveType != null) {
      setState(() {
        motorFormSqlDb.driveType = driveType;
      });
      await _updateMotorForm(
          motorFormSqlDb.id, 'driveType', motorFormSqlDb.driveType);
    }

    var bodyType = await vin.getBodyTypeAsync();
    print("Body Type is ${bodyType}");
    if (bodyType != null) {
      setState(() {
        motorFormSqlDb.bodyType = bodyType;
      });
      await _updateMotorForm(
          motorFormSqlDb.id, 'bodyType', motorFormSqlDb.bodyType);
    }

    var displacementL = await vin.getDisplacementLAsync();
    print("Displacement (L) is ${displacementL}");

    String disp = double.parse(displacementL).toStringAsFixed(1);
    if (disp != null && fuelType != null) {
      var engine = ("$disp L $fuelType").toString();
      print("Engine is ${engine}");

      if (engine != null) {
        setState(() {
          motorFormSqlDb.engine = engine;
        });
        await _updateMotorForm(
            motorFormSqlDb.id, 'engine', motorFormSqlDb.engine);
      }
    }

    // var generated = VINGenerator().generate();
    // print('Randomly Generated VIN is ${generated}');
  }

  // Future<void> _updateCategoryCount(bool addCatCount) async {
  //   int catCount;
  //   var catNamesCount = catNames
  //       .where((e) => e.catName.trim() == motorFormSqlDb.catName.trim())
  //       .toList();

  //   if (catNamesCount.length > 0) {
  //     if (catNamesCount[0].totalProducts != null) {
  //       if (addCatCount) {
  //         catCount = catNamesCount[0].totalProducts + 1;
  //       } else {
  //         catCount = catNamesCount[0].totalProducts - 1;
  //       }
  //     } else {
  //       catCount = 0;
  //     }
  //     await FirebaseFirestore.instance
  //         .collection('categories')
  //         .doc(catNamesCount[0].catDocId)
  //         .update({'totalProducts': catCount})
  //         .then((value) => print("categories Updated"))
  //         .catchError((error) => print("Failed to update categories: $error"));
  //   } else {
  //     print("No categories on database!!");
  //   }
  // }

  Future<String> _postAds() async {
    prodImagesSqlDb = prodImagesSqlDbE + prodImagesSqlDbI;

    _prodName = (motorFormSqlDb.year +
            ' ' +
            motorFormSqlDb.make +
            ' ' +
            motorFormSqlDb.model)
        .toString();
    print('post check2');

    if (motorFormSqlDb.catName.trim() == 'Car'.trim() ||
        motorFormSqlDb.catName.trim() == 'Motorbike'.trim() ||
        motorFormSqlDb.catName.trim() == 'Truck'.trim()) {
      print('post check3 - ${motorFormSqlDb.subCatDocId}');

      await FirebaseFirestore.instance.collection('products').add({
        'prodName': _prodName,
        'catName': motorFormSqlDb.catName,
        'subCatDocId': motorFormSqlDb.subCatDocId,
        'prodDes': motorFormSqlDb.prodDes,
        'sellerNotes': motorFormSqlDb.sellerNotes,
        'year': motorFormSqlDb.year,
        'make': motorFormSqlDb.make,
        'model': motorFormSqlDb.model,
        'prodCondition': motorFormSqlDb.prodCondition,
        'price': motorFormSqlDb.price,
        'currencyName': _currencyName,
        'currencySymbol': _currencySymbol,
        'imageUrlFeatured': motorFormSqlDb.imageUrlFeatured,
        'addressLocation': _addressLocation,
        'countryCode': _countryCode,
        'latitude': _latitude,
        'longitude': _longitude,
        'userDetailDocId': _userDetailDocId,
        'deliveryInfo': motorFormSqlDb.deliveryInfo,
        'distance': '',
        'status': 'Pending',
        'forSaleBy': motorFormSqlDb.forSaleBy,
        'listingStatus': 'Available',
        'createdAt': Timestamp.now(),
      }).then((p) async {
        print('post check4');
        await FirebaseFirestore.instance.collection('CtmSpecialInfo').add({
          'prodDocId': p.id.toString(),
          'year': motorFormSqlDb.year,
          'make': motorFormSqlDb.make,
          'model': motorFormSqlDb.model,
          'vehicleType': motorFormSqlDb.vehicleType,
          'mileage': motorFormSqlDb.mileage,
          'vin': motorFormSqlDb.vin,
          'engine': motorFormSqlDb.engine,
          'fuelType': motorFormSqlDb.fuelType,
          'options': motorFormSqlDb.options,
          'subModel': motorFormSqlDb.subModel,
          'numberOfCylinders': motorFormSqlDb.numberOfCylinders,
          'safetyFeatures': motorFormSqlDb.safetyFeatures,
          'driveType': motorFormSqlDb.driveType,
          'interiorColor': motorFormSqlDb.interiorColor,
          'bodyType': motorFormSqlDb.bodyType,
          'forSaleBy': motorFormSqlDb.forSaleBy,
          'warranty': motorFormSqlDb.warranty,
          'exteriorColor': motorFormSqlDb.exteriorColor,
          'trim': motorFormSqlDb.trim,
          'transmission': motorFormSqlDb.transmission,
          'steeringLocation': motorFormSqlDb.steeringLocation,
        }).then(
          (ctm) async {
            print('post check5');
            _prodDocId = p.id;

            if (_prodDocId.isNotEmpty) {
              for (var i = 0; i < prodImagesSqlDb.length; i++) {
                if (prodImagesSqlDb[i].imageUrl.substring(0, 5) != 'https') {
                  final fileNameExt =
                      prodImagesSqlDb[i].imageUrl.split('/').last;
                  final fileName = fileNameExt.split('.').first;

                  final ref = FirebaseStorage.instance
                      .ref()
                      .child(
                          'product_images/${user.uid}/${motorFormSqlDb.catName}/${motorFormSqlDb.make}')
                      .child(motorFormSqlDb.make +
                          motorFormSqlDb.model +
                          fileName +
                          '.jpg');

                  await ref.putFile(File(prodImagesSqlDb[i].imageUrl));

                  _imageUrl = await ref.getDownloadURL();

                  prodImagesSqlDb[i].imageUrl = _imageUrl;
                }
              }

              print('All images are loaded into storage');

              for (var i = 0; i < prodImagesSqlDb.length; i++) {
                await FirebaseFirestore.instance.collection('ProdImages').add({
                  'prodDocId': _prodDocId,
                  'imageType': prodImagesSqlDb[i].imageType,
                  'imageUrl': prodImagesSqlDb[i].imageUrl,
                  'featuredImage':
                      prodImagesSqlDb[i].featuredImage == 'true' ? true : false,
                }).then(
                  (value) async {
                    if (prodImagesSqlDb[i].featuredImage == 'true' &&
                        prodImagesSqlDb[i].imageUrl.isNotEmpty) {
                      motorFormSqlDb.imageUrlFeatured =
                          prodImagesSqlDb[i].imageUrl;
                      _prodUpdated = 'Uncompleted';
                      print('update status 1 -- $_prodUpdated');
                      await _updateProdFeaturedImage(
                              _prodDocId, motorFormSqlDb.imageUrlFeatured)
                          .then(
                        (value) {
                          print('update status 21 -- $_prodUpdated');
                          _prodUpdated = value;
                        },
                      );
                      print('update status 2 -- $_prodUpdated');
                    }
                  },
                );
              }
            }
          },
        ).catchError(
          (onError) {
            print('Unable to post your add please try again!!');
          },
        );
      });
      // return _prodUpdated;
    } else {
      print('post check6');
      await FirebaseFirestore.instance.collection('products').add({
        'prodName': _prodName,
        'catName': motorFormSqlDb.catName,
        'subCatDocId': motorFormSqlDb.subCatDocId,
        'prodDes': motorFormSqlDb.prodDes,
        'sellerNotes': motorFormSqlDb.sellerNotes,
        'year': motorFormSqlDb.year,
        'make': motorFormSqlDb.make,
        'model': motorFormSqlDb.model,
        'prodCondition': motorFormSqlDb.prodCondition,
        'price': motorFormSqlDb.price,
        'currencyName': _currencyName,
        'currencySymbol': _currencySymbol,
        'imageUrlFeatured': motorFormSqlDb.imageUrlFeatured,
        'addressLocation': _addressLocation,
        'countryCode': _countryCode,
        'latitude': _latitude,
        'longitude': _longitude,
        'userDetailDocId': _userDetailDocId,
        'deliveryInfo': motorFormSqlDb.deliveryInfo,
        'distance': '',
        'status': 'Pending',
        'forSaleBy': motorFormSqlDb.forSaleBy,
        'listingStatus': 'Available',
        'createdAt': Timestamp.now(),
      }).then((p) async {
        print('post check7');
        print('check prod Image insert in storage');
        _prodDocId = p.id;

        if (_prodDocId.isNotEmpty) {
          for (var i = 0; i < prodImagesSqlDb.length; i++) {
            if (prodImagesSqlDb[i].imageUrl.substring(0, 5) != 'https') {
              final fileNameExt = prodImagesSqlDb[i].imageUrl.split('/').last;
              final fileName = fileNameExt.split('.').first;

              final ref = FirebaseStorage.instance
                  .ref()
                  .child(
                      'product_images/${user.uid}/${motorFormSqlDb.catName}/${motorFormSqlDb.make}')
                  .child(motorFormSqlDb.make +
                      motorFormSqlDb.model +
                      fileName +
                      '.jpg');

              print('check prod Image insert in storage1');

              await ref.putFile(File(prodImagesSqlDb[i].imageUrl));

              print('check prod Image insert in storage2');

              _imageUrl = await ref.getDownloadURL();

              prodImagesSqlDb[i].imageUrl = _imageUrl;
            }
          }

          print('All images are loaded into storage');

          for (var i = 0; i < prodImagesSqlDb.length; i++) {
            print('check prod Image insert in firebase');
            await FirebaseFirestore.instance.collection('ProdImages').add({
              'prodDocId': _prodDocId,
              'imageType': prodImagesSqlDb[i].imageType,
              'imageUrl': prodImagesSqlDb[i].imageUrl,
              'featuredImage':
                  prodImagesSqlDb[i].featuredImage == 'true' ? true : false,
            }).then((value) async {
              if (prodImagesSqlDb[i].featuredImage == 'true' &&
                  prodImagesSqlDb[i].imageUrl.isNotEmpty) {
                motorFormSqlDb.imageUrlFeatured = prodImagesSqlDb[i].imageUrl;
                _prodUpdated = 'Uncompleted';
                print('update status 1 -- $_prodUpdated');
                await _updateProdFeaturedImage(
                        _prodDocId, motorFormSqlDb.imageUrlFeatured)
                    .then(
                  (value) {
                    print('update status 21 -- $_prodUpdated');
                    _prodUpdated = value;
                  },
                );
                print('update status 2 -- $_prodUpdated');
              }
            });
          }
          // print('update status 30 -- $_prodUpdated');
          // return _prodUpdated;
        }
      }).catchError((onError) {
        print('Unable to post your add please try again!!');
      });
      // print('update status 31 -- $_prodUpdated');
      // return _prodUpdated;
    }
    print('update status 32 -- $_prodUpdated');
    return _prodUpdated;
  }

  Future<void> _deleteAndProcess() async {
    // _updateCategoryCount(true);
    print('check post 1****');
    await _deleteImageAll();
    print('check post 3****');
    await _deleteMotorFormAll().then((value) async {
      // _showPostDialog();
      print('check post 4****');
      if (_prodUpdated == 'Success') {
        print('check post 5****');
        // await _dropMotorForm();
        setState(() {
          _isUpdated = true;
        });
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (_) {
        //         return TabsScreen();
        //       },
        //       fullscreenDialog: true),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Post added successfully!'),
              action: SnackBarAction(
                label: 'Continue',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) {
                          return TabsScreen();
                        },
                        fullscreenDialog: true),
                  );
                },
              )),
        );
      }
      print('check post 6****');
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (_) {
      //         return TabsScreen();
      //       },
      //       fullscreenDialog: true),
      // );
    });
  }

  Future<void> _deleteProduct(String prodId, String category) async {
    print('delete product1');
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
          // return batch.commit().catchError((error) => print(
          //     "Failed to delete products in CtmSpecialInfo batch: $error"));
        }).catchError((error) =>
                print("Failed to get product in CtmSpecialInfo: $error"));
      }
      print('delete product2');
      await FirebaseFirestore.instance
          .collection('ProdImages')
          .where('prodDocId', isEqualTo: prodId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });
        //git check
        print('delete product3');
        return batch.commit().catchError((error) =>
            print("Failed to delete products in ProdImages: $error"));
      });
    }).catchError((error) => print("Failed to delete product: $error"));
  }

  Future<String> _updateProdFeaturedImage(
      String prodDocId, String featuredImageUrl) async {
    print('check update1 - $_prodUpdated');
    await FirebaseFirestore.instance
        .collection('products')
        .doc(prodDocId)
        .update(
      {
        'imageUrlFeatured': '$featuredImageUrl',
      },
    ).then(
      (value) {
        _prodUpdated = 'Success';
        print("Product Updated - $_prodUpdated");
      },
    ).catchError(
      (error) {
        print("Failed to update product: $error");
        _prodUpdated = 'Error';
      },
    ).whenComplete(
      () {
        print('update completed - $_prodUpdated');
      },
    );
    print('check update2 - $_prodUpdated');
    return _prodUpdated;
  }

  // Functions to operate prod images

  Future _saveImage(ProdImagesSqlDb prodImageSqlDb) async {
    await prodImageProvider.addImages(prodImageSqlDb);
    int countE = await prodImageProvider.countEProdImages();
    int countI = await prodImageProvider.countIProdImages();
    setState(() {
      _eImageCount = countE;
      _iImageCount = countI;
    });
  }

  Future _deleteImage(String id, String imageType) async {
    await prodImageProvider.deleteImages(id, imageType);

    int countE = await prodImageProvider.countEProdImages();
    int countI = await prodImageProvider.countIProdImages();
    int count = countE + countI;
    setState(() {
      _eImageCount = countE;
      _iImageCount = countI;
    });

    if (count == 0) {
      await _deleteMotorFormAll();
      await _initialLoadMotorForm();
    }
  }

  Future<void> _deleteImageAll() async {
    print('check delete ****');
    await Provider.of<ProdImagesSqlDbProvider>(context, listen: false)
        .deleteImagesAll();
  }

  // Functions to operate motor form data

  Future<void> _initialLoadMotorForm() async {
    int count = await motorFormProvider.countMotorForm();
    setState(() {
      _motorFormCount = count;
    });
    print('motor form count initial - $_motorFormCount');
    if (_motorFormCount > 0) {
      List<MotorFormSqlDb> motorFormSqlDbL =
          await motorFormProvider.fetchMotorForm();
      motorFormSqlDb = motorFormSqlDbL[0];

      // Asign values to the controllers
      if (motorFormSqlDb.catName.trim() == 'Car'.trim() ||
          motorFormSqlDb.catName.trim() == 'Truck'.trim()) {
        controllerEC.text = motorFormSqlDb.exteriorColor;
        controllerIC.text = motorFormSqlDb.interiorColor;
      } else if (motorFormSqlDb.catName.trim() == 'Motorbike'.trim()) {
        controllerEC.text = motorFormSqlDb.exteriorColor;
      }
    }
    // if (_motorFormCount == 0) {
    //   motorFormSqlDb = MotorFormSqlDb();
    // }
  }

  Future<void> _saveMotorForm(MotorFormSqlDb motorFormSqlDb) async {
    await motorFormProvider.addMotorForm(motorFormSqlDb);
    await _initialLoadMotorForm();
  }

  Future<void> _updateMotorForm(
      String id, String columnName, String columnValue) async {
    await motorFormProvider.updateMotorForm(id, columnName, columnValue);
    await _initialLoadMotorForm();
  }

  Future<void> _deleteMotorFormAll() async {
    await motorFormProvider.deleteMotorFormAll();
  }

  Future<void> _dropMotorForm() async {
    await motorFormProvider.dropMotorForm();
  }
}

class ModelItemsSearch extends SearchDelegate<String> {
  String selectedItem = "";
  @override
  List<Widget> buildActions(BuildContext context) {
    // throw UnimplementedError();
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // throw UnimplementedError();
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, selectedItem);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // throw UnimplementedError();
    return Center(
      child: Text(selectedItem),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // throw UnimplementedError();
    List<Model> models = Provider.of<List<Model>>(context);
    final myList = query.isEmpty
        ? models
        : models
            .where((p) => (p.model.toLowerCase()).contains(query.toLowerCase()))
            .toList();
    return myList.isEmpty
        ? Text('No search ')
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Model listItem = myList[index];
              selectedItem = myList[0].model;
              return ListTile(
                title: Text(listItem.model),
                onTap: () {
                  // selectedItem = listItem.title;
                  // Navigator.of(context).pushNamed(DetailScreen.routeName,
                  //     arguments: selectedItem);
                  // showResults(context);
                },
              );
            },
          );
  }
}
