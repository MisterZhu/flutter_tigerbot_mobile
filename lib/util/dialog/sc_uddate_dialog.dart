import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router/tb_router_helper.dart';
import '../router/tb_router_path.dart';

///created by WGH
///on 2020/7/23
///description:版本更新提示弹窗
class SCUpdateDialog extends Dialog {
  final String upDateContent;
  final bool isForce;

  SCUpdateDialog({required this.upDateContent, required this.isForce});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 319.w,
            height: 370.w,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/home/bg_launch.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 110.w),
                        child: Text('发现新版本',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                decoration: TextDecoration.none)),
                      ),
                      Text(upDateContent,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              decoration: TextDecoration.none)),
                      Container(
                        width: 250.w,
                        height: 42.w,
                        margin: EdgeInsets.only(bottom: 15.w),
                        child: TextButton(
                            child: Text(
                              '立即更新',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87),
                            ),
                            onPressed: () {
                              var params = {
                                "title": '活动详情',
                                "url": 'https://www.baidu.com'
                              };
                              TBRouterHelper.pathPage(
                                  TBRouterPath.webViewPath, params);
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              TBRouterHelper.back(null);
            },
            child: Offstage(
              offstage: isForce,
              child: Container(
                  margin: EdgeInsets.only(top: 30.w),
                  child: Image.asset(
                    'assets/images/chat/chat_bottom_cancel.png',
                    width: 35.w,
                    height: 35.w,
                  )),
            ),
          )
        ],
      ),
    );
  }

  static showUpdateDialog(
      BuildContext context, String mUpdateContent, bool mIsForce) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: SCUpdateDialog(
                  upDateContent: mUpdateContent, isForce: mIsForce),
              onWillPop: _onWillPop);
        });
  }

  static Future<bool> _onWillPop() async {
    return false;
  }
}
