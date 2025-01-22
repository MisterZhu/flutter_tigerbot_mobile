import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/tb_export_common.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SCCustomScaffold(
      leading: _leading(),
      leadingWidth: 100,
      body: _body(),
      centerTitle: true,
      showBackIcon: true,
      showBackgroundImage: false,
      navBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      bodyBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      customTitleWidget: Text(
        'about_us'.tr,
        style: TextStyle(
          color: themed.theme_c.textColor,
          fontSize: 18.sp,
        ),
      ),
    );
  }

  /// leading
  Widget _leading() {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 24,
            height: 44,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 44.0,
              child: Image.asset(
                Assets.commonCommonBackIcon,
                width: 24.0,
                height: 24.0,
                color: themed.theme_c.textColor, // 你想要的颜色
                colorBlendMode: BlendMode.srcIn,
              ),
              onPressed: () {
                TBRouterHelper.back(null);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      color: themed.theme_c.bgColorF5, // 页面背景色
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: themed.theme_c.bgWhiteOrBlack, // 卡片背景色
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'license_info'.tr,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: themed.theme_c.textColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: themed.theme_c.rightIcon6B,
                  ),
                  onTap: () {
                    // 添加导航逻辑
                    TBRouterHelper.pathPage(TBRouterPath.archivalInfo, null);
                  },
                ),
                Divider(height: 1),
                ListTile(
                  title: Text(
                    'community_agreement'.tr,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: themed.theme_c.textColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: themed.theme_c.rightIcon6B,
                  ),
                  onTap: () {
                    // 添加导航逻辑
                    TBRouterHelper.pathPage(
                        TBRouterPath.communityConvention, null);
                  },
                ),
                Divider(height: 1),
                ListTile(
                  title: Text(
                    'user_agreement'.tr,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: themed.theme_c.textColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: themed.theme_c.rightIcon6B,
                  ),
                  onTap: () {
                    // 添加导航逻辑
                    var params = {
                      "title": "用户协议",
                      "url": "https://tigerbot.com/user-agreement.html"
                    };
                    TBRouterHelper.pathPage(TBRouterPath.webViewPath, params);
                  },
                ),
                Divider(height: 1),
                ListTile(
                  title: Text(
                    'private_agreement'.tr,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: themed.theme_c.textColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: themed.theme_c.rightIcon6B,
                  ),
                  onTap: () {
                    // 添加导航逻辑
                    var params = {
                      "title": "隐私协议",
                      "url": "https://tigerbot.com/private-agreement.html"
                    };
                    TBRouterHelper.pathPage(TBRouterPath.webViewPath, params);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
