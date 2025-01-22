import 'dart:async';

import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/login/widgets/login_button.dart';
import 'package:TigerChat/util/mobile_code.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/request/http_request.dart';
import 'package:TigerChat/util/request/response/TBResponse.dart';
import 'package:TigerChat/widgets/agree_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../util/event/event_bus.dart';
import '../../../util/tb_utils.dart';
import '../../home/logic/tb_launch_logic.dart';
import '../login_logic.dart';
import 'login_code_verify.dart';

class LoginMessageContent extends StatefulWidget {
  @override
  State<LoginMessageContent> createState() => _LoginMessageContentState();
}

class _LoginMessageContentState extends State<LoginMessageContent> {
  String _area = "+86";

  String? _verificationText;
  int _seconds = 60;
  Timer? _t;
  bool _showCountDown = false;
  List<Object>? _cns;
  List<Object>? _ens;

  TextEditingController _codeController = TextEditingController();
  late FocusNode _codeFocusNode;

  TextEditingController _phoneController = TextEditingController();
  final TBLaunchLogic logic = Get.put(TBLaunchLogic());
  final TBLoginLogic logicLogin = Get.find<TBLoginLogic>();

  bool _checked = false;

  @override
  void initState() {
    super.initState();
    bus.on(TBDefVal.kCodeSucceedEvent, onEventCallback);
    _codeFocusNode = FocusNode();
    _verificationText = 'get MobileCode'.tr;

    _cns = mobileCode["cn"];
    _ens = mobileCode["en"];

    _codeController.addListener(() {
      String text = _codeController.text;
      if (text.length > 4) {
        _codeController.value = TextEditingValue(
          text: text.substring(0, 4),
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: 4,
            ),
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  sendVerification() async {
    if (_showCountDown) {
      return;
    }

    String phoneNum = _phoneController.value.text;
    if (phoneNum.isEmpty) {
      Fluttertoast.showToast(
          msg: 'phone_number_cannot_empty'.tr, gravity: ToastGravity.CENTER);
      return;
    }
    // 发送验证码
    TBResponse response = await TBHttpRequest.post(TBUrl.kSendCodeUrl, context,
        params: {"area": _area, "mobile": phoneNum});
    if (response.success == false) {
      Fluttertoast.showToast(
          msg: 'Failed_Please_try_again_later'.tr,
          gravity: ToastGravity.CENTER);
      return;
    }

    _showCountDown = true;
    Fluttertoast.showToast(
        msg: 'code_send_success'.tr, gravity: ToastGravity.CENTER);
    _seconds--;
    setState(() {
      _verificationText = "$_seconds s";
    });
    _t = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _seconds--;
      if (_seconds > 0) {
        setState(() {
          _verificationText = "$_seconds s";
        });
      } else {
        _t?.cancel();
        _showCountDown = false;
        _seconds = 60;
        setState(() {
          _verificationText = 'Resend_code'.tr;
        });
      }
    });
  }

  void onEventCallback(dynamic arg) {
    print('--------------Event callback triggered with argument: $arg');
    if (_showCountDown) {
      return;
    }
    _showCountDown = true;
    Fluttertoast.showToast(
        msg: 'code_send_success'.tr, gravity: ToastGravity.CENTER);
    _seconds--;
    setState(() {
      FocusScope.of(context).requestFocus(_codeFocusNode);
      _verificationText = "$_seconds s";
    });
    _t = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _seconds--;
      if (_seconds > 0) {
        setState(() {
          _verificationText = "$_seconds s";
        });
      } else {
        _t?.cancel();
        _showCountDown = false;
        _seconds = 60;
        setState(() {
          _verificationText = 'Resend_code'.tr;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Object>? areas = TBUtils.isChineseLan() ? _cns : _ens;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20.w,
                ),
                // Text(_area),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _area,
                    selectedItemBuilder: (context) => areas!.map((e) {
                      Map<String, String> item = e as Map<String, String>;
                      return Center(child: Text(item['areaCode']!));
                    }).toList(),
                    items: areas!.map((e) {
                      Map<String, String> item = e as Map<String, String>;
                      return DropdownMenuItem(
                        child: Text(item['areaName']!,
                            style: TextStyle(
                                color: item['areaCode'] == _area
                                    ? Color(0xff6B6B6B)
                                    : Color(0xffD4D4D4))),
                        value: item["areaCode"],
                      );
                    }).toList(),
                    onChanged: (value) {
                      print("value $value");
                      String dropValue = value ?? "+86";
                      setState(() {
                        _area = dropValue;
                      });
                    },
                    style: TextStyle(
                      color: themed.theme_c.textColor, // 设置最终展示的文本颜色
                      fontSize: 16.0.sp, // 可以设置其他文本样式属性
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.r),
                      hintText: 'Telephone_num'.tr,
                      hintStyle: TextStyle(color: Color(0xffD4D4D4)),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: themed.theme_c.textColor, // 设置最终展示的文本颜色
                      fontSize: 16.0.sp, // 设置文本的字体大小
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            alignment: Alignment.center,
            height: 52.w,
            decoration: BoxDecoration(
                color: themed.theme_c.fieldBgColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: TextField(
              // maxLength: 4,
              // maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.number,
              controller: _codeController,
              focusNode: _codeFocusNode,
              decoration: InputDecoration(
                suffixIcon: TextButton(
                  onPressed: () {
                    // 处理点击事件的逻辑
                    print('点击了[查看原文]');
                    if (_showCountDown) {
                      return;
                    }
                    String phoneNum = _phoneController.value.text;
                    if (phoneNum.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'phone_number_cannot_empty'.tr,
                          gravity: ToastGravity.CENTER);
                      return;
                    }
                    TBWebVerifyView shareModal = TBWebVerifyView();
                    logic.isFinish = false;
                    logic.isSuccessful = false;
                    shareModal.showTeenModel(context, _area, phoneNum);
                  },
                  // sendVerification,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      _verificationText ?? "",
                      style: TextStyle(color: themed.theme_c.buttonBgColor),
                    ),
                  ),
                ),
                contentPadding:
                    EdgeInsets.only(left: 20.w, right: 20.w, top: 14.w),
                hintText: 'mobileCodeLogin'.tr,
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

              String code = _codeController.value.text;
              String phone = _phoneController.value.text;

              if (phone.isEmpty) {
                Fluttertoast.showToast(msg: 'Telephone_number_is_empty'.tr);
                return;
              }

              if (code.isEmpty) {
                Fluttertoast.showToast(msg: 'Enter_4-digit_code'.tr);
                return;
              }

              // 验证码登录
              TBHttpResponse response = await TBHttpRequest.post(
                  TBUrl.kLoginCodeUrl, context, params: {
                "code": code,
                "mobile": phone,
                "area": _area,
                "accessSource": "app"
              }) as TBHttpResponse;
              if (response.success) {
                UserInfoProvider userInfo =
                    Provider.of<UserInfoProvider>(context, listen: false);
                userInfo.login(response.data, isLocalSave: true);
                Fluttertoast.showToast(msg: 'Login_successful'.tr);

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
            height: 10.h,
          ),
          AgreePolicy((value) {
            _checked = value;
            logicLogin.isAgree = _checked;
          })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _t?.cancel();
    _t = null;
    super.dispose();
    bus.off(TBDefVal.kCodeSucceedEvent);
    _codeFocusNode.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    print('-----------移除bus监听111');
  }
}
