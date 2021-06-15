import 'package:blrber/models/product.dart';
import 'package:flutter/material.dart';

class ViewFullSpecs extends StatelessWidget {
  static const routeName = '/view_full_specs';
  @override
  Widget build(BuildContext context) {
    List<CtmSpecialInfo> ctmSpecialInfos =
        ModalRoute.of(context).settings.arguments as List<CtmSpecialInfo>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Specs'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
        child: Column(
          children: [
            if (ctmSpecialInfos[0].year.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Year',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].make.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Make',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].model.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Model',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].vehicleType.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'VehicleType',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].mileage.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Mileage',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
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
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].engine.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Engine',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].fuelType.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Fuel Type',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].options.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Options',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].subModel.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'SubModel',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].numberOfCylinders.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Number Of Cylinders',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].safetyFeatures.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Safety Features',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].driveType.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'DriveType',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
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
                              text: TextSpan(
                                text: 'InteriorColor',
                                style: TextStyle(
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
                                style: TextStyle(
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].bodyType.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Body Type',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].forSaleBy.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'For Sale By',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].warranty.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Warranty',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
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
                              text: TextSpan(
                                text: 'ExteriorColor',
                                style: TextStyle(
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
                                style: TextStyle(
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            if (ctmSpecialInfos[0].trim.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Trim',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].transmission.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Transmission',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            if (ctmSpecialInfos[0].steeringLocation.isNotEmpty)
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: 'Steering Location',
                              style: TextStyle(
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
                              style: TextStyle(
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
                  SizedBox(
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
