


import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../constant/tb_export_common.dart';
import 'package:flutter/material.dart';

import 'package:markdown/markdown.dart' as md;

class MathBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitText(dynamic text, TextStyle? preferredStyle) {
    print('111111111111');
    // if (text is Text) {
    //   String data = text.data ?? '';
    //
    //   final RegExp mathExpression = RegExp(r'\$\$([^\$]+)\$\$');
    //   final match = mathExpression.firstMatch(data);
    //
    //   if (match != null) {
    //     final mathString = match.group(1);
    //     return Math.tex(
    //       mathString!,
    //       mathStyle: MathStyle.display,
    //       textStyle: TextStyle(fontSize: 20),
    //     );
    //   }
    //
    //   final RegExp inlineMathExpression = RegExp(r'\$([^\$]+)\$');
    //   final inlineMatch = inlineMathExpression.firstMatch(data);
    //
    //   if (inlineMatch != null) {
    //     final mathString = inlineMatch.group(1);
    //     return Math.tex(
    //       mathString!,
    //       textStyle: TextStyle(fontSize: 20),
    //     );
    //   }
    // }
    return Math.tex(
      text,
      textStyle: TextStyle(fontSize: 20),
    );
    return super.visitText(text, TextStyle(fontSize: 14));
  }
}
class MathBlockBuilder1 extends MarkdownElementBuilder {
  @override
  Widget? visitText(dynamic text, TextStyle? preferredStyle) {
    print('2222222222');


    // return Math.tex(
    //   text,
    //   textStyle: TextStyle(fontSize: 20),
    // );
    return Math.tex(text, mathStyle: MathStyle.display);

    return super.visitText(text, TextStyle(fontSize: 14));
  }
}
class MathBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementBefore(md.Element element) {
    print('333333333');

    if (element.tag == 'mathblock') {
      // 处理数学公式块
      return const SizedBox(height: 16); // 添加一些垂直间距
    }
    return null;
  }
}

class MathBuilder1 extends MarkdownElementBuilder {
  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    print('4444444444');

    final RegExp mathExpression = RegExp(r'\$(.*?)\$');
    final match = mathExpression.firstMatch(text.text);

    if (match != null) {
      final mathString = match.group(1);
      return Math.tex(
        mathString ?? '',
        textStyle: TextStyle(fontSize: 20), // 设置字体大小
      );
    }

    return null;
  }
}



