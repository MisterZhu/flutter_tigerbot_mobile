import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'chat_feedback_input_item.dart';
import 'chat_feedback_item.dart';
import '../../../../constant/tb_export_common.dart';

class ChatFeedbackCell extends StatefulWidget {
  const ChatFeedbackCell(
      {required this.confirmHandle, required this.closeHandle, super.key});

  final Function() confirmHandle;
  final Function() closeHandle;

  @override
  State<ChatFeedbackCell> createState() => _ChatFeedbackCellState();
}

class _ChatFeedbackCellState extends State<ChatFeedbackCell> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              color: themed.theme_c.textColor,
              borderRadius: BorderRadius.all(Radius.circular(15.r))),
          width: 267.w,
          padding: EdgeInsets.all(15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                spacing: 10.w,
                runSpacing: 10.w,
                children: [
                  ChatFeedbackItem("Not good enough", false),
                  SizedBox(
                    width: 80.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<ChatProvider>(context, listen: false)
                          .hiddenChatBottom = false;
                      this.widget.closeHandle();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 6.w),
                      child: Image.asset(
                          "assets/images/chat/chat_feedback_close.png"),
                      width: 16.w,
                    ),
                  ),
                  ChatFeedbackItem("And the five senses of the problem", false),
                  ChatFeedbackItem("I want to roast", false),
                  ChatFeedbackItem("False information", false),
                  ChatFeedbackInputItem("I want to roast", false,
                      leading: Container(
                        padding: EdgeInsets.only(right: 5.w),
                        child: Image.asset(
                          "assets/images/chat/chat_feedback_edit.png",
                          width: 16.w,
                        ),
                      ))
                ],
              ),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Thank you for your suggestion！",
                      gravity: ToastGravity.CENTER);
                  this.widget.confirmHandle();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: themed.theme_c.textColor),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff5FC896),
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                ),
              )
            ],
          )),
    );
  }
}
