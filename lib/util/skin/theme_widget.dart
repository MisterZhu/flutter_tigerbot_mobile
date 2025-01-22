import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class ThemeWidget extends StatelessWidget {
  final Widget Function(BuildContext context, ThemeController themeController)
      builder;

  ThemeWidget({required this.builder});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return builder(context, controller);
      },
    );
  }
}

class ThemeContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;

  ThemeContainer({
    this.child,
    this.padding,
    this.margin,
    this.constraints,
    this.width,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return Container(
          padding: padding,
          margin: margin,
          constraints: constraints,
          width: width,
          height: height,
          decoration:
              decoration ?? BoxDecoration(color: controller.theme_c.bgColor),
          child: child,
        );
      },
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String activeText;
  final String inactiveText;

  CustomSwitch({
    required this.value,
    required this.onChanged,
    required this.activeText,
    required this.inactiveText,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: 60,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.value ? Colors.green : Colors.grey,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
              top: 5.0,
              left: widget.value ? 30.0 : 0.0,
              right: widget.value ? 0.0 : 30.0,
              child: Container(
                width: 28.0,
                height: 28.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    widget.value ? widget.activeText : widget.inactiveText,
                    style: TextStyle(
                      color: widget.value ? Colors.green : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
