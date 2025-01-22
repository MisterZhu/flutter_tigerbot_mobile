import 'dart:convert';

import 'chat_model.dart';

class ChatResponseLoadingModel extends ChatModel {
  ChatResponseLoadingModel() : super(content: "");

  @override
  String toString() {
    return jsonEncode(this);
  }
}
