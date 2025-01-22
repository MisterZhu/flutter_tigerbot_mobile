import 'package:TigerChat/pages/chat/widgets/cell/chat_response_item.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../constant/tb_export_common.dart';
import '../../../../util/code_element_builder.dart';
import '../../../../widgets/photo_view.dart';
import '../../../../widgets/tb_custom_clipper.dart';
import '../../logic/tb_chat_detail_logic.dart';
import '../../model/chat_response_model.dart';
import '../chat_like_tool.dart';
import 'chat_image_loading.dart';
import 'chat_response_search_item.dart';
import 'package:markdown/markdown.dart' as md;

class ChatResponseCell extends StatefulWidget {
  late ChatResponseModel? model;
  late int? indexNum;
  void Function(bool) foldHandle;
  void Function(bool) likeHandle;
  void Function() shareHandle;
  void Function() reportHandle;
  final Function()? deleteHandle;
  final Function()? mulChoiceHandle;
  final Function()? selectAllHandle;
  final Function(ChatResponseModel) onStateChanged;

  final Function(String)? regenerateHandle;

  ChatResponseCell(this.model, this.indexNum,
      {required this.foldHandle,
      required this.likeHandle,
      required this.shareHandle,
      required this.reportHandle,
      required this.onStateChanged,
      this.deleteHandle,
      this.mulChoiceHandle,
      this.selectAllHandle,
      this.regenerateHandle,
      Key? key})
      : super(key: key);

  @override
  State<ChatResponseCell> createState() => _ChatResponseCellState();
}

class _ChatResponseCellState extends State<ChatResponseCell> {
  // String content = "";
  // List<List<String>> tables = [];
  List images = [];

  GlobalKey _key = GlobalKey();
  GlobalKey _btnkey = GlobalKey();

  final GlobalKey itemKey = GlobalKey();
  double? itemHeight; // 用于保存高度

  final TBChatDetailLogic logicDet = Get.put(TBChatDetailLogic());

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

  Widget markdownMath(String content) {
    print('------------展示数学公式');
    return Padding(
      padding: EdgeInsets.only(left: 4.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: logicDet.getLatexText(content),
      ),
    );
  }

  Widget markdown(String content) {
    print('------------展示markdown文本');

    var leftP = 0.0;
    if ((logicDet.isMarkdownTable(content)) ||
        (content.contains("```")) ||
        (logicDet.isMathJaxOutsideCodeBlocks(content))) {
    } else {
      content = content.replaceAll("\n", "\n\n");
      leftP = 5.0;
    }
    ChatResponseModel? model = this.widget.model;

    return Container(
      padding: EdgeInsets.only(left: leftP.w, right: 0.0.w), // 设置左右边距为15.0
      child: MarkdownBody(
        data: content,
        onTapLink: (text, href, title) {
          debugPrint('title =$title text = $text url = $href');
          var params = {"title": text, "url": href};
          if (href != null && href != '') {
            TBRouterHelper.pathPage(TBRouterPath.webViewPath, params);
          }
        },
        styleSheet: MarkdownStyleSheet(
          listBullet: TextStyle(
            fontSize: TBDefVal.chatRegularFont.sp, // 你想要的字体大小
            // 其他样式属性...
          ),
          a: TextStyle(
            color: Color(0xFF1677FF), // 修改超链接的颜色
            // decoration: TextDecoration.underline, // 可选：添加下划线
          ),
          h1: TextStyle(
              height: TBDefVal.chatFontSpanHeight,
              color: themed.theme_c.textColorAns,
              fontSize: TBDefVal.chatRegularFont.sp,
              fontWeight: FontWeight.w500),
          p: TextStyle(
              height: TBDefVal.chatFontSpanHeight,
              color: themed.theme_c.textColorAns,
              fontSize: TBDefVal.chatRegularFont.sp,
              fontWeight: FontWeight.w500),
          // code: TextStyle(
          //   backgroundColor: themed.theme_c.bgColor, // 设置代码块背景颜色
          //   // color: themed.theme_c.textColorMild, // 设置代码块文字颜色
          // ),
        ),
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubWeb.blockSyntaxes,
          [
            md.EmojiSyntax(),
            SpanSyntax(), // Register custom syntax
          ],
        ),
        builders: {
          "code": CodeElementBuilder(TBDefVal.chatCodeFont),
          'custom_link':
              SpanElementBuilder(model?.items ?? []), // Register custom builder
        },
      ),
    );
  }

  // bool doesNotContainMarkdownLink(String text) {
  //   // 正则表达式匹配 [文本](链接) 的格式
  //   final RegExp spanTagRegExp = RegExp(r'<custom_link>.*?<\/custom_link>');
  //   return spanTagRegExp.hasMatch(text);
  // }
  bool doesNotContainMarkdownLink(String text) {
    // 正则表达式匹配 [文本](链接) 的格式
    RegExp markdownLinkRegExp = RegExp(r'\[.*?\]\(.*?\)');

    // 如果匹配到该格式的字符串，则返回 false，否则返回 true
    return markdownLinkRegExp.hasMatch(text);
  }

  Widget contentWidget(String content, List images) {
    ChatResponseModel? model = this.widget.model;
    var isTags = logicDet.containsCustomTags(content);
    if (isTags) {
      content = logicDet.replaceHyperLink(content, model!.items);
    }
    // var isLink = doesNotContainMarkdownLink(content);

    // print('是否包含超链接：$isLink');
    List<Widget> imageWidgets = images.map((e) {
      int index = images.indexOf(e);
      return GestureDetector(
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
          width: 200.w,
        ),
      );
    }).toList();

    // double calWidth = model?.calWidth ?? 0;

    double calWidth = 0;
    print(
        '----------------------------content --------------------- \n$content');
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    return Container(
      // constraints: BoxConstraints(
      //     maxWidth: calWidth > 0 ? calWidth.w : textNormalWidth.w),
      width: TBDefVal.chatMaxWidth.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logicDet.isMathJaxOutsideCodeBlocks(content)
              ? markdownMath(content)
              : markdown(content),
          SizedBox(
            height: 10.h,
          ),
          Column(
            children: imageWidgets,
          ),
          //          images.length > 0 || !(model?.isSearch ?? false) || isLink
          images.length > 0 ||
                  ((model?.items.length ?? 0) <= 0) ||
                  !(model?.isFinished ?? false)
              ? SizedBox(
                  height: 1,
                )
              : Padding(
                  // padding: EdgeInsets.all(8.w), // 调整Padding的大小以增大点击范围
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      showPopup();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          // imagePath("chat", "chat_more_quote"),
                          themed.getMoreImagePath(),
                          width: 16.w,
                          // color: themed.theme_c.iconColor, // 你想要的颜色
                          // colorBlendMode: BlendMode.srcIn, // 混合模式
                        ),
                      ],
                    ),
                  ),
                ),
          SizedBox(
            height: 10.w,
          ),
          images.length > 0
              ? SizedBox(
                  height: 1,
                )
              : ChatLikeTool(
                  indexNum: this.widget.indexNum ?? 0,
                  isUnlike: this.widget.model?.isUnlike ?? false,
                  model: this.widget.model,
                  likeTap: (like) {
                    this.widget.likeHandle(like);
                  },
                  reportTap: () {
                    this.widget.reportHandle();
                  },
                  shareTap: () {
                    this.widget.shareHandle();
                  },
                  copyTap: () {
                    if (!chatProvider.isStreamLoading) {
                      Clipboard.setData(ClipboardData(
                          text: this.widget.model?.content ?? ''));
                      Fluttertoast.showToast(
                        msg: 'Copy successfully'.tr,
                        gravity: ToastGravity.CENTER,
                      );
                    }
                  },
                  regenerateTap: () {
                    print("点击重新生成按钮");
                    print("regenerateHandle = ${this.widget.regenerateHandle}");
                    print("isStreamLoading = ${chatProvider.isStreamLoading}");
                    if (this.widget.regenerateHandle != null &&
                        !chatProvider.isStreamLoading) {
                      print("调用重新生成方法");

                      this
                          .widget
                          .regenerateHandle!(this.widget.model?.query ?? '');
                    }
                  },
                )
        ],
      ),
    );
  }

  double get textNormalWidth {
    ChatResponseModel? model = this.widget.model;
    bool noItems = model?.noItems ?? false;
    bool isSearch = model?.isSearch ?? false;
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    double maxWidth = chatProvider.isEditMode
        ? (TBDefVal.chatMaxWidth - 20 - 35)
        : (TBDefVal.chatMaxWidth - 20);
    // String? contentWithoutNewlines = model?.content?.replaceAll('\n', '');

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: model?.content ?? "",
          style: TextStyle(
            // letterSpacing: TBDefVal.chatWordSpacing, // 调整字符间距的值，可以为负数以减小间距
            fontSize: TBDefVal.chatRegularFont.sp,
            fontWeight: FontWeight.w500,
            // height: TBDefVal.chatFontSpanHeight
          ),
        ),
        // maxLines: 2,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    final double width = textPainter.width + 10.w;
    print('width = $width');
    print('maxWidth = $maxWidth');

    if (isSearch) {
      maxWidth = maxWidth;
    } else if (width > 150 && width <= maxWidth) {
      maxWidth = width;
    } else if (width < 150) {
      maxWidth = 150;
    }
    return maxWidth;
  }

  Widget get _content {
    print('---------------------------展示内容_content');
    ChatResponseModel? model = this.widget.model;
    // bool isFold = model?.isFold ?? false;
    double progress = (model?.progressP ?? 0) / 100.0;
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
          color: themed.theme_c.bgColorAns),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // model?.isOperation ?? false
          //     ? CustomProgressWidget(
          //         progress: progress, // 0.0 to 1.0
          //         upperText: '${model?.progressP ?? 0} %',
          //         lowerText: '答案生成中...',
          //       )
          //     : Container(),
          contentWidget(model?.content ?? "", model?.images ?? [])
        ],
      ),
    );
  }

  Widget get _imagecontent {
    print('---------------------------展示内容_imagecontent');
    ChatResponseModel? model = this.widget.model;
    final images = model?.images ?? [];
    List<Widget> imageWidgets = images.map((e) {
      int index = images.indexOf(e);
      return GestureDetector(
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
          width: 200.w,
        ),
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

  Widget get _loadingContent {
    ChatResponseModel? model = this.widget.model;
    double progress = (model?.progressP ?? 0) / 100.0;
    double imgProgress = logicDet.percentage / 100.0;

    print('-----------------------展示loading ${logicDet.percentage}');
    logicDet.startTimer();
    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 12.w, bottom: 12.w, top: 12.w),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
          color: themed.theme_c.bgColorAns),
      child: GetBuilder<TBChatDetailLogic>(
          id: TBDefVal.kChatLoading, // 添加id绑定，update时只当前GetBuilder会刷新
          // global: true, // 添加 global 参数，使其全局监听 影响性能
          builder: (state) {
            return Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // model?.isOperation ?? false
                //     ? CustomProgressWidget(
                //         progress: progress, // 0.0 to 1.0
                //         upperText: '${model?.progressP ?? 0} %',
                //         lowerText: '答案生成中...',
                //         imagePath:
                //             'assets/images/chat/chat_search_document_s.png',
                //       )
                //     : model?.isPainting ?? false
                //         ? CustomProgressWidget(
                //             progress: imgProgress, // 0.0 to 1.0
                //             upperText: '${logicDet.percentage.toInt()} %',
                //             lowerText: '图片生成中...',
                //             imagePath:
                //                 'assets/images/chat/chat_search_picture_s.png',
                //           )
                //         : SpinKitThreeBounce(
                //             color: themed.theme_c.textColor,
                //             size: 15,
                //           ),
                _buildCustomWidget(model, progress, imgProgress, logicDet),
              ],
            );
          }),
    );
  }

// 创建一个单独的方法来处理逻辑判断
  Widget _buildCustomWidget(ChatResponseModel? model, double progress,
      double imgProgress, TBChatDetailLogic logicDet) {
    if (model?.isOperation ?? false) {
      return CustomProgressWidget(
        progress: progress, // 0.0 to 1.0
        upperText: '${model?.progressP ?? 0} %',
        lowerText: '答案生成中...',
        imagePath: 'assets/images/chat/chat_search_document_s.png',
      );
    } else if (model?.isPainting ?? false) {
      return CustomProgressWidget(
        progress: imgProgress, // 0.0 to 1.0
        upperText: '${logicDet.percentage.toInt()} %',
        lowerText: '图片生成中...',
        imagePath: 'assets/images/chat/chat_search_picture_s.png',
      );
    } else if (model?.isSearching ?? false) {
      return CustomProgressWidget(
        progress: imgProgress, // 0.0 to 1.0
        upperText: '${logicDet.percentage.toInt()} %',
        lowerText: '全网搜索中...',
        imagePath: 'assets/images/chat/chat_search_s.png',
      );
    } else {
      return SpinKitThreeBounce(
        color: themed.theme_c.textColor,
        size: 15,
      );
    }
  }

  void showPopup() {
    ChatResponseModel? model = this.widget.model;

    List<Widget>? itemWidgets = [];
    if (model != null && model.isSearch) {
      itemWidgets = model.items.map((e) {
        return Container(
          alignment: Alignment.centerLeft,
          child: ChatResponseSearchItem(e),
          // padding: EdgeInsets.only(bottom: 5.w),
        );
      }).toList();
    }
    BrnPopupDirection topOrBot = BrnPopupDirection.bottom;
    double bottomDis = TBUtils.getBottomDistanceFromKey(itemKey);
    bottomDis = bottomDis + 140;
    double wegH = TBUtils.getHeightFromKey(itemKey);
    double offsetDis = 0.0;
    if (bottomDis >= TBDefVal.screenHeight / 2) {
      offsetDis = -80;
      topOrBot = BrnPopupDirection.bottom;
    } else {
      offsetDis = 125 - wegH;
      topOrBot = BrnPopupDirection.top;
    }
    BrnPopupWindow.showPopWindow(
      context,
      "",
      itemKey,
      hasCloseIcon: true,
      dismissCallback: () {},
      // offset: 20.w,
      arrowOffset: 26.w,
      offset: offsetDis,
      popDirection: topOrBot,
      // borderColor: TBColors.color_D7D8DB,
      // backgroundColor: TBColors.color_272727,
      backgroundColor: TBColors.color_323335,

      paddingInsets:
          const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      widget: Container(
        // height: 118.h,
        width: (TBDefVal.screenWidth - 60).w,
        // padding: EdgeInsets.all(8.w),
        child: itemWidgets.length > 3
            ? Container(
                height: 300.h,
                child: ListView(
                  padding: EdgeInsets.zero, // 去掉默认的padding
                  children: itemWidgets,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min, // 让Column自适应高度
                children: itemWidgets,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("-----response build response");
    if ((this.widget.model?.height ?? 0) < 20) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final RenderBox? renderBox =
            itemKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          itemHeight = renderBox.size.height;
          print("-----itemHeight response = $itemHeight");
          this.widget.model?.height = itemHeight;
          // widget.onStateChanged(this.widget.model!);
        }
      });
    }

    return Container(
      key: itemKey,
      child: Padding(
        padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
        child: Consumer<ChatProvider>(
          builder: (context, chat, child) {
            // this.widget.model?.resetWidth();
            ChatResponseModel? model = this.widget.model;
            String contentStr = model?.content ?? "";
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chat.isEditMode
                    ? Checkbox(
                        value: this.widget.model?.isEditSelected ?? false,
                        activeColor: themed.theme_c.buttonBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        onChanged: (value) {
                          setState(() {
                            this.widget.model?.isEditSelected = value;
                            widget.onStateChanged(this.widget.model!);
                          });
                        })
                    : SizedBox(
                        width: TBDefVal.margin.w,
                      ),
                // Image.asset(
                //   "assets/images/chat/chat_tiger.png",
                //   fit: BoxFit.contain,
                //   width: TBDefVal.chatHeaderWidth.w,
                // ),
                // SizedBox(
                //   width: TBDefVal.margin.w,
                // ),
                (contentStr.isEmpty && !(model!.isFinished))
                    ? _loadingContent
                    : GestureDetector(
                        child: (model?.images ?? []).length > 0
                            ? _imagecontent
                            : _content,
                        key: _key,
                        onLongPress: () {
                          // 不执行任何长按操作，直接返回
                          return;
                          BrnPopupDirection topOrBot = BrnPopupDirection.bottom;
                          double topdis =
                              TBUtils.getTopDistanceFromKey(itemKey);
                          double botdis =
                              TBUtils.getBottomDistanceFromKey(itemKey);
                          double wegH = TBUtils.getHeightFromKey(itemKey);
                          double offsetDis = 10.0;
                          if ((topdis >= 70 && botdis >= 70) ||
                              (topdis < 70 && botdis >= 70)) {
                            offsetDis = 10;
                            topOrBot = BrnPopupDirection.bottom;
                          } else if (topdis < 70 && botdis < 70) {
                            offsetDis = -(TBDefVal.screenHeight / 2 - botdis);
                            topOrBot = BrnPopupDirection.bottom;
                          } else if (topdis >= 70 && botdis < 70) {
                            offsetDis = 10;
                            topOrBot = BrnPopupDirection.top;
                          }
                          BrnPopupWindow.showPopWindow(
                            context,
                            'Clear Record'.tr,
                            _key,
                            // arrowOffset: -1000,
                            // offset: 25.w,
                            offset: offsetDis.h,
                            popDirection: topOrBot,
                            paddingInsets: const EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 0),

                            widget: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      if (this.widget.deleteHandle != null) {
                                        this.widget.deleteHandle!();
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0,
                                          right: 10.0,
                                          top: 14,
                                          bottom: 14),
                                      child: Text(
                                        'Delete'.tr,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 10.w,
                                  // ),
                                  Container(
                                    width: 1,
                                    height: 8.w,
                                    color: Colors.white,
                                  ),
                                  // SizedBox(
                                  //   width: 10.w,
                                  // ),
                                  Consumer<ChatProvider>(
                                      builder: (context, chat, child) {
                                    return InkWell(
                                      onTap: () {
                                        Get.back();

                                        chat.editMode = !chat.isEditMode;
                                        if (this.widget.mulChoiceHandle !=
                                            null) {
                                          this.widget.mulChoiceHandle!();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 14,
                                            bottom: 14),
                                        child: Text(
                                          chat.isEditMode
                                              ? 'Cancel Multi-select'.tr
                                              : 'Multi-select'.tr,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }),
                                  // SizedBox(
                                  //   width: 10.w,
                                  // ),
                                  Container(
                                    width: 1,
                                    height: 8.w,
                                    color: Colors.white,
                                  ),
                                  // SizedBox(
                                  //   width: 10.w,
                                  // ),
                                  Consumer<ChatProvider>(
                                      builder: (context, chat, child) {
                                    return InkWell(
                                      onTap: () {
                                        Get.back();

                                        print("点击全选");
                                        chat.choiceAll = !chat.isChoiceAll;
                                        if (this.widget.selectAllHandle !=
                                            null) {
                                          this.widget.selectAllHandle!();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 18.0,
                                            top: 14,
                                            bottom: 14),
                                        child: Text(
                                          chat.isChoiceAll
                                              ? 'Cancel select all'.tr
                                              : 'Select all'.tr,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                // SizedBox(
                //   width: TBDefVal.chatLRMargin.w,
                // ),
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

class CustomProgressWidget extends StatelessWidget {
  final double progress;
  final String upperText;
  final String lowerText;
  final String imagePath; // 新增图片路径参数

  const CustomProgressWidget({
    required this.progress,
    required this.upperText,
    required this.lowerText,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 左侧环形进度条
        Container(
          width: 50.0.w, // 调整宽度根据实际需求
          height: 50.0.w, // 调整高度根据实际需求
          padding: EdgeInsets.all(6.0.w), // 调整内边距根据实际需求
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10.0.w)), // 设置圆角
          ),
          child: Stack(
            children: [
              // 图片
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 22.0.w, // 调整图片宽度
                    height: 22.0.w, // 调整图片高度
                    color: themed.theme_c.themeOppoColor, // 你想要的颜色
                    colorBlendMode: BlendMode.srcIn, // 混合模式
                  ),
                ),
              ),
              // 圆形进度条
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: themed.theme_c.themeOppoColor33,
                  valueColor:
                      AlwaysStoppedAnimation(themed.theme_c.themeOppoColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.0.w), // 调整间距根据实际需求
        // 右侧文本
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              upperText,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
            Text(
              lowerText,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
