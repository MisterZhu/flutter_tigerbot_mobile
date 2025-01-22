import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/tb_default_value.dart';
import '../../../constant/tb_export_common.dart';
import '../logic/tb_chat_detail_logic.dart';

class ChatInputFile extends StatefulWidget {
  // final TBChatDetailLogic logic;
  // ChatInputFile({required this.logic});
  @override
  _ChatInputFileState createState() => _ChatInputFileState();
}

class _ChatInputFileState extends State<ChatInputFile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TBChatDetailLogic>(
        id: TBDefVal.kChatInputFile,
        builder: (state) {
          // if (!state.documentAnalysis) {
          //   // 当 documentAnalysis 为 false 时，返回一个空的组件
          //   return Container(); // 你可以根据需要返回其他空的组件
          // } else
          if (state.imageFilePath.isNotEmpty) {
            // 当 imagePath 有值时，返回 CustomImageWithCloseButton
            return CustomImageWithCloseButton(
              imageUrl: state.imageFilePath,
              onClosePressed: () {
                // 处理关闭按钮点击事件
                state.imageFilePath = '';
                state.update([TBDefVal.kChatInputFile]);
              },
            );
          } else if (state.documentPath.isNotEmpty) {
            // 当 documentPath 有值时，返回 CustomCard
            return CustomCard(
              title: state.documentPath,
              onClosePressed: () {
                // 处理关闭按钮点击事件
                state.documentPath = '';
                state.update([TBDefVal.kChatInputFile]);
              },
            );
          } else {
            // 其他情况，返回一个空的组件
            return Container(); // 你可以根据需要返回其他空的组件
          }
        });
  }
}

class CustomImageWithCloseButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onClosePressed;

  const CustomImageWithCloseButton({
    this.imageUrl = '',
    this.onClosePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.w, left: 0.w, right: 18.w),
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // 设置圆角
              border: Border.all(color: TBColors.color_D8D8D8),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10.0), // 使用ClipRRect确保图片也具有相同的圆角效果
              child: Image.file(
                File(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onClosePressed,
            child: Padding(
              padding: EdgeInsets.only(top: 5.w, right: 10.w),
              child: Image.asset(
                "assets/images/chat/chat_bottom_cancel.png",
                width: 18.w,
                height: 18.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback? onClosePressed;

  const CustomCard({
    this.title = '',
    this.onClosePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12.w, right: 18.w),
          width: 180.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: TBColors.color_D8D8D8),
          ),
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                width: 33.w,
                height: 33.w,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image.asset(
                    fileTypeImagePath(title),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // 添加这一行以实现超出一行的文本显示省略号
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onClosePressed,
            child: Padding(
              padding: EdgeInsets.only(top: 5.w, right: 10.w),
              child: Image.asset(
                "assets/images/chat/chat_bottom_cancel.png",
                width: 18.w,
                height: 18.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String fileTypeImagePath(String objectFilename) {
    List<String> filenameParts = objectFilename.split('.');
    String lastPart = filenameParts.last;
    var path = "assets/images/chat/chat_file_PDF.png";
    if (lastPart == "pdf") {
      path = "assets/images/chat/chat_file_PDF.png";
    } else if ((lastPart == "doc") || (lastPart == "docx")) {
      path = "assets/images/chat/chat_file_WORD.png";
    } else if ((lastPart == "xls") || (lastPart == "xlsx")) {
      path = "assets/images/chat/chat_file_EXCEL.png";
    } else if ((lastPart == "jpg") || (lastPart == "jpeg")) {
      path = "assets/images/chat/chat_file_JPG.png";
    } else if ((lastPart == "png")) {
      path = "assets/images/chat/chat_file_PNG.png";
    } else if ((lastPart == "txt")) {
      path = "assets/images/chat/chat_file_TXT.png";
    } else if ((lastPart == "html")) {
      path = "assets/images/chat/chat_file_HTML.png";
    } else if ((lastPart == "csv")) {
      path = "assets/images/chat/chat_file_CSV.png";
    } else {
      path = "assets/images/chat/chat_file_PDF.png";
    }
    return path;
  }
}
