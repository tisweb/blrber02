//Imports for pubspec packages
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Screens
import './view_photos.dart';

//Imports for Models
import '../models/product.dart';

class Photos extends StatefulWidget {
  final int crossAxisCount;
  final List<ProdImages> imageList;
  const Photos({Key key, this.crossAxisCount = 1, this.imageList});

  static const MethodChannel _channel = const MethodChannel('gallery_view');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  String _imageType = "";
  bool _imageTypeChange = false;
  @override
  Widget build(BuildContext context) {
    List<ProdImages> prodImages = widget.imageList;
    List<ProdImages> prodImagesgroup = [];
    List<ProdImages> prodImagesE = [];
    List<ProdImages> prodImagesI = [];
    if (prodImages != null) {
      prodImagesE = prodImages.where((e) => e.imageType.trim() == "E").toList();

      prodImagesI = prodImages.where((e) => e.imageType.trim() == "I").toList();
    }
    prodImagesgroup = prodImagesE + prodImagesI;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      backgroundColor: bBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 5,
                    ),
                shrinkWrap: true,
                itemCount: prodImagesgroup.length,
                itemBuilder: (context, index) {
                  if (_imageType != prodImagesgroup[index].imageType) {
                    _imageType = prodImagesgroup[index].imageType;
                    _imageTypeChange = true;
                  } else {
                    _imageTypeChange = false;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (_imageType == 'E' && _imageTypeChange)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Exterior (${prodImagesE.length})',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (_imageType == 'I' && _imageTypeChange)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Interior (${prodImagesI.length})',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        GestureDetector(
                          child: Image.network(
                            prodImagesgroup[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) {
                                    return ViewPhotos(
                                      imageIndex:
                                          prodImagesgroup[index].imageType ==
                                                  'I'
                                              ? index - prodImagesE.length
                                              : index,
                                      imageList:
                                          prodImagesgroup[index].imageType ==
                                                  'E'
                                              ? prodImagesE
                                              : prodImagesI,
                                      pageTitle:
                                          prodImagesgroup[index].imageType ==
                                                  'E'
                                              ? 'Exterior'
                                              : 'Interior',
                                    );
                                  },
                                  fullscreenDialog: true),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
