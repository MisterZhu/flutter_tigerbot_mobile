import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginButton extends StatelessWidget {
  void Function() loginHandle;

  LoginButton({required this.loginHandle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: MediaQuery.of(context).size.width - 70.w,
      child: TextButton(
        onPressed: loginHandle,
        child: Text(
          'login'.tr,
          style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.r))),
            backgroundColor:
                MaterialStateProperty.all(themed.theme_c.buttonBgColor),
            foregroundColor:
                MaterialStateProperty.all(themed.theme_c.buttonColor)),
      ),
    );
  }
}
