import 'package:TigerChat/pages/chat/model/chat_request_file_model.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../long_press_cell.dart';
import '../../../../constant/tb_export_common.dart';

class ChatRequestFileCell extends StatefulWidget {
  late ChatRequestFileModel? model;

  final Function()? deleteHandle;
  final Function()? mulChoiceHandle;
  final Function()? selectAllHandle;
  final Function(ChatRequestFileModel) onStateChanged;

  ChatRequestFileCell(this.model,
      {this.deleteHandle,
      this.mulChoiceHandle,
      this.selectAllHandle,
      required this.onStateChanged,
      Key? key})
      : super(key: key);

  @override
  State<ChatRequestFileCell> createState() => _ChatRequestFileCellState();
}

class _ChatRequestFileCellState extends State<ChatRequestFileCell> {
  final GlobalKey itemKey = GlobalKey();
  double? itemHeight; // 用于保存高度
  Widget _content(bool isEditModel) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: isEditModel
              ? (TBDefVal.chatFileBoxMaxWidth - 40).w
              : TBDefVal.chatFileBoxMaxWidth.w),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
          border: Border.all(color: themed.theme_c.fileColorBor),
          color: Colors.transparent),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                this.widget.model?.fileTypeImagePath ?? "",
                width: TBDefVal.chatHeaderWidth.w,
                height: TBDefVal.chatHeaderWidth.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model?.content ?? '',
                      style: TextStyle(
                          color: themed.theme_c.iconColor,
                          fontSize: 12.sp,
                          overflow: TextOverflow.ellipsis, // 超出部分省略号显示
                          fontWeight: FontWeight.normal),
                      maxLines: 1, // 最多显示1行，可根据实际情况调整
                    ),
                    Text(
                      "${widget.model?.fileTypeStr}",
                      style: TextStyle(
                          color: themed.theme_c.textColorMild, fontSize: 10.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          itemKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        itemHeight = renderBox.size.height;
        //print("itemHeight = $itemHeight");
        this.widget.model?.height = itemHeight;
        // widget.onStateChanged(this.widget.model!);

        // widget.onChangedHeight(this.widget.model!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: itemKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ChatProvider>(
          builder: (context, chat, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chat.isEditMode
                    ? Checkbox(
                        value: this.widget.model?.isEditSelected ?? false,
                        // fillColor: MaterialStateProperty.all(Color(0xffD4D4D4)),
                        activeColor: Color(0xff5FC896),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        onChanged: (value) {
                          setState(() {
                            this.widget.model?.isEditSelected = value;
                            widget.onStateChanged(this.widget.model!);
                          });
                        })
                    : SizedBox(),
                Spacer(),
                LongPressCell(
                    child: _content(chat.isEditMode),
                    deleteHandle: this.widget.deleteHandle,
                    mulChoiceHandle: this.widget.mulChoiceHandle,
                    selectAllHandle: this.widget.selectAllHandle),
                SizedBox(
                  width: 4.w,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
