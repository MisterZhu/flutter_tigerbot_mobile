import 'package:get/get.dart';

import '../customscaffold/sc_scaffold_controller.dart';
import '../pages/chat/ShareView/logic/tb_share_image_logic.dart';
import '../pages/chat/VoiceMsgView/logic/tb_voice_controller.dart';
import '../pages/chat/logic/tb_chat_detail_logic.dart';
import '../pages/home/logic/tb_launch_logic.dart';
import '../pages/mine/logic/tb_mine_logic.dart';

/// 首页-binding
class TBAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TBShareImageLogic>(() => TBShareImageLogic());
    Get.lazyPut<TBChatDetailLogic>(() => TBChatDetailLogic());
    Get.lazyPut<TBLaunchLogic>(() => TBLaunchLogic());
    Get.lazyPut<TBMineLogic>(() => TBMineLogic());
    Get.lazyPut<SCCustomScaffoldController>(() => SCCustomScaffoldController());
    Get.lazyPut(() => SCCustomScaffoldController());
    Get.lazyPut<TBVoiceController>(() => TBVoiceController());
  }
}
