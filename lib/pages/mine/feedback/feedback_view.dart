import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feedback_logic.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({Key? key}) : super(key: key);

  final logic = Get.put(FeedbackLogic());
  final state = Get.find<FeedbackLogic>().state;

  @override
  Widget build(BuildContext context) {
    return SCCustomScaffold(
      leading: _leading(),
      leadingWidth: 100,
      body: _body(context),
      centerTitle: true,
      showBackIcon: true,
      showBackgroundImage: false,
      navBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      bodyBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      customTitleWidget: Text(
        'Feedback'.tr,
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

  Widget _body(context) {
    return GestureDetector(
      onTap: () {
        // 点击页面其他地方，隐藏键盘
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'FeedbackTitle'.tr,
                style: TextStyle(
                    fontSize: 16.0.sp,
                    // fontWeight: FontWeight.bold,
                    color: themed.theme_c.textColor),
              ),
              SizedBox(height: 16.0),
              Text(
                'FeedbackTitle1'.tr,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Container(
                padding:
                    EdgeInsets.all(10.0), // Optional padding for the border
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Customize border color
                    width: 1.0, // Customize border width
                  ),
                  borderRadius:
                      BorderRadius.circular(5.0), // Customize border radius
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 100.0, // Set the minimum height
                    maxHeight: 100.0, // Set the maximum height
                  ),
                  child: TextField(
                    controller: state.inputController,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                      hintText: 'FeedbackTitle2'.tr,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 26.0),
              ElevatedButton(
                onPressed: () {
                  print(state.inputController.text);
                  logic.feedbackRequest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themed.theme_c.buttonBgColor, // 设置背景色
                  fixedSize: Size.fromHeight(45),
                  // 设置按钮的高度
                ),
                child: Text(
                  '提交',
                  style: TextStyle(
                      fontSize: 16.0.sp,
                      color: themed.theme_c.buttonColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide: BorderSide(
      color: TBColors.color_6B6B6B,
    ),
  );
}
