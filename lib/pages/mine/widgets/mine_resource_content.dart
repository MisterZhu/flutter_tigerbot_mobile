import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/mine/widgets/mine_resource_item.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MineResourceContent extends StatelessWidget {
  const MineResourceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(builder: (context, userInfo, child) {
      return Container(
        color: themed.theme_c.bgColor,
        child: Column(
          children: [
            MineResourceItem(
              title: 'Username'.tr,
              child: Text(userInfo.uuid,
                  style: TextStyle(
                      color: themed.theme_c.textColorMild, fontSize: 16.sp)),
            ),
            MineResourceItem(
              title: 'Nickname'.tr,
              child: Text(userInfo.name,
                  style: TextStyle(
                      color: themed.theme_c.textColorMild, fontSize: 16.sp)),
            ),
            // MineResourceItem(
            //   title: "简介",
            //   child: Text("我是一只小橘子呀，我是一只小橘子最多显示2行点点…",
            //       style: TextStyle(color: Colors.black, fontSize: 16.sp)),
            // ),
            // Divider(
            //   height: 30.w,
            //   indent: 20.w,
            //   endIndent: 20.w,
            // ),
            MineResourceItem(
              title: 'Telephone'.tr,
              child: Text(TBUtils.maskPhoneNumber(userInfo.mobile),
                  style: TextStyle(
                      color: themed.theme_c.textColorMild, fontSize: 16.sp)),
            ),
            MineResourceItem(
              title: 'bind_wechat'.tr,
              child: Text(
                  userInfo.wechatName.isNotEmpty
                      ? userInfo.wechat
                      : 'Unbound'.tr,
                  style: TextStyle(
                      color: themed.theme_c.textColorMild, fontSize: 16.sp)),
            ),
            // MineResourceItem(
            //   title: "更换密码",
            //   child: Text("**********",
            //       style: TextStyle(color: Colors.black, fontSize: 16.sp)),
            // ),
          ],
        ),
      );
    });
  }
}
