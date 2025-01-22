import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatFeedbackInputItem extends StatefulWidget {
  final String text;
  final Widget? leading;
  final bool selected;

  const ChatFeedbackInputItem(this.text, this.selected,
      {this.leading, super.key});

  @override
  State<ChatFeedbackInputItem> createState() => _ChatFeedbackInputItemState();
}

class _ChatFeedbackInputItemState extends State<ChatFeedbackInputItem> {
  late bool _selected;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _selected = false;
    _textEditingController = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(() {
        ChatProvider chatProvider =
            Provider.of<ChatProvider>(context, listen: false);
        chatProvider.hiddenChatBottom = _focusNode.hasFocus;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
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
                      color: this._selected
                          ? Color(0xff5FC896)
                          : Color(0xff6B6B6B)),
                )
              ],
            ),
          ),
        ),
        this._selected
            ? Container(
                padding: EdgeInsets.only(top: 10.w, bottom: 15.w, right: 10.w),
                child: TextField(
                  focusNode: _focusNode,
                  maxLines: 3,
                  controller: _textEditingController,
                  style: TextStyle(color: Color(0xff5FC896), fontSize: 10.sp),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10.r),
                    hintText: 'Please enter specific questions',
                    hintStyle:
                        TextStyle(color: Color(0xffD4D4D4), fontSize: 10.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
