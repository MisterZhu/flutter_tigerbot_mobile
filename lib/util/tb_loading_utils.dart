import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 加载显示工具类

class TBLoadingUtils {
  /// 显示加载框
  static Future<void> show({String? text}) async {
    String textString = text ?? '';
    var hideResult = await hide();
    if (textString.isEmpty || textString == '') {
      EasyLoading.instance.contentPadding = const EdgeInsets.all(20.0);
      return EasyLoading.show();
    } else {
      EasyLoading.instance.contentPadding =
          const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15);
      return EasyLoading.show(status: textString);
    }
  }

  /// 成功提示
  static Future<void> success({String? text}) async {
    String textString = text ?? '';
    var hideResult = await hide();
    if (textString.isEmpty || textString == '') {
      EasyLoading.instance.contentPadding =
          const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10);
      return EasyLoading.showSuccess(textString);
    } else {
      EasyLoading.instance.contentPadding =
          const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20);
      return EasyLoading.showSuccess(textString);
    }
  }

  /// 失败提示
  static Future<void> failure({String? text}) async {
    String textString = text ?? '';
    var hideResult = await hide();
    if (textString.isEmpty || textString == '') {
      EasyLoading.instance.contentPadding =
          const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10);
      return EasyLoading.showError(textString);
    } else {
      EasyLoading.instance.contentPadding =
          const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20);
      return EasyLoading.showError(textString);
    }
  }

  /// 信息提示
  static Future<void> info({String? text}) async {
    String textString = text ?? '';
    var hideResult = await hide();
    return EasyLoading.showInfo(textString);
  }

  /// 功能开发中
  static Future<void> developing() {
    return failure(text: "功能开发中");
  }

  /// 初始化loading配置
  static initLoading() {
    EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.maskType = EasyLoadingMaskType.clear;
    EasyLoading.instance.animationStyle = EasyLoadingAnimationStyle.opacity;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.squareCircle;
    EasyLoading.instance.dismissOnTap = true;
    EasyLoading.instance.backgroundColor = Colors.black54.withOpacity(0.5);
    EasyLoading.instance.indicatorColor = Colors.white;
    EasyLoading.instance.textColor = Colors.white;
    EasyLoading.instance.indicatorSize = 0.0;
    EasyLoading.instance.contentPadding =
        const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15);
    EasyLoading.instance.indicatorWidget = const CupertinoActivityIndicator(
      radius: 16.0,
      color: Colors.white,
    );
    EasyLoading.instance.successWidget = SizedBox(
      width: 24.0,
      height: 24.0,
      child: Image.asset(
        'images/loading/icon_success_white.png',
        width: 24.0,
        height: 24.0,
      ),
    );
    EasyLoading.instance.errorWidget = SizedBox(
      width: 24.0,
      height: 24.0,
      child: Image.asset(
        'images/loading/icon_failed_white.png',
        width: 24.0,
        height: 24.0,
      ),
    );
  }

  /// 隐藏loading
  static Future<void> hide() {
    return EasyLoading.dismiss(animation: true);
  }
}
