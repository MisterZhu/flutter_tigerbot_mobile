import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constant/tb_export_common.dart';

class ChatHelloWorldCell extends StatelessWidget {
  ChatHelloWorldCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
            child: Consumer<ChatProvider>(
              builder: (context, chat, child) {
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: TBDefVal.margin.w,
                      ),

                      // SizedBox(
                      //   width: TBDefVal.margin.w,
                      // ),
                      Container(
                          width: TBDefVal.chatBoxMaxWidth.w,
                          // height: 135.w,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.r),
                                bottomLeft: Radius.circular(15.r),
                                bottomRight: Radius.circular(15.r),
                              ),
                              color: themed.theme_c.bgColorAsk),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.w),
                                        border: Border.all(
                                            color: themed.theme_c.bgColorAns,
                                            width: 2.w),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(18.w),
                                        child: Image.asset(
                                          "assets/images/home/icon_home_tiger.png",
                                          fit: BoxFit.contain,
                                          width: 36.w,
                                          height: 36.w,
                                          // fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ]),
                              Text("Hello~ I am TigerBot".tr,
                                  maxLines: 3, // 根据需要调整
                                  style: TextStyle(
                                      color: themed.theme_c.textColorAns,
                                      fontSize: TBDefVal.chatRegularFont.sp,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 10.w,
                              ),
                              Text("I possess capabilities in general Q&A".tr,
                                  style: TextStyle(
                                      color: themed.theme_c.textColorAns,
                                      fontSize: TBDefVal.chatRegularFont.sp))
                            ],
                          ))
                    ]);
              },
            ),
          ),
        ),
        SizedBox(
          height: 80.h,
        )
      ],
    );
  }
}
