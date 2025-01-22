import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../constant/tb_export_common.dart';
import '../../../../util/tb_loading_utils.dart';
import '../../../../util/tb_permission_manager.dart';
import '../../../../util/wechat/tb_wechat_utils.dart';
import '../../logic/tb_chat_detail_logic.dart';
import '../../model/chat_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'dart:io';

class TBShareImageLogic extends GetxController {
  // 在控制器中定义需要共享的参数
  double zoomRatio = 0.64;

  //double zoomRatio = 0.57;

  List<ChatModel> dataSource = [];
  var repaintKey = GlobalKey();

  /// 聊天气泡最大宽度
  double chatBoxMaxWidth = 180.0;

  /// 聊天代码字体大小
  double chatCodeFont = 13.0;

  /// 聊天常规字体大小
  double chatRegularFont = 13.0;

  /// 聊天提示语字体大小
  double chatTipsFont = 11;

  /// 聊天字体竖向比例
  double chatFontSpanHeight = 1.7;

  String data = "这是要转换为二维码的字符串";

  ScrollController? scrollController;

  List<PartModel> partModels = [];
  List<List<PartModel>> result = [];

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    chatBoxMaxWidth = 375.0 * zoomRatio - 25;
  }

  String extractTable(String markdownText) {
    // 使用正则表达式匹配表格的起始和结束标志
    RegExp tableStartRegex = RegExp(r'\|\s*(.+?)\s*\|.*\n\|\s*[-]+\s*\|.*');
    RegExp tableEndRegex = RegExp(r'\n\|\s*(.+?)\s*\|.*\n');

    Match? startMatch = tableStartRegex.firstMatch(markdownText);
    Match? endMatch = tableEndRegex.firstMatch(markdownText);

    if (startMatch != null && endMatch != null) {
      // 提取表格部分
      int startIndex = startMatch.start;
      int endIndex = endMatch.end;

      String tableContent = markdownText.substring(startIndex, endIndex);

      return tableContent;
    } else {
      return "未找到匹配的表格";
    }
  }

  ///判断是否是数学公式
  bool containsMath(String text) {
    // 使用正则表达式来匹配 $...$ 或 $$...$$ 格式的字符串
    final pattern = RegExp(r'\$\$.*?\$\$|\$.*?\$');
    //要匹配 $$...$$ 格式的字符串，你可以使用以下正则表达式：
    // final pattern = RegExp(r'\$\$(.*?)\$\$');

    return pattern.hasMatch(text);
  }

  bool isMathJaxOutsideCodeBlocks(String text) {
    bool containsMathJax(String line) {
      final mathJaxPatterns = [
        RegExp(r"\\\("),
        // inline math mode \(...\)
        RegExp(r"\\\["),
        // display math mode \[...\]
        RegExp(r"\$\$"),
        // alternative display math mode $$...$$
        RegExp(r"\$[^\s]*\$"),
        // single dollar match without spaces between them
      ];

      for (var pattern in mathJaxPatterns) {
        if (pattern.hasMatch(line)) {
          return true;
        }
      }

      return false;
    }

    // Split the text by lines
    final lines = text.split('\n');

    bool inCodeBlock = false;

    for (var line in lines) {
      if (line.startsWith('```')) {
        inCodeBlock = !inCodeBlock;
        continue;
      }

      if (!inCodeBlock && containsMathJax(line)) {
        return true;
      }
    }

    return false;
  }

  ///判断是否是表格
  bool isMarkdownTable(String text) {
    // 检查文本中是否包含表格行的管道符和分隔线
    return text.contains('|') && text.contains('-');
  }

  ///检测字符串中是否包含 HTML 标签
  bool containsHtml(String text) {
    final RegExp htmlTagRegExp = RegExp(r'<[^>]*>');
    return htmlTagRegExp.hasMatch(text);
  }

  List<Widget> getLatexText(String text) {
    partModels = [];
    result = [];
    print('----------------------begin----------------------');

    final parts = splitText(text);
    for (final part in parts) {
      print(part);
      print('11111---');
    }
    for (final part in parts) {
      if (part.startsWith('\$\$') && part.endsWith('\$\$')) {
        String str = part.replaceAll('\$', '');
        partModels.add(PartModel(str, 2)); // $$...$$
      } else if (part.startsWith('\$') && part.endsWith('\$')) {
        String str = part.replaceAll('\$', '');
        partModels.add(PartModel(str, 1)); // $...$
      } else {
        partModels.add(PartModel(part, 0)); // Other text
      }
    }
    final twoDArray = convertTo2DArray(partModels);
    // for (final twopart in twoDArray) {
    //   print('----------------大组-----------------');
    //   for (final part in twopart) {
    //     print('xiao组-----------------');
    //     print('str: ${part.str}, type: ${part.type}');
    //   }
    // }
    return parseLatexText(twoDArray);
  }

  List<List<PartModel>> convertTo2DArray(List<PartModel> partModels) {
    List<PartModel> currentList = [];
    for (int i = 0; i < partModels.length; i++) {
      currentList.add(partModels[i]);
      if (partModels[i].type == 2) {
        result.add(List.from(currentList));
        currentList.clear();
      } else if (i == partModels.length - 1) {
        result.add(List.from(currentList));
        currentList.clear();
      } else if ((partModels[i + 1].type == 2)) {
        result.add(List.from(currentList));
        currentList.clear();
      }
    }
    return result;
  }

  List<String> splitText(String text) {
    final List<String> parts = [];
    final regex = RegExp(r'\$\$([^\$]+)\$\$|\$([^\$]+)\$');
    var matches = regex.allMatches(text);
    var currentIndex = 0;

    for (var match in matches) {
      if (match.start > currentIndex) {
        // Add the text before the match
        parts.add(text.substring(currentIndex, match.start));
      }

      if (match.group(1) != null) {
        // Matched $$...$$
        parts.add('\$\$${match.group(1)}\$\$');
      } else if (match.group(2) != null) {
        // Matched $...$
        parts.add('\$${match.group(2)}\$');
      }

      currentIndex = match.end;
    }
    if (currentIndex < text.length) {
      parts.add(text.substring(currentIndex));
    }

    return parts;
  }

  List<Widget> parseLatexText(List<List<PartModel>> twoDArray) {
    final List<Widget> widgets = [];

    for (var row in twoDArray) {
      if (row.length > 1) {
        // Create a Row for mixed content
        List<InlineSpan> rowSpans = [];
        for (var part in row) {
          if (part.type == 0) {
            rowSpans.add(TextSpan(
              text: part.str,
              style: TextStyle(
                  height: TBDefVal.chatFontSpanHeight,
                  color: TBDefVal.chatRegularColor,
                  fontSize: chatRegularFont.sp,
                  fontWeight: FontWeight.w500),
            ));
          } else if (part.type == 1) {
            rowSpans.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Math.tex(
                  part.str,
                  textStyle: TextStyle(
                      height: TBDefVal.chatFontSpanHeight,
                      color: TBDefVal.chatRegularColor,
                      fontSize: chatRegularFont.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            );
          }
        }
        widgets.add(RichText(
          text: TextSpan(
            children: rowSpans,
            style: TextStyle(
                height: TBDefVal.chatFontSpanHeight,
                color: TBDefVal.chatRegularColor,
                fontSize: chatRegularFont.sp,
                fontWeight: FontWeight.w500),
          ),
        ));
      } else {
        var part = row[0];
        if (part.type == 0) {
          // Use Text for single element with type 0
          widgets.add(Text(
            part.str,
            style: TextStyle(
                height: TBDefVal.chatFontSpanHeight,
                color: TBDefVal.chatRegularColor,
                fontSize: chatRegularFont.sp,
                fontWeight: FontWeight.w500),
          ));
        } else {
          // Use Math.tex for single element with type 2
          widgets.add(Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 水平滚动
              child: Math.tex(
                part.str,
                textStyle: TextStyle(
                    height: TBDefVal.chatFontSpanHeight,
                    color: TBDefVal.chatRegularColor,
                    fontSize: chatRegularFont.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ));
        }
      }
    }
    return widgets;
  }

  changeZoomRatio(double size) {
    zoomRatio = size;
    if (zoomRatio == 0.64) {
      chatBoxMaxWidth = 375.0 * zoomRatio - 30;

      /// 聊天代码字体大小
      chatCodeFont = 10.0;

      /// 聊天常规字体大小
      chatRegularFont = 10.0;

      /// 聊天提示语字体大小
      chatTipsFont = 9;

      /// 聊天字体竖向比例
      chatFontSpanHeight = 1.7;
    } else {
      chatBoxMaxWidth = 375.0 * zoomRatio - 27;

      /// 聊天代码字体大小
      chatCodeFont = 9.0;

      /// 聊天常规字体大小
      chatRegularFont = 9.0;

      /// 聊天提示语字体大小
      chatTipsFont = 8;

      /// 聊天字体竖向比例
      chatFontSpanHeight = 1.7;
    }
  }

  /// 执行存储图片到本地相册
  void doSaveImage() async {
    bool isGranted = await TBPermissionManager.getStoragePermission(
        completionHandler: () async {});
    debugPrint('-------------isGranted.$isGranted');
    if (isGranted) {
      PermissionStatus permissionStatus;
      debugPrint('-------------save');

      Uint8List data = await getImageData();
      String path = await saveImage(data);
      final result = await ImageGallerySaver.saveFile(path);
      TBLoadingUtils.success(text: '保存成功！');
      TBRouterHelper.back(null);
    }
    TBRouterHelper.back(null);
  }

  /// 分享给好友
  void doShareFriend() async {
    Uint8List data = await getImageData();
    TBWeChatUtils.instance.shareBinaryImage(data);
    TBRouterHelper.back(null);
  }

  /// 分享朋友圈
  void doShareCircle() async {
    Uint8List data = await getImageData();
    TBWeChatUtils.instance.shareBinaryImage(data, sceneValue: 1);
    TBRouterHelper.back(null);
  }

  /// 获取截取图片的数据
  Future<Uint8List> getImageData() async {
    BuildContext buildContext = repaintKey.currentContext!;
    //用于存储截取的图片数据
    var imageBytes;
    //通过 buildContext 获取到 RenderRepaintBoundary 对象，表示要截取的组件边界
    RenderRepaintBoundary boundary =
        buildContext.findRenderObject() as RenderRepaintBoundary;

    //这行代码获取设备的像素密度，用于设置截取图片的像素密度
    // double dpr = 3.0;
    double dpr = MediaQuery.of(buildContext).devicePixelRatio; // 使用设备的像素密度

    //将边界对象 boundary 转换为图像，使用指定的像素密度。
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    // image.width
    //将图像转换为ByteData数据，指定了数据格式为 PNG 格式。
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //将ByteData数据转换为Uint8List 类型的图片数据。
    imageBytes = byteData!.buffer.asUint8List();
    return imageBytes;
  }

  Future<String> saveImage(Uint8List imageByte) async {
    //将回调拿到的Uint8List格式的图片转换为File格式
    //获取临时目录
    if (Platform.isIOS || Platform.isAndroid) {
      // 在移动平台或桌面平台上运行文件操作代码
      var tempDir = await getTemporaryDirectory();
      //生成file文件格式
      var file =
          await File('${tempDir.path}/image_${DateTime.now().millisecond}.png')
              .create();
      //转成file文件
      file.writeAsBytesSync(imageByte);
      print("${file.path}");
      String path = file.path;
      return path;
    } else {
      return '';
    }
  }
}
