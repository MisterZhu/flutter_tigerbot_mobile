import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';

import '../logic/tb_mine_logic.dart';

class MineSwitchItem extends StatelessWidget {
  final TBMineLogic logic = Get.put(TBMineLogic());

  final String? imagePath;
  final String? text;
  final Function(bool teenMode)? onTap;

  MineSwitchItem({super.key, this.imagePath, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
      child: Container(
        height: 56.w,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 5.w,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: themed.theme_c.bgColorMild),
        child: Row(
          children: [
            Image.asset(
              imagePath ?? '',
              width: 24.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              text ?? '',
              style:
                  TextStyle(fontSize: 16.sp, color: themed.theme_c.textColor),
            ),
            Spacer(),
            Switch(
              // This bool value toggles the switch.
              value: logic.isTeenModel,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                // logic.isTeenModel = value;
                // logic.update();
                if (onTap != null) {
                  onTap!(value);
                }
                // This is called when the user toggles the switch.
              },
            ),
          ],
        ),
      ),
    );
  }
}
