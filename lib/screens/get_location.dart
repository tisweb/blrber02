import 'package:blrber/provider/get_current_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';

// Imports services
import '../services/api_keys.dart';

class GetLocation extends StatefulWidget {
  static const routeName = '/get-location';

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  String _addressLocation = '';
  @override
  Widget build(BuildContext context) {
    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Location'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Column(
            children: [
              Container(
                child: SearchMapPlaceWidget(
                  hasClearButton: true,
                  placeType: PlaceType.address,
                  placeholder: 'Enter the location',
                  apiKey: placeApiKey,
                  onSelected: (Place place) async {
                    getCurrentLocation.getselectedPosition(place);
                    print('check search place');
                    setState(() {
                      _addressLocation = place.description;
                    });
                  },
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  getCurrentLocation.getCurrentPosition();
                  print('check current location');
                  setState(() {
                    _addressLocation = getCurrentLocation.addressLocation;
                  });
                  Navigator.pop(context);
                },
                icon: Icon(Icons.my_location),
                label: Text("Pick current location"),
              ),
              Text(_addressLocation),
            ],
          ),
        ),
      ),
    );
  }
}
