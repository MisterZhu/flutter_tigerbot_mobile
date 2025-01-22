import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:TigerChat/constant/tb_export_common.dart';
import '../../../../util/provider/user_info_provider.dart';
import '../../../../widgets/cached_image.dart';
import '../../model/chat_request_model.dart';
import '../../ShareView/logic/tb_share_image_logic.dart';

class TBShareRequestCell extends StatefulWidget {
  late ChatRequestModel? model;

  final Function()? deleteHandle;
  final Function()? mulChoiceHandle;
  final Function()? selectAllHandle;
  final Function(ChatRequestModel) onStateChanged;

  TBShareRequestCell(this.model,
      {this.deleteHandle,
      this.mulChoiceHandle,
      this.selectAllHandle,
      required this.onStateChanged,
      Key? key})
      : super(key: key);

  @override
  State<TBShareRequestCell> createState() => _TBShareRequestCellState();
}

class _TBShareRequestCellState extends State<TBShareRequestCell> {
  final TBShareImageLogic logic = Get.find<TBShareImageLogic>();

  Widget _content(bool isEdit) {
    print("111111logic.chatBoxMaxWidth.w = ${logic.chatBoxMaxWidth}");
    return Container(
      constraints: BoxConstraints(maxWidth: logic.chatBoxMaxWidth.w + 12.w),
      padding: EdgeInsets.only(
          left: 10.r * logic.zoomRatio,
          top: 10.r * logic.zoomRatio,
          bottom: 10.r * logic.zoomRatio,
          right: 5.r * logic.zoomRatio),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r * logic.zoomRatio),
            bottomLeft: Radius.circular(15.r * logic.zoomRatio),
            bottomRight: Radius.circular(15.r * logic.zoomRatio),
          ),
          color: themed.theme_c.bgColorAsk),
      child: Text(
        this.widget.model?.content ?? "",
        style: TextStyle(
            letterSpacing: 0.7, // 调整字符间距的值，可以为负数以减小间距
            color: themed.theme_c.textColorAsk,
            fontSize: logic.chatRegularFont.sp,
            fontWeight: FontWeight.w500,
            height: TBDefVal.chatFontSpanHeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            right: TBDefVal.margin.w * logic.zoomRatio,
            top: 8.w * logic.zoomRatio,
            bottom: 8.w * logic.zoomRatio),
        child: Consumer<ChatProvider>(
          builder: (context, chat, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _content(false),
              ],
            );
          },
        ),
      ),
    );
  }
}
