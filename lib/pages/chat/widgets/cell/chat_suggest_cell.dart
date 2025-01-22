import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constant/tb_export_common.dart';
import '../../../../util/tb_utils.dart';
import '../../logic/tb_chat_detail_logic.dart';

class ChatSuggestCell extends StatelessWidget {
  void Function(String) searchHandle;

  ChatSuggestCell({required this.searchHandle, Key? key}) : super(key: key);
  final TBChatDetailLogic logicDet = Get.put(TBChatDetailLogic());

  @override
  Widget build(BuildContext context) {
    //print("logicDet.dataList = ${logicDet.dataList?.length}");
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
        child: Consumer<ChatProvider>(
          builder: (context, chat, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   width: TBDefVal.chatLRMargin.w,
                // ),
                SizedBox(
                  width: TBDefVal.margin.w,
                ),
                Container(
                    width: TBDefVal.chatBoxMaxWidth.w,
                    // height: 210.w,
                    padding: EdgeInsets.only(
                        left: 10.w, top: 10.w, bottom: 16.w, right: 10.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                        color: themed.theme_c.bgColorAns),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Example：".tr,
                                style: TextStyle(
                                  color: themed.theme_c.textColorMild,
                                  fontSize: TBDefVal.chatRegularFont.sp,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 4.0.w), // 右边距为10.0.w（根据需要调整）
                                child: InkWell(
                                  onTap: () {
                                    // 在这里添加按钮点击时要执行的操作
                                    logicDet.exampleChange();
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: Image.asset(
                                          "assets/images/chat/chat_change.png", // 替换为您的图像路径
                                          width: 20.0,
                                          height: 20.0,
                                          color: themed
                                              .theme_c.textColor, // 你想要的颜色
                                          colorBlendMode:
                                              BlendMode.srcIn, // 混合模式
                                        ),
                                      ),
                                      SizedBox(width: 5.0.w), // 图标和文本之间的间隔
                                      Text(
                                        "Change".tr, // 替换为按钮文本
                                        style: TextStyle(
                                          color:
                                              themed.theme_c.textColor, // 文本颜色
                                          fontSize:
                                              TBDefVal.chatRegularFont, // 文本大小
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ListView.builder(
                        //   padding: EdgeInsets.zero,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true, // 禁止内部ListView.builder滚动
                        //   itemCount: logicDet.randomList?.length,
                        //   itemBuilder: (context, index) {
                        //     final itemData = logicDet.randomList?[index];
                        //     String key =
                        //         TBUtils.isChineseLan() ? "title" : "title_en";
                        //     var realKey = TBUtils.isChineseLan()
                        //         ? "question_cn"
                        //         : "question_en";
                        //     final text = itemData![key];
                        //     final realText = itemData![realKey];
                        //
                        //     return Column(
                        //       children: [
                        //         SizedBox(height: 8.h), // 添加间隔
                        //         GestureDetector(
                        //           onTap: () {
                        //             // searchHandle(realText as String);
                        //             chat.editText = realText ?? "";
                        //           },
                        //           child: Container(
                        //             alignment: Alignment.centerLeft,
                        //             padding: EdgeInsets.only(
                        //                 left: 8.w,
                        //                 top: 8.w,
                        //                 bottom: 8.w,
                        //                 right: 8.w),
                        //             width: 320.w,
                        //             // color: themed.theme_c.bgColorEx,
                        //             decoration: BoxDecoration(
                        //               color: themed.theme_c.bgColorEx,
                        //               borderRadius: BorderRadius.circular(
                        //                   6.r), // 设置圆角半径为5像素
                        //             ),
                        //             child: Text(
                        //               text,
                        //               style: TextStyle(
                        //                 color: themed.theme_c.textColorMild,
                        //                 fontSize: TBDefVal.chatTipsFont.sp,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // )
                      ],
                    ))
                // _content,
              ],
            );
          },
        ),
      ),
    );
  }
}
