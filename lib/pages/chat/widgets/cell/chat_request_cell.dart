import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:TigerChat/constant/tb_export_common.dart';
import '../../../../util/provider/user_info_provider.dart';
import '../../../../widgets/cached_image.dart';
import '../../model/chat_request_model.dart';
import '../long_press_cell.dart';

class ChatRequestCell extends StatefulWidget {
  late ChatRequestModel? model;

  final Function()? deleteHandle;
  final Function()? mulChoiceHandle;
  final Function()? selectAllHandle;
  final Function(ChatRequestModel) onStateChanged;

  ChatRequestCell(this.model,
      {this.deleteHandle,
      this.mulChoiceHandle,
      this.selectAllHandle,
      required this.onStateChanged,
      Key? key})
      : super(key: key);

  @override
  State<ChatRequestCell> createState() => _ChatRequestCellState();
}

class _ChatRequestCellState extends State<ChatRequestCell> {
  final GlobalKey itemKey = GlobalKey();
  double? itemHeight; // 用于保存高度

  Widget _content(bool isEdit) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: isEdit
              ? (TBDefVal.chatBoxMaxWidth - TBDefVal.chatLRMargin).w
              : TBDefVal.chatBoxMaxWidth.w),
      padding: EdgeInsets.only(left: 12.r, top: 8.r, bottom: 12.r, right: 12.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
          color: themed.theme_c.bgColorAsk),
      child: Text(
        this.widget.model?.content ?? "",
        style: TextStyle(
            letterSpacing: TBDefVal.chatWordSpacing, // 调整字符间距的值，可以为负数以减小间距
            color: themed.theme_c.textColorAsk,
            fontSize: TBDefVal.chatRegularFont.sp,
            fontWeight: FontWeight.w500,
            height: TBDefVal.chatFontSpanHeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("-----response build request");
    if ((this.widget.model?.height ?? 0) < 20) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final RenderBox? renderBox =
            itemKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          itemHeight = renderBox.size.height;
          print("-----itemHeight request = $itemHeight");
          this.widget.model?.height = itemHeight;
          // widget.onStateChanged(this.widget.model!);
        }
      });
    }
    return Container(
      key: itemKey,
      child: Padding(
        padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
        child: Consumer<ChatProvider>(
          builder: (context, chat, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // chat.isEditMode
                //     ? Checkbox(
                //         value: this.widget.model?.isEditSelected ?? false,
                //         // fillColor: MaterialStateProperty.all(Color(0xffD4D4D4)),
                //         activeColor: Color(0xffFF98AC),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(4.r),
                //         ),
                //         onChanged: (value) {
                //           setState(() {
                //             this.widget.model?.isEditSelected = value;
                //             widget.onStateChanged(this.widget.model!);
                //           });
                //         })
                //     : SizedBox(),
                // SizedBox(
                //   width: TBDefVal.margin.w,
                // ),
                Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     chat.editText = this.widget.model?.content ?? "";
                //   },
                //   child: Container(
                //     padding: EdgeInsets.only(top: 5.w, right: 5.w),
                //     child: Image.asset(
                //       "assets/images/chat/chat_request_edit.png",
                //       width: 20.w,
                //     ),
                //   ),
                // ),
                LongPressCell(
                    child: _content(chat.isEditMode),
                    deleteHandle: this.widget.deleteHandle,
                    tapHandle: () {
                      chat.editText = this.widget.model?.content ?? "";
                    },
                    mulChoiceHandle: this.widget.mulChoiceHandle,
                    selectAllHandle: this.widget.selectAllHandle),
                SizedBox(
                  width: TBDefVal.margin.w,
                ),
                // GestureDetector(
                //   onTap: () {
                //     // Get.toNamed("/mine");
                //     TBRouterHelper.pathPage(TBRouterPath.minePath, null);
                //   },
                //   child: Consumer<UserInfoProvider>(
                //     builder: (ctx, userInfo, child) {
                //       return ClipOval(
                //         child: CachedImage(
                //           width: TBDefVal.chatHeaderWidth.w,
                //           height: TBDefVal.chatHeaderWidth.w,
                //           imageUrl: userInfo.avatar,
                //           fit: BoxFit.cover,
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }
}
