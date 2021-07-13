//Imports for pubspec Packages
import 'package:flutter/material.dart';

//Imports for Models
import 'package:blrber/models/product.dart';

class ViewFullSpecs extends StatelessWidget {
  static const routeName = '/view_full_specs';
  @override
  Widget build(BuildContext context) {
    List<CtmSpecialInfo> ctmSpecialInfos =
        ModalRoute.of(context).settings.arguments as List<CtmSpecialInfo>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Specs'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
        child: Column(
          children: [
            if (ctmSpecialInfos[0].year != null)
              if (ctmSpecialInfos[0].year.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Year',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].year,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].make != null)
              if (ctmSpecialInfos[0].make.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Make',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].make,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].model != null)
              if (ctmSpecialInfos[0].model.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Model',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].model,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].vehicleType != null)
              if (ctmSpecialInfos[0].vehicleType.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'VehicleType',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].vehicleType,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].mileage != null)
              if (ctmSpecialInfos[0].mileage.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Mileage',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].mileage,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].vin != null)
              if (ctmSpecialInfos[0].vin.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: TextSpan(
                                text: 'VIN',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].vin,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].engine != null)
              if (ctmSpecialInfos[0].engine.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Engine',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].engine,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].fuelType != null)
              if (ctmSpecialInfos[0].fuelType.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Fuel Type',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].fuelType,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].options != null)
              if (ctmSpecialInfos[0].options.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Options',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].options,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].subModel != null)
              if (ctmSpecialInfos[0].subModel.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'SubModel',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].subModel,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].numberOfCylinders != null)
              if (ctmSpecialInfos[0].numberOfCylinders.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Number Of Cylinders',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].numberOfCylinders,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].safetyFeatures != null)
              if (ctmSpecialInfos[0].safetyFeatures.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Safety Features',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].safetyFeatures,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].driveType != null)
              if (ctmSpecialInfos[0].driveType.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'DriveType',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].driveType,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].interiorColor != null)
              if (ctmSpecialInfos[0].interiorColor.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'InteriorColor',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].interiorColor,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].bodyType != null)
              if (ctmSpecialInfos[0].bodyType.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Body Type',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].bodyType,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].forSaleBy != null)
              if (ctmSpecialInfos[0].forSaleBy.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'For Sale By',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].forSaleBy,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].warranty != null)
              if (ctmSpecialInfos[0].warranty.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Warranty',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].warranty,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].exteriorColor != null)
              if (ctmSpecialInfos[0].exteriorColor.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'ExteriorColor',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].exteriorColor,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].trim != null)
              if (ctmSpecialInfos[0].trim.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Trim',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].trim,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].transmission != null)
              if (ctmSpecialInfos[0].transmission.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Transmission',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].transmission,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].steeringLocation != null)
              if (ctmSpecialInfos[0].steeringLocation.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Steering Location',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RichText(
                              text: TextSpan(
                                text: ctmSpecialInfos[0].steeringLocation,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
