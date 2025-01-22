import 'package:flutter/material.dart';

import '../../constant/tb_colors.dart';
import 'sc_base_dialog.dart';
import 'sc_bottom_sheet.dart';
import 'sc_bottom_sheet_model.dart';

/// 弹窗工具类
class SCDialogUtils {
  factory SCDialogUtils() => _instance;

  static SCDialogUtils get instance => _instance;

  static final SCDialogUtils _instance = SCDialogUtils._internal();

  SCDialogUtils._internal() {
    /// set deafult value
  }

  /*
  *  SCDialogUtils.instance.showMiddleDialog(context: context, title: '提示', content: '弹窗内容', customWidgetButtons:[
  *    defaultCustomButton(context,text: '取消',textColor: TBColors.color_1B1C33,fontWeight: FontWeight.w400),
  *    TextButton(
  *       onPressed: (){},
  *       child: Text('Custom Button', style: TextStyle(color:  Colors.pinkAccent))
  *     )
  *  ],);
  */
  /// 中间弹窗
  Future showMiddleDialog<T>(
      {required BuildContext context,
      Color bgColor = TBColors.color_FFFFFF,
      bool isShowCloseButton = false,
      bool isNeedCloseDiaLog = true,
      DiaLogLocation location = DiaLogLocation.middle,
      bool isSystemBottomDialog = false,
      Widget? customTitleWidget,
      String? title,
      Color titleColor = TBColors.color_000000,
      double titleFontSize = 18,
      FontWeight titleFontWeight = FontWeight.w400,
      TextAlign titleAlign = TextAlign.center,
      Widget? customContentWidget,
      String? content,
      Color contentColor = const Color(0xFF1B1C33),
      double contentFontSize = 14,
      double notTitleContentFontSize = 18,
      FontWeight contentFontWeight = FontWeight.w400,
      TextAlign contentAlign = TextAlign.center,
      List<Widget>? customWidgetButtons,
      List<String>? buttons,
      Color cancelButtonColor = colorWithHex9,
      Color otherButtonColor = colorWithQ,
      double cancelButtonFontSize = 16,
      double otherButtonFontSize = 16,
      FontWeight cancelButtonFontWeight = FontWeight.w400,
      FontWeight otherButtonFontWeight = FontWeight.w400,
      ButtonArrangeType arrangeType = ButtonArrangeType.row,
      Function(int index, BuildContext context)? onTap}) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return SCBaseDialog(
              bgColor: bgColor,
              isShowCloseButton: isShowCloseButton,
              isNeedCloseDiaLog: isNeedCloseDiaLog,
              customTitleWidget: customTitleWidget,
              location: location,
              isSystemBottomDialog: isSystemBottomDialog,
              title: title,
              titleColor: titleColor,
              titleFontSize: titleFontSize,
              titleFontWeight: titleFontWeight,
              titleAlign: titleAlign,
              customContentWidget: customContentWidget,
              content: content,
              contentColor: contentColor,
              contentFontSize: contentFontSize,
              notTitleContentFontSize: notTitleContentFontSize,
              contentFontWeight: contentFontWeight,
              contentAlign: contentAlign,
              customWidgetButtons: customWidgetButtons,
              buttons: buttons,
              cancelButtonColor: cancelButtonColor,
              otherButtonColor: otherButtonColor,
              cancelButtonFontSize: cancelButtonFontSize,
              otherButtonFontSize: otherButtonFontSize,
              cancelButtonFontWeight: cancelButtonFontWeight,
              otherButtonFontWeight: otherButtonFontWeight,
              arrangeType: arrangeType,
              onTap: onTap);
        });
  }

  /*
  *  var dataList = [
  *   SCBottomSheetModel.fromJson({
  *      "title": "任务1",
  *     "color": TBColors.color_1B1C33,
  *      "fontSize": SCFonts.f16,
  *      "fontWeight": FontWeight.w400
  *   }),
  *   SCBottomSheetModel.fromJson({
  *      "title": "任务2",
  *      "color": TBColors.color_1B1C33,
  *      "fontSize": SCFonts.f16,
  *      "fontWeight": FontWeight.w400
  *   })
  *  ];
  *  SCDialogUtils.instance.showBottomDialog(context: context, dataList: dataList, isShowCancel: false);
  *
  */
  /// 底部弹窗
  showBottomDialog(
      {required BuildContext context,
      required List<SCBottomSheetModel> dataList,
      bool? isShowCancel,
      SCBottomSheetModel? cancelModel,
      bool? isCloseDialog,
      Function(int index, BuildContext context)? onTap,
      Function(BuildContext context)? onCancelTap}) {
    /// -1为取消
    int currentIndex = -1;
    BuildContext currentContext;

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        builder: (BuildContext context) {
          return SCBottomSheet(
            dataList: dataList,
            isShowCancel: isShowCancel,
            customCancelModel: cancelModel,
            isCloseDialog: isCloseDialog,
            onTap: (int index, BuildContext context) {
              currentIndex = index;
              currentContext = context;
            },
            onCancelTap: (BuildContext context) {
              currentContext = context;
            },
          );
        }).then((value) {
          if (currentIndex == -1) {// 取消
            onCancelTap?.call(context);
          } else {// 其他
            onTap?.call(currentIndex, context);
          }
    });
  }

  /// 自定义底部弹窗，弹出验证码输入页面
  showCustomBottomDialog(
      {required BuildContext context, required Widget widget, bool? isDismissible}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: isDismissible ?? false,
        builder: (BuildContext context) {
          return widget;
        });
  }
}