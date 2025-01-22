import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:TigerChat/constant/tb_default_value.dart';
import 'package:TigerChat/sc_app.dart';
import 'package:TigerChat/util/router/tb_router_path.dart';
import 'package:TigerChat/util/tb_loading_utils.dart';
import 'package:TigerChat/util/tb_permission_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/tb_asset.dart';
import '../pages/mine/logic/tb_mine_logic.dart';
import '../pages/mine/widgets/tb_teen_pass_view.dart';
import 'package:path/path.dart' as path;

/// 图片缓存管理
import 'package:cached_network_image/cached_network_image.dart';

/// 工具类

class TBUtils {
  static Future<bool> getDeviceInfo() async {
    // bool isHuaWei = false;
    bool isOppo = false;
    bool isOnePlus = false;

    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

      // 获取设备制造商名并转换为小写
      String manufacturer = androidInfo.manufacturer.toLowerCase();

      // 判断是否为华为手机
      // if (manufacturer == 'huawei') {
      //   isHuaWei = true;
      // }

      // 判断是否为OPPO手机
      if (manufacturer == 'oppo') {
        isOppo = true;
        debugPrint('-------------------------->>>>>>>>>>oppo 手机');
      }

      // 判断是否为OnePlus手机
      if (manufacturer == 'oneplus') {
        isOnePlus = true;
        debugPrint('-------------------------->>>>>>>>>>OnePlus 手机');
      }
    } catch (e) {
      print('Error getting device info: $e');
    }

    // 返回是否是华为、OPPO或者OnePlus手机
    return isOppo || isOnePlus;
  }

  static FileTypeResult fileTypeConform(String filePath) {
    String fileExtension = path.extension(filePath);
    bool isSupported = [
      '.pdf',
      '.doc',
      '.docx',
      '.txt',
      '.html',
      '.png',
      '.jpg',
      '.jpeg',
      '.ppt',
      '.csv',
      '.pptx'
    ].contains(fileExtension);
    String fileType = fileExtension.replaceAll('.', '');
    return FileTypeResult(isSupported, fileType);
  }

  /*手机系统是否是中文*/
  static bool isChineseLan() {
    final deviceLocale = Get.deviceLocale;
    final isChinese = deviceLocale?.languageCode?.toLowerCase() == 'zh' &&
        (deviceLocale?.countryCode == 'CN' ||
            deviceLocale?.countryCode == 'TW' ||
            deviceLocale?.countryCode == 'HK' ||
            deviceLocale?.countryCode == 'MO');

    return isChinese;
  }

  /*计算文字宽宽高*/
  static Size boundingTextSize(
      BuildContext context, String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        locale: Localizations.localeOf(context),
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  // /*修改状态栏颜色*/
  // changeStatusBarStyle({required SystemUiOverlayStyle style}) {
  //   SystemChrome.setSystemUIOverlayStyle(style);
  // }

  /*获取屏幕宽度*/
  double getScreenWidth() {
    return MediaQueryData.fromView(window).size.width;
  }

  /*获取屏幕底部安全距离*/
  double getBottomSafeArea() {
    return MediaQueryData.fromView(window).padding.bottom;
  }

  ///获取当前context

  static getCurrentContext(
      {Function(BuildContext context)? completionHandler}) {
    Future.delayed(const Duration(seconds: 0), () async {
      BuildContext context = navigatorKey.currentState!.overlay!.context;
      completionHandler?.call(context);
    });
  }

  ///获取启动路由
  Future<String> getLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isShowPrivacy =
        preferences.getBool(TBDefVal.isShowPrivacyAlert) ?? true;
    String basePath = TBRouterPath.chatDetPath;
    if (Platform.isAndroid) {
      if (isShowPrivacy == true) {
        basePath = TBRouterPath.basePrivacyPath;
      } else {
        basePath = TBRouterPath.chatDetPath;
      }
    }

    return basePath;
  }
  // ///获取启动路由
  // Future<String> getLoginState() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String isShowPrivacy = preferences.getString(TBDefVal.kToken) ?? '';
  //   final applyStatus = preferences.getInt(TBDefVal.kApplyStatus) ?? 0;
  //
  //   if (isShowPrivacy.isNotEmpty) {
  //     if (applyStatus == 2) {
  //       return TBRouterPath.chatDetPath;
  //     } else {
  //       return TBRouterPath.root;
  //     }
  //   } else {
  //     return TBRouterPath.loginPath;
  //   }
  // }

  ///弹框青上年模式
  Future<void> showTeenModelState(String subTtile) async {
    final TBMineLogic logic = Get.put(TBMineLogic());
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBTeenPassView shareModal = TBTeenPassView();
      shareModal.showPassView(context, logic, '解锁青少年模式', subTtile);
    });
  }

  /*图片展示widget*/
  static Widget imageWidget(
      {required String url,
      double? width,
      double? height,
      BoxFit? fit,
      Widget? placeholder}) {
    if (url.contains('http')) {
      return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => placeholder ?? const SizedBox(),
          errorWidget: (context, url, error) => const Icon(Icons.error));
    } else {
      return Image.asset(
        url.isEmpty ? TBAsset.icon_home_tiger : url,
        width: width,
        height: height,
        fit: fit,
      );
    }
  }

  /*获取性别num*/
  static int getGenderNumber({required String genderString}) {
    if (genderString == '男') {
      return 1;
    } else {
      return 0;
    }
  }

  /*获取性别string*/
  static String getGenderString({required int gender}) {
    if (gender == 1) {
      return '男';
    } else {
      return '女';
    }
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 11) {
      return phoneNumber;
    }
    String maskedPhoneNumber = phoneNumber.replaceRange(3, 7, '****');
    return maskedPhoneNumber;
  }

  /*flutter调用h5*/
  String flutterCallH5({required String h5Name, required var params}) {
    var jsonParams = jsonEncode(params);
    return "$h5Name('$jsonParams')";
  }

  /*本地图片转base64字符串*/
  Future<String> localImageToBase64(String path) async {
    ByteData bytes = await rootBundle.load(path);
    var buffer = bytes.buffer;
    String base64 = jsonEncode(Uint8List.view(buffer));
    return base64;
  }

  ///获取组件高度
  static double getHeightFromKey(GlobalKey key) {
    // 获取 key 关联的小部件位置信息
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    // 返回小部件的 高度
    return renderBox.size.height;
  }

  ///获取组件距屏幕顶部距离

  static double getTopDistanceFromKey(GlobalKey key) {
    // 获取 key 关联的小部件位置信息
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

    // 返回小部件的 top 距离屏幕顶部的距离
    return widgetPosition.dy;
  }

  ///获取组件距屏幕底部距离
  static double getBottomDistanceFromKey(GlobalKey key) {
    // 获取屏幕的高度
    double screenHeight = MediaQuery.of(key.currentContext!).size.height;

    // 获取 key 关联的小部件位置信息
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

    // 返回小部件的 bottom 距离屏幕底部的距离
    return screenHeight - (widgetPosition.dy + renderBox.size.height);
  }

  ///获取数组中的随机四个元素
  List<T> getRandomFour<T>(List<T> list) {
    final random = Random();
    final List<T> result = [];

    // 随机生成四个不重复的索引
    final Set<int> randomIndexes = Set();
    while (randomIndexes.length < 4 && randomIndexes.length < list.length) {
      final index = random.nextInt(list.length);
      randomIndexes.add(index);
    }
    // 根据随机索引获取元素并添加到结果列表中
    randomIndexes.forEach((index) {
      result.add(list[index]);
    });
    return result;
  }

  ///获取数组中的随机n个元素
  List<T> getRandomItems<T>(List<T>? list, int count) {
    if (list == null) {
      return [];
    }
    final random = Random();
    list.shuffle(random);
    final itemCount = count <= list.length ? count : list.length;

    return list.take(itemCount).toList();
  }

  /// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
  static Future<void> saveImage(String imageUrl, {bool isAsset = false}) async {
    try {
      if (imageUrl == null) {
        TBLoadingUtils.failure(text: '保存失败，图片不存在！');
        return;
      }

      bool isGranted = await TBPermissionManager.getStoragePermission(
          completionHandler: () async {});
      if (isGranted) {
        TBLoadingUtils.show();

        /// 保存的图片数据
        Uint8List imageBytes;

        if (isAsset == true) {
          /// 保存资源图片
          ByteData bytes = await rootBundle.load(imageUrl);
          imageBytes = bytes.buffer.asUint8List();
        } else {
          /// 保存网络图片
          var response = await Dio().get(imageUrl,
              options: Options(responseType: ResponseType.bytes));
          imageBytes = Uint8List.fromList(response.data);
        }

        /// 保存图片
        final result = await ImageGallerySaver.saveImage(imageBytes);

        TBLoadingUtils.hide();

        if (result == null || result == '') {
          TBLoadingUtils.failure(text: '图片保存失败');
        } else {
          TBLoadingUtils.success(text: '保存成功');
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class FileTypeResult {
  final bool isSupported;
  final String fileExtension;

  FileTypeResult(this.isSupported, this.fileExtension);
}
