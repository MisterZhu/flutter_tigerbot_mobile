import 'package:TigerChat/pages/chat/widgets/cell/chat_response_item.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../constant/tb_export_common.dart';
import '../../../../util/code_element_builder.dart';
import '../../../../widgets/photo_view.dart';
import '../../logic/tb_chat_detail_logic.dart';
import '../../model/chat_response_model.dart';
import '../logic/tb_share_image_logic.dart';

class TBShareResponseCell extends StatefulWidget {
  late ChatResponseModel? model;

  void Function(bool) foldHandle;
  void Function(bool) likeHandle;
  void Function(bool) unlikeHandle;

  final Function()? deleteHandle;
  final Function()? mulChoiceHandle;
  final Function()? selectAllHandle;

  final Function(String)? regenerateHandle;

  TBShareResponseCell(this.model,
      {required this.foldHandle,
      required this.likeHandle,
      required this.unlikeHandle,
      this.deleteHandle,
      this.mulChoiceHandle,
      this.selectAllHandle,
      this.regenerateHandle,
      Key? key})
      : super(key: key);

  @override
  State<TBShareResponseCell> createState() => _TBShareResponseCellState();
}

class _TBShareResponseCellState extends State<TBShareResponseCell> {
  // String content = "";
  List<List<String>> tables = [];
  List images = [];
  final TBShareImageLogic logic = Get.find<TBShareImageLogic>();

  GlobalKey _key = GlobalKey();

  List<ChatResponseItemModel> chatResponseItems(List searchDataList) {
    List<ChatResponseItemModel> itemModels = searchDataList.map((e) {
      ChatResponseItemModel itemModel = ChatResponseItemModel.fromJson(e);
      return itemModel;
    }).toList();
    this.widget.model?.noItems = false;
    if (itemModels.length == 0) {
      this.widget.model?.noItems = true;
      ChatResponseItemModel defaultItemModel =
          ChatResponseItemModel.fromJson({});
      itemModels = [defaultItemModel];
    }
    return itemModels;
  }

  // Widget markdownMath(String content) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: logic.getLatexText(content),
  //
  //   );
  // }
  Widget markdownMath(String content) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: logic.getLatexText(content),
      ),
    );
  }

  Widget get _imagecontent {
    print('---------------------------展示内容_imagecontent');
    ChatResponseModel? model = this.widget.model;
    final images = model?.images ?? [];
    List<Widget> imageWidgets = images.map((e) {
      int index = images.indexOf(e);
      return Image.network(
        e,
        width: 150.w,
      );
    }).toList();
    return Container(
      padding: EdgeInsets.all(0),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
          color: themed.theme_c.bgColorAns),
      child: Column(
        children: imageWidgets,
      ),
    );
  }

  Widget markdown(String content) {
    // if (!logic.isMarkdownTable(content)) {
    //   content = content.replaceAll("\n", "\n\n");
    // }
    if ((logic.isMarkdownTable(content)) ||
        (content.contains("```")) ||
        (logic.isMathJaxOutsideCodeBlocks(content))) {
    } else {
      content = content.replaceAll("\n", "\n\n");
      // leftP = 5.0;
    }
    return MarkdownBody(
      data: content,
      styleSheet: MarkdownStyleSheet(
        //     em: TextStyle(color: Colors.green),
        listBullet: TextStyle(
          fontSize: logic.chatRegularFont.sp, // 你想要的字体大小
          // 其他样式属性...
        ),
        h1: TextStyle(
            height: 1.65,
            color: themed.theme_c.textColorAns,
            fontSize: logic.chatRegularFont.sp,
            fontWeight: FontWeight.w500),
        p: TextStyle(
            height: 1.65,
            color: themed.theme_c.textColorAns,
            fontSize: logic.chatRegularFont.sp,
            fontWeight: FontWeight.w500),
      ),
      builders: {
        "code": CodeElementBuilder(logic.chatCodeFont),
      },
    );
  }

  Widget contentWidget(String content, bool isFold) {
    ChatResponseModel? model = this.widget.model;
    List<List<String>> tables = model?.tables ?? [];
    if (tables.length > 0) {
      List<TableRow> rows = tables.map((List<String> rows) {
        List<Widget> cells = rows.map((String e) {
          return TableCell(
            child: Center(
              child: Container(
                child: Text(e),
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              ),
            ),
            verticalAlignment: TableCellVerticalAlignment.middle,
          );
        }).toList();
        return TableRow(children: cells);
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            border: TableBorder.all(color: Colors.grey),
            children: rows,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    }

    List<Widget>? itemWidgets = [];
    if (model != null && model.isSearch) {
      itemWidgets = model.items.map((e) {
        return Container(
          alignment: Alignment.centerLeft,
          child: ChatResponseItem(e),
          padding: EdgeInsets.only(bottom: 5.w * logic.zoomRatio),
        );
      }).toList();
      itemWidgets.add(Container(
        child: Row(
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.all(8.w * logic.zoomRatio),
              // 调整Padding的大小以增大点击范围
              child: InkWell(
                onTap: () {
                  bool fold = this.widget.model?.isFold ?? false;
                  this.widget.foldHandle(!fold);
                },
                child: Row(
                  children: [
                    Text('fold'.tr,
                        style: TextStyle(
                            fontSize: 10.sp * logic.zoomRatio,
                            color: themed.theme_c.iconColor,
                            height: 1.7)),
                    SizedBox(
                      width: 2.w * logic.zoomRatio,
                    ),
                    Image.asset(
                      imagePath("chat", "chat_arrow_up"),
                      width: 10.w * logic.zoomRatio,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }

    List<Widget> imageWidgets = images.map((e) {
      int index = images.indexOf(e);
      return Padding(
        padding: EdgeInsets.all(10.r * logic.zoomRatio),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PhotoPreview(
                          galleryItems: images,
                          defaultImage: index,
                          pageChanged: (int index) {},
                        )));
          },
          child: Image.network(
            e,
            width: 200.w * logic.zoomRatio,
          ),
        ),
      );
    }).toList();
    print("ismarkdownMath = ${logic.isMathJaxOutsideCodeBlocks(content)}");

    return Container(
      constraints: BoxConstraints(maxWidth: textPainterWidth2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logic.isMathJaxOutsideCodeBlocks(content)
              ? markdownMath(content)
              : markdown(content),
          SizedBox(
            height: 10.h * logic.zoomRatio,
          ),
          Column(
            children: imageWidgets,
          ),
          SizedBox(
            height: 1,
          ),
          SizedBox(
            height: !(this.widget.model?.isFold ?? false) ? 4.w : 0,
          ),
          Container(
            color: themed.theme_c.bgWhiteOrBlack,
            padding: !(this.widget.model?.isFold ?? false)
                ? EdgeInsets.all(8.w * logic.zoomRatio)
                : null,
            child: Column(
              children: isFold ? [] : itemWidgets,
            ),
          ),
          SizedBox(
            height: 10.w * logic.zoomRatio,
          ),
          Align(
            alignment: Alignment.centerLeft, // 设置文本左对齐
            child: Text(
              'The above content is generated by AI.'.tr,
              style: TextStyle(
                color: themed.theme_c.iconColor,
                fontSize: logic.chatTipsFont.sp,
              ),
            ),
          ),
          SizedBox(
            height: 10.w * logic.zoomRatio,
          ),
        ],
      ),
    );
  }

  double get textPainterWidth2 {
    ChatResponseModel? model = this.widget.model;
    bool isFold = model?.isFold ?? false;
    bool noItems = model?.noItems ?? false;
    bool isSearch = model?.isSearch ?? false;

    // ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    // double maxWidth = chatProvider.isEditMode
    //     ? (TBDefVal.chatBoxMaxWidth - 20 - 35)
    //     : (TBDefVal.chatBoxMaxWidth - 20);
    double maxWidth = logic.chatBoxMaxWidth - 18 * logic.zoomRatio;

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: model?.content ?? "",
            style: TextStyle(fontSize: logic.chatRegularFont.sp)),
        maxLines: 1,
        textDirection: TextDirection.ltr);

    if (isSearch && !noItems && !isFold) {
      textPainter.layout(minWidth: maxWidth, maxWidth: maxWidth);
      if (model?.isFinished ?? false) {
        // this.widget.model?.unfoldWidth = textPainter.width + 20;
      }
    } else {
      textPainter.layout(minWidth: 120 * logic.zoomRatio, maxWidth: maxWidth);
      if (model?.isFinished ?? false) {
        // this.widget.model?.width = textPainter.width + 20;
      }
    }

    return textPainter.width + 20 * logic.zoomRatio;
  }

  Widget get _content {
    ChatResponseModel? model = this.widget.model;
    bool isFold = model?.isFold ?? false;

    return Container(
      padding: EdgeInsets.all(10 * logic.zoomRatio),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r * logic.zoomRatio),
            bottomLeft: Radius.circular(15.r * logic.zoomRatio),
            bottomRight: Radius.circular(15.r * logic.zoomRatio),
          ),
          color: themed.theme_c.bgColorAnsShare),
      child: Column(
        children: [
          // (model?.images ?? []).length > 0
          //     ? _imagecontent
          //     : contentWidget(model?.content ?? "", isFold),
          contentWidget(model?.content ?? "", isFold)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ChatResponseModel? model = this.widget.model;

    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: 12.w * logic.zoomRatio, bottom: 12.w * logic.zoomRatio),
        child: Consumer<ChatProvider>(
          builder: (context, chat, child) {
            // this.widget.model?.resetWidth();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   width: TBDefVal.margin.w * logic.zoomRatio,
                // ),
                // Image.asset(
                //   "assets/images/chat/chat_tiger.png",
                //   fit: BoxFit.contain,
                //   width: 22.w,
                // ),
                SizedBox(
                  width: TBDefVal.margin.w * logic.zoomRatio,
                ),
                // _content,
                (model?.images ?? []).length > 0 ? _imagecontent : _content
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    this.widget.model?.stream = null;
    super.dispose();
  }
}
