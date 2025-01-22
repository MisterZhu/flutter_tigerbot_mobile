import 'package:flutter/gestures.dart';
import 'package:TigerChat/util/Colors/sc_color_hex.dart';

import '../../../../constant/sc_type_define.dart';
import '../../../../constant/tb_export_common.dart';
import '../model/sc_privacy_richtext_model.dart';

/// 通用-协议富文本item

class SCAgreementItem extends StatelessWidget {
  SCAgreementItem({
    Key? key,
    required this.list,
    this.isAgree = false,
    this.agreeAction,
    this.agreementDetailAction,
  }) : super(key: key);

  final List list;

  /// 协议富文本
  late List<InlineSpan> richTextList;

  /// 是否同意用户协议和隐私政策
  final bool isAgree;

  /// 协议详情
  final Function(String title, String url)? agreementDetailAction;

  /// 勾选协议
  final Function? agreeAction;

  @override
  Widget build(BuildContext context) {
    initData();
    return body();
  }

  /// 设置数据
  initData() {
    richTextList = list.map((e) {
      SCPrivacyRichTextModel model = SCPrivacyRichTextModel.fromJson(e);
      if (model.type == SCTypeDefine.richTextTypeImage) {
        return selectItem();
      } else if (model.type == SCTypeDefine.richTextTypeSpace) {
        return WidgetSpan(
            child: Container(
          color: SCHexColor(model.color ?? ''),
          width: 5,
          height: 5,
        ));
      } else {
        return agreementItem(
            title: model.title ?? '',
            url: model.url ?? '',
            color: SCHexColor(model.color ?? ''));
      }
    }).toList();
  }

  /// body
  Widget body() {
    return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(text: "", children: richTextList));
  }

  /// 勾选框
  WidgetSpan selectItem() {
    return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          child: Image.asset(
            isAgree ? TBAsset.iconSelectRadio : TBAsset.iconNormalRadio,
            width: 22,
            height: 22,
          ),
          onTap: () {
            if (agreeAction != null) {
              agreeAction?.call();
            }
          },
        ));
  }

  /// 协议文本
  TextSpan agreementItem(
      {String title = '',
      String url = '',
      Color color = TBColors.color_1B1C33}) {
    return TextSpan(
        text: title,
        style: TextStyle(fontSize: 12, color: color),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (agreementDetailAction != null && url.isNotEmpty) {
              agreementDetailAction?.call(title, url);
            }
          });
  }
}
