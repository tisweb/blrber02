//Imports for pubspec Packages
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Imports for Models
import '../constants.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/user_detail.dart';

// Imports for maps/location
import '../provider/get_current_location.dart';

// Imports for Widgets
import '../widgets/display_product_grid.dart';

// Imports for Screens
import '../screens/product_detail_screen.dart';
import '../screens/search_results.dart';

// Imports for Services
import '../services/connectivity.dart';
import '../services/load_mlmodel.dart';

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

  String _displayType = "Category";
  List _output;
  String imageLabel = "";
  bool status = false;

  String _countryCode = "";
  bool _dataLoaded = false;
  bool _connectionStatus = false;

  File pickedImage;

  TabController _tabController;

  List<Category> categoryList = [];
  List<Product> products = [];
  GetCurrentLocation getCurrentLocation = GetCurrentLocation();

  @override
  void initState() {
    isInitState = true;
    _checkConnectivity();
    print("Connectivity after ");
    // getCurrentLocation =
    //     Provider.of<GetCurrentLocation>(context, listen: false);
    // getCurrentLocation.getCurrentPosition();

    // LoadMlModel.loadModel();

    super.initState();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(imageFile.path);
    });

    if (pickedImage != null) {
      // runModelOnImage(); It is to run ml on tflite model
      var prodName = await findLabels(
          pickedImage); // It is to run ml on firebase ml vision

      if (prodName != "") {
        Navigator.of(context)
            .pushNamed(SearchResults.routeName, arguments: prodName);
      }
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
          imageLabel.split(",")[0] + " " + imageLabel.split(",")[1];

      print('image labels  out- $imageLabelOut');

      if (imageLabelOut != "") {
        Navigator.of(context)
            .pushNamed(SearchResults.routeName, arguments: imageLabelOut);
      }
    });
  }

  Future<String> findLabels(File _image) async {
    List<ImageLabelInfo> _imageLabels = [];
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(_image);

    final ImageLabeler labeler = GoogleVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.80));

    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      ImageLabelInfo _imageLabel = ImageLabelInfo();
      _imageLabel.imageLabel = label.text;
      _imageLabel.confidence = label.confidence;

      print(
          '_imageLabels info - ${_imageLabel.imageLabel} , ${_imageLabel.confidence}');
      _imageLabels.add(_imageLabel);
    }

    if (_imageLabels.length > 0) {
      _imageLabels.sort((a, b) {
        var aConfidence = a.confidence;
        var bConfidence = b.confidence;
        return aConfidence.compareTo(bConfidence);
      });
    }

    print('_imageLabels length - ${_imageLabels.length}');

    return _imageLabels[_imageLabels.length - 1].imageLabel;
  }

  @override
  void didChangeDependencies() async {
    if (_connectionStatus) {
      _initialGetInfo();
    }
    super.didChangeDependencies();
  }

  void _initialGetInfo() {
    getCurrentLocation = Provider.of<GetCurrentLocation>(context);

    if (getCurrentLocation.latitude != 0.0) {
      setState(() {
        _dataLoaded = true;
      });
    }

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
          }
        }
      }
    }
  }

  _checkConnectivity() async {
    var connectivityStatus = await ConnectivityCheck.connectivity();
    if (connectivityStatus == "WifiInternet" ||
        connectivityStatus == "MobileInternet") {
      getCurrentLocation =
          Provider.of<GetCurrentLocation>(context, listen: false);
      getCurrentLocation.getCurrentPosition();

      LoadMlModel.loadModel();
      setState(() {
        _connectionStatus = true;
      });
    } else {
      _connectionStatus = false;
    }
    print("Connectivity Status = ${connectivityStatus}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appBarRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Container(
            height: (MediaQuery.of(context).size.height) / 19,
            decoration: BoxDecoration(
                color: bBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                  ),
                ]),
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
                      color: bDisabledColor,
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
                      color: bDisabledColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 5),
            child: Flag(
                _countryCode.isEmpty
                    ? getCurrentLocation.countryCode
                    : _countryCode,
                height: 25,
                fit: BoxFit.fill),
          ),
        ),
      ],
    );

    final _pageBody = SafeArea(
      child: _dataLoaded
          ? Column(
              children: [
                Expanded(
                  flex: 10,
                  child: TabBarView(
                    controller: _tabController,
                    children:
                        List<Widget>.generate(categoryList.length, (index) {
                      return getCurrentLocation.addressLocation != ''
                          ? Column(
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    child: DisplayProductGrid(
                                      inCatName: categoryList[index].catName,
                                      inProdCondition: "",
                                      inDisplayType: _displayType,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                children: [
                                  Text("Something went wrong!"),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      child: Text('Refresh'))
                                ],
                              ),
                            );
                    }),
                  ),
                ),
              ],
            )
          : Center(
              child:
                  // CupertinoActivityIndicator(),
                  CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).scaffoldBackgroundColor),
                backgroundColor: bPrimaryColor,
              ),
            ),
    );
    final _appBar = AppBar(
      backgroundColor: bBackgroundColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: bDisabledColor),
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
        indicatorColor: bPrimaryColor,
        labelColor: bPrimaryColor,
        unselectedLabelColor: bDisabledColor,
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
  bool _isListening = false;

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

  void _showListenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Text("Name of the product"),
                    ),
                    Expanded(
                      child: AvatarGlow(
                        animate: _isListening,
                        glowColor: bPrimaryColor,
                        endRadius: 75.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          backgroundColor: bPrimaryColor,
                          onPressed: () async {
                            // _listen(context);
                            print('check 1 - $_isListening');
                            if (!_isListening) {
                              print('check 2 - $_isListening');
                              available = await _speech.initialize(
                                onStatus: (val) {
                                  print('onStatus: $val');
                                },
                                onError: (val) {
                                  print('onErrorss: $val');
                                },
                              );
                              print('check 3 - $_isListening - $available');
                              if (available) {
                                setState(() {
                                  _isListening = true;
                                });
                                print("checking1");
                                _speech.listen(
                                  onResult: (val) {
                                    print("checking2 - ${val.confidence}");
                                    _text = val.recognizedWords;

                                    _listeningState = val.finalResult;

                                    if (val.hasConfidenceRating &&
                                        val.confidence > 0) {
                                      _confidence = val.confidence;
                                    }

                                    if (_listeningState == true) {
                                      setState(() {
                                        query = _text;

                                        _isListening = false;
                                      });

                                      print("checking audio1 - $query");
                                      // Future.delayed(Duration(seconds: 1), () {
                                      Navigator.of(context).pop();

                                      Navigator.of(context).pushNamed(
                                          SearchResults.routeName,
                                          arguments: query);
                                      // });
                                    }
                                  },
                                );
                              }
                            } else {
                              setState(() {
                                _isListening = false;
                              });
                              _speech.stop();
                            }
                          },
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Text(query))
                  ],
                ),
              ),
              actions: <Widget>[],
            );
          },
        );
      },
    );
  }

  void _listen(BuildContext context) async {
    if (!_isListening) {
      available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
        },
        onError: (val) {
          print('onError: $val');
        },
      );
      if (available) {
        _speech.listen(onResult: (val) {
          _text = val.recognizedWords;

          _listeningState = val.finalResult;

          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }

          if (_listeningState == true) {
            query = _text;
            print("checking audio - $query");
            Navigator.of(context)
                .pushNamed(SearchResults.routeName, arguments: query);
          } else {}
        });
      }
    }
  }

  Future<String> _pickImageS() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);
    pickedImage = File(imageFile.path);

    if (pickedImage != null) {
      // prodName = await runModelOnImageS(); // It is to run with tflite model
      prodName = await findLabels(
          pickedImage); // It is to run with google ml vision model
    }
    return prodName;
  }

  Future<String> findLabels(File _image) async {
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
    }

    if (_imageLabels.length > 0) {
      _imageLabels.sort((a, b) {
        var aConfidence = a.confidence;
        var bConfidence = b.confidence;
        return aConfidence.compareTo(bConfidence);
      });
    }

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

    var imageLabelOut =
        imageLabelS.split(" ")[1] + " " + imageLabelS.split(" ")[2];

    return imageLabelOut;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
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
                _initSpeech();
                // _speech = stt.SpeechToText();

                // _listen(context);
                _showListenDialog(context);
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
            (p.prodName.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()) ||
            (p.catName.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()) ||
            (p.subCatType.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()) ||
            (p.prodDes.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()) ||
            (p.sellerNotes.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()) ||
            (p.make.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()) ||
            (p.model.toLowerCase().trim())
                .contains(selectedItem.toLowerCase().trim()))
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
                          child: CupertinoActivityIndicator(),
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
                (p.prodName.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()) ||
                (p.catName.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()) ||
                (p.subCatType.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()) ||
                (p.prodDes.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()) ||
                (p.sellerNotes.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()) ||
                (p.make.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()) ||
                (p.model.toLowerCase().trim())
                    .contains(query.toLowerCase().trim()))
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
