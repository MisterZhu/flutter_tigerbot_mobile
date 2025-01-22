import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constant/tb_colors.dart';
import '../tb_utils.dart';
import 'sc_bottom_sheet_model.dart';

/// 底部弹窗

class SCBottomSheet extends StatelessWidget {
  /// 数据源
  final List<SCBottomSheetModel> dataList;

  /// 是否显示取消按钮
  final bool? isShowCancel;

  /// 自定义取消按钮model
  final SCBottomSheetModel? customCancelModel;

  /// 取消按钮默认model
  SCBottomSheetModel? cancelModel;

  /// 按钮点击
  final Function(int index, BuildContext context)? onTap;

  /// 取消按钮点击
  final Function(BuildContext context)? onCancelTap;

  /// 是否关闭弹窗，默认是
  bool? isCloseDialog;

  /// count
  int count = 0;

  SCBottomSheet({
    Key? key,
    required this.dataList,
    this.isShowCancel = true,
    this.customCancelModel,
    this.onCancelTap,
    this.onTap,
    this.isCloseDialog = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  /// body
  Widget body(BuildContext context) {
    initData();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView.separated(
          padding: EdgeInsets.only(left: 0, right: 0 ,top: 0, bottom: TBUtils().getBottomSafeArea()),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return cell(index:index, context: context);
          },
          separatorBuilder: (BuildContext context, int index) {
            return line(index);
          },
          itemCount: count),
    );
  }

  /// 初始化数据
  initData() {
    bool cancelStatus = isShowCancel ?? true;
    count = cancelStatus ? (dataList.length + 1) : dataList.length;

    if (customCancelModel == null) {
      cancelModel ??= SCBottomSheetModel.fromJson({
        "title": "取消",
        "color": TBColors.color_1B1C33,
        "fontSize": 16.0,
        "fontWeight": FontWeight.w400
      });
    } else {
      cancelModel = customCancelModel;
    }
  }

  /// cell
  Widget cell({required int index, required BuildContext context}) {
    bool cancelStatus = isShowCancel ?? true;
    String title;
    double fontSize;
    FontWeight fontWeight;
    Color color;
    TextStyle style;

    if (cancelStatus && index == count - 1) {
      title = cancelModel?.title ?? '';
      fontSize = cancelModel?.fontSize ?? 16.0;
      fontWeight = cancelModel?.fontWeight ?? FontWeight.w400;
      color = cancelModel?.color ?? TBColors.color_1B1C33;
      style =
      TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
    } else {
      SCBottomSheetModel model = dataList[index];
      title = model.title ?? '';
      fontSize = model.fontSize ?? 16.0;
      fontWeight = model.fontWeight ?? FontWeight.w400;
      color = model.color ?? TBColors.color_1B1C33;
      style =
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
    }

    return SizedBox(
      height: 48.0,
      child: CupertinoButton(
          color: Colors.white,
          child: Text(title, textAlign: TextAlign.center, style: style),
          onPressed: () {
            if (cancelStatus && index == count - 1) {// 取消
              if (onCancelTap != null) {
                onCancelTap?.call(context);
              }

              closeDialogAction(context);
            } else {// 其他点击
              if (onTap != null) {
                onTap?.call(index, context);
              }

              bool closeState = isCloseDialog ?? true;

              if (closeState) {
                closeDialogAction(context);
              }
            }
          }),
    );
  }

  /// 关闭弹窗
  closeDialogAction(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// line
  Widget line(int index) {
    bool cancelStatus = isShowCancel ?? true;
    if (cancelStatus && index == count - 2) {
      return Container(
        height: 12.0,
        color: TBColors.color_F2F3F5,
      );
    } else {
      return const Divider(
        height: 0.5,
        color: TBColors.color_EDEDF0,
      );
    }

  }
}
