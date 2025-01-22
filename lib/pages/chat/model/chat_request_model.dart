import 'dart:convert';

import 'chat_model.dart';

class ChatRequestModel extends ChatModel {
  ChatRequestModel({required String content}) : super(content: content);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
