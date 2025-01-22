import 'package:TigerChat/pages/chat/widgets/chat_input.dart';
import 'package:TigerChat/pages/chat/widgets/stop_generation.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';

import '../../../constant/tb_default_value.dart';
import '../../../constant/tb_export_common.dart';
import '../VoiceMsgView/logic/tb_voice_controller.dart';

class ChatBottom extends StatefulWidget {
  late void Function(String) _searchHandle; // 搜索
  late void Function(bool) _searchModelHandle; // 探索模式

  late void Function() _newConversation; // 重新对话
  late void Function(bool) _mulConversation; // 多轮对话

  ChatBottom(
      {searchHandle,
      newConversation,
      searchModelHandle,
      mulConversation,
      refreshHandle})
      : this._searchHandle = searchHandle,
        this._searchModelHandle = searchModelHandle,
        this._newConversation = newConversation,
        this._mulConversation = mulConversation;

  @override
  State<ChatBottom> createState() => _ChatBottomState();
}

class _ChatBottomState extends State<ChatBottom> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chat, child) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            chat.isStreamLoading && !chat.isStopGeneration
                ? StopGeneration()
                : SizedBox(),
            SizedBox(
              height: chat.isStreamLoading && !chat.isStopGeneration ? 15.w : 0,
            ),
            Container(
              color: themed.theme_c.bgColor,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: GetBuilder<TBVoiceController>(
                        id: TBDefVal
                            .kChatInput, // 添加id绑定，update时只当前GetBuilder会刷新
                        // global: true, // 添加 global 参数，使其全局监听 影响性能
                        builder: (state) {
                          return ChatInput(
                            controller: state,
                            maxLines: 5,
                            handle: widget._searchHandle,
                            refreshHandle: widget._newConversation,
                            mulConversionHandle: widget._mulConversation,
                            searchModelHandle: widget._searchModelHandle,
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
