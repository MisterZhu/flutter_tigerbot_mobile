
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/tb_colors.dart';
import '../tb_utils.dart';


enum DiaLogLocation {
  middle,
  bottom
}

enum ButtonArrangeType {
  row,
  column
}

enum DiaLogTriangleType {
  none,
  left,
  middle,
  right
}
const colorH = TBColors.color_EEEEEE;
const colorWithCloseButton = TBColors.color_1B1C33;
const colorWithHex00 = TBColors.color_000000;
const colorWithHex1B1C33 = TBColors.color_1B1C33;
const colorWithHexFF6C00 = TBColors.color_FF6C00;
const colorWithHex9 = TBColors.color_999999;
const colorWithQ = TBColors.color_2989F2;
const colorWithDialogLine = Color.fromRGBO(255, 255, 255, 0.2);
const colorWithDialogBg = Color.fromRGBO(0, 0, 0, 0.4);
const btnFontSize = 16;
const btnHeight = 44.0;
const btnFontWeight = FontWeight.w400;

/// 中间和底部弹窗Widget
class SCBaseDialog extends StatefulWidget {

  /// 背景颜色 默认白色
  final Color? bgColor;
  /// 是否有关闭按钮 默认没有
  final bool? isShowCloseButton;
  /// 点击按钮是否需要关闭弹窗 默认为true
  final bool? isNeedCloseDiaLog;
  /// 弹窗位置(中间、底部)
  final DiaLogLocation? location;
  /// 是否是系统底部弹窗
  final bool? isSystemBottomDialog;

  /// 自定义标题组件 优先级：customTitleWidget > title
  final Widget? customTitleWidget;
  /// 标题
  final String? title;
  /// 标题颜色 默认 0x121D34
  final Color? titleColor;
  /// 标题字号 默认18
  final double? titleFontSize;
  /// 标题字重 默认 500
  final FontWeight? titleFontWeight;
  /// 标题区域布局 默认居中
  final TextAlign? titleAlign;

  /// 自定义的content组件 优先级：customContentWidget > content
  final Widget? customContentWidget;
  /// 内容
  final String? content;
  /// 内容文字颜色 默认 0x1B1C33
  final Color? contentColor;
  /// 有标题内容字号 默认14
  final double? contentFontSize;
  /// 无标题内容字号 默认18
  final double? notTitleContentFontSize;
  /// 内容字重 默认400
  final FontWeight? contentFontWeight;
  /// 内容区域布局 默认居中
  final TextAlign? contentAlign;

  /// 自定义按钮list 优先级：widgetButtons > buttons
  final List<Widget>? customWidgetButtons;
  /// 按钮list
  final List<String>? buttons;
  /// 取消按钮字体颜色 默认 0x999999
  final Color? cancelButtonColor;
  /// 其他按钮字体颜色 默认蓝色0x2989F2
  final Color? otherButtonColor;
  /// 取消按钮字体大小 默认17
  final double? cancelButtonFontSize;
  /// 其他按钮字体大小 默认17
  final double? otherButtonFontSize;
  /// 取消按钮字重 默认400
  final FontWeight? cancelButtonFontWeight;
  /// 按钮字重  默认500
  final FontWeight? otherButtonFontWeight;
  /// 按钮排列方式 默认横向排列
  final ButtonArrangeType? arrangeType;
  /// 点击返回index 0 1
  final Function(int index, BuildContext context)? onTap;

  const SCBaseDialog({
    Key? key,
    this.bgColor = Colors.white,
    this.isShowCloseButton = false,
    this.isNeedCloseDiaLog = true,
    this.customTitleWidget,
    this.location = DiaLogLocation.middle,
    this.isSystemBottomDialog = false,
    this.title = '',
    this.titleColor = colorWithHex00,
    this.titleFontSize = 18.0,
    this.titleFontWeight = FontWeight.w400,
    this.titleAlign = TextAlign.center,
    this.customContentWidget,
    this.content = '',
    this.contentColor = colorWithHex1B1C33,
    this.contentFontSize = 14.0,
    this.notTitleContentFontSize = 18.0,
    this.contentAlign = TextAlign.center,
    this.contentFontWeight = FontWeight.w400,
    this.customWidgetButtons,
    this.buttons,
    this.cancelButtonColor = colorWithHex1B1C33,
    this.otherButtonColor = colorWithHexFF6C00,
    this.cancelButtonFontSize = 16.0,
    this.otherButtonFontSize = 16.0,
    this.cancelButtonFontWeight = FontWeight.w400,
    this.otherButtonFontWeight = FontWeight.w400,
    this.arrangeType = ButtonArrangeType.row,
    this.onTap,
  }) : super(key: key);

  @override
  SCBaseDialogState createState() => SCBaseDialogState();
}

class SCBaseDialogState extends State<SCBaseDialog> {
  @override
  Widget build(BuildContext context) {
    return (widget.location == DiaLogLocation.bottom) ? _createBaseBottomDialog() : _createBaseMiddleDiaLog();
  }

  /// Bottom弹窗
  Widget _createBaseBottomDialog() {
    String title = widget.title ?? '';
    String content = widget.content ?? '';
    bool isSystemBottomDialog = widget.isSystemBottomDialog ?? false;
    ButtonArrangeType arrangeType = widget.arrangeType ?? ButtonArrangeType.row;

    bool emptyTitle =
    ((title.isEmpty || title == '' ) && widget.customTitleWidget == null); // 是否有标题
    bool emptyContent =
    ((content.isEmpty || content == '') && widget.customContentWidget == null); // 是否有内容
    return Material(
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            margin: isSystemBottomDialog ? const EdgeInsets.only(left: 10,bottom: 30,right: 10) : const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: widget.bgColor,
                      borderRadius: BorderRadius.circular(4.0)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          child: emptyTitle
                              ? Container()
                              : (widget.customTitleWidget != null)
                              ? widget.customTitleWidget
                              : Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              title,
                              style: TextStyle(color: widget.titleColor, fontSize: widget.titleFontSize, fontWeight: widget.titleFontWeight),
                            ),
                          )
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorH,
                                width: 1,
                              ),
                            )
                        ),
                        child: emptyContent
                            ? Container()
                            : (widget.customContentWidget != null)
                            ? widget.customContentWidget
                            : Container(
                          margin: const EdgeInsets.all(15.0),
                          child:  Text(
                            content,
                            style: TextStyle(color: widget.contentColor, fontSize: widget.contentFontSize,fontWeight: widget.contentFontWeight),
                          ),
                        ),
                      ),
                      (widget.customWidgetButtons != null)
                          ? _createCustomButtons(arrangeType)
                          : _createDefaultButtons(arrangeType,57.0)
                    ],
                  ),
                ),
                isSystemBottomDialog ? const SizedBox(height: 8) : const SizedBox(),
                isSystemBottomDialog
                    ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0)
                  ),
                  child: defaultCustomButton(context,
                      text: '取消',
                      textFontSize: btnFontSize,
                      buttonHeight: 57.0
                  ),
                )
                    : Container()
              ],
            ),
          ),
        )
    );
  }

  /// 中间弹窗相关方法
  Widget _createBaseMiddleDiaLog() {
    String title = widget.title ?? '';
    String content = widget.content ?? '';
    ButtonArrangeType arrangeType = widget.arrangeType ?? ButtonArrangeType.row;

    bool emptyTitle = ((title.isEmpty || title == '') && widget.customTitleWidget == null); // 是否有标题
    bool emptyContent = ((content.isEmpty || content == '') && widget.customContentWidget == null); // 是否有内容

    /// 弹窗容器宽度
    double width = TBUtils().getScreenWidth() > 302.0 ? 270.0 : (TBUtils().getScreenWidth() - 32.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            color: widget.bgColor,
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: emptyTitle
                              ? Container()
                              : widget.customTitleWidget ?? SizedBox(
                            width: double.infinity,
                            child: Text(
                              title,
                              textAlign: widget.titleAlign,
                              style: TextStyle(
                                  color: widget.titleColor,
                                  fontSize: widget.titleFontSize,
                                  fontWeight: widget.titleFontWeight),
                            ),
                          )
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: (widget.isShowCloseButton == false)
                              ? Container()
                              : InkWell(
                            child: const Icon(
                                Icons.close,
                                color: colorWithCloseButton),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: emptyTitle ? 20 : 10),
                emptyContent
                    ? Container()
                    : _getContentWidget(emptyTitle, emptyContent),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorH,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                // 创建按钮
                (widget.customWidgetButtons != null)
                    ? _createCustomButtons(arrangeType)
                    :_createDefaultButtons(arrangeType, btnHeight)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 创建默认buttons组
  Widget _createDefaultButtons(ButtonArrangeType type, double buttonHeight) {
    List<String> buttons = widget.buttons ?? [];

    return (buttons.isEmpty)
        ? Container()
        : (type == ButtonArrangeType.column)
        ? _createDefaultColumnButtons(buttonHeight)
        : _createDefaultRowButtons(buttonHeight);
  }

  /// 创建默认列的buttons
  _createDefaultColumnButtons(double buttonHeight) {
    List<String> buttons = widget.buttons ?? [];
    return Column(
      children: buttons.map((res) {
        int index = buttons.indexOf(res);
        return GestureDetector(
          child: Container(
              width: double.infinity,
              decoration: (index == buttons.length - 1)
                  ? const BoxDecoration()
                  : const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorH,
                    width: 1,
                  ),
                ),
              ),
              child: defaultCustomButton(context,
                  textColor: widget.otherButtonColor,
                  textFontSize: widget.otherButtonFontSize,
                  fontWeight: widget.otherButtonFontWeight,
                  needCloseDialog: widget.isNeedCloseDiaLog,
                  text: res,
                  buttonHeight: buttonHeight,
                  onTap: (){
                    if(widget.onTap != null) {
                      widget.onTap?.call(index, context);
                    }
                  })

          ),
        );
      }).toList(),
    );
  }

  /// 创建默认行的buttons
  _createDefaultRowButtons(double buttonHeight) {
    List<String> buttons = widget.buttons ?? [];

    return Row(
      children: buttons.map((res) {
        int index = buttons.indexOf(res);
        return Expanded(
          flex: 1,
          child: Container(
              decoration: (index == buttons.length - 1)
                  ? const BoxDecoration()
                  : const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: colorH,
                    width: 1.0,
                  ),
                ),
              ),
              child: defaultCustomButton(
                  context,
                  needCloseDialog: widget.isNeedCloseDiaLog,
                  text: res,
                  textColor: (index == 0) ? widget.cancelButtonColor : widget.otherButtonColor,
                  textFontSize: (index == 0) ? widget.cancelButtonFontSize : widget.otherButtonFontSize,
                  fontWeight: (index == 0) ? widget.cancelButtonFontWeight : widget.otherButtonFontWeight,
                  buttonHeight: buttonHeight,
                  onTap: (){
                    if(widget.onTap != null) {
                      widget.onTap?.call(index, context);
                    }
                  })
          ),
        );
      }).toList(),
    );
  }

  /// 创建自定义buttons
  Widget _createCustomButtons(ButtonArrangeType type) {
    List<Widget> customWidgetButtons = widget.customWidgetButtons ?? [];
    return (customWidgetButtons.isEmpty)
        ? Container()
        : (type == ButtonArrangeType.column)
        ? _createCustomColumnButtons()
        : _createCustomRowButtons();
  }

  /// 创建自定义列的buttons
  _createCustomColumnButtons() {
    List<Widget> customWidgetButtons = widget.customWidgetButtons ?? [];

    return Column(
      children: customWidgetButtons.map((buttonWidget) {
        int index = customWidgetButtons.indexOf(buttonWidget);
        return Container(
            width: double.infinity,
            decoration: (index == customWidgetButtons.length - 1)
                ? const BoxDecoration()
                : const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorH,
                  width: 1.0,
                ),
              ),
            ),
            child: buttonWidget
        );
      }).toList(),
    );
  }

  /// 创建自定义行的buttons
  _createCustomRowButtons() {
    List<Widget> customWidgetButtons = widget.customWidgetButtons ?? [];

    return Row(
      children: customWidgetButtons.map((buttonWidget) {
        int index = customWidgetButtons.indexOf(buttonWidget);
        return Expanded(
            flex: 1,
            child: Container(
                decoration: (index == customWidgetButtons.length - 1)
                    ? const BoxDecoration()
                    : const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: colorH,
                      width: 1.0,
                    ),
                  ),
                ),
                child: buttonWidget
            )
        );
      }).toList(),
    );
  }

  /// 获取弹窗content Widget
  _getContentWidget(emptyTitle, emptyContent) {
    String content = widget.content ?? '';

    return Container(
        width: double.infinity, // 跟外部容器等宽
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: (widget.customContentWidget != null)
            ? widget.customContentWidget
            : Text(
          content,
          textAlign: widget.contentAlign,
          style: TextStyle(
              color: widget.contentColor,
              fontSize: emptyTitle
                  ? widget.notTitleContentFontSize
                  : widget.contentFontSize,
              fontWeight: widget.contentFontWeight),
        )
    );
  }
}

/// 默认自定义按钮（中间、底部弹窗自定义按钮）
Widget defaultCustomButton(context,{
  text = '确认',
  textColor = colorWithQ,
  textFontSize = 16.0,
  fontWeight = btnFontWeight,
  needCloseDialog = true,
  buttonHeight = btnHeight,
  onTap
}) => CupertinoButton(padding: EdgeInsets.zero,child: Text(text,style: TextStyle(fontSize: textFontSize, color: textColor, fontWeight: fontWeight)),   onPressed: (){
  if(needCloseDialog) {
    Navigator.pop(context);
  }
  if(onTap != null) {
    onTap();
  }
},);

/// 默认自定义按钮(顶部弹窗)
Widget defaultContentButton(context,text,{
  textColor = colorWithQ,
  textFontSize = btnFontSize,
  fontWeight = FontWeight.w400,
  buttonHeight = btnHeight,
  onTap
}) => CupertinoButton(
  padding: EdgeInsets.zero,
  onPressed: (){
    if(onTap != null) {
      Navigator.pop(context);
      onTap();
    }
  },
  child:Text(text,style: TextStyle(fontSize: textFontSize, color: textColor, fontWeight: fontWeight)),
);