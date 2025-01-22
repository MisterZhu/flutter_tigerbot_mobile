import 'dart:convert';

abstract class ChatModel {
  String content;
  double? height = 0.0;
  bool? isEditSelected = false;

  ChatModel({
    required this.content,
  });

  @override
  String toString() {
    return jsonEncode(this);
  }
}
