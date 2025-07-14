import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constant/tb_export_common.dart';
import '../../model/chat_response_model.dart';

class ChatResponseSearchItem extends StatelessWidget {
  ChatResponseItemModel itemModel;

  ChatResponseSearchItem(this.itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(maxWidth: (TBDefVal.screenWidth - 35).w),
      // color: TBColors.buttonLine1,
      child: Column(
        mainAxisSize: MainAxisSize.min, // 让Column自适应高度
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
              ? InkWell(
                  onTap: itemModel.uri.isNotEmpty
                      ? () {
                          var params = {
                            "title": itemModel.title,
                            "url": itemModel.uri
                          };
                          TBRouterHelper.pathPage(
                              TBRouterPath.webViewPath, params);
                        }
                      : null,
                  child: Text(
                    itemModel.title,
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 10.sp,
                        color: themed.theme_c.buttonBgColor,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : SizedBox(height: 0), // 如果title为空，使用SizedBox来占位，高度为0
          if (itemModel.title.isNotEmpty) // 只在title不为空时显示SizedBox
            SizedBox(
              height: 5.h,
            ),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: itemModel.time.isNotEmpty ? itemModel.time + " — " : "",
                  style: TextStyle(fontSize: 10.sp, color: Colors.white)),
              TextSpan(
                  text: itemModel.description,
                  style: TextStyle(
                      fontSize: 10.sp, color: Colors.white, height: 1.5)),
              itemModel.uri.isNotEmpty && itemModel.title.isEmpty
                  ? TextSpan(
                      text: '  [查看原文]',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: themed.theme_c.buttonBgColor,
                        height: 1.5,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // 处理点击事件的逻辑
                          print('点击了[查看原文]');
                          var params = {"title": "原文", "url": itemModel.uri};
                          TBRouterHelper.pathPage(
                              TBRouterPath.webViewPath, params);
                        },
                    )
                  : TextSpan(), // 添加一个空的TextSpan以满足InlineSpan的要求
            ]),
            maxLines: 6, // 设置最大行数为3
            overflow: TextOverflow.ellipsis, // 超出部分显示省略号
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            itemModel.site,
            style: TextStyle(color: TBColors.color_B0B6BF, fontSize: 11.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
