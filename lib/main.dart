import 'package:TigerChat/sc_app.dart';
import 'constant/tb_config.dart';
import 'constant/tb_enum.dart';
import 'constant/tb_export_common.dart';

void main() async {
  TBConfig.env = TBEnvironment.production;
  startApp();
//   await ScreenUtil.ensureScreenSize();
// // 异步初始化
//   final prefs = await SharedPreferences.getInstance();
//   WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter初始化完毕
//
//
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//
//   // Android设备设置沉浸式
//   if(Platform.isAndroid) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarBrightness: Brightness.light,
//     ));
//   }
//   TBWeChatUtils.instance.initBase();
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) {
//           print("ChangeNotifierProvider:");
//           UserInfoProvider userInfo = UserInfoProvider();
//
//           String? infoString = prefs.getString("userInfo");
//           print("infoString: $infoString");
//
//           if (infoString != null) {
//             Map info = json.decode(infoString);
//             print("info: $info");
//             userInfo.login(info);
//           }
//
//           return userInfo;
//         }),
//         ChangeNotifierProvider(create: (ctx) => ChatProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
}
