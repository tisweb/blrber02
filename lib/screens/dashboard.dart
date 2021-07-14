//Imports for pubspec Packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

//Imports for pubspec Packages
import '../constants.dart';

//Imports for Models
import '../models/category.dart';
import '../models/product.dart';

class Dashboard extends StatefulWidget {
  final String adminUserPermission;
  const Dashboard({Key key, this.adminUserPermission}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _categoryFormKey = GlobalKey<FormState>();
  final _subCategoryFormKey = GlobalKey<FormState>();
  final _makeFormKey = GlobalKey<FormState>();
  final _modelFormKey = GlobalKey<FormState>();

  bool _addCategory = false;
  bool _addSubCategory = false;
  bool _addMake = false;
  bool _addModel = false;
  String _modifyCategory = '';
  String _modifySubCategory = '';
  String _modifyMake = '';
  String _modifyModel = '';
  Category category = Category();
  Make make = Make();
  Model model = Model();
  SubCategory subCategory = SubCategory();
  List<SubCategory> subCategories = [];
  List<Category> categories = [];
  List<Make> makes = [];
  List<Model> models = [];
  File pickedImage, pickedImageCompressed;
  String _imageUrl = "";
  List<DropdownMenuItem<String>> _catNames, _subCatNames, _makes = [];
  bool _searchableValidate = true;
  var _initialSelectedItem = 'Unspecified';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categories = Provider.of<List<Category>>(context);
    subCategories = Provider.of<List<SubCategory>>(context);
    makes = Provider.of<List<Make>>(context);
    models = Provider.of<List<Model>>(context);
    if (categories != null) {
      _catNames = [];
      _catNames.add(
        DropdownMenuItem(
          value: _initialSelectedItem,
          child: Text(_initialSelectedItem),
        ),
      );

      for (Category catName in categories) {
        _catNames.add(
          DropdownMenuItem(
            value: catName.catName,
            child: Text(catName.catName),
          ),
        );
      }
    }
    if (subCategories != null) {
      _subCatNames = [];
      _subCatNames.add(
        DropdownMenuItem(
          value: _initialSelectedItem,
          child: Text(_initialSelectedItem),
        ),
      );

      for (SubCategory subCatName in subCategories) {
        _subCatNames.add(
          DropdownMenuItem(
            value: subCatName.subCatType,
            child: Text(subCatName.subCatType),
          ),
        );
      }
    }

    if (makes != null) {
      _makes = [];
      _makes.add(
        DropdownMenuItem(
          value: _initialSelectedItem,
          child: Text(_initialSelectedItem),
        ),
      );

      for (Make make in makes) {
        _makes.add(
          DropdownMenuItem(
            value: make.make,
            child: Text(make.make),
          ),
        );
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _submitCategory() async {
    final isValid = _categoryFormKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _categoryFormKey.currentState.save();
      _showAddCategoryDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter Mandatory Fields!'),
        ),
      );
    }
  }

  Future<void> _submitSubCategory() async {
    final isValid = _subCategoryFormKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _subCategoryFormKey.currentState.save();
      _showAddSubCategoryDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter Mandatory Fields!'),
        ),
      );
    }
  }

  Future<void> _submitMake() async {
    final isValid = _makeFormKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _makeFormKey.currentState.save();
      _showAddMakeDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter Mandatory Fields!'),
        ),
      );
    }
  }

  Future<void> _submitModel() async {
    final isValid = _modelFormKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _modelFormKey.currentState.save();
      _showAddModelDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter Mandatory Fields!'),
        ),
      );
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add Category"),
              content: Container(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _modifyCategory == ''
                          ? const Text(
                              'Do you want to add Category?',
                              style: TextStyle(color: Colors.blue),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  bScaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                if (_modifyCategory == '')
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                if (_modifyCategory == '')
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      setState(() {
                        _modifyCategory = 'Start';
                      });

                      _modifyCategoryRecord().then((value) {
                        Navigator.of(context).pop();
                        if (_modifyCategory == 'Success') {
                          // setState(() {
                          _modifyCategory = '';
                          // });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Category Added Successfully!'),
                            ),
                          );
                        }
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddSubCategoryDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add Sub Category"),
              content: Container(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _modifySubCategory == ''
                          ? const Text(
                              'Do you want to add Sub Category?',
                              style: TextStyle(color: Colors.blue),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  bScaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                if (_modifySubCategory == '')
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                if (_modifySubCategory == '')
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      setState(() {
                        _modifySubCategory = 'Start';
                      });

                      _modifySubCategoryRecord().then((value) {
                        Navigator.of(context).pop();
                        if (_modifySubCategory == 'Success') {
                          // setState(() {
                          _modifySubCategory = '';
                          // });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sub Category Added Successfully!'),
                            ),
                          );
                        }
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddMakeDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add Make"),
              content: Container(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _modifyMake == ''
                          ? const Text(
                              'Do you want to add Make?',
                              style: TextStyle(color: Colors.blue),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  bScaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                if (_modifyMake == '')
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                if (_modifyMake == '')
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      setState(() {
                        _modifyMake = 'Start';
                      });

                      _modifyMakeRecord().then((value) {
                        Navigator.of(context).pop();
                        if (_modifyMake == 'Success') {
                          // setState(() {
                          _modifyMake = '';
                          // });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Make Added Successfully!'),
                            ),
                          );
                        }
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddModelDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add Model"),
              content: Container(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _modifyModel == ''
                          ? Text(
                              'Do you want to add Model?',
                              style: TextStyle(color: Colors.blue),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  bScaffoldBackgroundColor),
                              backgroundColor: bPrimaryColor,
                            ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                if (_modifyModel == '')
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                if (_modifyModel == '')
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      setState(() {
                        _modifyModel = 'Start';
                      });

                      _modifyModelRecord().then((value) {
                        Navigator.of(context).pop();
                        if (_modifyModel == 'Success') {
                          // setState(() {
                          _modifyModel = '';
                          // });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Model Added Successfully!'),
                            ),
                          );
                        }
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _modifyCategoryRecord() async {
    if (pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('category_images')
          .child(category.catName + '_' + 'category' + '.jpg');

      await ref.putFile(pickedImage);

      _imageUrl = await ref.getDownloadURL();

      category.imageUrl = _imageUrl;
    }

    await FirebaseFirestore.instance.collection('categories').add({
      'catName': category.catName,
      'iconValue': category.iconValue,
      'imageUrl': category.imageUrl,
    }).then((value) {
      print("Category Added");
      setState(() {
        _modifyCategory = "Success";
        category = Category();
      });
    }).catchError((error) => print("Failed to add category: $error"));
  }

  Future<void> _modifySubCategoryRecord() async {
    if (pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('sub_category_images')
          .child(subCategory.subCatType + '_' + 'sub_category' + '.jpg');

      await ref.putFile(pickedImage);

      _imageUrl = await ref.getDownloadURL();

      subCategory.imageUrl = _imageUrl;
    }

    await FirebaseFirestore.instance.collection('subCategories').add({
      'catName': subCategory.catName,
      'imageUrl': subCategory.imageUrl,
      'subCatType': subCategory.subCatType,
    }).then((value) {
      print("Sub Category Added");
      setState(() {
        _modifySubCategory = "Success";
        subCategory = SubCategory();
      });
    }).catchError((error) => print("Failed to add sub category: $error"));
  }

  Future<void> _modifyMakeRecord() async {
    await FirebaseFirestore.instance.collection('makes').add({
      'make': make.make,
      'subCatType': make.subCatType,
    }).then((value) {
      print("Make Added");
      setState(() {
        _modifyMake = "Success";
        print("make before - ${make.make}");
        make = Make();
        print("make after - ${make.make}");
      });
    }).catchError((error) => print("Failed to add make: $error"));
  }

  Future<void> _modifyModelRecord() async {
    await FirebaseFirestore.instance.collection('models').add({
      'make': model.make,
      'model': model.model,
      'subCatType': model.subCatType,
    }).then((value) {
      print("Model Added");
      setState(() {
        _modifyModel = "Success";
        model = Model();
      });
    }).catchError((error) => print("Failed to add model: $error"));
  }

  Future _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return null;
    }

    pickedImage = File(imageFile.path);
    pickedImageCompressed = await compressFile(pickedImage);

    setState(() {
      pickedImage = pickedImageCompressed;
    });
  }

  Future<File> compressFile(File file) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(file.path);
    File compressedFile;
    if (properties.width > 200 || properties.height > 200) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        targetWidth: 200,
        targetHeight: 200,
        quality: 100,
      );
      return compressedFile;
    } else if (properties.width > 200 && properties.height <= 200) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        targetWidth: 200,
        targetHeight: properties.height,
        quality: 100,
      );
      return compressedFile;
    } else if (properties.width <= 200 && properties.height > 200) {
      compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        targetWidth: properties.width,
        targetHeight: 200,
        quality: 100,
      );
      return compressedFile;
    } else {
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        leading: Row(
          children: [
            Expanded(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey[300],
              child: ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _addCategory = true;
                        _addSubCategory = false;
                        _addMake = false;
                        _addModel = false;
                      });
                    },
                    child: const Text("Add Category"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _addSubCategory = true;
                        _addCategory = false;
                        _addMake = false;
                        _addModel = false;
                      });
                    },
                    child: const Text("Add Sub Category"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _addMake = true;
                        _addSubCategory = false;
                        _addCategory = false;
                        _addModel = false;
                      });
                    },
                    child: const Text("Add Make"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _addModel = true;
                        _addMake = false;
                        _addSubCategory = false;
                        _addCategory = false;
                      });
                    },
                    child: const Text("Add Model"),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 20,
              color: Colors.green,
            ),
            if (_addCategory)
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _categoryFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: ValueKey('catName'),
                          onEditingComplete: () => focusNode.nextFocus(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Category';
                            } else if (categories != null) {
                              if (categories.any((e) =>
                                  e.catName.toLowerCase().trim() ==
                                  value.toLowerCase().trim())) {
                                return "Category already registered";
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Category'),
                          onSaved: (value) {
                            category.catName = value;
                          },
                        ),
                        Row(
                          children: [
                            const Text("Category Image"),
                            Stack(
                              children: [
                                CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImage != null
                                        ? FileImage(pickedImage)
                                        : AssetImage(
                                            'assets/images/default_user_image.png')),
                                Positioned(
                                  bottom: -10,
                                  right: -10,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera),
                                    onPressed: () async {
                                      await _pickImage();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          key: ValueKey('iconValue'),
                          keyboardType: TextInputType.number,
                          onEditingComplete: () => focusNode.nextFocus(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter iconValue';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Icon Value'),
                          onSaved: (value) {
                            category.iconValue = int.parse(value);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueGrey[700],
                            ),
                          ),
                          onPressed: () async {
                            await _submitCategory();
                          },
                          icon: const Icon(Icons.add_box),
                          label: const Text('Category'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            if (_addSubCategory)
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _subCategoryFormKey,
                    child: Column(
                      children: [
                        Container(
                          color: bScaffoldBackgroundColor,
                          child: SearchableDropdown.single(
                            items: _catNames,
                            hint: "Select Category",
                            searchHint: "Select Category",
                            onChanged: (value) async {
                              setState(() {
                                subCategory.catName = value;
                              });
                            },
                            validator: (value) {
                              if (value == 'Unspecified') {
                                _searchableValidate = false;
                                return 'Please select category! - $value';
                              }
                              _searchableValidate = true;
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        TextFormField(
                          key: ValueKey('subCatType'),
                          onEditingComplete: () => focusNode.nextFocus(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Sub Category';
                            } else if (subCategories != null) {
                              if (subCategories.any((e) =>
                                  e.subCatType.toLowerCase().trim() ==
                                      value.toLowerCase().trim() &&
                                  e.catName.toLowerCase().trim() ==
                                      subCategory.catName
                                          .toLowerCase()
                                          .trim())) {
                                return "Sub Category already registered";
                              }
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Sub Category'),
                          onSaved: (value) {
                            subCategory.subCatType = value;
                          },
                        ),
                        Row(
                          children: [
                            const Text("Sub Category Image"),
                            Stack(
                              children: [
                                CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: pickedImage != null
                                        ? FileImage(pickedImage)
                                        : AssetImage(
                                            'assets/images/default_user_image.png')),
                                Positioned(
                                  bottom: -10,
                                  right: -10,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera),
                                    onPressed: () async {
                                      await _pickImage();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueGrey[700],
                            ),
                          ),
                          onPressed: () async {
                            await _submitSubCategory();
                          },
                          icon: Icon(Icons.add_box),
                          label: const Text('SubCategory'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            // Make
            if (_addMake)
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _makeFormKey,
                    child: Column(
                      children: [
                        Container(
                          color: bScaffoldBackgroundColor,
                          child: SearchableDropdown.single(
                            items: _subCatNames,
                            hint: "Select Sub Category",
                            searchHint: "Select Sub Category",
                            onChanged: (value) async {
                              setState(() {
                                make.subCatType = value;
                              });
                            },
                            validator: (value) {
                              if (value == 'Unspecified') {
                                _searchableValidate = false;
                                return 'Please select Sub Category! - $value';
                              }
                              _searchableValidate = true;
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        TextFormField(
                          key: ValueKey('make'),
                          onEditingComplete: () => focusNode.nextFocus(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Make';
                            } else if (makes != null) {
                              if (makes.any((e) =>
                                  e.make.toLowerCase().trim() ==
                                      value.toLowerCase().trim() &&
                                  e.subCatType == make.subCatType)) {
                                return "Make already registered";
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Make'),
                          onSaved: (value) {
                            make.make = value;
                          },
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueGrey[700],
                            ),
                          ),
                          onPressed: () async {
                            await _submitMake();
                          },
                          icon: const Icon(Icons.add_box),
                          label: const Text('Make'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            // Model
            if (_addModel)
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _modelFormKey,
                    child: Column(
                      children: [
                        Container(
                          color: bScaffoldBackgroundColor,
                          child: SearchableDropdown.single(
                            items: _subCatNames,
                            hint: "Select Sub Category",
                            searchHint: "Select Sub Category",
                            onChanged: (value) async {
                              setState(() {
                                model.subCatType = value;
                              });
                            },
                            validator: (value) {
                              if (value == 'Unspecified') {
                                _searchableValidate = false;
                                return 'Please select sub Category! - $value';
                              }
                              _searchableValidate = true;
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        Container(
                          color: bScaffoldBackgroundColor,
                          child: SearchableDropdown.single(
                            items: _makes,
                            hint: "Select make",
                            searchHint: "Select make",
                            onChanged: (value) async {
                              setState(() {
                                model.make = value;
                              });
                            },
                            validator: (value) {
                              if (value == 'Unspecified') {
                                _searchableValidate = false;
                                return 'Please select make! - $value';
                              }
                              _searchableValidate = true;
                              return null;
                            },
                            isExpanded: true,
                          ),
                        ),
                        TextFormField(
                          key: ValueKey('model'),
                          onEditingComplete: () => focusNode.nextFocus(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Model';
                            } else if (models != null) {
                              if (models.any((e) =>
                                  e.model.toLowerCase().trim() ==
                                      value.toLowerCase().trim() &&
                                  e.subCatType == model.subCatType &&
                                  e.make == model.make)) {
                                return "Model already registered";
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Model'),
                          onSaved: (value) {
                            model.model = value;
                          },
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueGrey[700],
                            ),
                          ),
                          onPressed: () async {
                            await _submitModel();
                          },
                          icon: const Icon(Icons.add_box),
                          label: const Text('Model'),
                        )
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
