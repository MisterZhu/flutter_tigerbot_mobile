import 'package:TigerChat/constant/tb_default_value.dart';
import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/tb_asset.dart';
import '../../../../constant/tb_colors.dart';
import '../logic/tb_privacy_logic.dart';
import '../view/sc_privacy_alert.dart';

/// 用户协议与隐私政策弹窗-page
class SCPrivacyAlertPage extends StatelessWidget {
  TBPrivacyLogic state = Get.put(TBPrivacyLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  /// body
  Widget body() {
    return Stack(
      children: [
        Image.asset(
          TBAsset.launcherBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        maskItem(),
        privacyAlertItem()
      ],
    );
  }

  /// 半透明背景蒙层
  Widget maskItem() {
    return Container(
      width: double.infinity,
      color: TBColors.color_000000.withOpacity(0.5),
    );
  }

  /// 协议弹窗
  Widget privacyAlertItem() {
    return GetBuilder<TBPrivacyLogic>(builder: (state) {
      return SCBasicPrivacyAlert(
        isAgree: state.isAgree,
        titleString: state.title,
        contentString: state.content,
        descriptionString: state.description,
        cancelAction: () {
          // Fluttertoast.showToast(
          //     msg: TBDefVal.canUseAppMessage, gravity: ToastGravity.CENTER);
          SystemNavigator.pop(); // 退出应用
        },
        sureAction: () async {
          if (state.isAgree == true) {
            SharedPreferences preference =
                await SharedPreferences.getInstance();
            preference.setBool(TBDefVal.isShowPrivacyAlert, false);
            // SCJPush.initJPush();
            TBRouterHelper.pathOffAllPage(TBRouterPath.loginPath, null);
          } else {
            Fluttertoast.showToast(
                msg: TBDefVal.agreeUserAgreementMessage,
                gravity: ToastGravity.CENTER);
          }
        },
        agreeAction: () {
          state.updateAgreementState();
        },
        agreementDetailAction: (String? title, String url) {
          TBRouterHelper.pathPage(TBRouterPath.webViewPath,
              {"title": title, "url": url, "removeLoginCheck": true});
        },
      );
    });
  }
}
