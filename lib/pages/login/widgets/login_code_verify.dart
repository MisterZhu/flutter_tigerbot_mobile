import 'dart:convert';

import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../util/event/event_bus.dart';
import '../../../util/tb_utils.dart';
import '../../home/logic/tb_launch_logic.dart';
import '../privacy/logic/tb_privacy_logic.dart';

class TBWebVerifyView {
  WebViewController? _webViewController; // 添加WebViewController

  Future<void> showTeenModel(BuildContext context, String are, String mobile) {
    print('----------showTeenModel : $mobile');

    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GestureDetector(
          onTap: () {
            TBRouterHelper.back(null);
          },
          child: GetBuilder<TBLaunchLogic>(
              id: TBDefVal.kRefreshWebView,
              builder: (state) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                ((MediaQuery.of(context).size.width - 318) / 2),
                            vertical:
                                ((MediaQuery.of(context).size.height - 316) /
                                    2)),
                        // EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 48.0.w),
                        // EdgeInsets.symmetric(horizontal: 28.5.w, vertical: 248.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.w),
                          color: Colors.white,
                        ),
                        child: _buildWebView(context, are, mobile, state),
                      ),
                    ),
                    if (state.isFinish == false)
                      Container(
                        // color: Colors.black.withOpacity(0.5),
                        child: SpinKitWave(
                          color: Color(0xffFF98AC),
                          size: 35.0.r,
                          itemCount: 6,
                        ),
                      ),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget _buildWebView(
      BuildContext context, String are, String mobile, TBLaunchLogic logic) {
    // String url = '${TBUrl.kSendCodeWebView}?area=$are&mobile=$mobile';
    String encodedUrl =
        '${TBUrl.kSendCodeWebView}?area=${Uri.encodeComponent(are)}&mobile=${Uri.encodeComponent(mobile)}';

    return WebView(
      backgroundColor: Colors.transparent, // Set transparent background
      initialUrl: encodedUrl, // Replace with your URL
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) {
        print('-----------------------------开始加载 $encodedUrl');

        _webViewController = controller;
      },
      navigationDelegate: (NavigationRequest request) {
        print('Trying to navigate to: ${request.url}');

        Uri uri = Uri.parse(request.url);
        if (uri.scheme == 'jsbridge' && uri.pathSegments.isNotEmpty) {
          // 解码 URL 中的参数
          String decodedParameters = Uri.decodeFull(uri.pathSegments.first);
          try {
            // 尝试解析 JSON 字符串
            Map<String, dynamic> jsonMap = jsonDecode(decodedParameters);
            print('--------------jsonMap: $jsonMap');

            // 获取 bizResult 的值
            bool bizResult = jsonMap['bizResult'] ?? false;
            if (bizResult && (logic.isSuccessful == false)) {
              logic.isSuccessful = true;
              bus.emit(TBDefVal.kCodeSucceedEvent, "66666");
              TBRouterHelper.back(null);
            }
          } catch (e) {
            // JSON 解析失败，可以根据需要进行处理
          }
          return NavigationDecision.prevent;
        } else {
          return NavigationDecision.navigate;
        }
      },
      onPageFinished: (String url) {
        print('-----------------------------加载结束');

        // logic.isFinish = true;
        // logic.update([TBDefVal.kRefreshWebView]);
      },
      onProgress: (int progress) {
        print('-----------------------------加载进度：$progress');
        if (progress >= 80 && logic.isFinish == false) {
          print('----------------------------- > 80');
          print('-----------------------------加载进度：$progress');
          Future.delayed(const Duration(milliseconds: 500), () {
            logic.isFinish = true;
            logic.update([TBDefVal.kRefreshWebView]);
          });
        }
      },
      javascriptChannels: Set.from([
        JavascriptChannel(
          name: TBDefVal.jsVerifyResult, // 这是与web端约定的通道名称
          onMessageReceived: (JavascriptMessage message) {
            // 接收来自web端的消息
            print('Received message from web: ${message.message}');
            var jsonMessage = message.message;
            var decodedMessage = jsonDecode(jsonMessage);

            if (decodedMessage['bizResult'] is bool) {
              var result = decodedMessage['bizResult'] as bool;
              print("bizResult is a bool: " + result.toString());
              if (result == true && logic.isSuccessful == false) {
                print("result is a true");
                print('-----------发起bus通知');
                logic.isSuccessful = true;
                bus.emit(TBDefVal.kCodeSucceedEvent, "66666");
                TBRouterHelper.back(null);
              }
            }
            // 在这里可以处理web端传递过来的数据
          },
        ),
        JavascriptChannel(
          name: TBDefVal.jsCloseResult, // 这是与web端约定的通道名称
          onMessageReceived: (JavascriptMessage message) {
            // 接收来自web端的消息
            print('Received message from web: ${message.message}');
            TBRouterHelper.back(null);
          },
        ),
      ]),
    );
  }
}
