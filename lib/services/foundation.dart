import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';
import 'dart:io';

bool get isIos =>
    foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

String getCurrencySymbol() {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
  return format.currencySymbol;
}

String getCurrencySymbolByName(String name) {
  var format = NumberFormat.simpleCurrency(name: name);
  return format.currencySymbol;
}

String getCurrencyName() {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
  return format.currencyName;
}
