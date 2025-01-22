import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArchivalInfoPage extends StatelessWidget {
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
        'license_info'.tr,
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            '模型名称:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          SelectableText('TigerBot-70B'),
          SizedBox(height: 16.0),
          SelectableText(
            '备案信息:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          SelectableText('网信算备310105948605401230011号'),
          SelectableText('网信算备310105948605401240023号'),
          SelectableText('沪ICP备17048459号-8A'),
          SelectableText('Shanghai-TigerBot-20231106'),
        ],
      ),
    );
  }
}
