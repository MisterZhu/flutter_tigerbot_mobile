import 'package:TigerChat/constant/tb_default_value.dart';
import 'package:TigerChat/util/request/response/TBResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant/tb_export_common.dart';
import '../../util/provider/user_info_provider.dart';
import '../../util/request/http_request.dart';
import '../../util/tb_loading_utils.dart';
import '../../util/tb_utils.dart';
import '../home/logic/tb_launch_logic.dart';

/// 用户协议和隐私政策的GetXController

class TBLoginLogic extends GetxController {
  /// 是否同意相关协议，默认不同意
  bool isAgree = false;

  @override
  onInit() {
    super.onInit();
  }

  ///微信登录
  wechatLogin(String code) async {
    final TBLaunchLogic logicLaunch = Get.put(TBLaunchLogic());

    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBLoadingUtils.show();

      try {
        TBHttpResponse response =
            await TBHttpRequest.post(TBUrl.kLoginWechatUrl, context, params: {
          "appId": TBDefVal.kWeChatAppId,
          "wechatCode": code,
          // "accessSource": "app"
        }) as TBHttpResponse;

        if (response.success) {
          UserInfoProvider userInfo =
              Provider.of<UserInfoProvider>(context, listen: false);
          userInfo.login(response.data, isLocalSave: true);
          // Map<String, dynamic> user = response.data['user'];
          // String? mobile = user['mobile'];
          await logicLaunch.updateScHttp();
          TBLoadingUtils.hide();

          if (userInfo.mobile != null && userInfo.mobile.isNotEmpty) {
            Fluttertoast.showToast(msg: 'Login successful'.tr);
            await logicLaunch.requestKeyView(
              () {
                // 这里是在requestKeyView请求成功后执行的逻辑
                if (logicLaunch.applyStatus == 2) {
                  TBRouterHelper.pathOffAllPage(TBRouterPath.chatDetPath, null);
                } else {
                  TBRouterHelper.pathOffAllPage(TBRouterPath.root, null);
                }
              },
              () {
                // 这里是在requestKeyView请求失败后执行的逻辑
                TBRouterHelper.pathOffAllPage(TBRouterPath.root, null);
                // 处理失败逻辑
              },
            );
          } else {
            TBRouterHelper.pathOffAllPage(TBRouterPath.bindMobile, null);
          }
        } else {
          TBLoadingUtils.hide();

          Fluttertoast.showToast(msg: response.msg);
        }
      } catch (error) {
        TBLoadingUtils.hide();

        // 处理捕获到的其他错误，如网络异常等
        print('----------- 发生错误: $error');
        TBLoadingUtils.info(text: 'Wechat login failed'.tr);
      }
    });
  }
}
