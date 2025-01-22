import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ChatUploadStatusType { uploading, success, failed }

class ChatUploadStatus extends StatelessWidget {
  ChatUploadStatusType type;

  final Function()? reload;

  ChatUploadStatus(
      {super.key, this.type = ChatUploadStatusType.uploading, this.reload});

  @override
  Widget build(BuildContext context) {
    if (type == ChatUploadStatusType.uploading) {
      return Padding(
        padding: EdgeInsets.only(left: 8.w, top: 20.w),
        child: CupertinoActivityIndicator(
          radius: 8.w,
        ),
      );
    } else if (type == ChatUploadStatusType.success) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          if (this.reload != null) {
            this.reload!();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, top: 20.w),
          child: Image.asset(
            "assets/images/chat/chat_upload_error.png",
            width: 16.w,
          ),
        ),
      );
    }
  }
}
