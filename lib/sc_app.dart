import 'dart:convert';

import 'package:TigerChat/pages/home/logic/tb_launch_logic.dart';
import 'package:TigerChat/util/custom_material_color.dart';
import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:TigerChat/util/wechat/tb_wechat_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constant/tb_all_binding.dart';
import 'constant/tb_export_common.dart';
import 'dart:io';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void startApp() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter初始化完毕

  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // 异步初始化
  await SharedPreferences.getInstance();

  /// 路由的basePath
  String basePath = await TBUtils().getLoginState();
  // 初始化
  ScreenUtil.ensureScreenSize();
  final TBLaunchLogic logicLaunch = Get.put(TBLaunchLogic());
  final ThemeController themeController = Get.put(ThemeController());

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  // Android设备设置沉浸式
  // if (Platform.isAndroid) {
  //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarBrightness: Brightness.light,
  //   ));
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          print("ChangeNotifierProvider:");
          UserInfoProvider userInfo = UserInfoProvider();

          SharedPreferences.getInstance()
              .then((SharedPreferences sharedPreferences) {
            String? infoString = sharedPreferences.getString("userInfo");
            print("infoString: $infoString");

            if (infoString != null) {
              Map info = json.decode(infoString);
              print("info: $info");
              userInfo.login(info);
            }
          });
          return userInfo;
        }),
        ChangeNotifierProvider(create: (ctx) => ChatProvider()),
      ],
      child: ScreenUtilInit(
          designSize: Size(TBDefVal.screenWidth, TBDefVal.screenHeight),
          builder: (ctx, child) => GetBuilder<ThemeController>(
                builder: (controller) {
                  return GetMaterialApp(
                    theme: controller.theme, // 使用 ThemeController 的主题
                    title: 'TigerBot',
                    navigatorKey: navigatorKey,
                    debugShowCheckedModeBanner: false,
                    getPages: TBRouterPages.getPages,
                    initialRoute: basePath,
                    initialBinding: TBAllBinding(),
                    builder: EasyLoading.init(
                      builder: (context, widget) {
                        return MediaQuery(
                          // 设置文字大小不随系统设置改变
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: widget ?? const SizedBox(),
                        );
                      },
                    ),
                    navigatorObservers: [routeObserver],
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: [
                      const Locale('zh', 'CN'),
                      const Locale('en', 'US'),
                    ],
                    translations: TBTranslations(),
                    locale: TBUtils.isChineseLan()
                        ? Locale('zh', 'CN')
                        : Locale('en', 'US'),
                    // //设置默认语言
                    fallbackLocale: Locale("zh", "CN"), //在配置错误的情况下,使用的语言
                  );
                },
              )),
    ),
  );
}
