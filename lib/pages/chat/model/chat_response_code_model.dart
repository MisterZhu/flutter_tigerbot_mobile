import 'dart:convert';

import 'chat_response_model.dart';

class ChatResponseCodeModel extends ChatResponseModel {
  String code;

  ChatResponseCodeModel(
      {required bool isLike, required bool isUnlike, required this.code})
      : super(isLike: isLike, isUnlike: isUnlike, isSearch: false);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
