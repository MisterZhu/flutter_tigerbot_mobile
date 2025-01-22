import 'dart:ui';

/// title : "标题"
/// color : "颜色"
/// fontSize : 16.0
/// fontWeight : ""

class SCBottomSheetModel {
  SCBottomSheetModel({
    String? title,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    _title = title;
    _color = color;
    _fontSize = fontSize;
    _fontWeight = fontWeight;
  }

  SCBottomSheetModel.fromJson(dynamic json) {
    _title = json['title'];
    _color = json['color'];
    _fontSize = json['fontSize'];
    _fontWeight = json['fontWeight'];
  }

  String? _title;
  Color? _color;
  double? _fontSize;
  FontWeight? _fontWeight;

  String? get title => _title;
  Color? get color => _color;
  double? get fontSize => _fontSize;
  FontWeight? get fontWeight => _fontWeight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['color'] = _color;
    map['fontSize'] = _fontSize;
    map['fontWeight'] = _fontWeight;
    return map;
  }
}
