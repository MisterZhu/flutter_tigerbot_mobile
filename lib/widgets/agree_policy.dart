import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:TigerChat/widgets/webview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/navigator_util.dart';

class AgreePolicy extends StatefulWidget {
  @override
  State<AgreePolicy> createState() => _AgreePolicyState();

  Function(bool) _isChecked;

  AgreePolicy(this._isChecked);
}

class _AgreePolicyState extends State<AgreePolicy> {
  bool _checked = false;

  jumpToUserProtocol() {
    NavigatorUtil.push(
      context,
      Webview(
        initialUrl: "https://tigerbot.com/user-agreement.html",
        title: "用户协议",
      ),
    );
  }

  jumpToPrivacyPolicy() {
    NavigatorUtil.push(
      context,
      Webview(
        initialUrl: "https://tigerbot.com/private-agreement.html",
        title: "隐私协议",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(15.w, 15.w)),
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.transparent)),
            onPressed: () {
              setState(() {
                _checked = !_checked;
                this.widget._isChecked(_checked);
              });
            },
            child: _checked
                ? Image.asset(
                    themed.getSelectImagePath(),
                    width: 20.w,
                  )
                : Image.asset(
                    imagePath("login", "login_uncheck"),
                    width: 20.w,
                  )),
        Expanded(
          child: Text.rich(TextSpan(children: [
            TextSpan(text: 'loginAgree'.tr),
            TextSpan(
              text: 'userAgreement'.tr,
              style: TextStyle(color: themed.theme_c.buttonBgColor),
              recognizer: TapGestureRecognizer()..onTap = jumpToUserProtocol,
            ),
            TextSpan(text: 'loginAnd'.tr),
            TextSpan(
              text: 'privateAgreement'.tr,
              style: TextStyle(color: themed.theme_c.buttonBgColor),
              recognizer: TapGestureRecognizer()..onTap = jumpToPrivacyPolicy,
            ),
          ])),
        ),
      ],
    );
  }
}
