import 'package:TigerChat/pages/chat/model/tb_chat_msg_model.dart';
import 'package:TigerChat/util/date_format.dart';

import 'chat_model.dart';

class ChatResponseModel extends ChatModel {
  bool isLike = false;

  bool isUnlike = false;

  List? images;

  String? query;

  Stream? stream;

  String reqId = "";

  bool isFinished = false;

  bool isFold = true; // 是否折叠

  bool isSearch = false; //是否是搜索模式

  bool isOperation = false; //是否是解析文件状态
  bool isPainting = false; //是否是生成图片状态
  bool isSearching = false; //是否是联网搜索状态

  int progressP = 0; //解析文件进度

  List<ChatResponseItemModel> items = [];

  bool noItems = true;

  List<List<String>> tables = [];

  double width = 0;

  double unfoldWidth = 0;
  List<String>? siblingMessageIds;
  List<String>? variantMessageIds;
  String? parentMessageId = "";
  int? currentPage = 1;

  double get calWidth {
    if (isFold) {
      return width;
    } else {
      return unfoldWidth;
    }
  }

  resetWidth() {
    width = 0;
    unfoldWidth = 0;
  }

  ChatResponseModel(
      {this.query,
      this.images,
      required this.isUnlike,
      required this.isLike,
      this.siblingMessageIds,
      this.currentPage,
      this.variantMessageIds,
      this.parentMessageId,
      this.stream,
      required this.isSearch})
      : super(content: "");

  @override
  String toString() {
    return "";
  }
}

class ChatResponseItemModel {
  String title = '';

  String updateAt = '';

  String description = '';

  String site = '';
  String uri = '';
  int index = 0; //解析文件进度

  String get time {
    if (updateAt.isNotEmpty) {
      DateTime dateTime = DateTime.parse(updateAt);
      return dateFormat(dateTime);
    } else {
      return "";
    }
  }

  ChatResponseItemModel.fromJson(Map data) {
    this.title = data["title"] ?? "";
    this.updateAt = data["updateAt"] ?? "";
    this.description = data["description"] ?? "未搜索到结果";
    this.site = data["site"] ?? "";
    this.uri = data["uri"] ?? "";
    this.index = data["index"] ?? 0;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['site'] = this.site;
    data['title'] = this.title;
    data['uri'] = this.uri;
    data['index'] = this.index;

    return data;
  }

  @override
  String toString() {
    return "";
    // return jsonEncode(this);
  }
}
