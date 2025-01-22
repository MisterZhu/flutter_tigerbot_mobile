import 'dart:async';
import 'dart:io'; // 导入dart:io库，获取正确的File类
import 'dart:typed_data';

import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/tb_default_value.dart';
import '../../pages/login/login_logic.dart';
import '../tb_loading_utils.dart';

class TBWeChatUtils {
  factory TBWeChatUtils() => _instance;
  static TBWeChatUtils get instance => _instance;
  static final TBWeChatUtils _instance = TBWeChatUtils._internal();
  static late Fluwx _fluwx;
  static bool _isInitialized = false; // 添加初始化标志

  TBWeChatUtils._internal() {
    print("---------------------一也可初始化---------------");
  }

  // 获取 Fluwx 实例
  Fluwx get fluwx => _fluwx;

  /// 初始化
  Future initBase() async {
    if (_isInitialized) return; // 避免重复初始化

    print("---------------------initBase---------------");

    _fluwx = Fluwx();
    await initScaffold();
    // 监听微信登录回调
    // 设置初始化标志
  }

  /// 初始化scaffold数据
  Future initScaffold() async {
    print("---------------------registerApi---------------");
    _fluwx.registerApi(
      appId: TBDefVal.kWeChatAppId,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: TBDefVal.kWeChatUniversalLink,
    );
    _fluwx.addSubscriber((response) {
      if (response is WeChatAuthResponse) {
        print('WeChat login success, code: ${response.code}');
        print('WeChat login success, state: ${response.state}');
        print('WeChat login success, state: ${response.errCode}');

        print('WeChat login success,: ${response}');

        // setState(() {
        //   _result = 'state :${response.state} \n code:${response.code}';
        // });
        final code = response.code ?? '';
        if (code == '' || code.isEmpty) {
          TBLoadingUtils.info(text: 'Wechat login failed'.tr);
        } else {
          final TBLoginLogic logicLogin = Get.find<TBLoginLogic>();
          logicLogin.wechatLogin(code);
        }
      }
    });
    _isInitialized = true;
  }

  /// 是否安装微信
  Future<bool> isInstalledWeChat() async {
    final bool installed = await _fluwx.isWeChatInstalled;
    return installed;
  }

  /// 发起微信登录
  void loginWithWeChat() {
    _fluwx.authBy(
        which: NormalAuth(
            scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test'));
  }

  /// 分享Binary图片到 会话-朋友圈
  Future<void> shareBinaryImage(Uint8List source, {int sceneValue = 0}) async {
    final bool installed = await _fluwx.isWeChatInstalled;
    if (!installed) {
      // 微信未安装的处理
      TBLoadingUtils.info(text: TBDefVal.unInstallWeChatTip);
      return;
    }
    await _fluwx.share(WeChatShareImageModel(WeChatImage.binary(source),
        scene: sceneValue == 0 ? WeChatScene.session : WeChatScene.timeline));
  }

  /// 分享Asset图片到 会话-朋友圈
  Future<void> shareAssetImage(String source, {int sceneValue = 0}) async {
    final bool installed = await _fluwx.isWeChatInstalled;
    if (!installed) {
      // 微信未安装的处理
      TBLoadingUtils.info(text: TBDefVal.unInstallWeChatTip);
      return;
    }
    await _fluwx.share(WeChatShareImageModel(WeChatImage.asset(source),
        scene: sceneValue == 0 ? WeChatScene.session : WeChatScene.timeline));
  }

  /// 分享File图片到 会话-朋友圈
  Future<void> shareFileImage(File source, {int sceneValue = 0}) async {
    final bool installed = await _fluwx.isWeChatInstalled;
    if (!installed) {
      // 微信未安装的处理
      TBLoadingUtils.info(text: TBDefVal.unInstallWeChatTip);
      return;
    }
    await _fluwx.share(WeChatShareImageModel(WeChatImage.file(source),
        scene: sceneValue == 0 ? WeChatScene.session : WeChatScene.timeline));
  }

  /// 分享NetWork图片到 会话-朋友圈
  Future<void> shareNetWorkImage(String source, {int sceneValue = 0}) async {
    final bool installed = await _fluwx.isWeChatInstalled;
    if (!installed) {
      // 微信未安装的处理
      TBLoadingUtils.info(text: TBDefVal.unInstallWeChatTip);
      return;
    }
    await _fluwx.share(WeChatShareImageModel(WeChatImage.network(source),
        scene: sceneValue == 0 ? WeChatScene.session : WeChatScene.timeline));
  }
}
