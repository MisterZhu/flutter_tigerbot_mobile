import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/tb_mine_logic.dart';

class TBTeenPassView {
  Future<void> showPassView(
      BuildContext context, TBMineLogic logic, String title, String subTitle) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GetBuilder<TBMineLogic>(builder: (logic) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Container(
              // width: 355.0.w, // 设置宽度为200像素
              // height: 692.0.h, // 设置高度为100像素
              margin:
                  EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 120.0.w),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                color: themed.theme_c.bgColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 处理关闭按钮点击事件
                          TBRouterHelper.back(null);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(18.0.h),
                          child: Icon(
                            Icons.close,
                            size: 25.h,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 510.h, // 调整这个值以适应您的需求
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/mine/mine_teen_mode.png',
                                width: 96.w,
                                height: 96.w,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.w,
                                right: 25.w,
                                top: 12.w,
                                bottom: 5.w),
                            child: Text(
                              title,
                              textAlign: TextAlign.center, // 让文本居中
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: themed.theme_c.textColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 45.w,
                                right: 45.w,
                                top: 15.w,
                                bottom: 25.w),
                            child: Text(
                              subTitle,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: themed.theme_c.textColor),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 左侧输入框
                              Container(
                                width: 200.w, // 输入框的宽度
                                // height: 40.w,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0.w)),
                                  border: Border.all(
                                      width: 1, color: Colors.grey), // 边框颜色和宽度
                                ),
                                child: TextField(
                                  controller: logic.textEditingController,
                                  // 将文本编辑控制器分配给TextField
                                  decoration: InputDecoration(
                                    labelText: '请输入密码', // 占位字符
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.h,
                              ),
                              // 右侧提交按钮
                              Container(
                                width: 60.w, // 按钮的宽度
                                // height: 40.w,
                                decoration: BoxDecoration(
                                  color: themed.theme_c.themeOppoColor,
                                  borderRadius: BorderRadius.circular(
                                      5.0), // 添加圆角，这里设置为5.0
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // 处理提交按钮点击事件
                                    if (logic.isTeenModel) {
                                      logic.closeTeenMode();
                                    } else {
                                      logic.openTeenMode();
                                    }
                                  },
                                  child: Text(
                                    "提交",
                                    style: TextStyle(
                                      color: themed.theme_c.bgColor, // 文本颜色为粉色
                                      fontSize: 16.sp, // 字体大小为20
                                      fontWeight: FontWeight.bold, // 加粗
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 35.w),
                            // 设置左右边距为10
                            child: Divider(
                              color: themed.theme_c.lineColor, // 分割线颜色为灰色
                              thickness: 1, // 分割线厚度
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // 切换展开/折叠状态
                              logic.isShowCode = !logic.isShowCode;
                              logic.update();
                              print("diaoyong");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 35.w, right: 35.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0.w),
                                    child: Text(
                                      '忘记密码或想要更改密码？',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themed.theme_c.textColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(6.0.w),
                                    child: Image.asset(
                                      logic.isShowCode
                                          ? 'assets/images/common/common_right_arrow.png'
                                          : 'assets/images/common/common_right_down.png',
                                      // 使用不同的图片路径
                                      width: 12.w,
                                      height: 12.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: logic.isShowCode, // 控制子部件是否显示
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 40.w,
                                  right: 40.w,
                                  top: 12.w,
                                  bottom: 5.w),
                              child: Text(
                                '请联系contact@tigerbot.com，或添加客服微信',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: themed.theme_c.textColor),
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: logic.isShowCode, // 控制子部件是否显示
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 45.w),
                                  child: Image.network(
                                    'https://tigerbot.com/assets/weixin.c4771ce0.png',
                                    // 使用不同的图片路径
                                    width: 160.w,
                                    height: 160.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 35.w),
                            // 设置左右边距为10
                            child: Divider(
                              color: themed.theme_c.lineColor, // 分割线颜色为灰色
                              thickness: 1, // 分割线厚度
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
