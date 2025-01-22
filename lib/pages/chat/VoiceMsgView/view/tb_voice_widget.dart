import 'dart:async';
import 'dart:io';
import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';
import 'package:flutter_plugin_record_plus/utils/common_toast.dart';
import 'package:flutter_plugin_record_plus/widgets/custom_overlay.dart';
import '../../../../util/tb_permission_manager.dart';
import '../logic/tb_voice_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';

typedef startRecord = Future Function();
typedef stopRecord = Future Function();

class TBVoiceWidget extends StatefulWidget {
  final Function? startRecord;
  final Function? stopRecord;
  final double? height;
  final EdgeInsets? margin;
  final Decoration? decoration;

  /// startRecord 开始录制回调  stopRecord回调
  const TBVoiceWidget(
      {Key? key,
      this.startRecord,
      this.stopRecord,
      this.height,
      this.decoration,
      this.margin})
      : super(key: key);

  @override
  _TBVoiceWidgetState createState() => _TBVoiceWidgetState();
}

class _TBVoiceWidgetState extends State<TBVoiceWidget> {
  final TBVoiceController logic = Get.put(TBVoiceController());

  // 倒计时总时长
  int _countTotal = 62;
  double starty = 0.0;
  double offset = 0.0;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "images/voice_volume_1.png";

  ///默认隐藏状态
  bool voiceState = true;
  Timer? _timer;
  int _count = 0;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    logic.recordPlugin = new FlutterPluginRecord();

    _init();

    ///初始化方法的监听
    logic.recordPlugin?.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    /// 开始录制或结束录制的监听
    logic.recordPlugin?.response.listen((data) {
      if (data.msg == "onStop") {
        logic.audioPath = data.path ?? '';

        ///结束录制时会返回录制文件的地址方便上传服务器
        if (widget.stopRecord != null)
          widget.stopRecord!(data.path, data.audioTimeLength);
      } else if (data.msg == "onStart") {
        if (widget.startRecord != null) widget.startRecord!();
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    logic.recordPlugin!.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg ?? '');
      setState(() {
        if (voiceData > 0 && voiceData < 0.1) {
          voiceIco = "images/voice_volume_2.png";
        } else if (voiceData > 0.2 && voiceData < 0.3) {
          voiceIco = "images/voice_volume_3.png";
        } else if (voiceData > 0.3 && voiceData < 0.4) {
          voiceIco = "images/voice_volume_4.png";
        } else if (voiceData > 0.4 && voiceData < 0.5) {
          voiceIco = "images/voice_volume_5.png";
        } else if (voiceData > 0.5 && voiceData < 0.6) {
          voiceIco = "images/voice_volume_6.png";
        } else if (voiceData > 0.6 && voiceData < 0.7) {
          voiceIco = "images/voice_volume_7.png";
        } else if (voiceData > 0.7 && voiceData < 1) {
          voiceIco = "images/voice_volume_7.png";
        } else {
          voiceIco = "images/voice_volume_1.png";
        }
        if (overlayEntry != null) {
          overlayEntry!.markNeedsBuild();
        }
      });
    });
  }

  ///显示录音悬浮布局
  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return CustomOverlay(
          icon: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: _countTotal - _count < 11
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            (_countTotal - _count).toString(),
                            style: TextStyle(
                              fontSize: 70.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : new Image.asset(
                        voiceIco,
                        width: 100,
                        height: 100,
                        package: 'flutter_plugin_record_plus',
                      ),
              ),
              Container(
//                      padding: const EdgeInsets.only(right: 20, left: 20, top: 0),
                child: Text(
                  toastShow,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        );
      });
      Overlay.of(context)!.insert(overlayEntry!);
    }
  }

  showVoiceView() {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });

    ///显示录音悬浮布局
    buildOverLayView(context);

    start();
  }

  hideVoiceView() {
    if (_timer!.isActive) {
      if (_count < 1) {
        CommonToast.showView(
            context: context,
            msg: '说话时间太短',
            icon: Text(
              '!',
              style: TextStyle(fontSize: 80, color: Colors.white),
            ));
        logic.isUp = true;
      }
      _timer?.cancel();
      _count = 0;
    }

    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    stop();
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }

    if (logic.isUp) {
      print("取消发送");
    } else {
      print("进行发送");
    }
  }

  moveVoiceView() {
    setState(() {
      logic.isUp = starty - offset > 100 ? true : false;
      if (logic.isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  ///初始化语音录制的方法
  void _init() async {
    logic.recordPlugin?.init();
  }

  ///开始语音录制的方法
  void start() async {
    logic.recordPlugin?.start();
  }

  ///停止语音录制的方法
  void stop() {
    logic.recordPlugin?.stop();
  }

  ///播放语音的方法
  void play() {
    logic.recordPlugin?.playByPath(logic.audioPath, logic.audioType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onLongPressStart: (details) {
          recordPermission(details);
        },
        onLongPressEnd: (details) {
          hideVoiceView();
        },
        onLongPressMoveUpdate: (details) {
          offset = details.globalPosition.dy;
          moveVoiceView();
        },
        child: Container(
          height: widget.height ?? 60,
          // color: Colors.blue,
          decoration: widget.decoration ??
              BoxDecoration(
                borderRadius: new BorderRadius.circular(6.0),
                border:
                    Border.all(width: 1.0, color: themed.theme_c.bgColorBub),
              ),
          child: Center(
            child: Text(
              textShow,
            ),
          ),
        ),
      ),
    );
  }

  /// 权限
  recordPermission(details) async {
    // bool isHuaWei = await _getDeviceInfo();
    if (Platform.isAndroid) {
      TBPermissionManager.startMicrophonePrivacyAlert(
          completionHandler: (var result) {
        if (result == 1) {
          starty = details.globalPosition.dy;
          _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
            _count++;
            print('_count is 👉 $_count');
            if (_count == _countTotal) {
              hideVoiceView();
            }
          });
          showVoiceView();
        }
      });
    } else {
      starty = details.globalPosition.dy;
      _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
        _count++;
        print('_count is 👉 $_count');
        if (_count == _countTotal) {
          hideVoiceView();
        }
      });
      showVoiceView();
    }
  }

  Future<bool> _getDeviceInfo() async {
    bool isHuaWei = false;
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      // 判断是否为华为手机
      if (androidInfo.manufacturer.toLowerCase() == 'huawei') {
        isHuaWei = true;
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    return isHuaWei;
  }

  @override
  void dispose() {
    logic.recordPlugin?.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
