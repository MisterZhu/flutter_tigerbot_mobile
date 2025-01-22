/// 路由-path

class TBRouterPath {
  /// 根目录默认登录页面
  static String root = "/lib/pages/home/home_launch_page"; // 根目录

  static String welcomePath = "/lib/pages/welcome_page"; // 欢迎页面

  /// *************************** 登录 *****************************
  /// 登录
  static String loginPath = "/lib/pages/login/login_page";

  /// 密码登录
  static String psdLoginPath = "/lib/pages/login/psdLogin";

  /// *************************** 我的 *****************************
  /// 我的页面
  static String minePath = "/lib/pages/mine/mine_page";
  static String mineResourcePath = "/lib/pages/mine/mine_resource_page";
  static String accountPath = "/lib/pages/mine/account_page";

  /// *************************** chat *****************************
  /// chat页面
  static String chatDetPath = "/lib/pages/chat/chat_detail_page";

  /***************************** 通用页 ******************************/
  /// webView
  static String webViewPath = "/root/webView/webViewPage";
  static String wechatRecordPath = "/root/webView/wechatRecordPath";

  ///用户协议和隐私政策弹窗
  static String basePrivacyPath =
      "/lib/pages/login/privacy/sc_privacy_alert_page";

  ///用户反馈
  static String userFeedback = "/lib/pages/mine/feedback/feedback_page";

  ///关于我们
  static String aboutUs = "/lib/pages/mine/feedback/about_page";

  ///证照信息
  static String archivalInfo = "/lib/pages/mine/feedback/archival_info_page";

  ///社区公约
  static String communityConvention =
      "/lib/pages/mine/feedback/community_convention_page";

  ///绑定手机号
  static String bindMobile = "/lib/pages/login/bind_mobile/bind_mobile_page";

  ///绑定问题
  static String bindProblem = "/lib/pages/login/bind_mobile/bind_problem_page";
}
