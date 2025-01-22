import 'package:flutter/material.dart';

import '../../model/chat_response_code_model.dart';

class ChatResponseCodeCell extends StatefulWidget {
  late ChatResponseCodeModel? model;

  void Function(bool) likeHandle;
  void Function(bool) unlikeHandle;

  ChatResponseCodeCell(this.model,
      {required this.likeHandle, required this.unlikeHandle});

  @override
  State<ChatResponseCodeCell> createState() => _ChatResponseCodeCellState();
}

class _ChatResponseCodeCellState extends State<ChatResponseCodeCell> {
  Widget get _content {
    ChatResponseCodeModel? _model = this.widget.model;
    String? code = _model?.code;
    Widget codeWidget = SizedBox();
    print(code);
    if (code?.isNotEmpty ?? false) {
      codeWidget = Container(
        color: Colors.red,
        // width: 200,
        // height: 200,
        child: Text(code ?? 'xxx'),
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 240),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          color: Colors.grey[300]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _model?.content ?? "",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          codeWidget,
          // ChatLikeTool(
          //     isLike: _model?.isLike ?? false,
          //     isUnlike: _model?.isUnlike ?? false,
          //     likeTap: (like) {
          //       print("点赞 $like");
          //       this.widget.likeHandle(like);
          //     },
          //     unlikeTap: (unlike) {
          //       print("踩 $unlike");
          //       this.widget.unlikeHandle(unlike);
          //     })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.person),
            SizedBox(
              width: 10,
            ),
            _content
          ],
        ),
      ),
    );
  }
}
