import 'package:bruno/src/components/appraise/brn_appraise.dart';
import 'package:bruno/src/components/appraise/brn_appraise_header.dart';
import 'package:bruno/src/components/appraise/brn_appraise_config.dart';
import 'package:bruno/src/l10n/brn_intl.dart';
import 'package:flutter/material.dart';
import 'package:bruno/src/components/appraise/brn_appraise_interface.dart';

import 'chat_report_toast.dart';

/// 描述: 评价组件bottom picker，
/// 对BrnAppraise做了一层封装，可直接使用在showDialog里面

class TBReportPicker extends StatefulWidget {
  /// 标题
  final String title;

  /// 标题类型
  final BrnAppraiseHeaderType headerType;

  /// 自定义文案
  /// 若评分组件为表情，则list长度为5，不足5个时请在对应位置补空字符串
  /// 若评分组件为星星，则list长度不能比count小
  final List<String>? iconDescriptions;

  /// 标签
  final List<String>? tags;

  ///输入框允许提示文案
  final String inputHintText;

  /// 提交按钮的点击回调
  final BrnAppraiseConfirmClick? onConfirm;

  /// 评价组件的配置项
  final BrnAppraiseConfig config;

  /// create BrnAppraiseBottomPicker
  TBReportPicker({
    Key? key,
    this.title = '',
    this.headerType = BrnAppraiseHeaderType.spaceBetween,
    this.iconDescriptions,
    this.tags,
    this.inputHintText = '',
    this.onConfirm,
    this.config = const BrnAppraiseConfig(),
  }) : super(key: key);

  @override
  _TBReportPickerState createState() => _TBReportPickerState();
}

class _TBReportPickerState extends State<TBReportPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0x99000000),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: TBReportToast(
          title: widget.title,
          headerType: widget.headerType,
          iconDescriptions: widget.iconDescriptions ??
              BrnIntl.of(context).localizedResource.appriseLevel,
          tags: widget.tags,
          inputHintText: widget.inputHintText,
          onConfirm: (index, list, input) {
            if (widget.onConfirm != null) {
              widget.onConfirm!(index, list, input);
            }
          },
          config: widget.config,
        ),
      ),
    );
  }
}
