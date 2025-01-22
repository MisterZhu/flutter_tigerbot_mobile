import 'chat_model.dart';

class ChatRequestVoiceModel extends ChatModel {

  bool? hasEead = false;
  String pathType = "file";
  String path = "";
  bool isFinished = false;
  String second = "";

  ChatRequestVoiceModel(
      {
        this.hasEead,
        required this.pathType,
        required this.second,
        required this.path
      })
      : super(content: "");

  @override
  String toString() {
    return "";
  }
}