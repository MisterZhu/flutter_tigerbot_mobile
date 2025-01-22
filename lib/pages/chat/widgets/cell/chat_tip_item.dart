import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTipItem extends StatefulWidget {
  final int? number;

  final String text;

  const ChatTipItem(this.text, {this.number = 1, super.key});

  @override
  State<ChatTipItem> createState() => _ChatTipItemState();
}

class _ChatTipItemState extends State<ChatTipItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.w),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
                color: Color(0xffFFE6EB),
                borderRadius: BorderRadius.circular(4.r)),
            child: Center(
              child: Text("${this.widget.number ?? 0}",
                  style: TextStyle(fontSize: 10.sp, color: Color(0xffFF98AC))),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 12.sp, color: Color(0xff6B6B6B)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
