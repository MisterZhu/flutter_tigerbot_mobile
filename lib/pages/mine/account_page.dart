import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/request/response/TBResponse.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../util/request/http_request.dart';

class AccountPage extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();

  cancellationRequest(BuildContext context) async {
    if (_textEditingController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please fill in the reason for cancellation'.tr);
      return;
    }

    TBHttpResponse response = await TBHttpRequest.post(
        TBUrl.kIssuesUrl, context, params: {
      "type": "unregister",
      "title": "",
      "content": _textEditingController.text
    }) as TBHttpResponse;
    // print("response ${response.code}");
    if (response.code == 0) {
      Get.back();
      Fluttertoast.showToast(
          msg: 'Cancellation successful'.tr, gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset(
              themed.getBgImagePath(), fit: BoxFit.fitWidth,
// 混合模式
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 20.w,
              child: GestureDetector(
                child: Image.asset(
                  Assets.commonCommonBackIcon,
                  width: 24.w,
                  color: themed.theme_c.textColor, // 你想要的颜色
                  colorBlendMode: BlendMode.srcIn,
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ),
            Consumer<UserInfoProvider>(
              builder: (ctx, userInfo, child) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 155.w + MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.r),
                        child: Text('Logout warning prompt'.tr),
                      ),
                      SizedBox(
                        height: 55.w,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.w),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        'Account cancellation'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    content: Container(
                                      height: 150.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Are you sure to cancel your account?'
                                                  .tr),
                                          SizedBox(
                                            height: 20.w,
                                          ),
                                          Container(
                                            height: 100.w,
                                            child: TextField(
                                                // minLines: 1,
                                                maxLines: 10,
                                                controller:
                                                    _textEditingController,
                                                onSubmitted: (value) {
                                                  // searchHandle(userInfo.isLogin, value);
                                                },
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Write your message'.tr,
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffD4D4D4),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.r)),
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1, //宽度为5
                                                      )),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Cancel'.tr)),
                                      TextButton(
                                          onPressed: () async {
                                            cancellationRequest(context);
                                            // Navigator.of(context).popUntil(
                                            //     (route) => route.isFirst);
                                            // userInfo.logout();
                                            // eventBus.fire(Logout());
                                            // Fluttertoast.showToast(
                                          },
                                          child: Text(
                                            'Confirm1'.tr,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            height: 46.w,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                color: themed.theme_c.buttonBgColor),
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Account cancellation'.tr,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      backgroundColor:
                                          themed.theme_c.buttonBgColor,
                                      color: themed.theme_c.buttonColor),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
