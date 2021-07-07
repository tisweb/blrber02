import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheck {
  static Future<String> connectivity() async {
    var connectivityStatus = "";
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Connected to Mobile Internet');
          connectivityStatus = "MobileInternet";
        }
      } on SocketException catch (_) {
        print('not connected');
        connectivityStatus = "NoConnectivity";
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Connected to Wifi Internet');
          connectivityStatus = "WifiInternet";
        }
      } on SocketException catch (_) {
        print('not connected - $connectivityResult');
        connectivityStatus = "NoConnectivity";
      }
    } else if (connectivityResult == ConnectivityResult.none) {
      print('not connected - $connectivityResult');
      connectivityStatus = "NoConnectivity";
    } else {
      print('not connected - $connectivityResult');
      connectivityStatus = "NoConnectivity";
    }

    return connectivityStatus;
  }
}
