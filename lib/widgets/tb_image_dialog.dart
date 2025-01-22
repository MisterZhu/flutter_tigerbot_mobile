import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/tb_colors.dart';
import '../constant/tb_default_value.dart';
import '../constant/tb_enum.dart';
import '../util/skin/theme_controller.dart';

class TBImageDialog extends StatelessWidget {
  const TBImageDialog({
    Key? key,
    required this.items,
    this.itemBgColor,
    this.itemHeight,
    this.textStyle,
    this.onItemSelected, // 添加回调函数参数
  }) : super(key: key);
  final List<ItemLittleView> items;
  final Color? itemBgColor;
  final double? itemHeight;
  final TextStyle? textStyle;
  final void Function(TBImageDialogOption)? onItemSelected; // 回调函数

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: TBDefVal.screenWidth.w,
          padding: EdgeInsets.only(top: 25, right: 30, left: 30, bottom: 25),
          child: Row(
            children: items.map((e) {
              return Expanded(
                flex: 1, // 设置相同的 flex 值
                child: itemLittleView(
                  label: e.label,
                  icon: e.icon,
                  option: e.option,
                  onTap: () {
                    onItemSelected!(e.option); // 调用回调函数并传递选定的字符串参数
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget itemLittleView({
    required String label,
    required String icon,
    required TBImageDialogOption option,
    Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          // margin: EdgeInsets.only(right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                icon,
                width: 50.w,
                fit: BoxFit.cover,
                // color: themed.theme_c.iconColor, // 你想要的颜色
                // colorBlendMode: BlendMode.srcIn, // 混合模式
              ),
              SizedBox(
                height: 7.w,
              ),
              Container(
                width: 100.w,
                margin: EdgeInsets.only(top: 3),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: themed.theme_c.textColorMild,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

class ItemLittleView {
  final String label;
  final String icon;
  final TBImageDialogOption option;

  final Function()? onTap;

  ItemLittleView(
      {required this.label,
      required this.icon,
      required this.option,
      this.onTap});
}
