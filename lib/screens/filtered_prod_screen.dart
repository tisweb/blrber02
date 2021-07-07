import 'package:flutter/material.dart';
import '../widgets/display_product_grid.dart';

class FilteredProdScreen extends StatelessWidget {
  final List<String> queriedProdIdList;
  FilteredProdScreen({
    this.queriedProdIdList,
  });
  @override
  Widget build(BuildContext context) {
    print('filtered - ${queriedProdIdList.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
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
