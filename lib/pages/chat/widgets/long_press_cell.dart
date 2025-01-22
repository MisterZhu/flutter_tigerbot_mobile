import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../constant/tb_default_value.dart';
import '../../../util/provider/chat_provider.dart';
import '../../../util/tb_utils.dart';

class LongPressCell extends StatelessWidget {
  final Widget child;

  final Function()? deleteHandle;
  final Function()? tapHandle;
  final Function()? mulChoiceHandle;
  final Function()? selectAllHandle;

  GlobalKey _key = GlobalKey();

  LongPressCell(
      {required this.child,
      this.deleteHandle,
        this.tapHandle,
      this.mulChoiceHandle,
      this.selectAllHandle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: (){
        if (tapHandle != null) {
          tapHandle!();
        }
      },
      onLongPress: () {
        // 不执行任何长按操作，直接返回
        return;
        HapticFeedback.mediumImpact();

        BrnPopupDirection topOrBot = BrnPopupDirection.bottom;
        double topdis = TBUtils.getTopDistanceFromKey(_key);
        double botdis = TBUtils.getBottomDistanceFromKey(_key);
        double offsetDis = 10.0;
        if ((topdis >= 70 && botdis >= 70)||(topdis < 70 && botdis >= 70)){
          offsetDis = 10;
          topOrBot = BrnPopupDirection.bottom;
        }else if (topdis < 70 && botdis < 70) {
          offsetDis = -(TBDefVal.screenHeight/2 - botdis);
          topOrBot = BrnPopupDirection.bottom;
        }else if (topdis >= 70 && botdis < 70){
          offsetDis = 10;
          topOrBot = BrnPopupDirection.top;
        }
        BrnPopupWindow.showPopWindow(
          context,
          'Clear Record'.tr,
          _key,
          // arrowOffset: -1000,
          // offset: 25.w,
          offset: offsetDis.h,
          popDirection: topOrBot,
          paddingInsets: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          widget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();

                  if (deleteHandle != null) {
                    deleteHandle!();
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 10.0, top: 14, bottom: 14),
                  child: Text(
                    'Delete'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 10.w,
              // ),
              Container(
                width: 1,
                height: 8.w,
                color: Colors.white,
              ),
              // SizedBox(
              //   width: 10.w,
              // ),
              Consumer<ChatProvider>(builder: (context, chat, child) {
                return InkWell(
                  onTap: () {
                    Get.back();

                    chat.editMode = !chat.isEditMode;
                    if (mulChoiceHandle != null) {
                      mulChoiceHandle!();
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 14, bottom: 14),
                    child: Text(
                      chat.isEditMode
                          ? 'Cancel Multi-select'.tr
                          : 'Multi-select'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
              // SizedBox(
              //   width: 10.w,
              // ),
              Container(
                width: 1,
                height: 8.w,
                color: Colors.white,
              ),
              // SizedBox(
              //   width: 10.w,
              // ),
              Consumer<ChatProvider>(builder: (context, chat, child) {
                return InkWell(
                  onTap: () {
                    Get.back();

                    print("点击了全选2");
                    chat.choiceAll = !chat.isChoiceAll;
                    if (selectAllHandle != null) {
                      selectAllHandle!();
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 18.0, top: 14, bottom: 14),
                    child: Text(
                      chat.isChoiceAll
                          ? 'Cancel select all'.tr
                          : 'Select all'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
