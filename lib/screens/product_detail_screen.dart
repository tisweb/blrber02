//Imports for pubspec Packages
import 'package:flutter/material.dart';

//Imports for Widgets
import '../widgets/product_detail_item.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var _productDocId = '';

  @override
  Widget build(BuildContext context) {
    _productDocId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      body: ProductDetailItem(productDocId: _productDocId),
    );
  }
}
