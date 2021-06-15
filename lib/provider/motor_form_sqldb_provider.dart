import 'package:flutter/foundation.dart';
import '../helpers/db_helper_motor_form.dart';
import '../models/product.dart';

class MotorFormSqlDbProvider with ChangeNotifier {
  List<MotorFormSqlDb> _items = [];

  int _count;

  int get count => _count;

  List<MotorFormSqlDb> get items {
    return [..._items];
  }

  Future<void> addMotorForm(MotorFormSqlDb motorFormData) async {
    var id = DateTime.now().toString();

    await DBHelperMotorForm.insertMotorForm('motortable', {
      'id': id,
      'catName': motorFormData.catName,
      'subCatDocId': motorFormData.subCatDocId,
      'prodDes': motorFormData.prodDes,
      'sellerNotes': motorFormData.sellerNotes,
      'prodCondition': motorFormData.prodCondition,
      'price': motorFormData.price,
      'imageUrlFeatured': motorFormData.imageUrlFeatured,
      'deliveryInfo': motorFormData.deliveryInfo,
      'year': motorFormData.year,
      'make': motorFormData.make,
      'model': motorFormData.model,
      'vehicleType': motorFormData.vehicleType,
      'mileage': motorFormData.mileage,
      'vin': motorFormData.vin,
      'engine': motorFormData.engine,
      'fuelType': motorFormData.fuelType,
      'options': motorFormData.options,
      'subModel': motorFormData.subModel,
      'numberOfCylinders': motorFormData.numberOfCylinders,
      'safetyFeatures': motorFormData.safetyFeatures,
      'driveType': motorFormData.driveType,
      'interiorColor': motorFormData.interiorColor,
      'bodyType': motorFormData.bodyType,
      'exteriorColor': motorFormData.exteriorColor,
      'forSaleBy': motorFormData.forSaleBy,
      'warranty': motorFormData.warranty,
      'trim': motorFormData.trim,
      'transmission': motorFormData.transmission,
      'steeringLocation': motorFormData.steeringLocation,
      'vehicleTypeYear': motorFormData.vehicleTypeYear,
      'editPost': motorFormData.editPost,
    });
  }

  Future<int> countMotorForm() async {
    final dataList = await DBHelperMotorForm.getMotorFormCount('motortable');
    dataList.map((e) {
      _count = e["C"];
    }).toList();

    return _count;
  }

  void deleteMotorForm(String id) {
    DBHelperMotorForm.deleteMotorForm('motortable', id);
  }

  Future<void> deleteMotorFormAll() async {
    await DBHelperMotorForm.deleteMotorFormAll('motortable');
  }

  Future<void> dropMotorForm() async {
    await DBHelperMotorForm.dropMotorForm('motortable');
  }

  void updateMotorForm(String id, String columnName, String columnValue) {
    DBHelperMotorForm.updateMotorForm(
        'motortable', id, columnName, columnValue);
    fetchMotorForm();
  }

  Future<void> fetchMotorForm() async {
    final dataList = await DBHelperMotorForm.getMotorForm('motortable');

    return _items = dataList
        .map(
          (item) => MotorFormSqlDb(
            id: item['id'],
            catName: item['catName'],
            subCatDocId: item['subCatDocId'],
            prodDes: item['prodDes'],
            sellerNotes: item['sellerNotes'],
            prodCondition: item['prodCondition'],
            price: item['price'],
            imageUrlFeatured: item['imageUrlFeatured'],
            deliveryInfo: item['deliveryInfo'],
            year: item['year'],
            make: item['make'],
            model: item['model'],
            vehicleType: item['vehicleType'],
            mileage: item['mileage'],
            vin: item['vin'],
            engine: item['engine'],
            fuelType: item['fuelType'],
            options: item['options'],
            subModel: item['subModel'],
            numberOfCylinders: item['numberOfCylinders'],
            safetyFeatures: item['safetyFeatures'],
            driveType: item['driveType'],
            interiorColor: item['interiorColor'],
            bodyType: item['bodyType'],
            exteriorColor: item['exteriorColor'],
            forSaleBy: item['forSaleBy'],
            warranty: item['warranty'],
            trim: item['trim'],
            transmission: item['transmission'],
            steeringLocation: item['steeringLocation'],
            vehicleTypeYear: item['vehicleTypeYear'],
            editPost: item['editPost'],
          ),
        )
        .toList();
  }
}
