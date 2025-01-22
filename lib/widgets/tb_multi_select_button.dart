import 'package:TigerChat/constant/tb_default_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/tb_colors.dart';

class TBMultiSelectButton extends StatefulWidget {
  final List<String> items;
  final Function(List<bool>) onChanged;
  final List<bool> selectedItems;

  TBMultiSelectButton({
    required this.items,
    required this.onChanged,
    required this.selectedItems,
  });

  @override
  _TBMultiSelectButtonState createState() => _TBMultiSelectButtonState();
}

class _TBMultiSelectButtonState extends State<TBMultiSelectButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // 设置为居左对齐
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.items.length, (index) {
              final isSelected = widget.selectedItems[index];
              return InkWell(
                onTap: () {
                  final newSelection = List<bool>.from(widget.selectedItems);
                  newSelection[index] = !isSelected;
                  widget.onChanged(newSelection);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 5.w, bottom: 14.w),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? TBDefVal.chatThemePinkColor : TBColors.color_272625,
                        size: 22,
                      ),
                      SizedBox(width: 3),
                      Text(
                        widget.items[index],
                        style: TextStyle(
                          color: isSelected ? TBDefVal.chatThemePinkColor : TBColors.color_272625,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
