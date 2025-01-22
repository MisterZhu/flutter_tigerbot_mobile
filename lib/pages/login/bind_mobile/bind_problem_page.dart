import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/tb_export_common.dart';
import '../../../util/tb_utils.dart';

class BindProblemPage extends StatefulWidget {
  const BindProblemPage({super.key});

  @override
  State<BindProblemPage> createState() => _BindProblemPageState();
}

class _BindProblemPageState extends State<BindProblemPage> {
  @override
  Widget build(BuildContext context) {
    return SCCustomScaffold(
      leading: _leading(),
      leadingWidth: 100,
      body: _body(context),
      centerTitle: true,
      showBackIcon: false,
      showBackgroundImage: false,
      bodyBackgroundColor: TBColors.color_F8F8F8,
      customTitleWidget: Text(
        'binding problem'.tr,
        style: TextStyle(
          color: Colors.black,
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

  Widget _body(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 35.w),
          Text(
            'binding_problem_tip'.tr,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.w),
          Image.asset(
            Assets.loginWeixin, // 这里替换为你的图片路径
            width: 250.w,
            height: 250.w,
          ),
          SizedBox(height: 20.w),
          ElevatedButton(
            onPressed: () {
              // 保存图片的逻辑
              print("保存图片按钮被点击");
              TBUtils.saveImage(Assets.loginWeixin, isAsset: true);
            },
            child: Text(
              'save_image'.tr,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
