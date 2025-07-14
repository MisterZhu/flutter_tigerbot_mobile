import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:TigerChat/pages/chat/model/chat_request_file_model.dart';
import 'package:TigerChat/util/tb_permission_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenshot_callback/flutter_screenshot_callback.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/tb_config.dart';
import '../../../constant/tb_enum.dart';
import '../../../constant/tb_export_common.dart';
import '../../../util/request/http_request.dart';
import '../../../util/request/response/TBResponse.dart';
import '../../../util/request/sc_http_manager.dart';
import '../../../util/tb_loading_utils.dart';
import '../../../util/tb_utils.dart';
import '../../../util/wechat/tb_wechat_utils.dart';
import '../../../widgets/tb_image_dialog.dart';
import '../VoiceMsgView/logic/tb_voice_controller.dart';
import '../model/chat_helloworld_model.dart';
import '../model/chat_model.dart';
import '../model/chat_request_model.dart';
import '../model/chat_response_model.dart';
import '../model/tb_assistants_model.dart';
import '../model/tb_chat_msg_model.dart';

class PartModel {
  String str;
  int type;

  PartModel(this.str, this.type);
}

class TBChatDetailLogic extends GetxController implements IScreenshotCallback {
  List<Map>? _datas;

  // 创建一个空的总 Map 用于汇总所有 data 字段的 Map
  Map<String, dynamic>? totalDataMap = {};
  // List<dynamic>? dataList = [];
  // List<dynamic>? randomList = [];
  List? _types;
  late ScreenshotCallback _screenshotCallback;
  String _imagePath = '';

  String content = '';

  int eventCount = 0;
  int maxEventCount = 35;
  int number = 0;

  List<PartModel> partModels = [];
  List<List<PartModel>> result = [];

  String messagesId = '';
  int currentPage = 1;
  int dataSourceIndex = 0;

  String session = '';
  String assistant = '';
  // String metadata = '';

  String requestStr = '';
  bool documentAnalysis = false;
  bool onlineSearch = true;
  bool imageGeneration = true;
  bool isLast = false;
  bool isEdit = false;
  bool isStopGeneration = false;
  bool isLogin = false;
  bool isRemoveSuggest = true;

  List<String>? siblingMessageIds;

  List<TBAssistantsModel> assistantAry = [];
  List<TBSessionModel> sessionAry = [];
  List<TBSessionData> secondSeAry = [];
  List<ChatResponseItemModel> items = [];

  List<TBChatMessageModel> msgAry = [];
  List<ChatModel> dataSource = [];
  ScrollController? scrollController;

  // Completer<void> _completion = Completer<void>();
  late ImagePicker _picker = ImagePicker();
  String imageFilePath = '';
  String documentPath = '';
  String documentAllPath = '';
  String documentType = '';
  var _timer;
  double percentage = 0.0;
  int currentRetryCount = 0;

  @override
  onInit() async {
    super.onInit();
    SCHttpManager.init();

    scrollController = ScrollController();
    initCallback();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String isShowPrivacy = preferences.getString(TBDefVal.kToken) ?? '';
    bool isShowGuide = preferences.getBool(TBDefVal.isShowGuideAlert) ?? true;

    String mobile = preferences.getString(TBDefVal.kMobile) ?? '';

    debugPrint(
        '-------------------------->>>>>>>>>>isShowGuide = $isShowGuide');

    if (isShowPrivacy.isNotEmpty && mobile.isNotEmpty) {
      isLogin = true;
      // requestKeyView();
      createSession(showToast: false);
      requestSessionList();
      if (isShowGuide) {
        TBUtils.getCurrentContext(completionHandler: (context) async {
          Future.delayed(const Duration(milliseconds: 1500), () async {
            bool isOppoOrOnePlus = await TBUtils.getDeviceInfo();
            debugPrint(
                '-------------------------->>>>>>>>>>isOppoOrOnePlus = $isOppoOrOnePlus');
            if (isOppoOrOnePlus) {
              showAgreementDialog(context);
            }
          });
        });
      }
    } else {
      isLogin = false;
      // requestKeyView();
      resetDataSource();
      update([TBDefVal.kChatSession]);
      update([TBDefVal.kChatInputFile]);
      update([TBDefVal.kChatMsgList]);
      TBUtils.getCurrentContext(completionHandler: (context) async {
        TBHttpResponse response = await TBHttpRequest.post(
                TBUrl.kKeyViewUrl, context, params: {"key": "cases"})
            as TBHttpResponse;
        if (response.success) {
        } else {}
      });
    }

    // SCJPush.initJPush();
  }

  startTimer() {
    print('=============定时器开始执行');

    if (_timer == null) {
      print('=============定时器开启');
      percentage = 0.0;
      _timer = Timer.periodic(Duration(milliseconds: 500), (t) {
        print('--------------执行');
        final model = dataSource[0];
        if (isStopGeneration && model.content.isEmpty) {
          print("移除qian = ${dataSource.length}");
          print("-----------------------------------移除");
          dataSource.remove(model);
          print("移除hou = ${dataSource.length}");
          update([TBDefVal.kChatMsgList]);
          disTimer();
        }
        if (percentage <= 95) {
          percentage += Random().nextInt(3);
        }

        update([TBDefVal.kChatLoading]);
      });
    }
  }

  disTimer() {
    print('============定时器开始取消');
    if (_timer != null) {
      print('---------定时器销毁');
      _timer.cancel();
      _timer = null; // 手动将 _timer 置为 null
    }
  }

  ///新建会话
  createSession({bool showToast = true}) {
    final TBVoiceController voiceLogic = Get.find<TBVoiceController>();
    voiceLogic.showTool = false;
    voiceLogic.showMore = false;
    isRemoveSuggest = false;

    session = '';
    documentPath = '';
    documentAllPath = '';
    documentType = '';
    imageFilePath = '';
    documentAnalysis = false;
    onlineSearch = true;
    imageGeneration = true;
    resetDataSource();
    update([TBDefVal.kChatMsgList]);
    update([TBDefVal.kChatInputFile]);
    Get.find<TBVoiceController>().update([TBDefVal.kChatInput]);
    if (showToast) {
      Fluttertoast.showToast(msg: '新建会话成功', gravity: ToastGravity.CENTER);
    }
  }

  ///切换会话类型
  changeSessionType(int type) {
    print("--------------------object");
    final TBVoiceController voiceLogic = Get.find<TBVoiceController>();
    voiceLogic.showTool = false;
    voiceLogic.showMore = false;
    switch (type) {
      case 0: //联网
        onlineSearch = true;
        documentAnalysis = false;
        imageGeneration = true;

        break;
      case 1: //文件
        onlineSearch = false;
        documentAnalysis = true;
        imageGeneration = false;
        break;
      default:
        onlineSearch = true;
        documentAnalysis = false;
        imageGeneration = true;
        break;
      // case 0: //默认
      //   onlineSearch = false;
      //   documentAnalysis = false;
      //   imageGeneration = false;
      //
      //   break;
      // case 1: //联网
      //   onlineSearch = true;
      //   documentAnalysis = false;
      //   imageGeneration = false;
      //
      //   break;
      // case 2: //文件
      //   onlineSearch = false;
      //   documentAnalysis = true;
      //   imageGeneration = false;
      //
      //   break;
      // case 3: //文生图
      //   onlineSearch = false;
      //   documentAnalysis = false;
      //   imageGeneration = true;
      //
      //   break;
      // default:
      //   onlineSearch = false;
      //   documentAnalysis = false;
      //   imageGeneration = false;
      //
      //   break;
    }
    isRemoveSuggest = false;
    // if (session != '') {
    //   Fluttertoast.showToast(msg: '已开启新的会话', gravity: ToastGravity.CENTER);
    // } else {
    //   // if (onlineSearch) {
    //   //   Fluttertoast.showToast(msg: '开启联网模式', gravity: ToastGravity.CENTER);
    //   // } else {
    //   //   Fluttertoast.showToast(msg: '关闭联网模式', gravity: ToastGravity.CENTER);
    //   // }
    // }
    session = '';
    documentPath = '';
    documentAllPath = '';
    documentType = '';
    imageFilePath = '';
    resetDataSource();
    update([TBDefVal.kChatMsgList]);
    update([TBDefVal.kChatInputFile]);
    Get.find<TBVoiceController>().update([TBDefVal.kChatInput]);
    Fluttertoast.showToast(msg: '已开启新的会话', gravity: ToastGravity.CENTER);
  }

  // /*获取图类型片路径*/
  // String getSessionImgPath() {
  //   if (documentAnalysis) {
  //     return 'assets/images/chat/chat_search_file.png';
  //   } else if (onlineSearch) {
  //     return 'assets/images/chat/chat_search_earth.png';
  //   } else if (imageGeneration) {
  //     return 'assets/images/chat/chat_search_picture.png';
  //   } else {
  //     return 'assets/images/chat/chat_search_msg.png';
  //   }
  // }

/*获取图类型片路径*/
  String getSessionImgPathPink(TBSessionModel model) {
    if (model.pluginConfig?.documentAnalysis?.enabled ?? false) {
      return 'assets/images/chat/chat_search_document_s.png';
    } else if (model.pluginConfig?.onlineSearch?.enabled ?? false) {
      return 'assets/images/chat/chat_search_earth_s.png';
    } else if (model.pluginConfig?.imageGeneration?.enabled ?? false) {
      return 'assets/images/chat/chat_search_picture_s.png';
    } else {
      return 'assets/images/chat/chat_search_msg_s.png';
    }
  }

  ///重置消息数据源
  resetDataSource() {
    print('============重置消息数据源');

    dataSource.clear(); // 移除所有元素
    dataSource.add(ChatHelloWorldModel(content: ""));
    // dataSource.add(ChatSuggestModel(content: ""));
    // dataSource.insert(0, ChatSuggestModel(content: ""));
  }

  ///切换会话
  changeSession(String newSes) {
    final TBVoiceController voiceLogic = Get.find<TBVoiceController>();
    voiceLogic.showTool = false;
    voiceLogic.showMore = false;
    isRemoveSuggest = true;

    session = newSes;
    this.secondSeAry = testData(sessionAry);
    requestMsgList().then((_) {
      scrollToBottom();
    });
    voiceLogic.update([TBDefVal.kChatInput]);
  }

  /// 滚动到底部的方法
  void scrollToBottom() {
    scrollController?.jumpTo(0.0);
    // scrollController?.animateTo(
    //   scrollController!.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  ///进行一系列的新建会话的操作
  Future<void> verifyAssistant() async {
    Completer<void> completer = Completer<void>();
    if (assistant.isEmpty) {
      print('--------------assistant--isEmpty');
      await requestAssistant();
    }
    // 等待 verifySession 方法完成
    if (session.isEmpty) {
      print('--------------session--isEmpty');
      await verifySession();
    }
    // 手动触发 Completer 完成
    completer.complete();
    return completer.future;
  }

  ///新增文件会话
  addFile() {
    if (documentType == "pdf") {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.pdf));
    } else if ((documentType == "doc") || (documentType == "docx")) {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.word));
    } else if ((documentType == "xls") || (documentType == "xlsx")) {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.excel));
    } else if ((documentType == "jpg") || (documentType == "jpeg")) {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.jpg));
    } else if (documentType == "png") {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.png));
    } else if (documentType == "csv") {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.csv));
    } else if ((documentType == "ppt") || (documentType == "pptx")) {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.ppt));
    } else if (documentType == "html") {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.html));
    } else if (documentType == "txt") {
      dataSource.insert(
          0,
          ChatRequestFileModel(
              content: documentPath ?? '', fileType: ChatFileType.txt));
    }
    documentPath = '';
    documentAllPath = '';
    documentType = '';
    imageFilePath = '';
    update([TBDefVal.kChatInputFile]);
  }

  Future<void> uploadFile(String fileName, String filePath) async {
    Completer<void> completer = Completer<void>();
    print('fileName = $fileName');
    TBLoadingUtils.show();
    TBHttpRequest.uploadFile(
      baseUrl:
          TBConfig.BASE_URL + TBUrl.kCreateSession + '/$session' + '/objects',
      fileName: fileName,
      filePath: filePath,
      success: (value) {
        print(value);

        TBLoadingUtils.hide();
        completer.complete();
      },
      failure: (value) {
        TBLoadingUtils.hide();
        completer.complete();
      },
    );
    return completer.future;
  }

  Future sendHandle() async {}

  /// 获取 Assistant
  Future<void> requestAssistant() async {
    if (assistant.isEmpty) {
      print('--------------Assistan--begin');
      await SCHttpManager.instance.get(
          url: TBUrl.kGetAssistantUrl,
          params: null,
          success: (value) async {
            print('----------- Value: $value');
            List list = value['assistants'];
            assistantAry = List<TBAssistantsModel>.from(
                list.map((e) => TBAssistantsModel.fromJson(e)).toList());
            // 检查列表不为空
            if (assistantAry.isNotEmpty) {
              final model = assistantAry.last;
              // 获取 model.session 的值
              assistant = model.name ?? "";
              // metadata = model.displayName ?? "";
              // 打印或使用 sessionValue
              print('assistant Value: $assistant');
            }
            // TBUtils.getCurrentContext(completionHandler: (context) async {
            //   SCUpdateDialog.showUpdateDialog(
            //       context, '1.修复已知bug\n2.优化用户体验', false);
            // });
          },
          failure: (value) {
            print('failure 获取数据失败');
          });
    }
  }

  /// 效验 session
  Future<void> verifySession() async {
    if (requestStr.isEmpty) {
      print('--------------requestStr--begin');
      return;
    }
    var params = {
      "pluginConfig": {
        "documentAnalysis": {
          "enabled": documentAnalysis,
        },
        "onlineSearch": {
          "enabled": onlineSearch,
        },
        "imageGeneration": {
          "enabled": imageGeneration,
        },
      },
      "displayName": requestStr,
      "description": '',
      "assistant": assistant
    };
    print('--------------CreateSession--begin');

    await SCHttpManager.instance.post(
        url: TBUrl.kCreateSession,
        params: params,
        success: (value) {
          final model = TBSessionModel.fromJson(value);
          print('----------- sessionid: ${model.id}');
          session = model.id ?? '';
          requestSessionList();
        },
        failure: (err) {});
  }

  /// 获取会话窗口列表
  requestSessionList() {
    var params = {
      "orderBy": 'updateTime desc',
      "pageSize": 1000,
      "nextPageToken": '',
      "filter": 'labels:tigerbot'
    };
    print('----------- 开始获取会话session');
    SCHttpManager.instance.get(
        url: TBUrl.kCreateSession,
        params: params,
        success: (value) {
          print('----------- 成功获取会话session');

          if (value['sessions'] == null) {
            isRemoveSuggest = false;
            sessionAry = [];
            secondSeAry = testData(sessionAry);
            resetDataSource();

            update([TBDefVal.kChatSession]);
            update([TBDefVal.kChatInputFile]);
            update([TBDefVal.kChatMsgList]);
          } else {
            List list = value['sessions'];
            sessionAry = List<TBSessionModel>.from(
                list.map((e) => TBSessionModel.fromJson(e)).toList());

            if (sessionAry.isNotEmpty && session.isEmpty) {
              // isRemoveSuggest = true;
              // final model = sessionAry.first;
              // // 获取 model.session 的值
              // session = model.id ?? "";
              // onlineSearch = model.pluginConfig?.onlineSearch?.enabled ?? false;
              // documentAnalysis =
              //     model.pluginConfig?.documentAnalysis?.enabled ?? false;
              // imageGeneration =
              //     model.pluginConfig?.imageGeneration?.enabled ?? false;
              // requestMsgList().then((_) {
              //   scrollToBottom();
              // });
              // Get.find<TBVoiceController>().update([TBDefVal.kChatInput]);
            }
            secondSeAry = testData(sessionAry);
            print('---------------documentAnalysis = ${documentAnalysis}');
            print('---------------onlineSearch = ${onlineSearch}');
            update([TBDefVal.kChatSession]);
            update([TBDefVal.kChatInputFile]);
          }
        },
        failure: (value) {
          print('requestSessionList 获取数据失败');
        });
  }

  String fileTypeImagePath(String objectFilename) {
    List<String> filenameParts = objectFilename.split('.');
    String lastPart = filenameParts.last;
    var path = "assets/images/chat/chat_file_pdf.png";
    if ((lastPart == "pdf") || (lastPart == "PDF")) {
      path = "assets/images/chat/chat_file_PDF.png";
    } else if (lastPart == "csv") {
      path = "assets/images/chat/chat_file_CSV.png";
    } else if ((lastPart == "doc") || (lastPart == "docx")) {
      path = "assets/images/chat/chat_file_WORD.png";
    } else if ((lastPart == "xls") || (lastPart == "xlsx")) {
      path = "assets/images/chat/chat_file_EXCEL.png";
    } else {
      path = "assets/images/chat/chat_file_PDF.png";
    }
    return path;
  }

  /// 获取消息列表
  Future<void> requestMsgList() async {
    Completer<void> completer = Completer<void>();

    var params = {"pageSize": 100000, "filter": 'session=sessions/$session'};
    SCHttpManager.instance.get(
        url: TBUrl.kGetMessages,
        params: params,
        success: (value) {
          // resetDataSource();
          dataSource.clear(); // 移除所有元素
          List list = value['messages'];
          msgAry = List<TBChatMessageModel>.from(
              list.map((e) => TBChatMessageModel.fromJson(e)).toList());
          // if (msgAry.length > 0 && isRemoveSuggest) {
          //   ///如果有数据，清除问题示例
          //   dataSource.clear(); // 移除所有元素
          // }
          msgAry.forEach((msg) {
            // 在这里处理每一条消息（msg）
            if (msg.type == 'MESSAGE_TYPE_COMMON') {
              // dataSource.add(
              //     ChatRequestModel(content: msg.content?.inlineSource ?? ''));
              if (msg.metadata != null &&
                  msg.metadata?.objectFilename != null) {
                String objectFilename = msg.metadata?.objectFilename ?? '';
                List<String> filenameParts = objectFilename.split('.');
                String lastPart = filenameParts.last;
                debugPrint('----------------------lastPart = $lastPart');
                if ((lastPart == "pdf")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.pdf));
                } else if ((lastPart == "doc") || (lastPart == "docx")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.word));
                } else if ((lastPart == "xls") || (lastPart == "xlsx")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.excel));
                } else if ((lastPart == "txt")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.txt));
                } else if ((lastPart == "jpg") || (lastPart == "jpeg")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.jpg));
                } else if ((lastPart == "png")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.png));
                } else if ((lastPart == "ppt") || (lastPart == "pptx")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.ppt));
                } else if ((lastPart == "html")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.html));
                } else if ((lastPart == "csv")) {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.csv));
                } else {
                  dataSource.insert(
                      0,
                      ChatRequestFileModel(
                          content: msg.metadata?.objectFilename ?? '',
                          fileType: ChatFileType.pdf));
                }
              } else {
                dataSource.insert(0,
                    ChatRequestModel(content: msg.content?.inlineSource ?? ''));
              }
            } else if (msg.type == 'MESSAGE_TYPE_ASSISTANT') {
              ChatResponseModel model = ChatResponseModel(
                isUnlike: false,
                isLike: false,
                isSearch: onlineSearch,
              );
              model.isFinished = true;

              model.reqId = msg?.id ?? '';
              model.items = msg?.citation?.citations ?? [];
              model.content = msg.content?.inlineSource ?? '';
              // model.content +=
              //     """\n温度18-32摄氏度，东南风[^0^]、温度19-3摄氏度，东南风3级[^0^]、空气质量良好[^0^]""";
              model.content = replaceHyperLink(model.content, model.items);
              // model.content +=
              //     """温度18-32摄氏度，东南风([中国气象局](http://baidu.com))、温度19-3摄氏度，东南风3级([中国天气网](https://baidu.com))、空气质量良好([百度天气](https://baidu.com)) """;
              // model.content +=
              //     """\n超链接测试文本[[1]](http://baidu.com) 这种格式 还有[百度](https://baidu.com) ![](https://tigerbot.oss-cn-hangzhou.aliyuncs.com/imgs/bgc.png) \n\n\nSYNOPSIS 2ND EDITION\n\n![](https://tigerbot.oss-cn-hangzhou.aliyuncs.com/imgs/bgc.png)\n\n\nDAVID S. WALTHER\n\nAPPLIED KINESIOLOGY Synopsis 2nd """;
//               model.content += """
// \n```python
// pip install django
// ```\n
// """;
              // dataSource.add(model);

              model.siblingMessageIds = msg?.siblingMessageIds ?? [];
              siblingMessageIds = msg?.siblingMessageIds ?? [];
              model.currentPage = msg?.siblingMessageIds?.length ?? 1;
              currentPage = model.currentPage ?? 1;
              model.variantMessageIds = msg?.variantMessageIds ?? [];
              model.parentMessageId = msg?.parentMessageId ?? "";
              model.images = msg?.content?.ossSource?.inputUris ?? [];

              // if (model.items.length == 0) {
              //   model.noItems = true;
              //   ChatResponseItemModel defaultItemModel =
              //       ChatResponseItemModel.fromJson({});
              //   model.items = [defaultItemModel];
              // }
              dataSource.insert(0, model);
            }
          });
          print('--------------------dataSource.length = ${dataSource.length}');
          update([TBDefVal.kChatMsgList]);
          completer.complete(); // 异步操作完成（即使失败也算完成）
        },
        failure: (value) {
          resetDataSource();

          completer.complete(); // 异步操作完成（即使失败也算完成）
        });
    return completer.future; // 返回Future对象
  }

  /// 获取消息
  Future<void> requestMessage() async {
    Completer<void> completer = Completer<void>();

    SCHttpManager.instance.get(
        url: TBUrl.kGetMessages + '/$messagesId',
        params: null,
        success: (value) {
          // if (dataSource.length > 0){
          //   dataSource.removeAt(dataSourceIndex);
          // }
          final msg = TBChatMessageModel.fromJson(value);
          if (msg.type == 'MESSAGE_TYPE_COMMON') {
            // dataSource.add(
            //     ChatRequestModel(content: msg.content?.inlineSource ?? ''));
            // dataSource.insert(0,
            //     ChatRequestModel(content: msg.content?.inlineSource ?? ''));
            dataSource[dataSourceIndex] =
                ChatRequestModel(content: msg.content?.inlineSource ?? '');
          } else if (msg.type == 'MESSAGE_TYPE_ASSISTANT') {
            ChatResponseModel model = ChatResponseModel(
              isUnlike: false,
              isLike: false,
              isSearch: onlineSearch,
            );
            model.isFinished = true;
            model.content = msg.content?.inlineSource ?? '';
            // dataSource.add(model);
            model.reqId = msg?.id ?? '';

            model.items = msg?.citation?.citations ?? [];
            model.siblingMessageIds = msg?.siblingMessageIds ?? [];
            siblingMessageIds = msg?.siblingMessageIds ?? [];
            // if (currentPage != 1){
            model.currentPage = currentPage;
            // }else{
            //   model.currentPage = msg?.siblingMessageIds?.length ?? 1;
            // }
            model.variantMessageIds = msg?.variantMessageIds ?? [];
            model.parentMessageId = msg?.parentMessageId ?? "";
            // if (model.items.length == 0) {
            //   model.noItems = true;
            //   ChatResponseItemModel defaultItemModel =
            //       ChatResponseItemModel.fromJson({});
            //   model.items = [defaultItemModel];
            // }
            // dataSource.insert(0, model);
            dataSource[dataSourceIndex] = model;
          }
          print('--------------------dataSource.length = ${dataSource.length}');
          update([TBDefVal.kChatMsgList]);
          completer.complete(); // 异步操作完成（即使失败也算完成）
        },
        failure: (value) {
          completer.complete(); // 异步操作完成（即使失败也算完成）
        });
    return completer.future; // 返回Future对象
  }

  sureDeleteSession(String sessionId) {
    TBLoadingUtils.show();
    SCHttpManager.instance.delete(
        url: TBUrl.kCreateSession + '/$sessionId',
        params: null,
        success: (value) {
          TBLoadingUtils.hide();
          session = '';
          documentPath = '';
          documentAllPath = '';
          documentType = '';
          imageFilePath = '';
          requestSessionList();
        },
        failure: (err) {
          TBLoadingUtils.hide();
          if (err['msg'] != null) {
            String message = err['msg'];
            TBLoadingUtils.failure(text: message);
          }
        });
  }

  void showAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止点击对话框外部关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('use_guide'.tr),
          content: Container(
            width: double.maxFinite,
            height: 450.h, // 固定弹框高度
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('use_guide1'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                            )),
                        SizedBox(height: 4.0),

                        Text('use_guide2'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                            )),
                        SizedBox(height: 4.0),

                        Text('use_guide3'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                            )),
                        SizedBox(height: 4.0),

                        Text('use_guide4'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                            )),
                        SizedBox(height: 4.0),

                        Text('use_guide5'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                            )),
                        SizedBox(height: 8.0),
                        Text('use_guide6'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            )),
                        // 添加更多内容以测试滚动效果
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences preference =
                            await SharedPreferences.getInstance();
                        preference.setBool(TBDefVal.isShowGuideAlert, false);
                        Navigator.of(context).pop(); // 关闭对话框
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(200.w, 45.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.5.h),
                        ),
                      ),
                      child: Text(
                        'tong_yi'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop(); // 退出应用
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(200.w, 45.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.5.h),
                          // side: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        'non_use'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // List<TBSessionData> testData(List<TBSessionModel> sessions) {
  //   // Group sessions by date
  //   Map<String, List<TBSessionModel>> groupedSessions = {};
  //
  //   for (var model in sessions) {
  //     if (session == model.name) {
  //       model.isSelect = true;
  //     } else {
  //       model.isSelect = false;
  //     }
  //     DateTime dateTime = DateTime.parse(model.updateTime ?? '');
  //     String formattedDate =
  //         "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  //
  //     if (!groupedSessions.containsKey(formattedDate)) {
  //       groupedSessions[formattedDate] = [];
  //     }
  //
  //     groupedSessions[formattedDate]!.add(model);
  //   }
  //
  //   // Convert grouped sessions to ItemData list
  //   List<TBSessionData> result = groupedSessions.entries.map((entry) {
  //     String groupName = _getGroupName(entry.key);
  //
  //     return TBSessionData(groupName: groupName, sessions: entry.value);
  //   }).toList();
  //
  //   return result;
  // }
  //
  // String _getGroupName(String formattedDate) {
  //   DateTime dateTime = DateTime.parse(formattedDate);
  //   DateTime today = DateTime.now();
  //   Duration difference = today.difference(dateTime);
  //
  //   if (difference.inDays == 0) {
  //     return '今天';
  //   } else if (difference.inDays == 1) {
  //     return '昨天';
  //   } else {
  //     return '${difference.inDays}天前';
  //   }
  // }
  List<TBSessionData> testData(List<TBSessionModel> sessions) {
    // 根据 updateTime 进行分组
    Map<String, List<TBSessionModel>> groupedObjects = {};

    for (var obj in sessions) {
      String formattedDate = formatterDate(obj.updateTime, today: true);
      if (session == obj.id) {
        obj.isSelect = true;
        onlineSearch = obj.pluginConfig?.onlineSearch?.enabled ?? false;
        documentAnalysis = obj.pluginConfig?.documentAnalysis?.enabled ?? false;
        imageGeneration = obj.pluginConfig?.imageGeneration?.enabled ?? false;
      } else {
        obj.isSelect = false;
      }
      if (!groupedObjects.containsKey(formattedDate)) {
        groupedObjects[formattedDate] = [];
      }

      groupedObjects[formattedDate]!.add(obj);
    }

    // 整理成二维数组
    List<TBSessionData> result = groupedObjects.entries.map((entry) {
      return TBSessionData(groupName: entry.key, sessions: entry.value);
    }).toList();

    // 输出结果
    for (var group in result) {
      print('Group Title: ${group.groupName}');
      for (var obj in group.sessions) {
        print('  ${formatterDate(obj.updateTime)} - ${obj.updateTime}');
      }
    }
    return result;
  }

  String formatterDate(String? historyTime, {bool today = false}) {
    if (historyTime == null || historyTime.isEmpty) return '';

    // 将传入的历史时间转换为毫秒数
    int currentTime = DateTime.parse(historyTime).millisecondsSinceEpoch;
    int timeDiff = DateTime.now().millisecondsSinceEpoch - currentTime;
    int time = DateTime.now().millisecondsSinceEpoch - timeDiff;

    // 定义时间单位的毫秒数
    const int min = 60 * 1000;
    const int hour = min * 60;
    const int day = hour * 24;

    // 定义各时间段的毫秒数
    const int twoDay = hour * 48;
    const int threeDay = hour * 72;
    const int fourDay = hour * 96;
    const int fiveDay = hour * (24 * 5);
    const int sixDay = hour * (24 * 6);
    const int sevenDay = hour * (24 * 7);
    const int eightDay = hour * (24 * 8);
    const int nineDay = hour * (24 * 9);
    const int tenDay = hour * (24 * 10);
    const int elevenDay = hour * (24 * 10);
    const int halfMonth = hour * (24 * 15);
    const int oneMonth = hour * (24 * 30);
    const int twoMonth = hour * (24 * 60);
    const int threeMonth = hour * (24 * 90);

    // 计算时间差所包含的小时数和分钟数
    int exceedHour = (timeDiff / hour).floor();
    int exceedMin = (timeDiff / min).floor();

    // 根据时间差判断返回的字符串
    if (timeDiff < 0 && !today) {
      return '刚刚';
    }
    if (timeDiff < hour && !today) {
      return '$exceedMin分钟前';
    }
    if (timeDiff < day && !today) {
      return '$exceedHour小时前';
    }
    if (timeDiff < day && today) {
      return '今天';
    }
    if (timeDiff >= day && timeDiff < twoDay) {
      return '1天前';
    }
    if (timeDiff >= twoDay && timeDiff < threeDay) {
      return '2天前';
    }
    if (timeDiff >= threeDay && timeDiff < fourDay) {
      return '3天前';
    }
    if (timeDiff >= fourDay && timeDiff < fiveDay) {
      return '4天前';
    }
    if (timeDiff >= fiveDay && timeDiff < sixDay) {
      return '5天前';
    }
    if (timeDiff >= sixDay && timeDiff < sevenDay) {
      return '6天前';
    }
    if (timeDiff >= sevenDay && timeDiff < eightDay) {
      return '7天前';
    }
    if (timeDiff >= eightDay && timeDiff < nineDay) {
      return '8天前';
    }
    if (timeDiff >= nineDay && timeDiff < tenDay) {
      return '9天前';
    }
    if (timeDiff >= tenDay && timeDiff < elevenDay) {
      return '10天前';
    }
    if (timeDiff >= elevenDay && timeDiff < halfMonth) {
      return '半月前';
    }
    if (timeDiff >= halfMonth && timeDiff < oneMonth) {
      return '1月前';
    }
    if (timeDiff >= oneMonth && timeDiff < twoMonth) {
      return '2月前';
    }
    if (timeDiff >= twoMonth && timeDiff < threeMonth) {
      return '3月前';
    }

    // 如果时间差大于三个月，返回具体的日期时间
    if (timeDiff > threeMonth) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
      int year = date.year;
      int month = date.month;
      int day = date.day;
      int hour = date.hour;
      String hourStr = hour < 10 ? '0$hour' : '$hour';
      int min = date.minute;
      String minStr = min < 10 ? '0$min' : '$min';
      return '$year-$month-$day';
      // return '$year-$month-$day $hourStr:$minStr';
    }

    return '';
  }

  ///举报反馈
  showReportDialog() {
    print('举报方法');
    TBUtils.getCurrentContext(completionHandler: (context) async {
      _showMulSelectTagPicker(context);
    });
  }

  ///标签选择弹框
  void _showMulSelectTagPicker(BuildContext context) {
    List<String> tags = [
      '人身攻击',
      '谩骂攻击',
      '涉政反动',
      '涉黄信息',
      '血腥暴力',
      '其他',
    ];
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return TBReportPicker(
    //         title: "举报反馈问题",
    //         tags: tags,
    //         inputHintText: '我还有其他的反馈和意见',
    //         onConfirm: (index, list, input) {
    //           // showToast(index, list, input, context);
    //           print("index = $index");
    //           print("list = $list");
    //           print("input = $input");
    //           // if (input.isEmpty) {
    //           //   BrnToast.show('请输入举报内容', context);
    //           //   return;
    //           // }
    //           if (list.isEmpty) {
    //             // BrnToast.show('请选择要举报的问题类型', context);
    //             return;
    //           }
    //           String listAsString = list.join(', ');
    //           String result = '$listAsString, $input';
    //           print("Result = $result");
    //
    //           feedbackRequest(result);
    //         },
    //         config: BrnAppraiseConfig(
    //             showConfirmButton: true,
    //             isConfirmButtonEnabled: true,
    //             count: 5,
    //             starAppraiseHint: '星星未选择时的文案',
    //             inputTextChangeCallback: (input) {
    //               // BrnToast.show('输入的内容为' + input, context);
    //             },
    //             iconClickCallback: (index) {
    //               // BrnToast.show('选中的评价为$index', context);
    //             },
    //             tagSelectCallback: (list) {
    //               // BrnToast.show('选中的标签为:' + list.toString(), context);
    //             }),
    //       );
    //     });
  }

  /// 提交反馈
  feedbackRequest(String content) {
    TBLoadingUtils.show();
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response = await TBHttpRequest.post(
          TBUrl.kIssuesUrl, context,
          params: {"type": "report", "content": content}) as TBHttpResponse;
      if (response.code == 0) {
        TBLoadingUtils.hide();
        TBLoadingUtils.success(text: "举报提交成功");
        TBRouterHelper.back(null);
      } else {
        TBLoadingUtils.hide();
      }
    });
  }

  // /// 获取问题示例
  // requestKeyView() {
  //   TBUtils.getCurrentContext(completionHandler: (context) async {
  //     try {
  //       TBHttpResponse response = await TBHttpRequest.post(
  //               TBUrl.kKeyViewUrl, context, params: {"key": "cases"})
  //           as TBHttpResponse;
  //       if (response.success) {
  //         print("隐藏加载快");
  //
  //         Map<String, dynamic> map = jsonDecode(response.data);
  //         _datas = map.values.map((e) {
  //           var key = TBUtils.isChineseLan() ? "type_cn" : "type_en";
  //           var type = e[key];
  //           var data = e["data"];
  //           return {type: data};
  //         }).toList();
  //
  //         _datas?.forEach((dataMap) {
  //           dataMap.values.forEach((listOfMaps) {
  //             dataList?.addAll(listOfMaps);
  //           });
  //         });
  //
  //         randomList = TBUtils().getRandomItems(dataList, 4);
  //         print('----------- isLogin: $isLogin');
  //
  //         if (!isLogin) {
  //           resetDataSource();
  //           update([TBDefVal.kChatSession]);
  //           update([TBDefVal.kChatInputFile]);
  //           update([TBDefVal.kChatMsgList]);
  //         } else {
  //           update();
  //         }
  //       } else {
  //         print('----------- 网络请求失败');
  //       }
  //     } catch (error) {
  //       // 处理捕获到的其他错误，如网络异常等
  //       print('----------- 发生错误: $error');
  //       // 判断是否达到最大重试次数
  //       if (currentRetryCount < 30) {
  //         // 延迟一秒后进行下一次重试
  //         await Future.delayed(Duration(seconds: 2));
  //         currentRetryCount++;
  //         // 递归调用自身
  //         await requestKeyView();
  //       }
  //     }
  //   });
  // }

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

  // ///判断是否是数学公式
  // bool containsMath(String text) {
  //   // 使用正则表达式来匹配 $...$ 或 $$...$$ 格式的字符串
  //   final pattern = RegExp(r'\$\$.*?\$\$|\$.*?\$');
  //   //要匹配 $$...$$ 格式的字符串，你可以使用以下正则表达式：
  //   // final pattern = RegExp(r'\$\$(.*?)\$\$');
  //
  //   return pattern.hasMatch(text);
  // }

  bool isMathJaxOutsideCodeBlocks(String text) {
    bool containsMathJax(String line) {
      final mathJaxPatterns = [
        // RegExp(r"\\\("),
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

  ///检测字符串中是否包含 [^1^] 标签
  bool containsCustomTags(String text) {
    final RegExp regExp = RegExp(r'\[\^(.*?)\^\]');
    return regExp.hasMatch(text);
  }

  ///替换格式：[^1^]为"<custom_link>1<custom_link>"
  String replaceBracketsWithSpan(String input) {
    final RegExp regExp = RegExp(r'\[\^(.*?)\^\]');
    return input.replaceAllMapped(regExp, (Match match) {
      return '<custom_link>${match[1]}</custom_link>';
    });
  }

  ///替换格式：[^1^]为[1](https:)
  String replaceHyperLink(String input, List<ChatResponseItemModel> items) {
    final RegExp regExp = RegExp(r'\[\^(.*?)\^\]');
    // 替换所有匹配项
    String result = input.replaceAllMapped(regExp, (match) {
      String title = match.group(1) ?? '';
      String site = '';
      String url = '';
      if (items.length > 0) {
        for (var item in items) {
          if (title == (item.index.toString())) {
            // 跳转页面
            site = item.site;
            url = item.uri;
            break;
          }
        }
      }
      if (site == '') {
        return '';
      }
      return '([$site]($url))';
    });

    return result;
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
      // print('partModels----------------');
      // print('str: ${partModels[i].str}, type: ${partModels[i].type}');

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
                  color: themed.theme_c.textColorAns,
                  fontSize: TBDefVal.chatRegularFont.sp,
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
                      color: themed.theme_c.textColorAns,
                      fontSize: TBDefVal.chatRegularFont.sp,
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
                color: themed.theme_c.textColorAns,
                fontSize: TBDefVal.chatRegularFont.sp,
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
                color: themed.theme_c.textColorAns,
                fontSize: TBDefVal.chatRegularFont.sp,
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
                    color: themed.theme_c.textColorAns,
                    fontSize: TBDefVal.chatRegularFont.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ));
        }
      }
    }
    return widgets;
  }

  /// 获取详情并更新为已读
  exampleChange() {
    // randomList = TBUtils().getRandomItems(dataList, 4);
    update();
  }

  void initCallback() {
    _screenshotCallback = ScreenshotCallback();
    _screenshotCallback.startScreenshot();
    _screenshotCallback.setInterfaceScreenshotCallback(this);
  }

  screenshotCallback(String data) async {
    _imagePath = data;
    print(_imagePath);
    print("----------------监听截屏动作");
    bool isGranted = await TBPermissionManager.getStoragePermission(
        completionHandler: () async {});
    if (isGranted) {
      TBUtils.getCurrentContext(completionHandler: (context) async {
        TBWeChatUtils.instance.initBase();
        showScreenShare(context);
      });
    }
  }

  @override
  deniedPermission() async {
    print("没有权限");
  }

  /// 分享给好友
  void doShareFriend() async {
    TBWeChatUtils.instance.shareFileImage(File(_imagePath));
    TBRouterHelper.back(null);
  }

  /// 分享朋友圈
  void doShareCircle() async {
    TBWeChatUtils.instance.shareFileImage(File(_imagePath), sceneValue: 1);
    TBRouterHelper.back(null);
  }

  ///截屏被动分享
  showScreenShare(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    height: 45.h,
                  ),
                  Image.file(
                    File(_imagePath), // 传入图片文件路径
                    width: 375.w,
                    height: 520.h,
                    fit: BoxFit.contain,
                  ),
                  Spacer(),
                  Container(
                      padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                      height: 223.h,
                      decoration: BoxDecoration(
                          color: themed.theme_c.bgColorEx,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1),
                              topRight: Radius.circular(1))),
                      child: Column(
                        children: [
                          TBImageDialog(
                            items: [
                              ItemLittleView(
                                  label: "Wechat friend".tr,
                                  icon:
                                      "assets/images/chat/chat_share_wechat1.png",
                                  option: TBImageDialogOption.wechatFriend
                                  // onTap: () => doSaveImage(),
                                  // onTap: () => () {
                                  //   print("点击了");
                                  // },
                                  ),
                              ItemLittleView(
                                  label: "Circle of friend".tr,
                                  icon:
                                      "assets/images/chat/chat_share_circle1.png",
                                  option: TBImageDialogOption.circleOfFriend

                                  // onTap: () => () {
                                  //   print("点击了");
                                  // },
                                  ),
                            ],
                            onItemSelected: (selectedItem) {
                              // 传递回调函数，但可以在此处编写处理逻辑
                              print("选定的项目是：$selectedItem");
                              switch (selectedItem) {
                                case TBImageDialogOption.wechatFriend:
                                  doShareFriend();
                                  break;
                                default:
                                  doShareCircle();
                                  break;
                              }
                            },
                          ),
                          // Spacer(),
                          // SizedBox(
                          //   height: 24.0,
                          // ),
                          Divider(
                            color: themed.theme_c.lineColor, // 分割线颜色
                            height: 1, // 分割线高度
                          ),
                          Expanded(
                            child: Container(
                              width: TBDefVal.screenWidth.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 18),
                              color: themed.theme_c.bgColorEx,
                              child: Text(
                                "Cancel".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themed.theme_c.textColorMild,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

  Future<void> selectImageFromGallery() async {
    // 从图库选择图片
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final isConform = TBUtils.fileTypeConform(image.path);
      if (isConform.isSupported == false) {
        TBLoadingUtils.info(
            text:
                '请上传.pdf,.doc,.docx,.csv,.txt,.html,.png,.jpg,.jpeg,.ppt,.pptx文件！');
        return;
      }
      changeSessionType(1);

      // 使用选择的图片
      print('选择的图片路径：${image.path}');
      // imageFilePath = image.path;
      documentPath = image.name;
      documentAllPath = image.path;
      documentType = isConform.fileExtension ?? '';

      update([TBDefVal.kChatInputFile]);
    } else {
      print('没有选择图片。');
    }
  }

  Future<void> captureImageWithCamera() async {
    // 使用相机拍摄新照片
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      FileTypeResult isConform = TBUtils.fileTypeConform(photo.path);

      // final isConform = TBUtils.fileTypeConform(photo.path);
      if (isConform.isSupported == false) {
        TBLoadingUtils.info(
            text:
                '请上传.pdf,.doc,.docx,.csv,.txt,.html,.png,.jpg,.jpeg,.ppt,.pptx文件！');
        return;
      }
      changeSessionType(1);

      // 使用拍摄的照片
      print('拍摄的照片路径：${photo.path}');
      documentPath = photo.name;
      documentAllPath = photo.path;
      documentType = isConform.fileExtension ?? '';

      // imageFilePath = photo.path;
      update([TBDefVal.kChatInputFile]);
    } else {
      print('没有拍摄照片。');
    }
  }

  Future<void> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile firstFile = result.files.first;
        final isConform = TBUtils.fileTypeConform(firstFile.path ?? "");
        if (isConform.isSupported == false) {
          TBLoadingUtils.info(
              text:
                  '请上传.pdf,.doc,.docx,.csv,.txt,.html,.png,.jpg,.jpeg,.ppt,pptx文件！');
          return;
        }
        changeSessionType(1);

        print('File path: ${firstFile.path}');
        documentAllPath = firstFile.path ?? "";
        print('File name: ${firstFile.name}');
        documentPath = firstFile.name;
        print('File type: ${firstFile.extension}');
        documentType = firstFile.extension ?? '';

        update([TBDefVal.kChatInputFile]);
      } else {
        // User canceled the picker
      }
    } catch (error) {}
  }

  @override
  void onClose() {
    super.onClose();
    _screenshotCallback.stopScreenshot();
  }
}
