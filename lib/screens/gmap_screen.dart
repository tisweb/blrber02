import 'dart:collection';

import 'package:blrber/provider/get_current_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GMapScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String addressLocation;

  GMapScreen({
    this.lat,
    this.long,
    this.addressLocation,
  });
  @override
  _GMapScreenState createState() => _GMapScreenState();
}

class _GMapScreenState extends State<GMapScreen> {
  Set<Marker> _markers = HashSet<Marker>();

  String distanceS = "";

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("0"),
          position: LatLng(widget.lat, widget.long),
          infoWindow: InfoWindow(
            title: "${widget.addressLocation}",
            snippet: "Product Location!",
          ),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    _calculateDistance();
    super.didChangeDependencies();
  }

  _calculateDistance() {
    final getCurrentLocation = Provider.of<GetCurrentLocation>(context);
    double distanceD = Geolocator.distanceBetween(getCurrentLocation.latitude,
            getCurrentLocation.longitude, widget.lat, widget.long) /
        1000.round();

    if (distanceD != null) {
      setState(() {
        distanceS = distanceD.round().toString();
      });
    } else {
      setState(() {
        distanceS = distanceD.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: (widget.lat != null && widget.long != null)
          ? Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.lat, widget.long),
                    zoom: 15,
                  ),
                  markers: _markers,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('Distance : $distanceS km'),
                  ),
                )
              ],
            )
          : Container(),
    );
  }
}
