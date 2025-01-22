import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/tb_export_common.dart';
import '../../../util/common_tools.dart';

/// 应用列表-第一套皮肤

class TBLaunchReview extends StatelessWidget {

  final int? applyState;

  /// 按钮点击事件
  final Function(int type)? itemTapAction;

  TBLaunchReview({Key? key, required this.applyState, this.itemTapAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body();
  }
  Widget body() {
    return Column(
      children: [
        // 上方是一个左图右文
        Container(
          margin: EdgeInsets.only(
              left: 25.w, right: 25.w, top: 12.w, bottom: 12.w), // 适当调整边距
          child: Row(
            children: [
              // 左图
              // Image.asset('your_image_path.png', width: 100, height: 100),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 19.w,
              ),
              // 右文
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text(
                    'noAccess'.tr,
                    style: TextStyle(fontSize: 14),
                    maxLines: 2, // 最多两行
                    overflow: TextOverflow.ellipsis, // 超出两行的文本用省略号表示
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(
              left: 25.w, right: 25.w, top: 12.w, bottom: 12.w), // 适当调整边距
          child: Row(
            children: [
              // 左图
              // Image.asset('your_image_path.png', width: 100, height: 100),
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 19.w,
              ),
              // 右文
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text(
                    'applyWaitingTip'.tr,
                    style: TextStyle(fontSize: 14),
                    maxLines: 2, // 最多两行
                    overflow: TextOverflow.ellipsis, // 超出两行的文本用省略号表示
                  ),
                ),
              ),
            ],
          ),
        ),
        // 下方是两个并排的按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 第二个按钮
            Container(
              width: 260.w,
              height: 48.w,
              margin: EdgeInsets.symmetric(horizontal: 10.w), // 调整按钮之间的间距
              child: ElevatedButton(
                onPressed: () {
                  // 处理按钮点击事件
                  if (itemTapAction != null) {
                    itemTapAction?.call(1);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      TBDefVal.chatThemePinkColor), // 背景色为粉色
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0.w), // 8像素的圆角
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color: Colors.white, // 边框颜色为蓝色
                      width: 2.w, // 边框宽度为2
                    ),
                  ),
                ),
                child: Text(
                  'inviteCode'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}