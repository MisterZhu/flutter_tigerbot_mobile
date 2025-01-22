import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../chat/chat_detail_page.dart';

class HomeChatPage extends StatefulWidget {
  const HomeChatPage({Key? key}) : super(key: key);

  @override
  _HomeChatPageState createState() => _HomeChatPageState();
}

class _HomeChatPageState extends State<HomeChatPage>
    with AutomaticKeepAliveClientMixin {
  // 缓存页面
  @override
  bool get wantKeepAlive => true;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  onSubmitted(String value, bool isSearchMode) {
    FocusScope.of(context).requestFocus(FocusNode());
    UserInfoProvider userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    if (!userInfoProvider.isLogin) {
      // Get.toNamed("/login");
      TBRouterHelper.pathPage(TBRouterPath.loginPath, null);

      return;
    }
    if (value == null || value.isEmpty) {
      Fluttertoast.showToast(
          msg: 'no content'.tr, gravity: ToastGravity.CENTER);
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return ChatDetailPage(
        keyword: value,
      );
      // return ChatDetailPage(keywo, isSearchMode);
    }));
  }

  Widget get _center {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 120.h + MediaQuery.of(context).padding.top,
          ),
          Image.asset(
            imagePath("home", "icon_home_tiger"),
            width: 80.w,
          ),
          SizedBox(
            height: 40.h,
          ),
          Consumer<UserInfoProvider>(
            builder: (key, userInfo, child) {
              return Container(
                width: 335.w,
                height: 56.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                        child: TextField(
                            maxLines: 1,
                            focusNode: _focusNode,
                            controller: _textEditingController,
                            onSubmitted: (value) {
                              onSubmitted(value, userInfo.isSearchMode);
                            },
                            decoration: InputDecoration(
                              hintText: 'Ask something'.tr,
                              hintStyle: TextStyle(
                                  color: Color(0xffD4D4D4),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                              border: InputBorder.none,
                            ))),
                    GestureDetector(
                      onTap: () {
                        onSubmitted(
                            _textEditingController.text, userInfo.isSearchMode);
                      },
                      child: Image.asset(
                        imagePath("home", "icon_home_send"),
                        width: 24.w,
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 80.h,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: TBDefVal.chatBGColor,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: _center,
        ),
      ),
    );
  }
}
