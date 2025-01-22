import 'dart:convert';

import 'chat_model.dart';

class ChatNewModel extends ChatModel {
  ChatNewModel({required String content}) : super(content: content);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
