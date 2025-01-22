import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constant/tb_export_common.dart';
import '../../model/chat_response_model.dart';

class ChatResponseItem extends StatelessWidget {
  ChatResponseItemModel itemModel;

  ChatResponseItem(this.itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: TBDefVal.chatBoxMaxWidth.w),
      // color: TBColors.buttonLine1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   itemModel.title,
          //   style: TextStyle(
          //       height: 1.5,
          //       fontSize: 10.sp,
          //       color: Color(0xffF5879B),
          //       fontWeight: FontWeight.w500),
          // ),
          // SizedBox(
          //   height: 5.h,
          // ),
          itemModel.title.isNotEmpty
              ? Text(
            itemModel.title,
            style: TextStyle(
                height: 1.5,
                fontSize: 10.sp,
                color: Color(0xffF5879B),
                fontWeight: FontWeight.w500),
          )
              : SizedBox(height: 0), // 如果title为空，使用SizedBox来占位，高度为0
          if (itemModel.title.isNotEmpty) // 只在title不为空时显示SizedBox
            SizedBox(
              height: 5.h,
            ),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: itemModel.time.isNotEmpty ? itemModel.time + " — " : "",
                style: TextStyle(fontSize: 10.sp, color: Colors.grey[700])),
            TextSpan(
                text: itemModel.description,
                style: TextStyle(
                    fontSize: 10.sp, color: Colors.black, height: 1.5))
          ])),
          SizedBox(
            height: 5.h,
          ),
          Text(
            itemModel.site,
            style: TextStyle(color: Colors.grey[700], fontSize: 11.sp),
          )
        ],
      ),
    );
  }
}
