//Imports for pubspec Packages
import 'package:flutter/material.dart';

//Imports for Widgets
import '../widgets/display_product_grid.dart';

class FilteredProdScreen extends StatelessWidget {
  final List<String> queriedProdIdList;
  FilteredProdScreen({
    this.queriedProdIdList,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
      ),
      body: DisplayProductGrid(
        inCatName: 'NA',
        inProdCondition: 'NA',
        inDisplayType: 'Results',
        inqueriedProdIdList: queriedProdIdList,
      ),
    );
  }
}
