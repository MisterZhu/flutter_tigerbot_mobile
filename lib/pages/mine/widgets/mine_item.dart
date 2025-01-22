import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/tb_export_common.dart';

class MineItem extends StatelessWidget {
  final String? imagePath;
  final String? text;
  final String? rightText;

  final Function()? onTap;

  MineItem({super.key, this.imagePath, this.text, this.rightText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          height: 56.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              if (rightText != null && rightText!.isNotEmpty)
                Text(
                  rightText!,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              SizedBox(
                width: 8.w,
              ),
              Image.asset(
                'assets/images/common/common_right_arrow.png',
                width: 8.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
