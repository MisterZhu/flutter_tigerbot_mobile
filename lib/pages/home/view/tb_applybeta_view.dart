import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/tb_multi_select_button.dart';
import '../logic/tb_launch_logic.dart';

class TBApplyBetaModal {
  Future<void> showShareModel(BuildContext context, TBLaunchLogic logic) {
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
            margin: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 60.0.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(18.0.w),
                        child: Text(
                          'apply'.tr,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: TBColors.color_333333),
                        ),
                      ),
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

                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 18.w, right: 18.w, top: 18.w, bottom: 5.w),
                    child: Text(
                      'applyInfoTip'.tr,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: TBColors.color_1A1A1A),
                    ),
                  ),
                  BrnTextBlockInputFormItem(
                    controller: TextEditingController()..text = logic.phoneNum,
                    title: "mobile".tr,
                    hint: "Telephone_number_is_empty".tr,
                    isRequire: true,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (newValue) {
                      // BrnToast.show("点击触发回调_${newValue}_onChanged", context);
                      logic.phoneNum = newValue;
                    },
                    themeData: BrnFormItemConfig(
                        backgroundColor: Colors.white,
                        titleTextStyle:
                            BrnTextStyle(color: TBColors.color_272625)),
                  ),
                  BrnTextBlockInputFormItem(
                    controller: TextEditingController()..text = logic.emailNum,
                    title: "email".tr,
                    hint: "Please enter".tr,
                    // isRequire: true,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (newValue) {
                      // BrnToast.show("点击触发回调_${newValue}_onChanged", context);
                      logic.emailNum = newValue;
                    },
                    themeData: BrnFormItemConfig(
                        backgroundColor: Colors.white,
                        titleTextStyle:
                            BrnTextStyle(color: TBColors.color_272625)),
                  ),
                  BrnTextBlockInputFormItem(
                    controller: TextEditingController()
                      ..text = logic.organiName,
                    title: "organization".tr,
                    hint: "Please enter".tr,
                    isRequire: true,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (newValue) {
                      // BrnToast.show("点击触发回调_${newValue}_onChanged", context);
                      logic.organiName = newValue;
                    },
                    themeData: BrnFormItemConfig(
                        backgroundColor: Colors.white,
                        titleTextStyle:
                            BrnTextStyle(color: TBColors.color_272625)),
                  ),
                  BrnMultiChoiceInputFormItem(
                    title: "applyForTip".tr,
                    options: [],
                    value: [],
                  ),
                  multiSelectView(),
                  SizedBox(
                    height: 30.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 处理按钮点击事件
                      logic.requestTestApply();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          TBDefVal.chatThemePinkColor), // 背景色为粉色
                      // padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18)), // 左右间距为18
                      minimumSize: MaterialStateProperty.all(
                          Size((TBDefVal.screenWidth - 84).w, 40.w)), // 高度为40
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // 四周圆角为5
                        side: BorderSide(
                            color: Colors.transparent,
                            width: 1.0), // 边框颜色黑色，宽度为1
                      )),
                    ),
                    child: Text(
                      'Confirm'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: themed.theme_c.textColor,
                      ),
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
  Widget multiSelectView() {
    return GetBuilder<TBLaunchLogic>(builder: (logic) {
      return Container(
        child: TBMultiSelectButton(
          items: ['chat'.tr, 'creation'.tr, 'coding'.tr, 'other'.tr],
          selectedItems: logic.selectedItems,
          onChanged: (newSelection) {
            logic.selectedItems = newSelection;
            logic.update();
          },
        ),
      );
    });
  }
}
