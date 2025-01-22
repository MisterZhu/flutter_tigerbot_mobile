import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatResponseLoadingCell extends StatelessWidget {
  ChatResponseLoadingCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SpinKitWave(
              color: themed.theme_c.themeOppoColor,
              size: 15.0.r,
              itemCount: 6,
            ),
            SizedBox(
              height: 6.w,
            ),
            Text(
              'Thinking, please wait a moment'.tr,
              style: TextStyle(
                  color: themed.theme_c.textColorMild, fontSize: 12.sp),
            )
          ],
        ),
      ),
    );
  }
}
