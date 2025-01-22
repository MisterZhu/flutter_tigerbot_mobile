import 'dart:convert';

import 'chat_model.dart';

class ChatSuggestModel extends ChatModel {
  ChatSuggestModel({required String content}) : super(content: content);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
