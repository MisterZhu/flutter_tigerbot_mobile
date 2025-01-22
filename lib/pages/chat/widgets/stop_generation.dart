import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../util/tb_utils.dart';
import '../logic/tb_chat_detail_logic.dart';

class StopGeneration extends StatelessWidget {
  const StopGeneration({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ChatProvider chatProvider =
            Provider.of<ChatProvider>(context, listen: false);
        final TBChatDetailLogic logicDet = Get.put(TBChatDetailLogic());

        if (!chatProvider.isStopGeneration) {
          chatProvider.stopGeneration = true;
          logicDet.isStopGeneration = true;
          chatProvider.streamLoading = false;
          logicDet.disTimer();
        }
      },
      child: Container(
        width: TBUtils.isChineseLan() ? 106.w : 146.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: Colors.transparent, // 去掉背景色
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
          border: Border.all(
            color: themed.theme_c.iconColor, // 设置边框颜色
            width: 1.0, // 设置边框宽度
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 12.w,
            ),
            Image.asset(
              "assets/images/chat/chat_detail_stop.png",
              width: 12.w,
              color: themed.theme_c.iconColor, // 你想要的颜色
              colorBlendMode: BlendMode.srcIn, // 混合模式
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              'Stop generation…'.tr,
              style:
                  TextStyle(fontSize: 12.sp, color: themed.theme_c.iconColor),
            )
          ],
        ),
      ),
    );
  }
}
