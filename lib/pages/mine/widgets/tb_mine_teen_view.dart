import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/mine/widgets/tb_teen_pass_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/tb_mine_logic.dart';

class TBMineTeenView {
  Future<void> showTeenModel(BuildContext context, TBMineLogic logic) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 120.0.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.w),
              color: themed.theme_c.bgColor,
            ),
            child: SingleChildScrollView(
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
                          padding: EdgeInsets.all(18.0.w),
                          child: Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        left: 25.w, right: 25.w, top: 12.w, bottom: 5.w),
                    child: Text(
                      logic.isTeenModel ? '青少年模式已开启' : '青少年模式未开启',
                      textAlign: TextAlign.center, // 让文本居中
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: themed.theme_c.textColor),
                    ),
                  ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.w, right: 25.w, top: 5.w, bottom: 5.w),
                    child: Text(
                      '在青少年模式中，AI大模型提供的对话内容来自于权威教辅数据训练所生成，关注青少年的心理健康，营造积极乐观的对话氛围。',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: themed.theme_c.textColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.w, right: 25.w, top: 15.w, bottom: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // 确保Row左对齐
                      children: [
                        Text(
                          '多轮对话限制',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: themed.theme_c.textColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.w, right: 25.w, top: 5.w, bottom: 5.w),
                    child: Text(
                      '单日可对话次数50次，超过轮次限制时需要输入密码继续使用',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: themed.theme_c.textColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.w, right: 25.w, top: 15.w, bottom: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // 确保Row左对齐
                      children: [
                        Text(
                          '禁用时间',
                          textAlign: TextAlign.start, // 让文本居左
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: themed.theme_c.textColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.w, right: 25.w, top: 5.w, bottom: 5.w),
                    child: Text(
                      '每日晚22时至次日早6时无法开启对话，需输入密码启用',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: themed.theme_c.textColor),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      TBRouterHelper.back(null);

                      // 处理按钮点击事件
                      TBTeenPassView shareModal = TBTeenPassView();
                      if (logic.isTeenModel) {
                        shareModal.showPassView(
                            context, logic, '输入密码', '关闭青少年模式，请输入密码');
                      } else {
                        shareModal.showPassView(
                            context, logic, '设置密码', '此密码将用于关闭青少年模式及解除对话限制');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          logic.isTeenModel
                              ? TBColors.color_8A8A8A
                              : themed.theme_c.themeOppoColor), // 背景色为粉色
                      // padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18)), // 左右间距为18
                      minimumSize:
                          MaterialStateProperty.all(Size(150.w, 40.w)), // 高度为40
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // 四周圆角为5
                        side: BorderSide(
                            color: Colors.transparent,
                            width: 1.0), // 边框颜色黑色，宽度为1
                      )),
                    ),
                    child: Text(
                      logic.isTeenModel ? '关闭青少年模式' : '开启青少年模式',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: themed.theme_c.bgColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 皮肤
  // Widget multiSelectView() {
  //   return GetBuilder<TBMineLogic>(builder: (logic) {
  //     return Container(
  //       child: TBMultiSelectButton(
  //         items: ['chat'.tr, 'creation'.tr, 'coding'.tr, 'other'.tr],
  //         selectedItems: logic.selectedItems,
  //         onChanged: (newSelection) {
  //           logic.selectedItems = newSelection;
  //           logic.update();
  //         },
  //       ),
  //     );
  //   });
  // }
}
