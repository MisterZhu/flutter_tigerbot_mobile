import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constant/tb_export_common.dart';
import 'sc_string_utils.dart';

class TBWebViewController extends GetxController {
  var progress = 0.0.obs;

  // Method to update progress
  void updateProgress(double value) {
    progress.value = value;
  }
}

class TBWebViewPage extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const TBWebViewPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<TBWebViewPage> createState() => _TBWebViewPageState();
}

class _TBWebViewPageState extends State<TBWebViewPage> {
  WebViewController? webViewController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final TBWebViewController _webViewController = Get.put(TBWebViewController());

  /// webView title
  String _title = "";

  /// webView url
  String _url = "";

  /// 如果是富文本 则传递richText
  String _richText = "";

  bool _isLocalUrl = false;

  /// 进度
  double progress = 0;

  @override
  void initState() {
    super.initState();
    dynamic params = Get.arguments;
    print('webView接收的参数：$params');
    _title =
        StringUtils.isNotNullOrEmpty(params?["title"]) ? params!["title"] : "";
    _url = StringUtils.isNotNullOrEmpty(params?["url"]) ? params!["url"] : "";

    _richText = StringUtils.isNotNullOrEmpty(params?["richText"])
        ? params!["richText"]
        : "";
    _isLocalUrl = params?["isLocalUrl"] ?? false;
  }

  @override
  void dispose() {
    // EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SCCustomScaffold(
      leading: _leading(),
      leadingWidth: 100,
      body: _body(),
      centerTitle: true,
      showBackIcon: true,
      showBackgroundImage: false,
      navBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      bodyBackgroundColor: themed.theme_c.bgWhiteOrBlack,
      customTitleWidget: Text(
        _title,
        style: TextStyle(
          color: themed.theme_c.textColor,
          fontSize: 18.sp,
        ),
      ),
    );
  }

  /// leading
  Widget _leading() {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 24,
            height: 44,
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 44.0,
                child: Image.asset(
                  Assets.commonCommonBackIcon,
                  width: 24.0,
                  height: 24.0,
                  color: themed.theme_c.textColor, // 你想要的颜色
                  colorBlendMode: BlendMode.srcIn,
                ),
                onPressed: () {
                  goBack();
                }),
          ),
        ],
      ),
    );
  }

  /// body
  Widget _body() {
    return ((StringUtils.isNullOrEmpty(_url) && !_isLocalUrl) ||
            (_isLocalUrl &&
                (StringUtils.isNullOrEmpty(_richText) &&
                    StringUtils.isNullOrEmpty(_url))))
        ? Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text("当前路径为空"),
            ),
          )
        : _isLocalUrl && StringUtils.isNotNullOrEmpty(_richText)
            ? RichText(
                text: TextSpan(text: _richText),
              )
            : contentItem();
  }

  /// content
  Widget contentItem() {
    return Stack(
      children: [
        webViewItem(),
        progressIndicator(),
      ],
    );
  }

  /// webView
  Widget webViewItem() {
    print('-----------------------------开始加载webViewItem');
    return WebView(
      initialUrl: _isLocalUrl ? "" : _url,
      // 设置初始缩放比例

      /// 是否开启JS
      javascriptMode: JavascriptMode.unrestricted,

      /// 跟H5交互的方法到此处处理
      javascriptChannels: {
        // jxTokenChannel(context),
        // getLocationChannel(context),
        // scanChannel(context),
        // userInfoChannel(context),
        // cameraChannel(context),
        // photosChannel(context),
        // callChannel(context),
        // browserChannel(context),
        // wechatPayChannel(context),
        // alipayChannel(context),
        // gobackNativeChannel(context),
        safetyVerification(context),
        closeVerification(context),
      },

      ///WebView创建
      onWebViewCreated: _onWebViewCreated,

      ///页面开始加载
      onPageStarted: _onPageStarted,

      ///页面加载结束
      onPageFinished: _onPageFinished,

      onProgress: _onProgress,

      ///如果出现错误
      onWebResourceError: (WebResourceError error) =>
          debugPrint('error:${error.description}'),

      navigationDelegate: (NavigationRequest request) {
        // Here you can intercept and decide whether to allow the navigation or not
        print(
            '---------------------------Trying to navigate to: ${request.url}');

        // Example: Allow navigation only to a specific domain
        // if (request.url.startsWith('https://example.com')) {
        //   return NavigationDecision.navigate;
        // } else {
        //   // Prevent navigation to other URLs
        //   return NavigationDecision.prevent;
        // }
        return NavigationDecision.navigate;
      },
    );
  }

  /// 进度条
  Widget progressIndicator() {
    return Obx(() {
      bool offstage = _webViewController.progress.value < 1.0 ? false : true;
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: Offstage(
          offstage: offstage,
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: TBColors.primaryColor,
            value: _webViewController.progress.value,
          ),
        ),
      );
    });
  }

  // Widget progressIndicator() {
  //   bool offstage = progress < 1.0 ? false : true;
  //   return Positioned(
  //       left: 0,
  //       right: 0,
  //       top: 0,
  //       child: Offstage(
  //         offstage: offstage,
  //         child: LinearProgressIndicator(
  //           backgroundColor: Colors.transparent,
  //           color: TBColors.primaryColor,
  //           value: progress,
  //         ),
  //       ));
  // }

  /// webView创建
  void _onWebViewCreated(WebViewController controller) async {
    print('-----------------------------开始创建 :$_url');

    webViewController = controller;
    // webViewController?.loadUrl(Uri.dataFromString(html,
    //         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
    //     .toString());
    if (_isLocalUrl) {
      await _loadHtmlFromAssets();
    }
    _controller.complete(controller);
    webViewController!.clearCache();
  }

  /// webView开始加载
  void _onPageStarted(String url) {
    // EasyLoading.show();
    print('-----------------------------加载开始');
  }

  /// webView加载结束
  void _onPageFinished(String url) async {
    print('-----------------------------加载结束');

    _webViewController.updateProgress(1.0);

    // EasyLoading.dismiss();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   if (mounted) {
    //     setState(() {
    //       progress = 1;
    //     });
    //   }
    // });
    // var params = {
    //   'are': '+86',
    //   'phone': '18605888871',
    // };
    // print(params);

    // webViewController?.runJavascript(TBUtils()
    //     .flutterCallH5(h5Name: TBDefVal.areAndMobileKey, params: params));
    // webViewController
    //     ?.runJavascript("areaAndmobile('+86','13093553089')");

    // setState(() {
    //   progress = 1;
    // });
  }

  void _onProgress(int progress) {
    print('-----------------------------加载进度：$progress');
    double value = progress / 100;
    _webViewController.updateProgress(value);
    // if (mounted) {
    //   setState(() {
    //     this.progress = progress / 100;
    //   });
    // }
  }

  Future<void> _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(_url);
    webViewController?.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  // 后退
  goBack() async {
    if (webViewController == null) {
      TBRouterHelper.back(null);
      return;
    }
    bool goBack = await webViewController!.canGoBack();
    if (goBack) {
      webViewController!.goBack();
    } else {
      TBRouterHelper.back(null);
    }
  }

//  方圆当前社区ID
  JavascriptChannel safetyVerification(BuildContext context) =>
      JavascriptChannel(
          name: TBDefVal.jsVerifyResult,
          onMessageReceived: (JavascriptMessage message) {
            var jsonMessage = message.message;
            // var decodedMessage = jsonDecode(jsonMessage);
            // var id = decodedMessage['id'];
            // var spaceId = decodedMessage['spaceId'] as int;

            // print("fycommunityId = " + jsonMessage);
            // print("token = " + id);
            // print("spaceId = $spaceId");
          });
  //  方圆当前社区ID
  JavascriptChannel closeVerification(BuildContext context) =>
      JavascriptChannel(
          name: 'testClick',
          onMessageReceived: (JavascriptMessage message) {
            String msg = message.message;
            print("fycommunityId = " + msg);
          }
          // name: TBDefVal.jsVerifyResult,
          // onMessageReceived: (JavascriptMessage message) {
          //   var jsonMessage = message.message;
          //
          //   print("fycommunityId = " + jsonMessage);
          // }
          );
}
