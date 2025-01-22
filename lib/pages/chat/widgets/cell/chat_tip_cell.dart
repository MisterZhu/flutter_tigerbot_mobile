import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'chat_tip_item.dart';

class ChatTipCell extends StatefulWidget {
  const ChatTipCell(
      {required this.confirmHandle, required this.closeHandle, super.key});

  final Function() confirmHandle;
  final Function() closeHandle;

  @override
  State<ChatTipCell> createState() => _ChatTipCellState();
}

class _ChatTipCellState extends State<ChatTipCell> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.r))),
        width: 267.w,
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Maybe you want to know：",
                  style: TextStyle(color: Color(0xff111111)),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .hiddenChatBottom = false;
                    this.widget.closeHandle();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 6.w),
                    // color: Colors.red,
                    child: Image.asset(
                        "assets/images/chat/chat_feedback_close.png"),
                    width: 16.w,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.w,
            ),
            ChatTipItem(
              "Help me generate a summary，Try to streamline as much as possible",
              number: 1,
            ),
            ChatTipItem(
              "Organize content on finance",
              number: 2,
            ),
            ChatTipItem(
              "Organize content on finance",
              number: 3,
            ),
          ],
        ),
      ),
    );
  }
}
