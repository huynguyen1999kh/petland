import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HexColor extends Color {
  static const MethodChannel _channel = const MethodChannel('hexcolor');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color fromHex(String hexColor) {
    try {
      return Color(_getColorFromHex(hexColor));
    } catch(e) {
      return Colors.white;
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}