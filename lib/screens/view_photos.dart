//Imports for pubspec Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

//Imports for Constants
import '../constants.dart';

//Imports for Models
import '../models/product.dart';

class ViewPhotos extends StatefulWidget {
  final imageIndex;
  final List<ProdImages> imageList;
  final String pageTitle;
  ViewPhotos({
    this.imageIndex,
    this.imageList,
    this.pageTitle,
  });

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  PageController pageController;
  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: widget.pageTitle,
            style: const TextStyle(
              color: bBackgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            children: [
              const TextSpan(
                text: '(',
                style: TextStyle(
                  color: bBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: '${currentIndex + 1}',
                style: TextStyle(
                  color: bBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: ' of ',
                style: TextStyle(
                  color: bBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: '${widget.imageList.length}',
                style: TextStyle(
                  color: bBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const TextSpan(
                text: ')',
                style: TextStyle(
                  color: bBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageList[index].imageUrl),
              );
            },
            onPageChanged: onPageChanged,
            itemCount: widget.imageList.length,
            loadingBuilder: (context, progress) => Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                child: CircularProgressIndicator(
                  value: progress == null
                      ? null
                      : progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
