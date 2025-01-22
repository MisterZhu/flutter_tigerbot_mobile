// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class RectangleIndicator extends Decoration {
  const RectangleIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.radius = 4.0,
    this.padding = const EdgeInsets.all(0),
    this.rectangleColor = Colors.blue,
    this.paintingStyle = PaintingStyle.fill,
    this.shadowColor,
  })  : assert(borderSide != null),
        assert(insets != null);

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  final double radius;
  final EdgeInsets padding;
  final Color rectangleColor;
  final Color? shadowColor;

  final PaintingStyle paintingStyle;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(this, this.paintingStyle, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left - padding.left,
      -padding.top,
      indicator.width + padding.left + padding.right,
      indicator.height + padding.top + padding.bottom,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _CirclePainter extends BoxPainter {
  _CirclePainter(this.decoration, this.paintingStyle, VoidCallback? onChanged)
      : assert(decoration != null),
        super(onChanged);

  final RectangleIndicator decoration;
  final PaintingStyle paintingStyle;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    // 计算 indicator 的 rect
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    // 定义绘制的样式
    final RRect rrect =
        RRect.fromRectAndRadius(indicator, Radius.circular(decoration.radius));
    final Paint paint = decoration.borderSide.toPaint()
      ..style = this.paintingStyle
      ..strokeWidth = 1
      ..color = decoration.rectangleColor;
    final Path path = Path()..addRRect(rrect.shift(Offset(1, 1)));
    // 绘制阴影
    if (decoration.shadowColor != null) {
      canvas..drawShadow(path, decoration.shadowColor!, 4, false);
    }
    // 绘制圆角矩形
    canvas..drawRRect(rrect, paint);
  }
}
