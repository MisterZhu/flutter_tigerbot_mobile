import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/widgets/dash_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatNewCell extends StatelessWidget {
  final time;

  ChatNewCell(this.time, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: DashLine(
            color: themed.theme_c.textColorPlace,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Image.asset(
          "assets/images/chat/chat_new_icon.png",
          width: 32.w,
          height: 32.w,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'newChat'.tr,
          style:
              TextStyle(color: themed.theme_c.textColorMild, fontSize: 12.sp),
        )
      ],
    );
  }
}
