import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/login/privacy/view/sc_agreement_item.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constant/sc_type_define.dart';
import 'package:TigerChat/util/Colors/sc_color_hex.dart';

/// 用户协议和隐私政策弹窗

class SCBasicPrivacyAlert extends StatelessWidget {
  SCBasicPrivacyAlert({
    Key? key,
    this.isAgree = false,
    this.titleString = '',
    this.contentString = '',
    this.descriptionString = '',
    this.cancelAction,
    this.sureAction,
    this.agreementDetailAction,
    this.agreeAction,
  }) : super(key: key);

  /// 是否同意用户协议和隐私政策
  final bool isAgree;

  /// 标题
  final String titleString;

  /// 正文
  final String contentString;

  /// 描述
  final String descriptionString;

  /// 取消
  final Function? cancelAction;

  /// 确定
  final Function? sureAction;

  /// 协议详情
  final Function(String? title, String url)? agreementDetailAction;

  /// 勾选协议
  final Function? agreeAction;

  late List list;

  @override
  Widget build(BuildContext context) {
    initData();
    return body(context);
  }

  /// body
  Widget body(BuildContext context) {
    /// 弹窗宽度
    double width = 311;
    var getScreenWidth = MediaQuery.of(context).size.width;
    if (getScreenWidth != 0) {
      if (getScreenWidth > TBDefVal.screenWidth) {
        width = 311.0;
      } else {
        width = TBUtils().getScreenWidth() - 64.0;
      }
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
                color: TBColors.color_FFFFFF,
                borderRadius: BorderRadius.circular(6.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleItem(),
                const SizedBox(
                  height: 20.5,
                ),
                contentItem(),
                const SizedBox(
                  height: 14.0,
                ),
                descriptionItem(),
                const SizedBox(
                  height: 18.0,
                ),
                privacyItem(),
                const SizedBox(
                  height: 18.0,
                ),
                lineH(),
                bottomItem(),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 设置数据
  initData() {
    list = [
      {
        'type': SCTypeDefine.richTextTypeImage,
        'title': '',
        'imageUrl': isAgree ? TBAsset.iconSelectRadio : TBAsset.iconNormalRadio,
        'url': '',
        'color': SCHexColor.colorToString(TBColors.color_FFFFFF)
      },
      {
        'type': SCTypeDefine.richTextTypeText,
        'title': ' 同意',
        'imageUrl': '',
        'url': '',
        'color': SCHexColor.colorToString(TBColors.color_1B1C33)
      },
      {
        'type': SCTypeDefine.richTextTypeText,
        'title': '《用户协议》',
        'imageUrl': '',
        'url': TBDefVal.userAgreementUrl,
        'color': SCHexColor.colorToString(TBColors.color_FF6C00)
      },
      {
        'type': SCTypeDefine.richTextTypeText,
        'title': '和',
        'imageUrl': '',
        'url': '',
        'color': SCHexColor.colorToString(TBColors.color_1B1C33)
      },
      {
        'type': SCTypeDefine.richTextTypeText,
        'title': '《隐私政策》',
        'imageUrl': '',
        'url': TBDefVal.privacyProtocolUrl,
        'color': SCHexColor.colorToString(TBColors.color_FF6C00)
      },
    ];
  }

  /// title
  Widget titleItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.5),
      child: Center(
        child: Text(
          titleString,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18,
              color: TBColors.color_1B1C33,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// 正文
  Widget contentItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 190.0,
        child: SingleChildScrollView(
          //正文
          child: Text(
            contentString,
            style: const TextStyle(
                fontSize: 14,
                color: TBColors.color_5E5E66,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  /// 描述
  Widget descriptionItem() {
    String title = descriptionString;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14,
            color: TBColors.color_1B1D33,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  /// 用户协议和隐私政策
  Widget privacyItem() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SCAgreementItem(
          list: list,
          isAgree: isAgree,
          agreeAction: () {
            if (agreeAction != null) {
              agreeAction?.call();
            }
          },
          agreementDetailAction: (title, url) {
            if (agreementDetailAction != null && url.isNotEmpty) {
              agreementDetailAction?.call(title, url);
            }
          },
        ));
  }

  /// 水平分割线
  Widget lineH() {
    return const Divider(
      color: TBColors.color_D7D7DB,
      height: 1,
    );
  }

  /// 垂直分割线
  Widget lineV() {
    return Container(
      width: 0.5,
      height: 44.0,
      color: TBColors.color_D7D7DB,
    );
  }

  /// 同意或取消按钮
  Widget sureOrCancelBtn({required String title, required int index}) {
    return SizedBox.expand(
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16,
                color: TBColors.color_1B1C33,
                fontWeight: FontWeight.normal),
          ),
          onPressed: () {
            if (index == 0) {
              // 取消
              cancelBtnAction();
            } else {
              // 同意
              sureBtnAction();
            }
          }),
    );
  }

  /// 底部按钮
  Widget bottomItem() {
    return SizedBox(
      height: 44.0,
      child: Row(
        children: [
          Expanded(flex: 1, child: sureOrCancelBtn(title: '拒绝', index: 0)),
          lineV(),
          Expanded(flex: 1, child: sureOrCancelBtn(title: '同意并使用', index: 1)),
        ],
      ),
    );
  }

  /// 勾选协议
  selectAgreementAction() {
    if (agreeAction != null) {
      agreeAction?.call();
    }
  }

  /// 取消
  cancelBtnAction() {
    if (cancelAction != null) {
      cancelAction?.call();
    }
  }

  /// 同意并使用
  sureBtnAction() {
    if (sureAction != null) {
      sureAction?.call();
    }
  }
}
