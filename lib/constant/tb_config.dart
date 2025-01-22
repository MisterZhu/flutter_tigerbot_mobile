

import 'package:TigerChat/constant/tb_enum.dart';

class TBConfig {
  /// 环境
  static TBEnvironment env = TBEnvironment.production;

  static bool isSupportProxyForProduction = false;

  /// iOS是否支持平方SC字体
  static bool isSupportPFSCForIOS = true;

  /// base url
  static String get BASE_URL {
    switch (env) {
      case TBEnvironment.develop:
        return "https://pai-test.tigerobo.com/x-pai-biz";
      case TBEnvironment.production:
        return "https://pai.tigerobo.com/x-pai-biz";
      default:
        return "https://pai.tigerobo.com/x-pai-biz";
    }
  }

}
