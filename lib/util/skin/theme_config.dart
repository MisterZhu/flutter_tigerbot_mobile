// theme_config.dart

import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark,
  Pink,
}

class ThemeConfig {
  /// 主题颜色
  final Color themePinkColor;

  /// 海报颜色
  final Color shareBgColor00;
  final Color shareBgColor;
  final Color shareBgColor33;
  final Color shareBgColor44;

  ///鲜明对比色
  final Color themeOppoColor;

  /// 主题颜色透明度20%
  final Color themeOppoColor33;

  /// 背景颜色
  final Color bgColor; //页面背景色
  final Color bgColorMild; //多用于边框等次一级背景色
  final Color bgColorEx; //问题示例背景色

  final Color bgColorF5;
  final Color bgWhiteOrBlack; //纯色黑或白
  final Color fieldBgColor; //登录输入框背景色

  /// 分割线颜色
  final Color lineColor; // 页面中大多数分割线颜色
  final Color lineColorCode; // markdown代码块中的分割线

  /// 问答气泡背景颜色
  final Color bgColorBub; //输入框边框颜色
  final Color bgColorAsk; //问题气泡颜色
  final Color bgColorAns; //回答气泡颜色
  final Color bgColorAnsShare; //分享回答气泡颜色

  /// 问答文本颜色
  final Color textColorBub;
  final Color textColorAsk; //问题文本颜色
  final Color textColorAns; //回答文本颜色
  final Color textColorPlace; //输入框占位符文本颜色

  /// 文件边框线颜色
  final Color fileColorBor; // 文件边框线颜色

  /// 文本颜色
  final Color textColor; //纯色文本颜色（黑或白）
  final Color textColorMild; //次一级文本颜色（用于问题示例，答案底部提示语）

  /// 按钮颜色
  final Color buttonColor; //按钮文本颜色
  final Color buttonBgColor; //按钮背景颜色

  /// 聊天常规字体颜色
  final Color
      chatRegularColor; //暂时问答都是同一种字体，（textColorAsk和textColorAns暂时没使用，看是否需要）
  /// 聊天背景色
  final Color chatBGColor;

  /// 图标颜色
  final Color iconColor; // 按钮图标颜色（页面主按钮）
  final Color iconColorSevere; // 预留，暂未使用
  final Color iconColorMild; // 按钮图标颜色（次一级，答案左下角）
  final Color rightIcon6B; // APP中使用，个人资源右侧剪头

  /// 弹窗颜色
  final Color alertSureColor; // APP中弹框确认按钮颜色
  final Color alertCancelColor; // APP中弹框取消按钮颜色
  final Color alertBgColor; // APP中弹框背景颜色
  ThemeConfig({
    required this.themePinkColor,
    required this.themeOppoColor,
    required this.themeOppoColor33,
    required this.shareBgColor,
    required this.shareBgColor00,
    required this.shareBgColor33,
    required this.shareBgColor44,
    required this.bgWhiteOrBlack,
    required this.bgColor,
    required this.bgColorMild,
    required this.bgColorEx,
    required this.bgColorF5,
    required this.fieldBgColor,
    required this.lineColor,
    required this.lineColorCode,
    required this.textColor,
    required this.textColorMild,
    required this.fileColorBor,
    required this.buttonColor,
    required this.buttonBgColor,
    required this.chatRegularColor,
    required this.chatBGColor,
    required this.iconColor,
    required this.iconColorSevere,
    required this.iconColorMild,
    required this.rightIcon6B,
    required this.bgColorBub,
    required this.bgColorAsk,
    required this.bgColorAns,
    required this.bgColorAnsShare,
    required this.textColorBub,
    required this.textColorAsk,
    required this.textColorAns,
    required this.textColorPlace,
    required this.alertSureColor,
    required this.alertCancelColor,
    required this.alertBgColor,
  });
}

final Map<AppTheme, ThemeConfig> themeConfigs = {
  AppTheme.Light: ThemeConfig(
    themePinkColor: Color(0xFFFFFFFF),
    themeOppoColor: Color(0xFF5A81F3),

    shareBgColor: Color(0xfff3f6fb),
    shareBgColor00: Color(0x00f3f6fb),
    shareBgColor44: Color(0xfff3f6fb),
    shareBgColor33: Color(0xFFBDC5F1),

    themeOppoColor33: Color(0x33000000),
    // bgColor: Color(0xfff5f6f7),
    bgColor: Color(0xfff3f6fb),

    bgWhiteOrBlack: Color(0xffffffff),
    bgColorMild: Color(0xfffafafa),
    bgColorEx: Color(0xfff3f5fa),
    fieldBgColor: Color(0xfff0f0f0),
    bgColorF5: Color(0xfff5f5f5),
    lineColor: Color(0xffcbcbcb),
    lineColorCode: Color(0xffcbcbcb),
    fileColorBor: Color(0xffd8d8d8),
    textColor: Colors.black,
    textColorMild: Color(0xff6b6b6b),
    buttonColor: Color(0xffffffff),
    buttonBgColor: Color(0xff5A81F3),
    chatRegularColor: Color(0xff4a4a4a),
    chatBGColor: Color(0xfff3f6fb),
    iconColor: Color(0xff111111),
    iconColorSevere: Color(0xff000000),
    iconColorMild: Color(0xff7d7d7d),
    rightIcon6B: Color(0xff6b6b6b),
    bgColorBub: Color(0xffd7d7d7),
    textColorPlace: Color(0xffd4d4d4),
    bgColorAsk: Color(0xffffffff),
    // bgColorAns: Color(0xfff3f5fa),
    bgColorAns: Color(0x00f3f5fa),
    bgColorAnsShare: Color(0x00f3f5fa),
    textColorBub: Color(0xff0d0d0d),
    textColorAsk: Color(0xff000000),
    textColorAns: Color(0xff000000),
    alertSureColor: Color(0xffdb524e),
    alertCancelColor: Color(0xff000000),
    alertBgColor: Color(0xffffffff),
//     themePinkColor: Color(0xFFFF98AC),
//
//     themeOppoColor: Color(0xFFFF98AC),
//     themeOppoColor33: Color(0x33FF98AC),
//     bgColor: Color(0xffffffff),
//     bgWhiteOrBlack: Color(0xffffffff),
//     bgColorMild: Color(0xfffafafa),
//     bgColorEx: Color(0xfff3f5fa),
// //    bgColorEx: Color(0xfffbfcfd),
//     fieldBgColor: Color(0xfff0f0f0),
//     bgColorF5: Color(0xfff5f5f5),
//     lineColor: Color(0xffcbcbcb),
//     lineColorCode: Color(0xffcbcbcb),
//     fileColorBor: Color(0xffd8d8d8),
//     textColor: Colors.black,
//     textColorMild: Color(0xff6b6b6b),
//     buttonColor: Color(0xffffffff),
//     buttonBgColor: Color(0xFFFF98AC),
//     chatRegularColor: Color(0xff4a4a4a),
//     chatBGColor: Color(0xfff3f6fb),
//     iconColor: Color(0xff111111),
//     iconColorSevere: Color(0xff000000),
//     iconColorMild: Color(0xff7d7d7d),
//     rightIcon6B: Color(0xff6b6b6b),
//     bgColorBub: Color(0xffd7d7d7),
//     textColorPlace: Color(0xffd4d4d4),
//     bgColorAsk: Color(0xFFFF98AC),
//     // bgColorAns: Color(0xfff3f5fa),
//     bgColorAns: Color(0x00f3f5fa),
//     bgColorAnsShare: Color(0xfff3f5fa),
//     textColorBub: Color(0xff0d0d0d),
//     textColorAsk: Color(0xffffffff),
//     textColorAns: Color(0xff000000),
//     alertSureColor: Color(0xffdb524e),
//     alertCancelColor: Color(0xff000000),
//     alertBgColor: Color(0xffffffff),
  ),
  AppTheme.Dark: ThemeConfig(
    themePinkColor: Color(0xff212425),

    themeOppoColor: Color(0xFFFFFFFF),
    themeOppoColor33: Color(0x33FFFFFF),
    // shareBgColor: Color(0xFF101010),
    shareBgColor: Color(0xFF212425),

    // shareBgColor00: Color(0x0011111A),
    // shareBgColor44: Color(0xFF11111A),
    shareBgColor00: Color(0x00212425),
    shareBgColor44: Color(0xFF212425),
    shareBgColor33: Color(0xFF2E2E3A),
    // bgColor: Color(0xff151619),
    bgColor: Color(0xff212425),

    bgWhiteOrBlack: Color(0xff212425),
    bgColorMild: Color(0xff26272c),
    bgColorEx: Color(0xff26272c),

    fieldBgColor: Color(0xff26272c),
    bgColorF5: Color(0xff050505),
    lineColor: Color(0xff6b6b6b),
    lineColorCode: Color(0xff424242),
    fileColorBor: Color(0xff424242),
    textColor: Colors.white,
    textColorMild: Color(0xffe3e3e3),
    buttonColor: Color(0xffffffff),
    buttonBgColor: Color(0xff5A81F3),
    chatRegularColor: Color(0xffececec),
    chatBGColor: Color(0xff4a4a4a),
    iconColor: Color(0xffb4b4b4),
    iconColorSevere: Color(0xffffffff),
    iconColorMild: Color(0xffb4b4b4),
    rightIcon6B: Color(0xff6b6b6b),
    bgColorBub: Color(0xff303039),
    textColorPlace: Color(0xff666666),
    bgColorAsk: Color(0xff303039),
    // bgColorAns: Color(0xff2f2f2f),
    bgColorAns: Color(0x002f2f2f),
    bgColorAnsShare: Color(0x002f2f2f),

    textColorBub: Color(0xffececec),
    textColorAsk: Color(0xffffffff),
    textColorAns: Color(0xffffffff),
    alertSureColor: Color(0xffdb524e),
    alertCancelColor: Color(0xff000000),
    alertBgColor: Color(0xffffffff),
  ),
  AppTheme.Pink: ThemeConfig(
    themePinkColor: Color(0xFFFF98AC),

    themeOppoColor: Color(0xFFFF98AC),
    themeOppoColor33: Color(0x33FF98AC),
    shareBgColor: Color(0xFFFF98AC),
    shareBgColor33: Color(0x33FF98AC),
    shareBgColor00: Color(0xFF2c2a2a),
    shareBgColor44: Color(0xFFFF98AC),

    bgColor: Color(0xffffffff),
    bgWhiteOrBlack: Color(0xffffffff),
    bgColorMild: Color(0xfffafafa),
    bgColorEx: Color(0xfff0f7ff),

    fieldBgColor: Color(0xfff0f0f0),
    bgColorF5: Color(0xfff5f5f5),
    lineColor: Color(0xffcbcbcb),
    lineColorCode: Color(0xffcbcbcb),
    fileColorBor: Color(0xffd8d8d8),
    textColor: Colors.black,
    textColorMild: Color(0xff6b6b6b),
    buttonColor: Color(0xffffffff),
    buttonBgColor: Color(0xFFFF98AC),
    chatRegularColor: Color(0xff4a4a4a),
    chatBGColor: Color(0xfff3f6fb),
    iconColor: Color(0xff111111),
    iconColorSevere: Color(0xff000000),
    iconColorMild: Color(0xff7d7d7d),
    rightIcon6B: Color(0xff6b6b6b),
    bgColorBub: Color(0xffd7d7d7),
    textColorPlace: Color(0xffd4d4d4),
    bgColorAsk: Color(0xFFFF98AC),
    // bgColorAns: Color(0xfff3f5fa),
    bgColorAns: Color(0x00f3f5fa),
    bgColorAnsShare: Color(0xfff3f5fa),

    textColorBub: Color(0xff0d0d0d),
    textColorAsk: Color(0xffffffff),
    textColorAns: Color(0xff000000),
    alertSureColor: Color(0xffdb524e),
    alertCancelColor: Color(0xff000000),
    alertBgColor: Color(0xffffffff),
  ),
  // AppTheme.Green: ThemeConfig(
  //   themePinkColor: Colors.green,
  //   bgColor: Colors.green[100]!,
  //   textColor: Colors.green[900]!,
  //   buttonColor: Colors.green,
  // ),
};
