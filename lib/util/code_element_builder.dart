import 'package:TigerChat/util/dialog/sc_base_dialog.dart';
import 'package:TigerChat/util/skin/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/a11y-dark.dart';
import 'package:flutter_highlighter/themes/a11y-light.dart';
import 'package:flutter_highlighter/themes/agate.dart';
import 'package:flutter_highlighter/themes/an-old-hope.dart';
import 'package:flutter_highlighter/themes/androidstudio.dart';
import 'package:flutter_highlighter/themes/arduino-light.dart';
import 'package:flutter_highlighter/themes/arta.dart';
import 'package:flutter_highlighter/themes/ascetic.dart';
import 'package:flutter_highlighter/themes/atelier-cave-dark.dart';
import 'package:flutter_highlighter/themes/atelier-cave-light.dart';
import 'package:flutter_highlighter/themes/atelier-dune-dark.dart';
import 'package:flutter_highlighter/themes/atelier-dune-light.dart';
import 'package:flutter_highlighter/themes/atelier-estuary-dark.dart';
import 'package:flutter_highlighter/themes/atelier-estuary-light.dart';
import 'package:flutter_highlighter/themes/atelier-forest-dark.dart';
import 'package:flutter_highlighter/themes/atelier-forest-light.dart';
import 'package:flutter_highlighter/themes/atelier-heath-dark.dart';
import 'package:flutter_highlighter/themes/atelier-heath-light.dart';
import 'package:flutter_highlighter/themes/atelier-lakeside-dark.dart';
import 'package:flutter_highlighter/themes/atelier-lakeside-light.dart';
import 'package:flutter_highlighter/themes/atelier-plateau-dark.dart';
import 'package:flutter_highlighter/themes/atelier-plateau-light.dart';
import 'package:flutter_highlighter/themes/atelier-savanna-dark.dart';
import 'package:flutter_highlighter/themes/atelier-savanna-light.dart';
import 'package:flutter_highlighter/themes/atelier-seaside-dark.dart';
import 'package:flutter_highlighter/themes/atelier-seaside-light.dart';
import 'package:flutter_highlighter/themes/atelier-sulphurpool-dark.dart';
import 'package:flutter_highlighter/themes/atelier-sulphurpool-light.dart';
import 'package:flutter_highlighter/themes/atom-one-dark-reasonable.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_highlighter/themes/brown-paper.dart';
import 'package:flutter_highlighter/themes/codepen-embed.dart';
import 'package:flutter_highlighter/themes/color-brewer.dart';
import 'package:flutter_highlighter/themes/darcula.dart';
import 'package:flutter_highlighter/themes/dark.dart';
import 'package:flutter_highlighter/themes/default.dart';
import 'package:flutter_highlighter/themes/docco.dart';
import 'package:flutter_highlighter/themes/dracula.dart';
import 'package:flutter_highlighter/themes/far.dart';
import 'package:flutter_highlighter/themes/foundation.dart';
import 'package:flutter_highlighter/themes/github-gist.dart';
import 'package:flutter_highlighter/themes/github.dart';
import 'package:flutter_highlighter/themes/gml.dart';
import 'package:flutter_highlighter/themes/googlecode.dart';
import 'package:flutter_highlighter/themes/grayscale.dart';
import 'package:flutter_highlighter/themes/gruvbox-dark.dart';
import 'package:flutter_highlighter/themes/gruvbox-light.dart';
import 'package:flutter_highlighter/themes/hopscotch.dart';
import 'package:flutter_highlighter/themes/hybrid.dart';
import 'package:flutter_highlighter/themes/idea.dart';
import 'package:flutter_highlighter/themes/ir-black.dart';
import 'package:flutter_highlighter/themes/isbl-editor-dark.dart';
import 'package:flutter_highlighter/themes/isbl-editor-light.dart';
import 'package:flutter_highlighter/themes/kimbie.dark.dart';
import 'package:flutter_highlighter/themes/kimbie.light.dart';
import 'package:flutter_highlighter/themes/lightfair.dart';
import 'package:flutter_highlighter/themes/magula.dart';
import 'package:flutter_highlighter/themes/mono-blue.dart';
import 'package:flutter_highlighter/themes/monokai-sublime.dart';
import 'package:flutter_highlighter/themes/monokai.dart';
import 'package:flutter_highlighter/themes/night-owl.dart';
import 'package:flutter_highlighter/themes/nord.dart';
import 'package:flutter_highlighter/themes/obsidian.dart';
import 'package:flutter_highlighter/themes/ocean.dart';
import 'package:flutter_highlighter/themes/paraiso-dark.dart';
import 'package:flutter_highlighter/themes/paraiso-light.dart';
import 'package:flutter_highlighter/themes/pojoaque.dart';
import 'package:flutter_highlighter/themes/purebasic.dart';
import 'package:flutter_highlighter/themes/qtcreator_dark.dart';
import 'package:flutter_highlighter/themes/qtcreator_light.dart';
import 'package:flutter_highlighter/themes/railscasts.dart';
import 'package:flutter_highlighter/themes/routeros.dart';
import 'package:flutter_highlighter/themes/school-book.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:flutter_highlighter/themes/solarized-dark.dart';
import 'package:flutter_highlighter/themes/solarized-light.dart';
import 'package:flutter_highlighter/themes/sunburst.dart';
import 'package:flutter_highlighter/themes/tomorrow-night-blue.dart';
import 'package:flutter_highlighter/themes/tomorrow-night-bright.dart';
import 'package:flutter_highlighter/themes/tomorrow-night-eighties.dart';
import 'package:flutter_highlighter/themes/tomorrow-night.dart';
import 'package:flutter_highlighter/themes/tomorrow.dart';
import 'package:flutter_highlighter/themes/vs.dart';
import 'package:flutter_highlighter/themes/vs2015.dart';
import 'package:flutter_highlighter/themes/xcode.dart';
import 'package:flutter_highlighter/themes/xt256.dart';
import 'package:flutter_highlighter/themes/zenburn.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markdown/markdown.dart' as md;

import '../constant/tb_export_common.dart';
import '../pages/chat/model/chat_response_model.dart';

class CodeHightLightView extends StatefulWidget {
  final String content;
  final String lang;
  final double fontSize;

  const CodeHightLightView({
    super.key,
    required this.content,
    required this.lang,
    required this.fontSize,
  });

  @override
  State<CodeHightLightView> createState() => _CodeHightLightViewState();
}

class _CodeHightLightViewState extends State<CodeHightLightView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isLangEmpty = widget.lang.isEmpty;
    Map<String, TextStyle> githubTheme1;

    final ThemeController themeController = Get.find<ThemeController>();
    if (themeController.currentTheme.value == AppTheme.Dark) {
      githubTheme1 = {
        'root': TextStyle(
            backgroundColor: Color(0xff26272c), color: Color(0xffDCDCDC)),
        'keyword': TextStyle(color: Color(0xff569CD6)),
        'literal': TextStyle(color: Color(0xff569CD6)),
        'symbol': TextStyle(color: Color(0xff569CD6)),
        'name': TextStyle(color: Color(0xff569CD6)),
        'link': TextStyle(color: Color(0xff569CD6)),
        'built_in': TextStyle(color: Color(0xff4EC9B0)),
        'type': TextStyle(color: Color(0xff4EC9B0)),
        'number': TextStyle(color: Color(0xffB8D7A3)),
        'class': TextStyle(color: Color(0xffB8D7A3)),
        'string': TextStyle(color: Color(0xffD69D85)),
        'meta-string': TextStyle(color: Color(0xffD69D85)),
        'regexp': TextStyle(color: Color(0xff9A5334)),
        'template-tag': TextStyle(color: Color(0xff9A5334)),
        'subst': TextStyle(color: Color(0xffDCDCDC)),
        'function': TextStyle(color: Color(0xffDCDCDC)),
        'title': TextStyle(color: Color(0xffDCDCDC)),
        'params': TextStyle(color: Color(0xffDCDCDC)),
        'formula': TextStyle(color: Color(0xffDCDCDC)),
        'comment':
            TextStyle(color: Color(0xff57A64A), fontStyle: FontStyle.italic),
        'quote':
            TextStyle(color: Color(0xff57A64A), fontStyle: FontStyle.italic),
        'doctag': TextStyle(color: Color(0xff608B4E)),
        'meta': TextStyle(color: Color(0xff9B9B9B)),
        'meta-keyword': TextStyle(color: Color(0xff9B9B9B)),
        'tag': TextStyle(color: Color(0xff9B9B9B)),
        'variable': TextStyle(color: Color(0xffBD63C5)),
        'template-variable': TextStyle(color: Color(0xffBD63C5)),
        'attr': TextStyle(color: Color(0xff9CDCFE)),
        'attribute': TextStyle(color: Color(0xff9CDCFE)),
        'builtin-name': TextStyle(color: Color(0xff9CDCFE)),
        'section': TextStyle(color: Color(0xffffd700)),
        'emphasis': TextStyle(fontStyle: FontStyle.italic),
        'strong': TextStyle(fontWeight: FontWeight.bold),
        'bullet': TextStyle(color: Color(0xffD7BA7D)),
        'selector-tag': TextStyle(color: Color(0xffD7BA7D)),
        'selector-id': TextStyle(color: Color(0xffD7BA7D)),
        'selector-class': TextStyle(color: Color(0xffD7BA7D)),
        'selector-attr': TextStyle(color: Color(0xffD7BA7D)),
        'selector-pseudo': TextStyle(color: Color(0xffD7BA7D)),
        'addition': TextStyle(backgroundColor: Color(0xff144212)),
        'deletion': TextStyle(backgroundColor: Color(0xff660000)),
      };
    } else {
      githubTheme1 = {
        'root': TextStyle(
            color: Color(0xff333333), backgroundColor: Color(0xfffafafa)),
        'comment':
            TextStyle(color: Color(0xff999988), fontStyle: FontStyle.italic),
        'quote':
            TextStyle(color: Color(0xff999988), fontStyle: FontStyle.italic),
        'keyword':
            TextStyle(color: Color(0xff333333), fontWeight: FontWeight.bold),
        'selector-tag':
            TextStyle(color: Color(0xff333333), fontWeight: FontWeight.bold),
        'subst':
            TextStyle(color: Color(0xff333333), fontWeight: FontWeight.normal),
        'number': TextStyle(color: Color(0xff008080)),
        'literal': TextStyle(color: Color(0xff008080)),
        'variable': TextStyle(color: Color(0xff008080)),
        'template-variable': TextStyle(color: Color(0xff008080)),
        'string': TextStyle(color: Color(0xffdd1144)),
        'doctag': TextStyle(color: Color(0xffdd1144)),
        'title':
            TextStyle(color: Color(0xff990000), fontWeight: FontWeight.bold),
        'section':
            TextStyle(color: Color(0xff990000), fontWeight: FontWeight.bold),
        'selector-id':
            TextStyle(color: Color(0xff990000), fontWeight: FontWeight.bold),
        'type':
            TextStyle(color: Color(0xff445588), fontWeight: FontWeight.bold),
        'tag':
            TextStyle(color: Color(0xff000080), fontWeight: FontWeight.normal),
        'name':
            TextStyle(color: Color(0xff000080), fontWeight: FontWeight.normal),
        'attribute':
            TextStyle(color: Color(0xff000080), fontWeight: FontWeight.normal),
        'regexp': TextStyle(color: Color(0xff009926)),
        'link': TextStyle(color: Color(0xff009926)),
        'symbol': TextStyle(color: Color(0xff990073)),
        'bullet': TextStyle(color: Color(0xff990073)),
        'built_in': TextStyle(color: Color(0xff0086b3)),
        'builtin-name': TextStyle(color: Color(0xff0086b3)),
        'meta':
            TextStyle(color: Color(0xff999999), fontWeight: FontWeight.bold),
        'deletion': TextStyle(backgroundColor: Color(0xffffdddd)),
        'addition': TextStyle(backgroundColor: Color(0xffddffdd)),
        'emphasis': TextStyle(fontStyle: FontStyle.italic),
        'strong': TextStyle(fontWeight: FontWeight.bold),
      };
    }
    final ratio = widget.fontSize / 15;

    ///vs2015Theme   androidstudioTheme  xt256Theme  zenburnTheme
    ///githubTheme1  xcodeTheme  vsTheme a11yLightTheme githubTheme
    return Container(
      decoration: BoxDecoration(
        color: themed.theme_c.bgColor, // 设置代码块背景颜色
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Stack(
          children: [
            if (!isLangEmpty)
              Transform.translate(
                offset: Offset(0, 15), // 调整垂直偏移量
                child: Container(
                  color: themed.theme_c.bgColorMild, // 设置滚动背景颜色
                  child: SingleChildScrollView(
                    // controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    primary: true, // 添加此行以使用 PrimaryScrollController
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth:
                              (TBDefVal.chatBoxMaxWidth - 16).w), // 设置最小宽度
                      child: HighlightView(
                        widget.content,
                        language: widget.lang,
                        theme: githubTheme1,
                        padding: EdgeInsets.only(
                            left: 8.0.w,
                            right: 8.0.w,
                            bottom: 0.0.w,
                            top: 25.0.w),
                        textStyle: TextStyle(
                          fontSize: widget.fontSize.sp,
                          color: themed.theme_c.textColorMild,
                          height: TBDefVal.chatFontSpanHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (isLangEmpty)
              HighlightView(
                widget.content,
                language: widget.lang,
                theme: githubTheme1,
                // padding: EdgeInsets.only(
                //     left: 8.0.w, right: 8.0.w, bottom: 5.0.w, top: 0.0.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0.w, // 水平边距
                  vertical: 1.0.w, // 垂直边距
                ),
                textStyle: TextStyle(
                  fontSize: widget.fontSize.sp,
                  color: themed.theme_c.textColorMild,
                  // height: TBDefVal.chatFontSpanHeight,
                ),
              ),
            if (!isLangEmpty)
              Positioned(
                  top: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 8.w, right: 8.w, top: 5.0.w, bottom: 5.0.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.r),
                              topRight: Radius.circular(5.r),
                            ),
                            color: themed.theme_c.bgColorMild),
                        child: Row(
                          children: [
                            Text(
                              widget.lang,
                              style: TextStyle(
                                  fontSize: widget.fontSize.sp,
                                  fontWeight: FontWeight.w500,
                                  color: themed.theme_c.iconColorMild
                                      .withOpacity(0.8)),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                _copyToClipboard(widget.content);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Image.asset(
                                  "assets/images/chat/chat_code_copy.png",
                                  width: (16 * ratio).w,
                                  color: themed.theme_c.iconColorMild
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1, // 分割线高度
                        color: themed.theme_c.lineColorCode, // 分割线颜色
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: 'Copy successfully'.tr,
      gravity: ToastGravity.CENTER,
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  final double fontSize; // 添加fontSize参数

  CodeElementBuilder(this.fontSize);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    print('66666666666666 code ----------$language');

    print('66666666666666code');
    print('element.textContent = ${element.textContent}');

    return CodeHightLightView(
      content: element.textContent,
      lang: language,
      fontSize: fontSize, // 将fontSize参数传递给CodeHightLightView
    );
  }
}

///自定义超链接
class SpanElementBuilder extends MarkdownElementBuilder {
  final List<ChatResponseItemModel> items; // 添加fontSize参数
  SpanElementBuilder(this.items);
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        print('Clicked on: ${element.textContent}');
        if (items.length > 0) {
          for (var item in items) {
            if (element.textContent == (item.index.toString())) {
              // 跳转页面
              var params = {"title": item.site, "url": item.uri};
              if (item.uri != null && item.uri != '') {
                TBRouterHelper.pathPage(TBRouterPath.webViewPath, params);
              }
              break;
            }
          }
        }
        // Handle the click event here
      },
      child: Padding(
        padding:
            EdgeInsets.only(top: 2.5.w, left: 2.0.w, right: 2.0.w), // 向下偏移 2 像素
        child: Container(
          width: 17.w,
          height: 17.w,
          decoration: BoxDecoration(
            color: TBColors.color_515865,
            borderRadius: BorderRadius.circular(50),
          ),
          // padding: EdgeInsets.all(2),
          child: Center(
            child: Text(
              element.textContent,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class SpanSyntax extends md.InlineSyntax {
  SpanSyntax() : super(r'<custom_link>(.*?)<\/custom_link>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    // Add a custom element with the content
    final element = md.Element.text('custom_link', match[1]!);
    parser.addNode(element);
    return true;
  }
}
