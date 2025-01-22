// theme_controller.dart

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../constant/tb_colors.dart';
import '../../constant/tb_default_value.dart';
import '../../constant/tb_export_common.dart';
import '../../customscaffold/sc_scaffold_controller.dart';
import '../custom_material_color.dart';
import '../tb_utils.dart';
import 'theme_config.dart';

class ThemeController extends GetxController {
  var currentTheme = AppTheme.Light.obs;
  late ThemeConfig theme_c;
  String skinStr = '';
  late bool defDarkTheme = false;

  ThemeData get theme {
    switch (currentTheme.value) {
      case AppTheme.Light:
        return ThemeData.light().copyWith(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: customMaterialColor(Color(0xFF5A81F3)),
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0xFF5A81F3),
              selectionColor: Color(0xFF5A81F3),
              selectionHandleColor: Color(0xFF5A81F3),
            ));
      // return ThemeData.light().copyWith(
      //     primaryColor: Colors.white,
      //     scaffoldBackgroundColor: Colors.white,
      //     colorScheme: ColorScheme.fromSwatch(
      //       primarySwatch: customMaterialColor(Color(0xFFFF98AC)),
      //     ),
      //     highlightColor: Colors.transparent,
      //     splashColor: Colors.transparent,
      //     textSelectionTheme: TextSelectionThemeData(
      //       cursorColor: Color(0xFFFF98AC),
      //       selectionColor: Color(0xFFFF98AC),
      //       selectionHandleColor: Color(0xFFFF98AC),
      //     ));
      case AppTheme.Dark:
        return ThemeData.dark().copyWith(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: customMaterialColor(Colors.black),
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: Colors.grey,
              selectionHandleColor: Colors.grey,
            ));
      default:
        return ThemeData.light().copyWith(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: customMaterialColor(Color(0xFF5A81F3)),
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0xFF5A81F3),
              selectionColor: Color(0xFF5A81F3),
              selectionHandleColor: Color(0xFF5A81F3),
            ));
        return ThemeData.light().copyWith(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: customMaterialColor(Color(0xFFFF98AC)),
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0xFFFF98AC),
              selectionColor: Color(0xFFFF98AC),
              selectionHandleColor: Color(0xFFFF98AC),
            ));
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadTheme();
    _updateCustomColors();
  }

  void _updateCustomColors() {
    theme_c = themeConfigs[currentTheme.value]!;
  }

  String getBgImagePath() {
    if (currentTheme.value == AppTheme.Dark) {
      return Assets.mineMineBg;
    } else {
      return Assets.mineMineBg3;
    }
  }

  String getSelectImagePath() {
    return Assets.loginLoginChecked1;

    if (currentTheme.value == AppTheme.Light) {
      return Assets.loginLoginChecked;
    } else {
      return Assets.loginLoginChecked1;
    }
  }

  String getSendImagePath() {
    return "assets/images/chat/chat_input_send1.png";

    if (currentTheme.value == AppTheme.Light) {
      return "assets/images/chat/chat_input_send.png";
    } else {
      return "assets/images/chat/chat_input_send1.png";
    }
  }

  String getMessageIconPath() {
    return Assets.chatChatMessageBlue;

    if (currentTheme.value == AppTheme.Light) {
      return Assets.chatChatMessage;
    } else {
      return Assets.chatChatMessageBlue;
    }
  }

  String getFileIconPath() {
    return Assets.chatChatSearchFileBlue2;

    if (currentTheme.value == AppTheme.Light) {
      return Assets.chatChatSearchFilePink2;
    } else {
      return Assets.chatChatSearchFileBlue2;
    }
  }

  String getMoreImagePath() {
    if (currentTheme.value == AppTheme.Light) {
      return Assets.chatChatMoreQuote3;
    } else {
      return Assets.chatChatMoreQuote2;
    }
  }

  void saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final state = Get.find<SCCustomScaffoldController>();

    switch (theme) {
      case '浅色':
        skinStr = '浅色';
        currentTheme.value = AppTheme.Light;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        state.setStatusBarStyle(SystemUiOverlayStyle.dark);

        break;
      case '深色':
        skinStr = '深色';
        currentTheme.value = AppTheme.Dark;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        state.setStatusBarStyle(SystemUiOverlayStyle.light);

        break;
      case '粉色':
        skinStr = '粉色';
        currentTheme.value = AppTheme.Pink;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        state.setStatusBarStyle(SystemUiOverlayStyle.dark);

        break;
      default:
        skinStr = '跟随系统';
        TBUtils.getCurrentContext(completionHandler: (context) async {
          defDarkTheme = isDarkMode(context);
        });
        if (defDarkTheme) {
          currentTheme.value = AppTheme.Dark;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          state.setStatusBarStyle(SystemUiOverlayStyle.light);
        } else {
          currentTheme.value = AppTheme.Light;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
          state.setStatusBarStyle(SystemUiOverlayStyle.dark);
        }
    }
    debugPrint('------------------------------theme = $theme');

    prefs.setString(TBDefVal.kCurrentTheme, theme);
    _updateCustomColors();
    update(); // 触发手动更新
  }

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString(TBDefVal.kCurrentTheme);
    debugPrint('------------------------------get theme = $themeString');

    final state = Get.put(SCCustomScaffoldController());

    if (themeString != null) {
      switch (themeString) {
        case '浅色':
          skinStr = '浅色';
          currentTheme.value = AppTheme.Light;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
          state.setStatusBarStyle(SystemUiOverlayStyle.dark);

          break;
        case '深色':
          skinStr = '深色';
          currentTheme.value = AppTheme.Dark;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          state.setStatusBarStyle(SystemUiOverlayStyle.light);

          break;
        case '粉色':
          skinStr = '粉色';
          currentTheme.value = AppTheme.Pink;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
          state.setStatusBarStyle(SystemUiOverlayStyle.dark);

          break;
        default:
          skinStr = '跟随系统';

          TBUtils.getCurrentContext(completionHandler: (context) async {
            defDarkTheme = isDarkMode(context);
          });
          // defDarkTheme = false;
          if (defDarkTheme) {
            currentTheme.value = AppTheme.Dark;
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
            state.setStatusBarStyle(SystemUiOverlayStyle.light);
          } else {
            currentTheme.value = AppTheme.Light;
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
            state.setStatusBarStyle(SystemUiOverlayStyle.dark);
          }
      }
    } else {
      skinStr = '跟随系统';
      TBUtils.getCurrentContext(completionHandler: (context) async {
        defDarkTheme = isDarkMode(context);
      });

      if (defDarkTheme) {
        currentTheme.value = AppTheme.Dark;
        state.setStatusBarStyle(SystemUiOverlayStyle.light);
      } else {
        currentTheme.value = AppTheme.Light;
        state.setStatusBarStyle(SystemUiOverlayStyle.dark);
      }
    }
    _updateCustomColors();
  }
}

var themed = Get.find<ThemeController>();
