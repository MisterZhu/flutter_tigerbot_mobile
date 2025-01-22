import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/chat/model/chat_request_file_model.dart';
import 'package:TigerChat/pages/chat/model/chat_tip_model.dart';
import 'package:TigerChat/pages/chat/model/hello_suggest_model.dart';
import 'package:TigerChat/pages/chat/ShareView/logic/tb_share_image_logic.dart';
import 'package:TigerChat/pages/chat/ShareView/page/tb_share_image_page.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_feedback_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_helloworld_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_new_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_report_picker.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_report_toast.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_request_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_request_file_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_response_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_response_code_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_response_loading_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_suggest_cell.dart';
import 'package:TigerChat/pages/chat/widgets/cell/chat_tip_cell.dart';
import 'package:TigerChat/pages/chat/widgets/chat_session_page.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/request/http_request.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../constant/tb_config.dart';
import '../../constant/tb_enum.dart';
import '../../sc_app.dart';
import '../../util/dialog/sc_uddate_dialog.dart';
import '../../util/event/event_bus.dart';
import '../../util/request/response/TBResponse.dart';
import '../../util/request/sse_service.dart';
import '../../util/tb_loading_utils.dart';
import '../../util/tb_utils.dart';
import '../../util/wechat/tb_wechat_utils.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/tb_custom_shareView.dart';
import '../../widgets/tb_image_dialog.dart';
import '../home/logic/tb_launch_logic.dart';
import 'VoiceMsgView/logic/tb_voice_controller.dart';
import 'logic/tb_chat_detail_logic.dart';
import 'model/chat_feedback_model.dart';
import 'model/chat_helloworld_model.dart';
import 'model/chat_model.dart';
import 'model/chat_new_model.dart';
import 'model/chat_request_model.dart';
import 'model/chat_response_code_model.dart';
import 'model/chat_response_loading_model.dart';
import 'model/chat_response_model.dart';
import 'model/tb_chat_msg_model.dart';
import 'widgets/chat_bottom.dart';

class ChatDetailPage extends StatefulWidget {
  String keyword = '';

  ChatDetailPage({this.keyword = '', Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String _clientSession = "";

  bool _isMulConversation = false;

  bool _isSearchMode = false;

  GlobalKey _key = GlobalKey();
  final TBShareImageLogic logic = Get.put(TBShareImageLogic());
  final TBChatDetailLogic logicDet = Get.put(TBChatDetailLogic());
  final TBVoiceController logicVoiceC = Get.put(TBVoiceController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SSEService _sseService;
  StreamSubscription<SSEModel>? _subscription;

  @override
  void initState() {
    super.initState();
    _sseService = SSEService();

    _clientSession = Uuid().v4();

    UserInfoProvider userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    _isSearchMode = userInfoProvider.isSearchMode;

    bus.on(TBDefVal.kPushEvent, onEventCallback);
    //bus.emit(TBDefVal.kPushEvent, type);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _sseService.dispose();
    bus.off(TBDefVal.kPushEvent);

    super.dispose();
  }

  void onEventCallback(dynamic arg) {
    print('--------------Event callback triggered with argument: $arg');
    debugPrint('-------------发送问题 按钮2');

    searchRequest(arg);
  }

  void likeHandle(int index, bool like) {
    // 点赞
    final responseModel = logicDet.dataSource[index] as ChatResponseModel;
    String reqId = responseModel.reqId;
    TBHttpRequest.post(TBUrl.kChatFeedBackUrl, context,
        params: {"emotion": 1, "reqId": reqId}).then((value) {
      if (value.success) {
        responseModel.isLike = like;
        if (like) {
          responseModel.isUnlike = false;
        }
        setState(() {
          logicDet.dataSource[index] = responseModel;
        });
      }
    });
  }

  void unlikeHandle(int index, bool unlike) {
    // 踩
    final responseModel = logicDet.dataSource[index] as ChatResponseModel;
    String reqId = responseModel.reqId;
    TBHttpRequest.post(TBUrl.kChatFeedBackUrl, context,
        params: {"emotion": -1, "reqId": reqId}).then((value) {
      if (value.success) {
        responseModel.isUnlike = unlike;
        if (unlike) {
          responseModel.isLike = false;
        }
        setState(() {
          logicDet.dataSource[index] = responseModel;
          // if (unlike) {
          //   final last = logicDet.dataSource.last;
          //   if (last.runtimeType != ChatFeedbackModel) {
          //     logicDet.dataSource.add(ChatFeedbackModel(content: ""));
          //   }
          // }
        });
      }
    });
  }

  void foldHandle(int index, bool fold) {
    // 展开关闭
    final responseModel = logicDet.dataSource[index] as ChatResponseModel;
    responseModel.isFold = fold;
    setState(() {
      logicDet.dataSource[index] = responseModel;
    });
  }

  // Future<TBResponse> sendMsg(String text, [bool isRepeat = false]) async {
  //   ChatProvider chatProvider =
  //       Provider.of<ChatProvider>(context, listen: false);
  //   Future.microtask(() => chatProvider.streamLoading = true);
  //
  //   Map<String, Object> params = {
  //     "clientSession": _clientSession,
  //     "useMulti": _isMulConversation,
  //     "openSearchMode": _isSearchMode,
  //     "text": text,
  //     "session": _isMulConversation ? chatProvider.session : [],
  //   };
  //   if (isRepeat) {
  //     params['modelParams'] = {"doSample": true, "temperature": 0.2};
  //   }
  //   return await TBHttpRequest.postStream(TBUrl.kChatConsultUrl, context,
  //       params: params);
  // }
  Future<TBResponse> sendMsg(String text, [String isRepeat = '']) async {
    var params = {
      "message": {
        "id": isRepeat,
        "session": 'sessions/${logicDet.session}',
        "content": {
          "contentType": 'text/plain',
          "inlineSource": text,
        }
      }
    };
    logicDet.items = [];

    return await TBHttpRequest.postStream(TBUrl.kChatStreamUrl, context,
        params: params);
  }

  Future<void> _cancelSubscription() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null; // 重置订阅变量
      _sseService = SSEService();
    }
  }

  void _startSSE(String text, [String isRepeat = '']) async {
    // 取消之前的订阅（如果有）
    await _cancelSubscription();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? token = preferences.getString(TBDefVal.kToken);
    var params = {
      "message": {
        "id": isRepeat,
        "session": 'sessions/${logicDet.session}',
        "content": {
          "contentType": 'text/plain',
          "inlineSource": text,
        }
      }
    };
    try {
      await _sseService.subscribeToSSE(
        method: SSERequestType.POST,
        url: '${TBConfig.BASE_URL}/chat-backend/chatStream',
        headers: {
          "token": token ?? '',
          "Accept": "text/event-stream",
          "Cache-Control": "no-cache",
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: params,
      );
      logicDet.items = [];
      UserInfoProvider userInfo =
          Provider.of<UserInfoProvider>(context, listen: false);

      ChatResponseModel model = ChatResponseModel(
          query: text,
          isUnlike: false,
          isLike: false,
          stream: _sseService.stream,
          isSearch: userInfo.isSearchMode);
      if (isRepeat.isNotEmpty) {
        model.siblingMessageIds = logicDet.siblingMessageIds;
        model.siblingMessageIds?.add('value');
        model.currentPage = model.siblingMessageIds?.length ?? 0;
      }
      setState(() {
        logicDet.dataSource.insert(0, model);
      });
      String content = "";
      List images = [];
      List<List<String>> tables = [];
      bool finished = false;
      bool isStop = false;
      bool isOperdation = false;
      bool isPainting = false;
      bool isSearching = false;

      int progressP = 0;

      ChatProvider chatProvider =
          Provider.of<ChatProvider>(context, listen: false);
      print('----------->>>>_sseService begin<<<<-----------');
      if (chatProvider.isStopGeneration) {
        chatProvider.stopGeneration = false;
        logicDet.isStopGeneration = false;
      }

      _subscription = _sseService.stream.listen((event) async {
        if (chatProvider.isStopGeneration) {
          isStop = true;
          await _cancelSubscription();
        }
        print('----------Id: ' + event.id!);
        print('----------Event: ' + event.event!);
        print('----------Data: ' + event.data!);
        if (event.data != null && event.data != '' && !isStop) {
          String jsonData = event.data ?? '';
          try {
            Map<String, dynamic> data = json.decode(jsonData);
            final msgModel = TBChatMessageContent.fromJson(data);

            if (event.event == 'completed') {
              print('----------->>>>completed<<<<-----------');

              finished = true;
              logicDet.disTimer();
              content = msgModel.messages?.last?.content?.inlineSource ?? '';
              print("content =\n $content");
              // print("searchDataList = ${data["searchDataList"]}");
              setState(() {
                model.reqId = msgModel.messages?.last?.id ?? '';

                model.items =
                    msgModel.messages?.last?.citation?.citations ?? [];
                if (model.items.length == 0) {
                  if (logicDet.items.length != 0) {
                    model.noItems = false;
                    model.items = logicDet.items;
                  }
                } else {
                  model.noItems = false;
                  logicDet.items =
                      msgModel.messages?.last?.citation?.citations ?? [];
                }
              });
              images =
                  msgModel.messages?.last?.content?.ossSource?.inputUris ?? [];
              if (images.length > 0 && (content?.isBlank ?? false)) {
                // content = 'chatImageDefaultText'.tr;
                content = '';

                setState(() {
                  model.content = content;
                });
              }
              setState(() {
                model.images = images;
              });
              logicDet.requestMsgList();
              if (finished || isStop) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  chatProvider.streamLoading = false;
                  chatProvider.sessionAddAssistant(content);
                });
                setState(() {
                  model.isFinished = true;
                  model.content = content;
                });
              }
            } else {
              print('----------->>>>chunk<<<<-----------');
              isOperdation =
                  ((msgModel.metadata?.operationMetadata?.stage ?? '') ==
                      'STAGE_ANALYZING');
              isPainting =
                  ((msgModel.metadata?.operationMetadata?.stage ?? '') ==
                      'STAGE_PAINTING');
              isSearching =
                  ((msgModel.metadata?.operationMetadata?.stage ?? '') ==
                      'STAGE_SEARCHING');
              String? newText =
                  msgModel.messages?.last?.content?.inlineSource ?? '';
              content = content + (newText ?? "");
              if (isOperdation) {
                progressP =
                    msgModel.metadata?.operationMetadata?.progressPercent ?? 0;
              }
              model.items = msgModel.messages?.last?.citation?.citations ?? [];
              if (model.items.length == 0) {
                if (logicDet.items.length != 0) {
                  model.noItems = false;
                  model.items = logicDet.items;
                }
              } else {
                model.noItems = false;
                logicDet.items =
                    msgModel.messages?.last?.citation?.citations ?? [];
              }
              setState(() {
                model.isOperation = isOperdation;
                model.isPainting = isPainting;
                model.isSearching = isSearching;
                model.progressP = progressP;
                model.content = content;
              });
              if (finished || isStop) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  chatProvider.streamLoading = false;
                  chatProvider.sessionAddAssistant(content);
                });
                setState(() {
                  model.isFinished = true;
                  model.content = content;
                });
              }
            }
          } catch (e) {
            // 发生异常时的处理
            print('----------->>>>解析异常<<<<-----------');

            print('Error decoding JSON: $e');
            // 可以记录错误日志或进行其他处理
            logicDet.disTimer();
            finished = true;
          }
        }
      }, onError: (error) {
        print('----------->>>>error<<<<-----------');

        Provider.of<ChatProvider>(context, listen: false).streamLoading = false;
      }, onDone: () {
        print('----------->>>>onDone<<<<-----------');
      });
    } catch (error) {
      print('----------->>>>catch<<<<-----------');

      Provider.of<ChatProvider>(context, listen: false).streamLoading = false;
    }
  }

  handleStream(Stream stream, ChatResponseModel model) async {
    String content = "";
    List images = [];
    List<List<String>> tables = [];
    bool finished = false;
    bool isStop = false;
    bool isOperdation = false;
    bool isPainting = false;

    int progressP = 0;

    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);

    if (chatProvider.isStopGeneration) {
      chatProvider.stopGeneration = false;
      logicDet.isStopGeneration = false;
    }
    final buffer = <int>[];

    await for (var event in stream) {
      if (chatProvider.isStopGeneration) {
        isStop = true;
      }

      if (event != null && !isStop) {
        buffer.addAll(event);
        String str = '';
        try {
          str = utf8.decode(buffer);
          buffer.clear(); // 清空缓冲区
        } catch (e) {
          if (e is FormatException) {
            continue; // 数据还不完整，继续累积数据
          } else {
            rethrow;
          }
        }
        print("----------------------》》》》》》str =\n $str");

        String jsonStr = "";
        if (str.contains("event:chunk")) {
          jsonStr = str.split("event:chunk").last;
        }
        if (jsonStr.isBlank ?? false) {
          jsonStr = str.split("event:completed").last;
        }

        final startObjIndex = jsonStr.indexOf('{');
        String jsonData = '';
        final endObjIndex = jsonStr.lastIndexOf('}');
        if (startObjIndex != -1) {
          jsonData = jsonStr.substring(startObjIndex, endObjIndex + 1);
        }
        if (jsonData.isNotEmpty) {
          try {
            Map<String, dynamic> data = json.decode(jsonData);
            final msgModel = TBChatMessageContent.fromJson(data);

            finished =
                (msgModel.metadata?.streamMetadata?.completed ?? false) ||
                    str.contains("event:completed");

            if (finished) {
              logicDet.disTimer();
              content = msgModel.messages?.last?.content?.inlineSource ?? '';
              print("content =\n $content");
              // print("searchDataList = ${data["searchDataList"]}");
              setState(() {
                model.reqId = msgModel.messages?.last?.id ?? '';

                model.items =
                    msgModel.messages?.last?.citation?.citations ?? [];
                if (model.items.length == 0) {
                  if (logicDet.items.length != 0) {
                    model.noItems = false;
                    model.items = logicDet.items;
                  }
                } else {
                  model.noItems = false;
                  logicDet.items =
                      msgModel.messages?.last?.citation?.citations ?? [];
                }
              });
              images =
                  msgModel.messages?.last?.content?.ossSource?.inputUris ?? [];
              if (images.length > 0 && (content?.isBlank ?? false)) {
                // content = 'chatImageDefaultText'.tr;
                content = '';

                setState(() {
                  model.content = content;
                });
              }
              setState(() {
                model.images = images;
              });
              logicDet.requestMsgList();
            } else {
              isOperdation =
                  ((msgModel.metadata?.operationMetadata?.stage ?? '') ==
                      'STAGE_ANALYZING');
              isPainting =
                  ((msgModel.metadata?.operationMetadata?.stage ?? '') ==
                      'STAGE_PAINTING');
              String? newText =
                  msgModel.messages?.last?.content?.inlineSource ?? '';
              content = content + (newText ?? "");
              if (isOperdation) {
                progressP =
                    msgModel.metadata?.operationMetadata?.progressPercent ?? 0;
              }
              model.items = msgModel.messages?.last?.citation?.citations ?? [];
              if (model.items.length == 0) {
                if (logicDet.items.length != 0) {
                  model.noItems = false;
                  model.items = logicDet.items;
                }
              } else {
                model.noItems = false;
                logicDet.items =
                    msgModel.messages?.last?.citation?.citations ?? [];
              }
              setState(() {
                model.isOperation = isOperdation;
                model.isPainting = isPainting;

                model.progressP = progressP;
                model.content = content;
              });
            }
          } catch (e) {
            // 发生异常时的处理
            print('Error decoding JSON: $e');
            // 可以记录错误日志或进行其他处理
            logicDet.disTimer();
            finished = true;
          }
        }
        // logicDet.scrollToBottom();
      }
    }
    if (finished || isStop) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        chatProvider.streamLoading = false;
        chatProvider.sessionAddAssistant(content);
      });
      setState(() {
        model.isFinished = true;
        model.content = content;
      });
    }
  }

  addNewModel() {
    Provider.of<ChatProvider>(context, listen: false).clearSession();
    final _chatModel = logicDet.dataSource.last;

    if (_chatModel.runtimeType != ChatNewModel) {
      DateTime dateTime = DateTime.now();
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');
      setState(() {
        // logicDet.dataSource.add(ChatNewModel(content: "$month.$day $hour:$minute"));
        logicDet.dataSource
            .insert(0, ChatNewModel(content: "$month.$day $hour:$minute"));
      });
    }
    // logicDet.scrollToBottom();
  }

  removeFeedback() {
    setState(() {
      // logicDet.dataSource.removeLast();
      if (logicDet.dataSource.isNotEmpty) {
        logicDet.dataSource.removeAt(0);
      }
    });
  }

  Widget get _listView {
    return GestureDetector(
      onTap: () {
        ChatProvider chatProvider =
            Provider.of<ChatProvider>(context, listen: false);
        // if (!chatProvider.isStreamLoading) {
        FocusScope.of(context).requestFocus(FocusNode());
        // }
      },
      child: ListView.builder(
        padding: EdgeInsets.zero,
        // 添加这一行
        reverse: true,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        // physics: ClampingScrollPhysics(), // 禁止回弹

        controller: logicDet.scrollController,
        itemCount: logicDet.dataSource.length,
        itemBuilder: (BuildContext context, int index) {
          ChatProvider chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          if (chatProvider.isChoiceAll) {
            logicDet.dataSource.forEach((e) {
              e.isEditSelected = chatProvider.isChoiceAll;
            });
          }
          if (index >= logicDet.dataSource.length) {
            return SizedBox.fromSize();
          }
          ChatModel chatModel = logicDet.dataSource[index];

          if (chatModel.runtimeType == ChatRequestModel) {
            ChatRequestModel requestModel = chatModel as ChatRequestModel;
            // print("ChatRequestModel = ${chatModel.content}");
            return ChatRequestCell(
              chatModel,
              deleteHandle: () {
                print("点击了删除");
                showDeleteDialog(chatModel);
              },
              onStateChanged: (ChatRequestModel chatRequest) {
                print("点击了勾选");
                ChatProvider chatProvider =
                    Provider.of<ChatProvider>(context, listen: false);
                chatProvider.choiceAll = false;
                logicDet.dataSource[index] = chatRequest;
              },
              key: ValueKey(requestModel.content),
            );
          } else if (chatModel.runtimeType == ChatResponseCodeModel) {
            print(
                "C------------------------hatResponseCodeModel = ${chatModel.content}");
            return ChatResponseCodeCell(chatModel as ChatResponseCodeModel,
                likeHandle: (like) {
              likeHandle(index, like);
            }, unlikeHandle: (unlike) {
              unlikeHandle(index, unlike);
            });
          } else if (chatModel.runtimeType == ChatResponseModel) {
            // print("ChatResponseModel = ${chatModel.content}");
            if (index == 0) {
              logicDet.isLast = true;
            } else {
              logicDet.isLast = false;
            }
            ChatResponseModel responseModel = chatModel as ChatResponseModel;
            return ChatResponseCell(
              responseModel,
              index,
              foldHandle: (fold) {
                foldHandle(index, fold);
              },
              likeHandle: (like) {
                likeHandle(index, like);
              },
              shareHandle: () {
                //unlikeHandle(index, unlike);
                ChatModel chatModel = logicDet.dataSource[index];

                logic.dataSource = [];
                // logic.dataSource.add(logicDet.dataSource[index + 1]);
                // logic.dataSource.add(chatModel);

                // 计算拷贝的起始位置
                int startIndex = logicDet.dataSource.length - 1;
// 使用 insertAll 方法将 logicDet.dataSource 数组的元素拷贝到 logic.dataSource 中
                logic.dataSource = [];
                for (int i = index; i <= startIndex; i++) {
                  logic.dataSource.add(logicDet.dataSource[i]);
                }

                ///进行倒序排序
                logic.dataSource = logic.dataSource.reversed.toList();
                double totalHeight = logic.dataSource.fold(0.0,
                    (double accumulator, ChatModel data) {
                  print("height = ${data.height!}");
                  print("isEditSelected = ${data.isEditSelected!}");
                  print("content = ${data.content!}");

                  return accumulator + data.height!;
                });
                if (totalHeight > 604) {
                  logic.changeZoomRatio(0.57);
                } else {
                  logic.changeZoomRatio(0.64);
                }

                showShareModel(context);
              },
              reportHandle: () {
                logicDet.showReportDialog();
              },
              deleteHandle: () {
                showDeleteDialog(chatModel);
              },
              regenerateHandle: (content) {
                FocusScope.of(context).requestFocus(FocusNode());
                ChatModel requestModel = logicDet.dataSource[1];
                debugPrint('-------------发送问题 按钮3');

                searchRequest(
                    requestModel.content, responseModel.parentMessageId ?? '');
              },
              mulChoiceHandle: () {},
              selectAllHandle: () {},
              onStateChanged: (ChatResponseModel chatRequest) {
                print("点击了勾选2");
                ChatProvider chatProvider =
                    Provider.of<ChatProvider>(context, listen: false);
                chatProvider.choiceAll = false;
                logicDet.dataSource[index] = chatRequest;
              },
              key: ObjectKey(responseModel.stream),
            );
          } else if (chatModel.runtimeType == ChatResponseLoadingModel) {
            // print("ChatResponseLoadingModel = ${chatModel.content}");

            return ChatResponseLoadingCell(
              key: ValueKey(index),
            );
          } else if (chatModel.runtimeType == ChatFeedbackModel) {
            // print("ChatFeedbackModel = ${chatModel.content}");

            return ChatFeedbackCell(
              confirmHandle: () {
                removeFeedback();
              },
              closeHandle: () {
                removeFeedback();
              },
            );
          } else if (chatModel.runtimeType == ChatRequestFileModel) {
            // print("ChatRequestFileModel = ${chatModel.content}");

            ChatRequestFileModel requestModel =
                chatModel as ChatRequestFileModel;
            return ChatRequestFileCell(
              requestModel,
              deleteHandle: () {
                showDeleteDialog(chatModel);
              },
              onStateChanged: (ChatRequestFileModel chatRequest) {
                print("点击了勾选3");
                ChatProvider chatProvider =
                    Provider.of<ChatProvider>(context, listen: false);
                chatProvider.choiceAll = false;
                logicDet.dataSource[index] = chatRequest;
              },
              key: ValueKey(requestModel.content),
            );
          } else if (chatModel.runtimeType == ChatTipModel) {
            // print("ChatTipModel = ${chatModel.content}");

            return ChatTipCell(
              confirmHandle: () {
                removeFeedback();
              },
              closeHandle: () {
                removeFeedback();
              },
            );
          } else if (chatModel.runtimeType == ChatHelloWorldModel) {
            // print("ChatHelloWorldModel = ${chatModel.content}");

            return ChatHelloWorldCell();
          } else if (chatModel.runtimeType == ChatSuggestModel) {
            // print("ChatSuggestModel = ${chatModel.content}");

            return GetBuilder<TBChatDetailLogic>(builder: (state) {
              return ChatSuggestCell(
                searchHandle: (content) {
                  FocusScope.of(context).requestFocus(FocusNode());

                  ChatProvider chatProvider =
                      Provider.of<ChatProvider>(context, listen: false);
                  if (chatProvider.isStreamLoading) {
                    Fluttertoast.showToast(msg: 'Please wait'.tr);
                  } else {
                    setState(() {
                      debugPrint('-------------发送问题 按钮');
                      searchRequest(content);
                    });
                  }
                },
              );
            });
          } else {
            final chatNewModel = chatModel as ChatNewModel;
            // print("ChatNewModel = ${chatModel.content}");

            return ChatNewCell(chatNewModel.content,
                key: ValueKey(chatNewModel.content));
          }
        },
      ),
    );
  }

  showDeleteDialog(ChatModel model) {
    print('删除方法');
    showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          children: <Widget>[
            Spacer(),
            dialogItem(
                text: 'Delete'.tr,
                color: themed.theme_c.alertSureColor,
                tapHandle: () {
                  setState(() {
                    logicDet.dataSource.remove(model);
                  });
                  Fluttertoast.showToast(
                      msg: 'Successfully deleted'.tr,
                      gravity: ToastGravity.CENTER);
                }),
            SizedBox(
              height: 10.w,
            ),
            dialogItem(
              text: 'Cancel'.tr,
              color: themed.theme_c.alertSureColor,
            )
          ],
        );
      },
    );
  }

  /// 执行存储图片到本地相册
  void doSaveImage() async {
    // await _requestPermission();
    // Uint8List data = await getImageData();
    // String path = await saveImage(data);
    // final result = await ImageGallerySaver.saveFile(path);
    // showDialog(
    //     context: context,
    //     builder: (_) {
    //       return AlertDialog(
    //         title: Text("保存成功！"),
    //       );
    //     });
  }

  Widget dialogItem(
      {required String text, required Color color, Function()? tapHandle}) {
    return GestureDetector(
      onTap: () {
        Get.back();
        if (tapHandle != null) {
          tapHandle!();
        }
      },
      child: Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: color),
          ),
        ),
        width: 287.w,
        height: 44.w,
        decoration: BoxDecoration(
            color: themed.theme_c.alertBgColor,
            borderRadius: BorderRadius.circular(22.r)),
      ),
    );
  }

  Widget bottomItem(String text, String imagePath, Function() tapHandle) {
    return InkWell(
      onTap: tapHandle,
      child: Container(
        // color: Colors.blue, // 设置背景色
        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        // 调整内边距大小来扩大点击范围
        child: Column(
          children: [
            // Icon(Icons.cancel_outlined),
            Image.asset(
              imagePath,
              width: 24.w,
            ),
            SizedBox(
              height: 12.w,
            ),
            Text(
              text,
              style: TextStyle(
                  color: themed.theme_c.textColorMild,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget get _contentBottom {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    if (chatProvider.isEditMode) {
      return Container(
        color: themed.theme_c.bgColor,
        // padding: EdgeInsets.only(top: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            bottomItem('Cancel'.tr, "assets/images/chat/chat_bottom_cancel.png",
                () {
              logicDet.dataSource.forEach((element) {
                element.isEditSelected = false;
              });

              chatProvider.editMode = false;
              setState(() {});
            }),
            bottomItem('Delete'.tr, "assets/images/chat/chat_bottom_delete.png",
                () {
              setState(() {
                logicDet.dataSource = logicDet.dataSource.where((element) {
                  return !(element.isEditSelected ?? false);
                }).toList();
              });
              chatProvider.editMode = false;
              Fluttertoast.showToast(
                  msg: 'Successfully deleted'.tr, gravity: ToastGravity.CENTER);
            }),
          ],
        ),
      );
    } else if (!chatProvider.hiddenChatBottom) {
      return ChatBottom(
        searchHandle: (value) async {
          debugPrint('-------------发送问题 按钮1');
// 列表滑到底部
          searchRequest(value);
        },
        newConversation: () {
          print('重新对话');
          // logicVoice.play();
          // TBRouterHelper.pathPage(TBRouterPath.wechatRecordPath, null);
          // logicVoiceC.play();
          // 重新对话 更新uuid
          addNewModel();
          _clientSession = Uuid().v4();
        },
        searchModelHandle: (value) {
          print('搜索模式');
          // logicVoice.startRecord();
          addNewModel();
          _isSearchMode = value;
        },
        mulConversation: (value) {
          print('duo轮');
          // logicVoice.stopRecorder();

          addNewModel();
          _isMulConversation = value;
        },
        refreshHandle: () {
          print('refresh');

          addNewModel();
          _clientSession = Uuid().v4();
        },
      );
    } else {
      return SizedBox();
    }
  }

  ///主动分享
  showShareModel(BuildContext context) {
    TBWeChatUtils.instance.initBase();
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
                  RepaintBoundary(
                    key: logic.repaintKey,
                    child: TBShareImagePage(),
                  ),
                  Spacer(),
                  Container(
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
                              ItemLittleView(
                                  label: "Save to album".tr,
                                  icon:
                                      "assets/images/chat/chat_share_save1.png",
                                  option: TBImageDialogOption.saveToAlbum

                                  // onTap: () => () {
                                  //   print("点击了");
                                  // },
                                  ),
                            ],
                            onItemSelected: (selectedItem) {
                              // 传递回调函数，但可以在此处编写处理逻辑
                              print("选定的项目是：$selectedItem");
                              switch (selectedItem) {
                                case TBImageDialogOption.saveToAlbum:
                                  logic.doSaveImage();
                                  break;
                                case TBImageDialogOption.wechatFriend:
                                  logic.doShareFriend();
                                  break;
                                default:
                                  logic.doShareCircle();
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

  Future<void> searchRequest(String content, [String isRepeat = '']) async {
    if (logicDet.isLogin == false) {
      TBRouterHelper.pathPage(TBRouterPath.loginPath, null);
      return;
    }
    logicDet.requestStr = content;
    final fileName = logicDet.documentPath;
    final filePath = logicDet.documentAllPath;

    // 列表滑到底部
    setState(() {
      if (logicDet.session.isEmpty) {
        logicDet.dataSource.clear(); // 移除所有元素
      }
      if (filePath.isNotEmpty) {
        logicDet.addFile();
      }
      if (_isMulConversation) {
        Provider.of<ChatProvider>(context, listen: false)
            .sessionAddHuman(content);
      }
      // logicDet.dataSource.add(ChatRequestModel(content: content));
      // logicDet.dataSource.add(ChatResponseLoadingModel());
      if (isRepeat.isNotEmpty && logicDet.dataSource.length > 1) {
        logicDet.dataSource.removeRange(0, 2);
      }
      logicDet.dataSource.insert(0, ChatRequestModel(content: content));
      // logicDet.dataSource.insert(0, ChatResponseLoadingModel());
    });
    logicDet.scrollToBottom();

    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    Future.microtask(() => chatProvider.streamLoading = true);

    await logicDet.verifyAssistant();
    if (filePath.isNotEmpty) {
      await logicDet.uploadFile(fileName, filePath);
    }
    print('----------- 结束: ');
    _startSSE(content, isRepeat);
    // try {
    //   sendMsg(content, isRepeat).then((TBResponse response) {
    //     TBStreamResponse streamResponse = response as TBStreamResponse;
    //     if (streamResponse.success) {
    //       UserInfoProvider userInfo =
    //           Provider.of<UserInfoProvider>(context, listen: false);
    //
    //       ChatResponseModel model = ChatResponseModel(
    //           query: content,
    //           isUnlike: false,
    //           isLike: false,
    //           stream: streamResponse.stream,
    //           isSearch: userInfo.isSearchMode);
    //       if (isRepeat.isNotEmpty) {
    //         model.siblingMessageIds = logicDet.siblingMessageIds;
    //         model.siblingMessageIds?.add('value');
    //         model.currentPage = model.siblingMessageIds?.length ?? 0;
    //       }
    //       setState(() {
    //         // if (logicDet.dataSource.first.runtimeType ==
    //         //     ChatResponseLoadingModel) {
    //         //   // logicDet.dataSource.removeLast();
    //         //   logicDet.dataSource.removeAt(0);
    //         // }
    //         // logicDet.dataSource.add(model);
    //         logicDet.dataSource.insert(0, model);
    //       });
    //
    //       handleStream(streamResponse.stream, model);
    //     } else {
    //       Provider.of<ChatProvider>(context, listen: false).streamLoading =
    //           false;
    //     }
    //   }).catchError((error) {
    //     // setState(() {
    //     //   if (logicDet.dataSource.first.runtimeType ==
    //     //       ChatResponseLoadingModel) {
    //     //     // logicDet.dataSource.removeLast();
    //     //     logicDet.dataSource.removeAt(0);
    //     //   }
    //     // });
    //     Provider.of<ChatProvider>(context, listen: false).streamLoading = false;
    //   });
    // } catch (error) {
    //   // setState(() {
    //   //   if (logicDet.dataSource.first.runtimeType == ChatResponseLoadingModel) {
    //   //     // logicDet.dataSource.removeLast();
    //   //     logicDet.dataSource.removeAt(0);
    //   //   }
    //   // });
    //   Provider.of<ChatProvider>(context, listen: false).streamLoading = false;
    // }
  }

  List<ChatResponseItemModel> chatResponseItems(
      List searchDataList, ChatResponseModel model) {
    List<ChatResponseItemModel> itemModels = searchDataList.map((e) {
      ChatResponseItemModel itemModel = ChatResponseItemModel.fromJson(e);
      return itemModel;
    }).toList();
    model.noItems = false;
    if (itemModels.length == 0) {
      model.noItems = true;
      ChatResponseItemModel defaultItemModel =
          ChatResponseItemModel.fromJson({});
      itemModels = [defaultItemModel];
    }
    return itemModels;
  }

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);

    return ThemeWidget(builder: (context, themeController) {
      return Scaffold(
          key: _scaffoldKey, // Set the key here

          appBar: AppBar(
              elevation: 0.0,
              backgroundColor: themed.theme_c.bgColor,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/chat/chat_tiger.png",
                    width: 34.0.w,
                    height: 34.0.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8.0.w),
                  Text(
                    "TigerBot",
                    style: TextStyle(color: themed.theme_c.textColor),
                  ),
                ],
              ),
              leading: _buildPopupMenuButton(context),
              actions: [
                Stack(
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          ChatProvider chatProvider =
                              Provider.of<ChatProvider>(context, listen: false);
                          if (chatProvider.isStreamLoading) {
                            Fluttertoast.showToast(msg: 'Please wait'.tr);
                            return;
                          }
                          if (logicDet.isLogin == false) {
                            TBRouterHelper.pathPage(
                                TBRouterPath.loginPath, null);
                            return;
                          }
                          logicDet.createSession();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.asset(
                            "assets/images/chat/chat_more_refresh2.png",
                            // 你的菜单图标路径
                            width: 23.0.w,
                            height: 23.0.w,
                            fit: BoxFit.cover,
                            color: themed.theme_c.iconColor, // 你想要的颜色
                            colorBlendMode: BlendMode.srcIn, // 混合模式
                          ),
                        ),
                      ),
                    ),
                    // Center(
                    //     child: GestureDetector(
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(18.w),
                    //             border:
                    //                 Border.all(color: Colors.white, width: 2.w),
                    //           ),
                    //           child: ClipOval(
                    //             child: userInfoProvider.avatar.isEmpty
                    //                 ? SizedBox()
                    //                 : CachedImage(
                    //                     width: 36.w,
                    //                     height: 35.w,
                    //                     imageUrl: userInfoProvider.avatar,
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //           ),
                    //         ),
                    //         onTap: () {
                    //           // Navigator.pushNamed(context, "/mine");
                    //           TBRouterHelper.pathPage(
                    //               TBRouterPath.minePath, null);
                    //         }))
                  ],
                ),
                SizedBox(
                  width: 20.w,
                )
              ]),
          body: Container(
            color: themed.theme_c.bgColor,
            // padding: EdgeInsets.only(bottom: 34.h),
            child: Column(
              children: [
                Expanded(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: GetBuilder<TBChatDetailLogic>(
                      id: TBDefVal.kChatMsgList,
                      // 添加id绑定，update时只当前GetBuilder会刷新
                      builder: (state) {
                        return Container(
                          child: NotificationListener(
                            onNotification: (ScrollNotification note) {
                              // FocusScopeNode node = FocusScope.of(context);
                              // print(node.isFirstFocus);
                              FocusScope.of(context).requestFocus(FocusNode());
                              return false;
                            },
                            child: _listView,
                          ),
                        );
                      }),
                )),
                _contentBottom,
                Container(
                  height: 34.w,
                  color: themed.theme_c.bgColor,
                ),
              ],
            ),
          ),
          drawer: GetBuilder<TBChatDetailLogic>(
              id: TBDefVal.kChatSession, // 添加id绑定，update时只当前GetBuilder会刷新
              builder: (state) {
                return ChatSessionPage(
                  logicDet: state,
                  doSelect: () {
                    /// 选择
                    ///
                  },
                );
              })
          // Builder(
          //   builder: (context) => ChatSessionPage(sessions: sessions),
          // ),
          );
    });
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ChatProvider chatProvider =
            Provider.of<ChatProvider>(context, listen: false);
        if (chatProvider.isStreamLoading) {
          Fluttertoast.showToast(msg: 'Please wait'.tr);
          return;
        }
        if (logicDet.isLogin == false) {
          TBRouterHelper.pathPage(TBRouterPath.loginPath, null);
          return;
        }
        // Scaffold.of(context).openDrawer();
        _scaffoldKey.currentState
            ?.openDrawer(); // Access the ScaffoldState using the key
      },
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset(
          "assets/images/chat/chat_detail_menu.png", // 你的菜单图标路径
          width: 24.0,
          height: 24.0,
          color: themed.theme_c.iconColor, // 你想要的颜色
          colorBlendMode: BlendMode.srcIn, // 混合模式
        ),
      ),
    );
  }

  ///左上角按钮及菜单
  PopupMenuButton _popupMenuButton(BuildContext context) {
    return PopupMenuButton(
      icon: Image.asset(
        "assets/images/chat/chat_detail_menu.png", width: 25.w,
        color: themed.theme_c.iconColor, // 你想要的颜色
        colorBlendMode: BlendMode.srcIn, // 混合模式
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 2,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: "clean",
            height: 40.h,
            padding: EdgeInsets.only(top: 0, right: 0, left: 20, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/chat/chat_clear_record.png",
                  width: 16.w,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  'Clear Record'.tr,
                  style: TextStyle(
                      color: themed.theme_c.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          PopupMenuItem(
            value: "share",
            height: 40.h,
            padding: EdgeInsets.only(top: 0, right: 0, left: 20, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/chat/chat_bottom_share.png",
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  'Share'.tr,
                  style: TextStyle(
                      color: themed.theme_c.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ];
      },
      onSelected: (selectedValue) {
        if (selectedValue == "clean") {
          ChatProvider chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          if (chatProvider.isStreamLoading) {
            Fluttertoast.showToast(
                msg: 'Please wait'.tr, gravity: ToastGravity.CENTER);
          } else {
            _clientSession = Uuid().v4();
            setState(() {
              logicDet.dataSource = [];
            });
            Get.back();
            Fluttertoast.showToast(
                msg: 'Cleared session successfully'.tr,
                gravity: ToastGravity.CENTER);
            Get.back();
          }
        } else {
          logic.dataSource = logicDet.dataSource;
          double totalHeight =
              logic.dataSource.fold(0.0, (double accumulator, ChatModel data) {
            print("height = ${data.height!}");
            print("isEditSelected = ${data.isEditSelected!}");
            print("content = ${data.content!}");

            return accumulator + data.height!;
          });
          if (totalHeight > 604) {
            logic.changeZoomRatio(0.57);
          } else {
            logic.changeZoomRatio(0.64);
          }

          showShareModel(context);
          // showScreenShare(context);
        }
      },
      onCanceled: () {
        print("canceled");
      },
      // 上移 40 逻辑像素
      offset: Offset(0, 55),
      // color: Colors.grey,
    );
  }
}
