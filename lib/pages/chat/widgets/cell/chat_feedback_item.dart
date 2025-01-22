import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatFeedbackItem extends StatefulWidget {
  final String text;
  final Widget? leading;
  final bool selected;

  const ChatFeedbackItem(this.text, this.selected, {this.leading, super.key});

  @override
  State<ChatFeedbackItem> createState() => _ChatFeedbackItemState();
}

class _ChatFeedbackItemState extends State<ChatFeedbackItem> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this._selected = !this._selected;
        });
      },
      child: Container(
        height: 24.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: this._selected ? Color(0xffDFF9EC) : Color(0xffFAFAFA),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            this.widget.leading != null ? this.widget.leading! : SizedBox(),
            Text(
              widget.text,
              style: TextStyle(
                  fontSize: 12.sp,
                  color:
                      this._selected ? Color(0xff5FC896) : Color(0xff6B6B6B)),
            )
          ],
        ),
      ),
    );
  }
}
