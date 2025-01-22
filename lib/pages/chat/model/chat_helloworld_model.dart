import 'dart:convert';

import 'chat_model.dart';

class ChatHelloWorldModel extends ChatModel {
  ChatHelloWorldModel({required String content}) : super(content: content);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
