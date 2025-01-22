import 'package:TigerChat/customscaffold/sc_scaffold_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constant/tb_colors.dart';

class SCCustomScaffold extends StatelessWidget {
  /*body*/
  late Widget body;

  /*是否隐藏返回按钮*/
  late bool showBackIcon;

  /*标题*/
  late String title;

  /*标题是否居中*/
  late bool centerTitle;

  late double? elevation;

  /*是否显示背景图片*/
  late bool showBackgroundImage;

  /*背景图片url*/
  late String backgroundImageUrl;

  /*自定义title-widget*/
  Widget? customTitleWidget;

  /*NavBackgroundColor*/
  Color? navBackgroundColor;
  /*NavBackgroundColor*/
  Color? bodyBackgroundColor;
  /*title-style*/
  TextStyle? textStyle;

  /*leading*/
  Widget? leading;

  /*leading宽度 默认56*/
  double? leadingWidth;

  /*导航栏右侧*/
  List<Widget>? actions;

  /*页面是否随着键盘上移*/
  bool? resizeToAvoidBottomInset;

  SCCustomScaffold(
      {Key? key,
      required this.body,
      this.showBackIcon = true,
      this.title = '',
      this.centerTitle = true,
      this.showBackgroundImage = false,
      this.backgroundImageUrl = '',
      this.navBackgroundColor,
      this.bodyBackgroundColor,
      this.textStyle,
      this.leading,
      this.elevation = 0,
      this.leadingWidth,
      this.actions,
      this.customTitleWidget,
      this.resizeToAvoidBottomInset})
      : super(key: key);

  // final state = Get.find<SCCustomScaffoldController>();
  final state = Get.put(SCCustomScaffoldController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    if (state.statusBarStyle == SystemUiOverlayStyle.dark) {
      debugPrint('------------------------------dark');
    } else {
      debugPrint('------------------------------light');
    }
    // TODO: implement build
    return GetBuilder<SCCustomScaffoldController>(builder: (state) {
      return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: AppBar(
          title: getTitleWidget(),
          centerTitle: centerTitle,
          iconTheme: IconThemeData(
            color: state.backIconColor,
          ),
          backgroundColor: getNavBackgroundColor(),
          systemOverlayStyle: state.statusBarStyle,
          automaticallyImplyLeading: showBackIcon,
          flexibleSpace: getNavBackgroundImage(),
          elevation: elevation,
          leading: leading,
          leadingWidth: leadingWidth,
          actions: actions,
        ),
        body: body,
        backgroundColor: bodyBackgroundColor ?? TBColors.color_FFFFFF,
      );
    });
  }

  /*Nav背景图片*/
  Widget getNavBackgroundImage() {
    return showBackgroundImage
        ? (backgroundImageUrl.contains('http')
            ? CachedNetworkImage(
                imageUrl: backgroundImageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              )
            : Image.asset(
                backgroundImageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ))
        : const SizedBox();
  }

  /*Nav背景颜色*/
  Color getNavBackgroundColor() {
    if (showBackgroundImage) {
      return Colors.transparent;
    } else {
      return navBackgroundColor ?? state.primaryColor;
    }
  }

  /*title-widget*/
  Widget getTitleWidget() {
    return customTitleWidget ??
        Text(
          title,
          style: textStyle ?? TextStyle(color: state.titleColor),
        );
  }
}
