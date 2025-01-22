import 'package:TigerChat/pages/login/widgets/login_message_content.dart';
import 'package:TigerChat/pages/login/widgets/login_psd_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../constant/tb_export_common.dart';
import '../../generated/assets.dart';
import '../../util/request/http_request.dart';
import '../../util/request/response/TBResponse.dart';
import '../../util/request/tb_url.dart';
import '../../util/wechat/tb_wechat_utils.dart';
import 'login_logic.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TBLoginLogic logic = Get.put(TBLoginLogic());

  TabController? _tabController;
  bool _canBack = true;
  bool _isWeChatInstalled = false;

  @override
  void initState() {
    super.initState();
    _tabController = null;
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    dynamic params = Get.arguments;
    debugPrint('webView接收的参数：$params');
    if (params != null && params.isNotEmpty) {
      _canBack = params?['canBack'] ?? true;
    }

    _initializeWeChat();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TBHttpResponse response = await TBHttpRequest.post(
              TBUrl.kKeyViewUrl, context, params: {"key": "cases"})
          as TBHttpResponse;
      if (response.success) {
      } else {}
    });
  }

  Future<void> _initializeWeChat() async {
    await TBWeChatUtils.instance.initBase();

    bool isWeChatInstalled = await TBWeChatUtils.instance.isInstalledWeChat();
    setState(() {
      _isWeChatInstalled = isWeChatInstalled;
    });
  }

  void _loginWithWeChat() {
    TBWeChatUtils.instance.loginWithWeChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(children: [
          Image.asset(themed.getBgImagePath(), fit: BoxFit.fitWidth),
          Column(
            children: [
              Row(
                children: [
                  _canBack
                      ? GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 60.w, left: 15.w),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 20.r,
                            ),
                          ),
                        )
                      : Container(
                          height: 80.0.w,
                        ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 40.w),
                child: Column(
                  children: [
                    TabBar(
                      indicatorPadding: EdgeInsets.only(
                          bottom: -10.w, right: 15.w, left: 15.w),
                      indicatorWeight: 4.w,
                      indicatorColor: themed.theme_c.buttonBgColor,
                      labelStyle: TextStyle(fontSize: 22.sp),
                      labelColor: themed.theme_c.textColor,
                      unselectedLabelStyle: TextStyle(fontSize: 18.sp),
                      unselectedLabelColor: themed.theme_c.textColor,
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        // S.of(context).mobileCodeLogin,
                        // S.of(context).passwordLogin
                        'mobileCodeLogin'.tr,
                        'passwordLogin'.tr
                      ].map((f) {
                        return Center(
                          child: new Text(
                            f,
                          ),
                        );
                      }).toList(),
                    ),
                    Container(
                      height: 400.w,
                      padding: EdgeInsets.only(top: 30.r),
                      child: TabBarView(
                        controller: _tabController,
                        children: [LoginMessageContent(), LoginPsdContent()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isWeChatInstalled)
            Positioned(
              bottom: 150.0.h, // 距离底部150像素
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // Add your onTap code here!
                    print('Icon tapped');
                    if (!logic.isAgree) {
                      Fluttertoast.showToast(
                          msg:
                              'Please_check_User_Agreement_and_Privacy_Agreement'
                                  .tr,
                          gravity: ToastGravity.CENTER);
                      return;
                    }
                    _loginWithWeChat();
                  },
                  child: IntrinsicWidth(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: TBColors.color_F8F8F8,
                        borderRadius: BorderRadius.circular(24
                            .w), // Adjust the border radius to match the image
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w), // Add horizontal padding
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Ensure Row only takes the necessary space
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the children horizontally
                            children: [
                              Image.asset(
                                Assets
                                    .loginWechatIcon, // Add your WeChat icon asset here
                                width: 24.w,
                                height: 24.w,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'wechat_login'.tr, // WeChat Login
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
