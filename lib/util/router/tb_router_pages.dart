import 'package:TigerChat/pages/home/home_launch_page.dart';
import 'package:TigerChat/pages/login/psd_login_page.dart';
import 'package:get/get.dart';

import '../../pages/chat/chat_detail_page.dart';
import '../../pages/login/bind_mobile/bind_mobile_page.dart';
import '../../pages/login/bind_mobile/bind_problem_page.dart';
import '../../pages/login/privacy/page/sc_privacy_alert_page.dart';
import '../../pages/mine/about_us/about_page.dart';
import '../../pages/mine/about_us/archival_info.dart';
import '../../pages/mine/about_us/community_convention.dart';
import '../../pages/mine/feedback/feedback_view.dart';
import '../../pages/welcome_page.dart';
import '../../pages/login/login_page.dart';
import '../../pages/mine/mine_page.dart';
import '../../pages/mine/mine_resource_page.dart';
import '../../pages/mine/account_page.dart';

import '../webview/tb_webview_page.dart';
import 'tb_router_path.dart';

/// 路由-pages
class TBRouterPages {
  /*根据path使用路由*/
  static final List<GetPage> getPages = [
    /// 首页
    GetPage(name: TBRouterPath.root, page: () => HomeLaunchPage()),

    /// welcome
    GetPage(name: TBRouterPath.welcomePath, page: () => WelcomePage()),

    /// 验证码登录
    GetPage(name: TBRouterPath.loginPath, page: () => LoginPage()),

    /// 密码登录
    GetPage(name: TBRouterPath.psdLoginPath, page: () => PsdLoginPage()),

    /// 我的页面
    GetPage(name: TBRouterPath.minePath, page: () => MinePage()),

    /// 我的账户
    GetPage(name: TBRouterPath.accountPath, page: () => AccountPage()),

    /// 聊天详情页
    GetPage(name: TBRouterPath.chatDetPath, page: () => ChatDetailPage()),

    /// 个人详情页
    GetPage(
        name: TBRouterPath.mineResourcePath, page: () => MineResourcePage()),

    ///webView
    GetPage(name: TBRouterPath.webViewPath, page: () => const TBWebViewPage()),
    /*首次的用户协议和隐私政策弹窗*/
    GetPage(
        name: TBRouterPath.basePrivacyPath, page: () => SCPrivacyAlertPage()),

    ///FeedbackPage
    GetPage(name: TBRouterPath.userFeedback, page: () => FeedbackPage()),

    ///关于我们
    GetPage(name: TBRouterPath.aboutUs, page: () => AboutUsPage()),

    ///证照信息
    GetPage(name: TBRouterPath.archivalInfo, page: () => ArchivalInfoPage()),
    GetPage(
        name: TBRouterPath.communityConvention, page: () => ConventionPage()),

    ///微信绑定手机号
    GetPage(name: TBRouterPath.bindMobile, page: () => BindMobilePage()),

    ///微信绑定手机号
    GetPage(name: TBRouterPath.bindProblem, page: () => BindProblemPage()),
  ];

  // /*根据code使用路由*/
  // static var pageCode = {
  //   /*用户协议和隐私政策*/
  //   8000 : SCRouterPath.basePrivacyPath,
  //   /*引导页*/
  //   9000 : SCRouterPath.guidePath,
  //   /*验证码登录-输入手机号*/
  //   9001 : SCRouterPath.codeLoginPath,
  //   /*城市选择*/
  //   9002 : SCRouterPath.selectCityPath,
  //   /*社区选择*/
  //   9003 : SCRouterPath.selectCommunityPath,
  //   /*tab*/
  //   10000 : SCRouterPath.tabPath,
  //   /*首页*/
  //   10001 : SCRouterPath.homePath,
  //   /*扫一扫*/
  //   10002 : SCRouterPath.scanPath,
  //   /*全部应用*/
  //   10011 : SCRouterPath.servicePagePath,
  //   /*切换房屋*/
  //   5001 : SCRouterPath.toggleHousesPagePath,
  //   /*新增房号*/
  //   5002 : SCRouterPath.addHousePagePath,
  //   /*设置*/
  //   5003 : SCRouterPath.settingPath,
  //   /*个人资料*/
  //   5004 : SCRouterPath.personalInfoPath,
  //   /*实名认证*/
  //   5005 : SCRouterPath.realNameVerifyPath,
  //   /*webView*/
  //   20000 : SCRouterPath.webViewPath,
  //   /*房号选择*/
  //   20001 : SCRouterPath.selectHousePath,
  // };
}
