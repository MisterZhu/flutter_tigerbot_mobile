import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../util/popup_window.dart';
import '../VoiceMsgView/logic/tb_voice_controller.dart';
import '../VoiceMsgView/view/tb_voice_widget.dart';
import '../logic/tb_chat_detail_logic.dart';
import 'Chat_bottom_tool.dart';
import 'chat_bottom_more.dart';
import 'chat_input_file.dart';

class ChatInput extends StatefulWidget {
  int maxLines = 1;

  // String? text;

  late void Function(String) handle;

  void Function()? refreshHandle;

  void Function(bool)? mulConversionHandle;

  void Function(bool)? searchModelHandle;

  void Function(String)? changeHandle;
  final TBVoiceController controller;

  ChatInput(
      {required this.controller,
      required this.handle,
      this.changeHandle,
      this.mulConversionHandle,
      this.searchModelHandle,
      required this.refreshHandle,
      this.maxLines = 1});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  // late bool _showMore;
  // late bool _showTool;
  late bool _showAdd;
  final GlobalKey _key = GlobalKey();
  final TBChatDetailLogic logicDet = Get.put(TBChatDetailLogic());

  @override
  void initState() {
    super.initState();
    widget.controller.showMore = false;
    widget.controller.showTool = false;
    _showAdd = true;

    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          if (widget.controller.showMore && _focusNode.hasFocus) {
            widget.controller.showMore = false;
          }
          if (widget.controller.showTool && _focusNode.hasFocus) {
            widget.controller.showTool = false;
          }
        });
      });

    _textEditingController = TextEditingController()
      ..addListener(() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _showAdd = _textEditingController.text.isBlank ?? false;
          });
        });
      });
  }

  searchHandle(bool isLogin, String searchContent) {
    if (!isLogin) {
      // Get.toNamed("/login");
      TBRouterHelper.pathPage(TBRouterPath.loginPath, null);

      return;
    }
    String content = searchContent.trim();
    if (content.isEmpty) {
      Fluttertoast.showToast(
          msg: 'no content'.tr, gravity: ToastGravity.CENTER);
    } else {
      widget.handle(content);
      this._textEditingController.clear();
    }
  }

  // void showPopup() {
  //   // 创建一个 FixedExtentScrollController，用于控制选项滚动
  //   print('logicDet.onlineSearch = ${logicDet.onlineSearch}');
  //
  //   var selectIndex = logicDet.onlineSearch ? 1 : 0;
  //   if (logicDet.documentAnalysis) {
  //     selectIndex = 2;
  //   }
  //   if (logicDet.imageGeneration) {
  //     selectIndex = 3;
  //   }
  //   print('selectIndex = $selectIndex');
  //
  //   final controller = FixedExtentScrollController(
  //       initialItem: selectIndex); // 将 initialItem 设置为所需的索引
  //   // 显示模态底部表单
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 300,
  //         child: Column(
  //           children: <Widget>[
  //             // 添加一个顶部的灰色条
  //             Container(
  //               height: 50,
  //               color: Colors.transparent,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   TextButton(
  //                     child: Text(
  //                       '取消',
  //                       style: TextStyle(
  //                           fontSize: 16.sp,
  //                           color: themed.theme_c.textColorAns,
  //                           fontWeight: FontWeight.w500),
  //                     ),
  //                     onPressed: () => TBRouterHelper.back(null),
  //                   ),
  //                   TextButton(
  //                     child: Text(
  //                       '确定',
  //                       style: TextStyle(
  //                           fontSize: 16.sp,
  //                           color: themed.theme_c.textColorAns,
  //                           fontWeight: FontWeight.w500),
  //                     ),
  //                     onPressed: () {
  //                       print('selectIndex11111 = $selectIndex');
  //                       logicDet.changeSessionType(selectIndex);
  //                       widget.controller.update([TBDefVal.kChatInput]);
  //                       TBRouterHelper.back(null);
  //                       // Navigator.pop(context);
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // 添加一个单列选择器
  //             Expanded(
  //               child: CupertinoPicker(
  //                 scrollController: controller,
  //                 itemExtent: 50, // 每个选项的高度
  //                 onSelectedItemChanged: (int index) {
  //                   // 处理选中项的变化
  //                   // ...
  //                   print("index = $index");
  //                   selectIndex = index;
  //                 },
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: EdgeInsets.only(left: 140.w),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           imagePath("chat", "chat_search_msg31"),
  //                           width: 22.w,
  //                           height: 22.w,
  //                           color: themed.theme_c.textColorAns, // 你想要的颜色
  //                           colorBlendMode: BlendMode.srcIn, // 混合模式
  //                         ),
  //                         SizedBox(width: 8),
  //                         Text(
  //                           '默认',
  //                           style: TextStyle(
  //                               fontSize: 16.sp,
  //                               color: themed.theme_c.textColorAns,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(left: 140.w),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           imagePath("chat", "chat_search_earth31"),
  //                           width: 22.w,
  //                           height: 22.w,
  //                           color: themed.theme_c.textColorAns, // 你想要的颜色
  //                           colorBlendMode: BlendMode.srcIn, // 混合模式
  //                         ),
  //                         SizedBox(width: 8),
  //                         Text(
  //                           '联网模式',
  //                           style: TextStyle(
  //                               fontSize: 16.sp,
  //                               color: themed.theme_c.textColorAns,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(left: 140.w),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           imagePath("chat", "chat_search_file31"),
  //                           width: 22.w,
  //                           height: 22.w,
  //                           color: themed.theme_c.textColorAns, // 你想要的颜色
  //                           colorBlendMode: BlendMode.srcIn, // 混合模式
  //                         ),
  //                         SizedBox(width: 8),
  //                         Text(
  //                           '文件对话',
  //                           style: TextStyle(
  //                               fontSize: 16.sp,
  //                               color: themed.theme_c.textColorAns,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(left: 140.w),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           imagePath("chat", "chat_search_picture31"),
  //                           width: 22.w,
  //                           height: 22.w,
  //                           color: themed.theme_c.textColorAns, // 你想要的颜色
  //                           colorBlendMode: BlendMode.srcIn, // 混合模式
  //                         ),
  //                         SizedBox(width: 8),
  //                         Text(
  //                           '文生图',
  //                           style: TextStyle(
  //                               fontSize: 16.sp,
  //                               color: themed.theme_c.textColorAns,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    return Consumer<UserInfoProvider>(
      builder: (ctx, userInfo, child) {
        return Column(
          children: [
            Row(
              children: [
                // InkWell(
                //   key: _key,
                //   onTap: () {
                //     // setState(() {
                //     //   _showMore = false;
                //     //   _showTool = !_showTool;
                //     // });
                //     if (logicDet.isLogin == false) {
                //       TBRouterHelper.pathPage(TBRouterPath.loginPath, null);
                //       return;
                //     }
                //     if (chatProvider.isStreamLoading) {
                //       Fluttertoast.showToast(
                //           msg: 'Please wait'.tr, gravity: ToastGravity.CENTER);
                //       return;
                //     }
                //     widget.controller.showMore = false;
                //     widget.controller.showTool = false;
                //
                //     widget.controller.update([TBDefVal.kChatInput]);
                //     // showPopup();
                //     if (logicDet.onlineSearch) {
                //       logicDet.changeSessionType(1);
                //       widget.controller.update([TBDefVal.kChatInput]);
                //     } else {
                //       logicDet.changeSessionType(0);
                //       widget.controller.update([TBDefVal.kChatInput]);
                //     }
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(4.0), // 调整内边距以增大点击范围
                //     child: Opacity(
                //       opacity: TBDefVal.opacity80,
                //       child: Image.asset(
                //         imagePath("chat", "chat_search_earth"),
                //         // logicDet.getSessionImgPath(),
                //         width: 24.w,
                //         color: logicDet.onlineSearch
                //             ? themed.theme_c.buttonBgColor
                //             : themed.theme_c.iconColor, // 你想要的颜色
                //         colorBlendMode: BlendMode.srcIn, // 混合模式
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   width: 8.w,
                // ),
                InkWell(
                  onTap: () {
                    if (logicDet.isLogin == false) {
                      TBRouterHelper.pathPage(TBRouterPath.loginPath, null);
                      return;
                    }
                    if (chatProvider.isStreamLoading) {
                      Fluttertoast.showToast(
                          msg: 'Please wait'.tr, gravity: ToastGravity.CENTER);
                      return;
                    }
                    widget.controller.changeInput();
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // 调整半径以扩大点击范围
                  ),
                  child: Container(
                    padding: EdgeInsets.all(4.0), // 调整内边距以增大点击范围
                    child: Opacity(
                      opacity: TBDefVal.opacity80,
                      child: Image.asset(
                        imagePath(
                            "chat",
                            widget.controller.inputVoice
                                ? 'chat_input_keyboard'
                                : 'chat_input_voice'),
                        width: 24.w,
                        color: themed.theme_c.iconColor, // 你想要的颜色
                        colorBlendMode: BlendMode.srcIn, // 混合模式
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                widget.controller.inputVoice
                    ? Container(
                        padding: EdgeInsets.only(left: 1.w),
                        width: TBDefVal.chatTextWidth.w,
                        child: TBVoiceWidget(
                          startRecord: this.widget.controller.startRecord,
                          stopRecord: this.widget.controller.stopRecord,
                          // 加入定制化Container的相关属性
                          height: 50.0,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(left: 10.w),
                        width: TBDefVal.chatTextWidth.w,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: themed.theme_c.bgColorBub, width: 1),
                            color: themed.theme_c.bgColorAns,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatInputFile(),
                            Row(
                              children: [
                                Consumer<ChatProvider>(
                                    builder: (context, chatProvider, child) {
                                  if (chatProvider.editText.isNotEmpty) {
                                    _textEditingController.text =
                                        chatProvider.editText;
                                    _focusNode.requestFocus();
                                    chatProvider.editText = '';
                                  }
                                  return Container(
                                    width: (TBDefVal.chatTextWidth - 45).w,
                                    // width: logicDet.documentAnalysis
                                    //     ? (TBDefVal.chatTextWidth - 45).w
                                    //     : (TBDefVal.chatTextWidth - 21).w,
                                    child: TextField(
                                        minLines: 1,
                                        maxLines: 5,
                                        focusNode: _focusNode,
                                        style: TextStyle(
                                          letterSpacing: TBDefVal
                                              .chatWordSpacing, // 调整字符间距的值，可以为负数以减小间距
                                        ),
                                        onChanged: (value) {
                                          if (widget.changeHandle != null) {
                                            widget.changeHandle!(value);
                                          }
                                        },
                                        controller: _textEditingController,
                                        onSubmitted: (value) {
                                          searchHandle(userInfo.isLogin, value);
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter'.tr,
                                          hintStyle: TextStyle(
                                              color:
                                                  themed.theme_c.textColorPlace,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp),
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        )),
                                  );
                                }),
                              ],
                            ),
                          ],
                        )),
                SizedBox(
                  width: 8.w,
                ),
                GestureDetector(
                    child: _buildImageBasedOnCondition(
                        logicDet, _textEditingController),
                    onTap: () {
                      if (chatProvider.isStreamLoading) {
                        Fluttertoast.showToast(
                            msg: 'Please wait'.tr,
                            gravity: ToastGravity.CENTER);
                        return;
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_textEditingController.text.isEmpty) {
                        setState(() {
                          widget.controller.showTool = false;
                          widget.controller.showMore =
                              !widget.controller.showMore;
                        });
                      } else {
                        searchHandle(userInfo.isLogin,
                            this._textEditingController.value.text);
                      }
                    })
              ],
            ),
            SizedBox(
              height: widget.controller.showMore ? 20.w : 0,
            ),
            if (widget.controller.showMore)
              ChatBottomMore(
                refreshHandle: () {
                  if (this.widget.refreshHandle != null) {
                    this.widget.refreshHandle!();
                  }
                },
                photoHandle: () {
                  logicDet.selectImageFromGallery();
                },
                albumHandle: () {
                  logicDet.captureImageWithCamera();
                },
                fileHandle: () {
                  logicDet.selectFile();
                },
              )
            else if (widget.controller.showTool)
              ChatBottomTool(
                mulConversation: (value) {
                  if (this.widget.mulConversionHandle != null) {
                    this.widget.mulConversionHandle!(value);
                  }
                },
                exploreModel: (value) {
                  if (this.widget.searchModelHandle != null) {
                    this.widget.searchModelHandle!(value);
                  }
                },
              )
            else
              SizedBox()
          ],
        );
      },
    );
  }

  Image _buildImageBasedOnCondition(
      TBChatDetailLogic logicDet, TextEditingController textEditingController) {
    // if (!logicDet.documentAnalysis) {
    //   return Image.asset(
    //     themed.getSendImagePath(),
    //     width: 24.w,
    //   );
    // } else
    if (textEditingController.text.isEmpty) {
      return Image.asset(
        "assets/images/chat/chat_input_add.png",
        width: 24.w,
        color: themed.theme_c.iconColor, // 你想要的颜色
        colorBlendMode: BlendMode.srcIn, // 混合模式
      );
    } else {
      return Image.asset(
        themed.getSendImagePath(),
        width: 24.w,
      );
    }
  }
}

class TBSelectModel {
  final String iconData; // 左侧图标
  final String displayName; // 文本
  bool isSelect; // 是否选中

  TBSelectModel({
    required this.iconData,
    required this.displayName,
    this.isSelect = false, // 默认未选中
  });
}
