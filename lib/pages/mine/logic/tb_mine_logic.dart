import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';

import '../../../util/request/tb_url.dart';
import '../../../util/provider/user_info_provider.dart';
import '../../../util/request/http_request.dart';
import '../../../util/request/response/TBResponse.dart';
import '../../../util/tb_loading_utils.dart';
import '../../../util/tb_utils.dart';

class TBMineLogic extends GetxController {
  String passWord = '';
  bool isTeenModel = false;
  bool isShowCode = true;
  TextEditingController textEditingController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    // TBUtils.getCurrentContext(completionHandler: (context) async {
    //   UserInfoProvider userInfo =
    //       Provider.of<UserInfoProvider>(context, listen: false);
    //   phoneNum = userInfo.mobile;
    // });
    searchTeenMode();
    print('-----------------searchTeenMode1');
  }

  /// 查询青少年模式
  searchTeenMode() {
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response = await TBHttpRequest.post(
          TBUrl.kSearchTeenModeUrl, context,
          params: null) as TBHttpResponse;
      if (response.success) {
        print('isTeenModel = ${response.data}');
        isTeenModel = response.data;
        update();
      }
    });
  }

  /// 开启青少年模式
  openTeenMode() {
    String inputText = textEditingController.text;
    if (inputText.isEmpty) {
      TBLoadingUtils.info(text: "Please_enter_password".tr);
      return;
    }
    var params = {
      'teenPassword': inputText,
    };
    TBLoadingUtils.show();
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response = await TBHttpRequest.post(
          TBUrl.kOpenTeenModeUrl, context,
          params: params) as TBHttpResponse;
      if (response.success) {
        TBLoadingUtils.hide();
        TBLoadingUtils.success(text: "青少年模式已开启");
        TBRouterHelper.back(null);
        searchTeenMode();
        print('-----------------searchTeenMode2');
      } else {
        TBLoadingUtils.hide();
      }
    });
  }

  /// 关闭青少年模式
  closeTeenMode() {
    print(textEditingController.text);
    String inputText = textEditingController.text;
    if (inputText.isEmpty) {
      TBLoadingUtils.info(text: "Please_enter_password".tr);
      return;
    }
    var params = {
      'teenPassword': inputText,
    };
    TBLoadingUtils.show();
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response = await TBHttpRequest.post(
          TBUrl.kCloseTeenModeUrl, context,
          params: params) as TBHttpResponse;
      if (response.success) {
        TBLoadingUtils.hide();
        TBLoadingUtils.success(text: "青少年模式已关闭");
        TBRouterHelper.back(null);

        searchTeenMode();
        print('-----------------searchTeenMode3');
      } else {
        TBLoadingUtils.hide();
      }
    });
  }
}
