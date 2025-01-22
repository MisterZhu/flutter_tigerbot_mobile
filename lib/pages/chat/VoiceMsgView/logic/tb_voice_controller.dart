import 'dart:async';
import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';
import '../../../../constant/tb_export_common.dart';
import '../../../../util/provider/chat_provider.dart';
import '../../../../util/request/http_request.dart';
import '../../../../util/tb_loading_utils.dart';
import '../../../../util/tb_utils.dart';

class TBVoiceController extends GetxController {
  /// 当path 为url   type为 url
  String audioPath = '';

  /// 当path 为本地地址 type为 file
  String audioType = 'file';

  /// 返回结果
  String result = '';
  bool isUp = false;
  FlutterPluginRecord? recordPlugin;
  bool inputVoice = false;
  bool showTool = false;
  bool showMore = false;

  @override
  onInit() {
    initVoice();
    super.onInit();
  }

  initVoice() {}

  startRecord() {
    print("开始录制");
  }

  changeInput() {
    inputVoice = !inputVoice;
    update([TBDefVal.kChatInput]);
  }

  stopRecord(String path, double audioTimeLength) {
    if (isUp) {
      print("------222222----取消发送");
    } else {
      print("----1111111------发送");
      sendHandle();
    }
  }

  Future sendHandle() async {
    TBLoadingUtils.show();
    TBHttpRequest.uploadAudioFile(
      filePath: audioPath,
      success: (value) {
        inputVoice = false;
        result = value['results'];
        update([TBDefVal.kChatInput]);
        TBUtils.getCurrentContext(completionHandler: (context) async {
          // UserInfoProvider userInfoProvider =
          // Provider.of(context, listen: false);
          ChatProvider chat = Provider.of<ChatProvider>(context, listen: false);
          chat.editText = result;
        });
      },
      failure: (value) {
        inputVoice = true;
        result = '';
      },
    );
  }

  ///播放语音的方法
  void play() {
    recordPlugin?.playByPath(audioPath, audioType);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
