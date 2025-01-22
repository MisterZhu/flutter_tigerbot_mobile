import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/request/sc_http_manager.dart';
import '../../../util/request/tb_url.dart';
import '../../../util/provider/user_info_provider.dart';
import '../../../util/request/http_request.dart';
import '../../../util/request/response/TBResponse.dart';
import '../../../util/tb_loading_utils.dart';
import '../../../util/tb_utils.dart';
import '../model/tb_applyinfo_model.dart';

class TBLaunchLogic extends GetxController {
  TBApplyInfoModel? infoModel;

  /// 权限状态 applyStatus: 0, // WAIT_APPLY(0,"待申请"), WAIT_AUDIT(1,"待审核"), PASS(2,"已通过"), REFUSE(3,"不通过"),
  int applyStatus = 4;
  String inviteCode = '';
  String phoneNum = '';
  String emailNum = '';
  String organiName = '';
  String useWay = '';

  /// 是否加载完成
  bool isFinish = false;
  bool isSuccessful = false;

  List<bool> selectedItems = [false, false, false, false];

  @override
  onInit() {
    super.onInit();
    requestKeyView(() {}, () {});
    TBUtils.getCurrentContext(completionHandler: (context) async {
      UserInfoProvider userInfo =
          Provider.of<UserInfoProvider>(context, listen: false);
      phoneNum = userInfo.mobile;
    });
    SCHttpManager.init();
  }

  Future<void> updateScHttp() async {
    SCHttpManager.init();
  }

  /// 获取用户状态
  Future<void> requestKeyView(
      void Function() onSuccess, void Function() onFailure) async {
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response =
          await TBHttpRequest.post(TBUrl.kApplyInfoUrl, context, params: null)
              as TBHttpResponse;
      if (response.success) {
        infoModel = TBApplyInfoModel.fromJson(response.data);
        print("infoModel11 = ${infoModel?.applyStatus}");
        applyStatus = infoModel?.applyStatus ?? 0;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(TBDefVal.kApplyStatus, applyStatus);

        update();

        // 调用成功回调函数
        onSuccess();
      } else {
        // 处理请求失败的逻辑

        // 调用失败回调函数
        onFailure();
      }
    });
  }

  /// 获取用户信息
  Future<void> getUserInfo(
      void Function() onSuccess, void Function() onFailure) async {
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response =
          await TBHttpRequest.post(TBUrl.kUserInfoUrl, context, params: null)
              as TBHttpResponse;
      if (response.success) {
        UserInfoProvider userInfo =
            Provider.of<UserInfoProvider>(context, listen: false);
        userInfo.login(response.data, isLocalSave: true);
        phoneNum = userInfo.mobile;

        // 调用成功回调函数
        onSuccess();
      } else {
        // 处理请求失败的逻辑

        // 调用失败回调函数
        onFailure();
      }
    });
  }

  /// 邀请码申请
  requestInviteCode() {
    var params = {
      'inviteCode': inviteCode,
    };
    TBLoadingUtils.show();
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response = await TBHttpRequest.post(
          TBUrl.kInviteCodeUrl, context,
          params: params) as TBHttpResponse;
      if (response.success) {
        TBLoadingUtils.hide();
        TBLoadingUtils.info(text: "Submit successfully".tr);

        requestKeyView(() {}, () {});
      } else {
        TBLoadingUtils.hide();
      }
    });
  }

  /// 内测申请
  requestTestApply() {
    if (phoneNum.isEmpty) {
      Fluttertoast.showToast(
        msg: 'phone_number_cannot_empty'.tr,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    if (organiName.isEmpty) {
      Fluttertoast.showToast(
        msg: 'enterpriseIsEmpty'.tr,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    useWay = "";
    for (int i = 0; i < selectedItems.length; ++i) {
      if (selectedItems[i]) {
        if (i == 0) {
          useWay = TBUtils.isChineseLan() ? '闲聊' : 'chat';
        } else if (i == 1) {
          useWay =
              useWay + ',' + (TBUtils.isChineseLan() ? '文本创作' : 'Creation');
        } else if (i == 2) {
          useWay = useWay + ',' + (TBUtils.isChineseLan() ? '编码' : 'Coding');
        } else {
          useWay = useWay + ',' + (TBUtils.isChineseLan() ? '其他' : 'Other');
        }
      }
    }
    if (useWay.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Use Select at least one'.tr,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    var params = {
      'mobile': phoneNum,
      'useWay': useWay,
      'entity': organiName,
      'email': emailNum,
    };
    print("params = $params");
    TBRouterHelper.back(null);

    TBLoadingUtils.show();
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response =
          await TBHttpRequest.post(TBUrl.kTestApplyUrl, context, params: params)
              as TBHttpResponse;
      if (response.success) {
        TBLoadingUtils.hide();
        TBLoadingUtils.info(text: "Submit successfully".tr);
        requestKeyView(() {}, () {});
      } else {
        TBLoadingUtils.hide();
      }
    });
  }
}
