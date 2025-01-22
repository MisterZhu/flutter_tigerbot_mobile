import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:TigerChat/util/router/tb_router_helper.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/tb_colors.dart';
import '../constant/tb_default_value.dart';
import 'dialog/sc_base_dialog.dart';
import 'dialog/sc_dialog_utils.dart';

class TBPermissionManager {
  static final TBPermissionManager _singleton = TBPermissionManager._internal();
  factory TBPermissionManager() => _singleton;

  TBPermissionManager._internal();
  // bool _dialogShown = false;

  ///权限失败弹框
  static showPermissionDialog(String message) {
    TBUtils.getCurrentContext(completionHandler: (context) async {
      BrnDialogManager.showConfirmDialog(
        context,
        title: '温馨提示',
        cancel: '取消',
        confirm: '确定',
        message: message,
        onCancel: () {
          TBRouterHelper.back(null);
        },
        onConfirm: () {
          openAppSettings();
          TBRouterHelper.back(null);
        },
      );
    });
  }

  /// 拍照
  static Future<bool> getStoragePermission(
      {Function? completionHandler}) async {
    final completer = Completer<bool>();

    /// android权限为Permission.storage对应iOS的Permission.photos
    if (Platform.isAndroid) {
      await TBUtils.getCurrentContext(completionHandler: (context) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool isShowAlert =
            preferences.getBool(TBDefVal.isShowStorageAlert) ?? false;
        if (!isShowAlert) {
          SCDialogUtils.instance.showMiddleDialog(
            context: context,
            title: "温馨提示",
            content: TBDefVal.storageAlertMessage,
            customWidgetButtons: [
              defaultCustomButton(context,
                  text: '取消',
                  textColor: TBColors.color_1B1C33,
                  fontWeight: FontWeight.w400, onTap: () async {
                completer.complete(false);
                // TBRouterHelper.back(null);
              }),
              defaultCustomButton(context,
                  text: '确定',
                  textColor: TBColors.color_1B1C33,
                  fontWeight: FontWeight.w400, onTap: () async {
                preferences.setBool(TBDefVal.isShowStorageAlert, true);
                PermissionStatus permissionStatus =
                    await Permission.storage.request();
                if (permissionStatus == PermissionStatus.granted) {
                  debugPrint('-------------PermissionStatus.granted1');
                  completionHandler?.call();
                  completer.complete(true);
                } else {
                  debugPrint('-------------PermissionStatus.granted2');
                  showPermissionDialog(TBDefVal.noAlbumPermis);
                  completer.complete(false);
                }
              }),
            ],
          );
        } else {
          PermissionStatus permissionStatus =
              await Permission.storage.request();
          if (permissionStatus == PermissionStatus.granted) {
            debugPrint('-------------PermissionStatus.granted3');

            completionHandler?.call();
            completer.complete(true);
          } else {
            debugPrint('-------------PermissionStatus.granted34');

            showPermissionDialog(TBDefVal.noAlbumPermis);
            completer.complete(false);
          }
        }
      });
    } else {
      PermissionStatus permissionStatus = await Permission.photos.request();
      if (permissionStatus == PermissionStatus.granted) {
        debugPrint('-------------PermissionStatus.granted345');

        completionHandler?.call();
        completer.complete(true);
      } else {
        debugPrint('-------------PermissionStatus.granted3456');

        showPermissionDialog(TBDefVal.noAlbumPermis);
        completer.complete(false);
      }
    }
    return completer.future;
  }

  ///相册权限
  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      TBUtils.getCurrentContext(completionHandler: (context) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool isShowAlert =
            preferences.getBool(TBDefVal.isShowStorageAlert) ?? false;
        if (!isShowAlert) {
          SCDialogUtils.instance.showMiddleDialog(
            context: context,
            title: "允许TigerBot访问以下权限吗？",
            content: TBDefVal.storageAlertMessage,
            customWidgetButtons: [
              defaultCustomButton(context,
                  text: '取消',
                  textColor: TBColors.color_1B1C33,
                  fontWeight: FontWeight.w400),
              defaultCustomButton(context,
                  text: '确定',
                  textColor: TBColors.color_1B1C33,
                  fontWeight: FontWeight.w400, onTap: () async {
                preferences.setBool(TBDefVal.isShowStorageAlert, true);
                TBRouterHelper.back(null);

                await _requestPermission();
                // startLocation(completionHandler: completionHandler);
              }),
            ],
          );
        } else {
          await _requestPermission();
        }
      });
    } else {
      await _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    PermissionStatus permissionStatus;

    // 检查权限和申请权限
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }
    if (permissionStatus == PermissionStatus.granted) {
      /* 外部调用
      .then((_) {
             //申请权限请求成功后的操作
        })
        **/
    }
    // else if (!_dialogShown) {
    //   /*外部调用
    //   .catchError((error){
    //       // wu权限的操作
    //    })
    //   * */
    //   print('-----------------------------------弹出次数');
    //   showPermissionDialog(TBDefVal.noAlbumPermis);
    // }
  }

  /// 麦克风-隐私权限提示
  static startMicrophonePrivacyAlert(
      {Function(int result)? completionHandler}) async {
    Future.delayed(const Duration(seconds: 0), () async {
      TBUtils.getCurrentContext(completionHandler: (context) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool isShowAlert =
            preferences.getBool(TBDefVal.isShowVoiceAlert) ?? false;
        if (!isShowAlert) {
          SCDialogUtils.instance.showMiddleDialog(
            context: context,
            title: "允许TigerBot访问以下2项权限吗？",
            content: TBDefVal.microAlertMessage,
            customWidgetButtons: [
              defaultCustomButton(context,
                  text: '取消',
                  textColor: TBColors.color_1B1C33,
                  fontWeight: FontWeight.w400),
              defaultCustomButton(context,
                  text: '确定',
                  textColor: TBColors.color_1B1C33,
                  fontWeight: FontWeight.w400, onTap: () async {
                preferences.setBool(TBDefVal.isShowVoiceAlert, true);
                await Permission.microphone.request().isGranted;
                if (Platform.isAndroid) {
                  await Permission.storage.request();
                } else {
                  await Permission.photos.request();
                }
                completionHandler?.call(2);
                // startLocation(completionHandler: completionHandler);
              }),
            ],
          );
        } else {
          completionHandler?.call(1);
        }
      });
    });
  }
}
