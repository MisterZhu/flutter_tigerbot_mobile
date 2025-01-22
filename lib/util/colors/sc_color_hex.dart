/*
* 字符串转color
* Color color1 = HexColor("b74093");
* Color color2 = HexColor("#b74093");
* Color color3 = HexColor("#88b74093");
*/

import 'package:flutter/cupertino.dart';

class SCHexColor extends Color {

  SCHexColor(final String hexColor) : super(_getStringColor(hexColor));

  static int _getStringColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  /// 颜色检测只保存 #RRGGBB格式 FF透明度
  /// [color] 格式可能是材料风/十六进制/string字符串
  /// 返回[String] #rrggbb 字符串
  static String? colorToString(Object color) {
    if (color is Color) {
      /// 0xFFFFFFFF
      /// 将十进制转换成为16进制 返回字符串但是没有0x开头
      String temp = color.value.toRadixString(16);
      color = "#${temp.substring(2, 8)}";
    }
    return color.toString();
  }
}
