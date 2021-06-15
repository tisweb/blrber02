import 'package:blrber/widgets/display_product_grid.dart';

import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  static const routeName = '/search-results';

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  String _productName = "";
  String _prodCondition = "";
  String _displayType = "Search";
  @override
  Widget build(BuildContext context) {
    _productName = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Container(
        child: DisplayProductGrid(
          inCatName: _productName,
          inProdCondition: _prodCondition,
          inDisplayType: _displayType,
        ),
      ),
    );
  }
}
