import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../util/colors/sc_color_hex.dart';

class SCCustomScaffoldController extends GetxController {
  /*导航栏背景色*/
  Color primaryColor = SCHexColor('#FFFFFF');
  /*title颜色*/
  Color titleColor = SCHexColor('#000000');
  /*返回按钮颜色*/
  Color backIconColor = SCHexColor('#000000');
  /*状态栏颜色,黑色或白色,默认黑色*/
  SystemUiOverlayStyle statusBarStyle = SystemUiOverlayStyle.dark;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  /*设置导航栏背景色*/
  void setPrimaryColor(Color color) {
    primaryColor = color;
    update();
  }

  /*设置title颜色*/
  void setTitleColor(Color color) {
    titleColor = color;
    update();
  }

  /*设置返回按钮颜色*/
  void setBackIconColor(Color color) {
    backIconColor = color;
    update();
  }

  /*设置状态栏颜色*/
  void setStatusBarStyle(SystemUiOverlayStyle systemUiOverlayStyle) {
    statusBarStyle = systemUiOverlayStyle;
    update();
  }
}
