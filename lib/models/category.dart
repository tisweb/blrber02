class Category {
  String catDocId;
  String catName;
  String imageUrl;
  int serialNum;
  int iconValue;

  Category({
    this.catDocId,
    this.catName,
    this.imageUrl,
    this.serialNum,
    this.iconValue,
  });
}

class SubCategory {
  String subCatDocId;
  String subCatType;
  String catName;
  String imageUrl;

  SubCategory({
    this.subCatDocId,
    this.subCatType,
    this.catName,
    this.imageUrl,
  });
}
