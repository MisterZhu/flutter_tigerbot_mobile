import 'dart:convert';

import 'chat_model.dart';

class ChatTipModel extends ChatModel {
  ChatTipModel({required String content}) : super(content: content);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
