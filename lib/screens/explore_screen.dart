import 'dart:io';

import 'package:blrber/models/user_detail.dart';
import 'package:blrber/screens/motor_filter_screen.dart';
import 'package:blrber/screens/search_results.dart';
import 'package:blrber/services/load_mlmodel.dart';
import 'package:blrber/widgets/display_product_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_switch/flutter_switch.dart';

// Imports for models
import '../models/category.dart';
import '../models/product.dart';

// Imports for maps/location
import '../provider/get_current_location.dart';

// Imports for widgets
import '../widgets/display_product_grid.dart';

// Imports for screens
import '../screens/product_detail_screen.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore-screen';

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class ImageLabelInfo {
  String imageLabel;
  double confidence;

  ImageLabelInfo({
    this.imageLabel,
    this.confidence,
  });
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isInitState = false;
  String _prodCondition = "Used";
  String _displayType = "Category";
  List _output;
  String imageLabel = "";
  bool status = false;
  // String _catName = "";
  String _countryCode = "";
  bool _dataLoaded = false;

  File pickedImage;

  TabController _tabController;
  List<Category> categoryList = [];
  List<Product> products = [];
  GetCurrentLocation getCurrentLocation = GetCurrentLocation();

  @override
  void initState() {
    isInitState = true;
    getCurrentLocation =
        Provider.of<GetCurrentLocation>(context, listen: false);
    getCurrentLocation.getCurrentPosition();
    print('check loc1 init - ${getCurrentLocation.latitude}');

    super.initState();
    LoadMlModel.loadModel();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(imageFile.path);
      print('picked image - $pickedImage');
    });

    if (pickedImage != null) {
      runModelOnImage();
    }
  }

  runModelOnImage() async {
    var output = await Tflite.runModelOnImage(
      path: pickedImage.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      threshold: 0.8,
    );

    setState(() {
      _output = output;
      imageLabel = _output[0]["label"];

      var imageLabelOut =
          imageLabel.split(" ")[1] + " " + imageLabel.split(" ")[2];

      print('image labels  out- $imageLabelOut');

      if (imageLabelOut != "") {
        Navigator.of(context)
            .pushNamed(SearchResults.routeName, arguments: imageLabelOut);
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // getCurrentLocation = Provider.of<GetCurrentLocation>(context);
  //   // print('check loc1 - ${getCurrentLocation.latitude}');

  //   // getCurrentLocation.getCurrentPosition();

  //   // print('check loc2 - ${getCurrentLocation.latitude}');
  //   // _setBuyingCountryCode();
  //   // final categories = Provider.of<List<Category>>(context);
  //   // products = Provider.of<List<Product>>(context);

  //   // if (_countryCode.isEmpty) {
  //   //   _countryCode = getCurrentLocation.countryCode;
  //   // }

  //   // if (products != null) {
  //   //   products = products
  //   //       .where((e) =>
  //   //           e.status == 'Verified' &&
  //   //           e.listingStatus == 'Available' &&
  //   //           e.countryCode == _countryCode)
  //   //       .toList();
  //   // }

  //   // categoryList = [];
  //   // for (var i = 0; i < categories.length; i++) {
  //   //   var cnt = products
  //   //       .where((e) =>
  //   //           e.catName.trim().toLowerCase() ==
  //   //           categories[i].catName.trim().toLowerCase())
  //   //       .toList()
  //   //       .length;
  //   //   if (cnt > 0) {
  //   //     categoryList.add(categories[i]);
  //   //   }
  //   // }

  //   _initialGetInfo();

  //   super.didChangeDependencies();
  // }

  @override
  void didChangeDependencies() {
    print('check loc1 - did change');
    _initialGetInfo();
    super.didChangeDependencies();
  }

  void _initialGetInfo() {
    getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    print('check loc1 - ${getCurrentLocation.latitude}');

    if (getCurrentLocation.latitude != 0.0) {
      setState(() {
        print('data is available for the app');
        _dataLoaded = true;
      });
    }

    // getCurrentLocation.getCurrentPosition();

    print('check loc2 - ${getCurrentLocation.latitude}');
    _setBuyingCountryCode();
    final categories = Provider.of<List<Category>>(context);
    products = Provider.of<List<Product>>(context);

    if (_countryCode.isEmpty) {
      _countryCode = getCurrentLocation.countryCode;
    }

    if (products.length > 0) {
      products = products
          .where((e) =>
              e.status == 'Verified' &&
              e.listingStatus == 'Available' &&
              e.countryCode == _countryCode)
          .toList();
    }

    categoryList = [];
    for (var i = 0; i < categories.length; i++) {
      var cnt = products
          .where((e) =>
              e.catName.trim().toLowerCase() ==
              categories[i].catName.trim().toLowerCase())
          .toList()
          .length;
      if (cnt > 0) {
        categoryList.add(categories[i]);
      }
    }
  }

  void _setBuyingCountryCode() {
    final user = FirebaseAuth.instance.currentUser;
    _countryCode = "";
    if (user != null) {
      final List<UserDetail> userDetails =
          Provider.of<List<UserDetail>>(context);
      if (userDetails != null) {
        if (userDetails.length > 0) {
          var userData = userDetails
              .where((e) => e.userDetailDocId.trim() == user.uid.trim())
              .toList();
          if (userData.length > 0) {
            if (userData[0].buyingCountryCode != null) {
              _countryCode = userData[0].buyingCountryCode;
            }
            print('userupdate - explore');
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('check loc1 - new explore');
    print('userupdate - explore widget');
    final _appBarRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 9,
          child: Container(
            height: (MediaQuery.of(context).size.height) / 17,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: ItemsSearch(products: products),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      _pickImage();
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Flag(
              _countryCode.isEmpty
                  ? getCurrentLocation.countryCode
                  : _countryCode,
              height: 25,
              fit: BoxFit.fill),
        ),
      ],
    );
    final _pageBody = SafeArea(
      child: _dataLoaded
          ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: FlutterSwitch(
                              width: MediaQuery.of(context).size.width / 5,
                              activeColor: Theme.of(context).primaryColor,
                              inactiveColor: Theme.of(context).primaryColor,
                              activeText: 'New',
                              inactiveText: 'Used',
                              value: status,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  status = val;
                                  if (status == true) {
                                    _prodCondition = 'New';
                                  } else {
                                    _prodCondition = 'Used';
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) {
                                          return MotorFilterScreen();
                                        },
                                        fullscreenDialog: true),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        CupertinoIcons.slider_horizontal_3,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 10,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Filters',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: TabBarView(
                    controller: _tabController,
                    children:
                        List<Widget>.generate(categoryList.length, (index) {
                      // setState(() {
                      //   _catName = categoryList[index].catName;
                      // });
                      return getCurrentLocation.addressLocation != ''
                          ? Container(
                              child: DisplayProductGrid(
                                inCatName: categoryList[index].catName,
                                inProdCondition: _prodCondition,
                                inDisplayType: _displayType,
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    }),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
    final _appBar = AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Theme.of(context).disabledColor),
      title: _appBarRow,
      bottom: TabBar(
        controller: _tabController,
        tabs: List<Widget>.generate(categoryList.length, (index) {
          return Tab(
            text: categoryList[index].catName,
            icon: Icon(
              IconData(categoryList[index].iconValue,
                  fontFamily: 'IconFont', fontPackage: 'line_awesome_icons'),
            ),
          );
        }),
        isScrollable: true,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).disabledColor,
      ),
    );

    return DefaultTabController(
      length: categoryList.length,
      child: Scaffold(
        appBar: _appBar,
        body: _pageBody,
      ),
    );
  }
}

class ItemsSearch extends SearchDelegate<String> {
  String selectedItem = "";
  File pickedImage;
  String imageLabelS = '';
  String prodName;

  List<Product> products;

  ItemsSearch({this.products});

  stt.SpeechToText _speech;

  bool _listeningState = false;
  String _text = '';
  double _confidence = 1.0;
  bool available = false;

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    print('Listen function called!');
    available = await _speech.initialize(
      onStatus: (val) {
        print('onStatus: $val');
      },
      onError: (val) {
        print('onError: $val');
      },
    );
  }

  void _listen(BuildContext context) {
    if (available) {
      _speech.listen(onResult: (val) {
        _text = val.recognizedWords;
        _listeningState = val.finalResult;

        if (val.hasConfidenceRating && val.confidence > 0) {
          _confidence = val.confidence;
        }

        if (_listeningState == true) {
          query = _text;
          Navigator.of(context)
              .pushNamed(SearchResults.routeName, arguments: query);
        }
      });
    }
  }

  Future<String> _pickImageS() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);
    pickedImage = File(imageFile.path);

    if (pickedImage != null) {
      prodName = await runModelOnImageS(); // It is run with tflite model
      // prodName = await findLabels(
      //     pickedImage); // It is run with google ml vision model
    }
    return prodName;
  }

  Future<String> findLabels(File _image) async {
    print('image labeling1');
    List<ImageLabelInfo> _imageLabels = [];
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(_image);

    final ImageLabeler labeler = GoogleVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.80));

    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      ImageLabelInfo _imageLabel = ImageLabelInfo();
      _imageLabel.imageLabel = label.text;
      _imageLabel.confidence = label.confidence;

      _imageLabels.add(_imageLabel);

      print('image label : ${_imageLabel.imageLabel}, ${label.confidence}');
    }

    if (_imageLabels.length > 0) {
      _imageLabels.sort((a, b) {
        var aConfidence = a.confidence;
        var bConfidence = b.confidence;
        return aConfidence.compareTo(bConfidence);
      });
    }

    print(
        'image label last: ${_imageLabels[_imageLabels.length - 1].imageLabel}');

    return _imageLabels[_imageLabels.length - 1].imageLabel;
  }

  Future<String> runModelOnImageS() async {
    var output = await Tflite.runModelOnImage(
      path: pickedImage.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      threshold: 0.8,
    );

    imageLabelS = output[0]["label"];
    print('image labels - $imageLabelS');

    var imageLabelOut =
        imageLabelS.split(" ")[1] + " " + imageLabelS.split(" ")[2];

    print('image labels  out- $imageLabelOut');
    return imageLabelOut;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    _initSpeech();
    return [
      query != ""
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = "";
              },
            )
          : IconButton(
              icon: Icon(Icons.mic),
              onPressed: () {
                _listen(context);
              },
            ),
      IconButton(
        icon: Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          var prodNameS = await _pickImageS();
          query = prodNameS;
          Navigator.of(context)
              .pushNamed(SearchResults.routeName, arguments: query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        close(context, selectedItem);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final prodList = products
        .where((p) =>
            (p.prodName.toLowerCase()).contains(selectedItem.toLowerCase()) ||
            (p.catName.toLowerCase()).contains(selectedItem.toLowerCase()))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: prodList.length,
      itemBuilder: (BuildContext context, int j) {
        return Column(
          children: [
            Expanded(
              flex: 9,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                      arguments: prodList[j].prodDocId);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: prodList[j].imageUrlFeatured != null
                      ? Image(
                          image: NetworkImage(
                            prodList[j].imageUrlFeatured,
                          ),
                          fit: BoxFit.fill,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ),
            Expanded(flex: 2, child: Text(prodList[j].prodName)),
          ],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? []
        : products
            .where((p) =>
                (p.prodName.toLowerCase()).contains(query.toLowerCase()) ||
                (p.catName.toLowerCase()).contains(query.toLowerCase()))
            .toList();
    return myList.isEmpty
        ? Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text('Search Items...'))
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Product listItem = myList[index];
              selectedItem = myList[0].prodName;
              return ListTile(
                title: Row(
                  children: [
                    Text(listItem.prodName),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          selectedItem = listItem.catName;
                          showResults(context);
                        },
                        child: Text(listItem.catName))
                  ],
                ),
                onTap: () {
                  selectedItem = listItem.prodName;

                  showResults(context);
                },
              );
            },
          );
  }
}
