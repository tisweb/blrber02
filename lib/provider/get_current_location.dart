import 'package:currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class GetCurrentLocation extends ChangeNotifier {
  String _addressLocation;
  String _coordinates;
  double _latitude;
  double _longitude;
  String _countryName;
  String _countryCode;
  String _currencyCode;

  GetCurrentLocation() {
    _addressLocation = '';
    _coordinates = '';
    _countryCode = '';
    _countryName = '';
    _latitude = 0.0;
    _longitude = 0.0;
    _currencyCode = '';
  }

  String get addressLocation => _addressLocation;
  String get coordinates => _coordinates;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get countryName => _countryName;
  String get countryCode => _countryCode;
  String get currencyCode => _currencyCode;

  set addressLocation(String addressLocation) {
    _addressLocation = addressLocation;
    notifyListeners();
  }

  set coordinates(String coordinates) {
    _coordinates = coordinates;
    notifyListeners();
  }

  set latitude(double latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set longitude(double longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  set countryName(String countryName) {
    _countryName = countryName;
    notifyListeners();
  }

  set countryCode(String countryCode) {
    _countryCode = countryCode;
    notifyListeners();
  }

  set currencyCode(String currencyCode) {
    _currencyCode = currencyCode;
    notifyListeners();
  }

  Future<void> getCurrentPosition() async {
    final cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final cPCoordinates = Coordinates(cPosition.latitude, cPosition.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(cPCoordinates);
    final first = address.first;

    addressLocation = "${first.subLocality}, ${first.locality}";
    coordinates = cPCoordinates.toString();
    latitude = cPosition.latitude;
    longitude = cPosition.longitude;
    countryName = first.countryName;
    countryCode = first.countryCode;

    currencyCode = CurrencyPickerUtils.getCountryByIsoCode(countryCode)
        .currencyCode
        .toString();
  }

  Future<void> getselectedPosition(Place place) async {
    Geolocation geolocation = await place.geolocation;

    LatLng latLng = geolocation.coordinates;

    final sPcoordinates = Coordinates(latLng.latitude, latLng.longitude);

    final address =
        await Geocoder.local.findAddressesFromCoordinates(sPcoordinates);
    final first = address.first;
    addressLocation = "${first.subLocality}, ${first.locality}";
    coordinates = sPcoordinates.toString();
    latitude = latLng.latitude;
    longitude = latLng.longitude;
    countryName = first.countryName;
    countryCode = first.countryCode;

    currencyCode = CurrencyPickerUtils.getCountryByIsoCode(countryCode)
        .currencyCode
        .toString();
  }
}
