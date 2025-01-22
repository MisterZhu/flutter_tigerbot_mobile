import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../util/provider/chat_provider.dart';
import '../../../util/provider/user_info_provider.dart';

class ChatBottomTool extends StatefulWidget {
  late void Function(bool) _mulConversation; // 多轮对话
  late void Function(bool) _exploreModel; // 探索

  ChatBottomTool({mulConversation, exploreModel})
      : this._mulConversation = mulConversation,
        this._exploreModel = exploreModel;

  @override
  State<ChatBottomTool> createState() => _ChatBottomToolState();
}

class _ChatBottomToolState extends State<ChatBottomTool> {
  Color itemBgColor = Colors.white;

  Widget _searchItem(
      String content, String imgPath, bool switchValue, Function switchHandle) {
    return Container(
      // width: 150.w,
      height: 42.h,
      decoration: BoxDecoration(
          color: Color(0xffF5F5F5), borderRadius: BorderRadius.circular(21.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.w,
          ),
          Image.asset(
            imagePath("chat", imgPath),
            width: 16.w,
          ),
          SizedBox(
            width: 6.w,
          ),
          Text(
            content,
            style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xff111111),
                fontWeight: FontWeight.w500),
          ),
          Consumer<ChatProvider>(
            builder: (ctx, chatProvider, child) {
              return Switch(
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xffFF98AC),
                  inactiveTrackColor: Colors.grey[300],
                  value: switchValue,
                  onChanged: (value) {
                    if (chatProvider.isStreamLoading) {
                      Fluttertoast.showToast(msg: 'Please wait'.tr, gravity: ToastGravity.CENTER);
                    } else {
                      switchHandle(value);
                    }
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _item(String content, Function tapHandle) {
    return Consumer<ChatProvider>(
      builder: (ctx, chat, child) {
        return GestureDetector(
          onTapDown: (details) {
            setState(() {
              itemBgColor = Color(0xffDFF9EC);
            });
          },
          onTapUp: (details) {
            setState(() {
              itemBgColor = Colors.white;
            });
          },
          onTap: () {
            if (chat.isStreamLoading) {
              Fluttertoast.showToast(msg: 'Please wait'.tr, gravity: ToastGravity.CENTER);
            } else {
              tapHandle();
            }
          },
          child: child,
        );
      },
      child: Container(
        height: 26.h,
        decoration: BoxDecoration(
            color: itemBgColor, borderRadius: BorderRadius.circular(13.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 10.w,
            ),
            // Image.asset("assets/images/chat/chat_tool_new.png", width: 16.w),
            SizedBox(
              width: 5.w,
            ),
            Text(
              content,
              style: TextStyle(fontSize: 12.sp),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    // if (chatProvider.isStreamLoading && !chatProvider.isStopGeneration) {
    //   return StopGeneration();
    // } else {
    return Container(
      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
      child: Consumer<UserInfoProvider>(builder: (context, userInfo, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _searchItem(
                'searchMode'.tr, "chat_search", userInfo.isSearchMode,
                (value) {
              this.widget._exploreModel(value);
              userInfo.searchMode = value;
              userInfo.localSave();
            }),
            SizedBox(
              width: 12.w,
            ),
            _searchItem('multipleRounds'.tr, "chat_new",
                userInfo.isMulConversation, (value) {
              this.widget._mulConversation(value);
              userInfo.mulConversation = value;
            }),
            // SizedBox(
            //   width: 15.w,
            // ),
            // _item(S.of(context).resetting, () {
            //   this.widget._newConversation();
            // })
          ],
        );
      }),
    );
    // }
  }
}
