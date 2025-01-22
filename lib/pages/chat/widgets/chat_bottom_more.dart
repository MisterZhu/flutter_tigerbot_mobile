import 'dart:io';

import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'chat_inspiration_content.dart';

class ChatBottomMore extends StatelessWidget {
  void Function()? refreshHandle;
  void Function()? photoHandle;
  void Function()? albumHandle;
  void Function()? fileHandle;

  ChatBottomMore(
      {this.refreshHandle,
      this.photoHandle,
      this.albumHandle,
      this.fileHandle});

  Widget moreItem(String imagePath, String text, Function() handle) {
    return GestureDetector(
      onTap: handle,
      child: Column(children: [
        Stack(alignment: Alignment.center, children: [
          Container(
              width: 66.w,
              height: 66.w,
              decoration: BoxDecoration(
                color: themed.theme_c.bgColorMild,
                borderRadius: BorderRadius.circular(8.r),
              )),
          Image.asset(
            "assets/images/chat/chat_more_$imagePath.png",
            width: 32.w,
            fit: BoxFit.fitWidth,
            color: themed.theme_c.iconColor, // 你想要的颜色
            colorBlendMode: BlendMode.srcIn, // 混合模式
          )
        ]),
        SizedBox(
          height: 14.w,
        ),
        Text(
          text,
          style: TextStyle(
              color: themed.theme_c.textColorMild,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // moreItem('inspiration', 'Inspiration'.tr, () {
        //   showModalBottomSheet(
        //       context: context,
        //       builder: (build) {
        //         return ChatInspirationContent();
        //       });
        // }),
        SizedBox(
          width: 10.w,
        ),
        moreItem('photo', 'Album'.tr, () {
          if (this.photoHandle != null) {
            this.photoHandle!();
          }
        }),
        SizedBox(
          width: 20.w,
        ),

        moreItem('camera', 'Camera'.tr, () async {
          if (this.albumHandle != null) {
            this.albumHandle!();
          }
        }),

        SizedBox(
          width: 20.w,
        ),
        moreItem('upload', 'File'.tr, () async {
          if (this.fileHandle != null) {
            this.fileHandle!();
          }
        }),
      ],
    );
  }
}
