import 'dart:ui';

import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  final Widget child;

  const BlurContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Image.asset(
            "assets/images/bg_sky.png",
            fit: BoxFit.fitHeight,
          ),
        ),
        Center(
          child: ClipRect(
            // 可裁切矩形
            child: BackdropFilter(
              // 背景过滤器
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        child
      ],
    );
  }
}
