import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/chat/chat_detail_page.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/request/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../util/request/response/TBResponse.dart';
import '../../../widgets/agree_policy.dart';
import '../../home/logic/tb_launch_logic.dart';
import '../login_logic.dart';
import 'login_button.dart';

class LoginPsdContent extends StatefulWidget {
  @override
  State<LoginPsdContent> createState() => _LoginPsdContentState();
}

class _LoginPsdContentState extends State<LoginPsdContent> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _psdController = TextEditingController();
  final TBLaunchLogic logic = Get.put(TBLaunchLogic());

  String? _psdErrorText;

  String? _accountErrorText;
  final TBLoginLogic logicLogin = Get.find<TBLoginLogic>();

  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
            alignment: Alignment.center,
            height: 52.w,
            decoration: BoxDecoration(
                color: themed.theme_c.fieldBgColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: TextField(
              controller: _accountController,
              decoration: InputDecoration(
                errorText: _accountErrorText,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10.h),
                hintText: 'Telephone_number_is_empty'.tr,
                hintStyle: TextStyle(color: Color(0xffD4D4D4)),

                // hintText: S.of(context).loginAccount,
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: themed.theme_c.textColor, // 设置最终展示的文本颜色
                fontSize: 16.0.sp, // 设置文本的字体大小
              ),
            ),
          ),
          SizedBox(
            height: 15.w,
          ),
          Container(
            alignment: Alignment.center,
            height: 52.w,
            decoration: BoxDecoration(
                color: themed.theme_c.fieldBgColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: TextField(
              controller: _psdController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                errorText: _psdErrorText,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10.h),
                // hintText: S.of(context).loginPassword,
                hintText: 'Please_enter_password'.tr,
                hintStyle: TextStyle(color: Color(0xffD4D4D4)),

                border: InputBorder.none,
              ),
              style: TextStyle(
                color: themed.theme_c.textColor, // 设置最终展示的文本颜色
                fontSize: 16.0.sp, // 设置文本的字体大小
              ),
            ),
          ),
          SizedBox(
            height: 40.w,
          ),
          LoginButton(
            loginHandle: () async {
              FocusScope.of(context).requestFocus(FocusNode());

              if (!_checked) {
                Fluttertoast.showToast(
                    msg: 'Please_check_User_Agreement_and_Privacy_Agreement'.tr,
                    gravity: ToastGravity.CENTER);
                return;
              }

              String account = _accountController.value.text;
              String psd = _psdController.value.text;

              if (account.isEmpty) {
                setState(() {
                  _accountErrorText = 'Account_cannot_be_empty'.tr;
                });
                return;
              } else {
                setState(() {
                  _accountErrorText = null;
                });
              }

              if (psd.isEmpty) {
                setState(() {
                  _psdErrorText = 'Password_cannot_be_empty'.tr;
                });
                return;
              }

              if (psd.length < 6) {
                setState(() {
                  _psdErrorText = "密码不能小于6位";
                });
                return;
              }
              setState(() {
                _psdErrorText = null;
              });

              TBHttpResponse response = await TBHttpRequest.post(
                  TBUrl.kLoginPasswordUrl, context, params: {
                "mobile": account,
                "password": psd,
                "accessSource": "app"
              }) as TBHttpResponse;

              if (response.success) {
                UserInfoProvider userInfo =
                    Provider.of<UserInfoProvider>(context, listen: false);
                userInfo.login(response.data, isLocalSave: true);
                Fluttertoast.showToast(msg: 'Login successful'.tr);
                await logic.updateScHttp();
                await logic.requestKeyView(
                  () {
                    // 这里是在requestKeyView请求成功后执行的逻辑
                    if (logic.applyStatus == 2) {
                      TBRouterHelper.pathOffAllPage(
                          TBRouterPath.chatDetPath, null);
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
              }
            },
          ),
          SizedBox(
            height: 10.w,
          ),
          AgreePolicy((value) {
            _checked = value;
            logicLogin.isAgree = _checked;
          })
        ],
      ),
    );
  }
}
