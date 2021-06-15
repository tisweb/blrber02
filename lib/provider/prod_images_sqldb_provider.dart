import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../helpers/db_helper.dart';

class ProdImagesSqlDbProvider with ChangeNotifier {
  List<ProdImagesSqlDb> _itemsE = [];

  List<ProdImagesSqlDb> get itemsE {
    return [..._itemsE];
  }

  List<ProdImagesSqlDb> _itemsI = [];

  List<ProdImagesSqlDb> get itemsI {
    return [..._itemsI];
  }

  int _count;

  int get count => _count;

  Future addImages(ProdImagesSqlDb prodImageSqlDb) async {
    var id = DateTime.now().toString();
    await DBHelper.insert('prod_images', {
      'id': id,
      'imageUrl': prodImageSqlDb.imageUrl,
      'imageType': prodImageSqlDb.imageType,
      'featuredImage': prodImageSqlDb.featuredImage,
    });
  }

  void deleteImages(String id, String imageType) {
    DBHelper.delete('prod_images', id);
    fetchAndSetImages(imageType);
  }

  Future<void> deleteImagesAll() async {
    await DBHelper.deleteAll('prod_images');
    notifyListeners();
  }

  Future<int> countProdImages() async {
    final dataList = await DBHelper.getProdImagesCount('prod_images');
    dataList.map((e) {
      _count = e["C"];
    }).toList();

    return _count;
  }

  Future<int> countEProdImages() async {
    final dataList =
        await DBHelper.getProdImagesCountByType('prod_images', 'E');
    dataList.map((e) {
      _count = e["C"];
    }).toList();

    return _count;
  }

  Future<int> countIProdImages() async {
    final dataList =
        await DBHelper.getProdImagesCountByType('prod_images', 'I');
    dataList.map((e) {
      _count = e["C"];
    }).toList();

    return _count;
  }

  Future<void> fetchAndSetImages(String imgType) async {
    final dataList = await DBHelper.getData('prod_images', '$imgType');

    if (imgType == 'E') {
      _itemsE = dataList
          .map(
            (item) => ProdImagesSqlDb(
              id: item['id'],
              imageUrl: item['imageUrl'],
              imageType: item['imageType'],
              featuredImage: item['featuredImage'],
            ),
          )
          .toList();
      notifyListeners();
    } else if (imgType == 'I') {
      _itemsI = dataList
          .map(
            (item) => ProdImagesSqlDb(
              id: item['id'],
              imageUrl: item['imageUrl'],
              imageType: item['imageType'],
              featuredImage: item['featuredImage'],
            ),
          )
          .toList();
      notifyListeners();
    }
  }
}
