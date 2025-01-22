import 'dart:convert';

import 'chat_model.dart';

enum ChatFileType {
  pdf,
  excel,
  word,
  txt,
  html,
  png,
  jpg,
  ppt,
  csv,
}

class ChatRequestFileModel extends ChatModel {
  ChatFileType fileType;

  String get fileTypeStr {
    switch (this.fileType) {
      case ChatFileType.pdf:
        return "PDF";
      case ChatFileType.excel:
        return "EXCEL";
      case ChatFileType.word:
        return "WORD";
      case ChatFileType.txt:
        return "TXT";
      case ChatFileType.html:
        return "HTML";
      case ChatFileType.png:
        return "PNG";
      case ChatFileType.jpg:
        return "JPG";
      case ChatFileType.ppt:
        return "PPT";
      case ChatFileType.csv:
        return "CSV";
    }
  }

  String get fileTypeImagePath {
    String path = "assets/images/chat/chat_file_$fileTypeStr.png";
    print(path);
    return path;
  }

  ChatRequestFileModel(
      {required String content, this.fileType = ChatFileType.pdf})
      : super(content: content);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
