import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ContentTop extends StatefulWidget {
  @override
  State<ContentTop> createState() => _ContentTopState();
}

class _ContentTopState extends State<ContentTop> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("TigetBot"),
          TextButton(
              onPressed: () {
                String? routePath = ModalRoute.of(context)?.settings.name;

                if (routePath != TBRouterPath.loginPath) {
                  // Get.toNamed("/login");
                  TBRouterHelper.pathPage(TBRouterPath.loginPath, null);

                }
              },
              child: Text(
                'login'.tr,
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }
}
