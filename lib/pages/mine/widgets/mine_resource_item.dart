import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/tb_colors.dart';
import '../../../constant/tb_export_common.dart';

class MineResourceItem extends StatelessWidget {
  final String title;

  final Widget child;

  const MineResourceItem({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(maxWidth: 100.w),
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                title,
                style:
                    TextStyle(color: themed.theme_c.textColor, fontSize: 16.sp),
              ),
            ),
          ),
          Expanded(
            child: child,
            flex: 2,
          ),
          SizedBox(width: 20.w),
          // Padding(
          //   padding: EdgeInsets.only(left: 20.w, right: 20.w),
          //   child: Image.asset(
          //     "assets/images/common/common_right_arrow.png",
          //     width: 8.w,
          //     fit: BoxFit.contain,
          //   ),
          // ),
        ],
      ),
    );
  }
}
