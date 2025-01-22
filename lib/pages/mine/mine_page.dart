import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/mine/widgets/mine_item.dart';
import 'package:TigerChat/pages/mine/widgets/mine_switch_item.dart';
import 'package:TigerChat/pages/mine/widgets/tb_mine_teen_view.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../util/skin/theme_controller.dart';
import '../../widgets/cached_image.dart';
import 'logic/tb_mine_logic.dart';

class MinePage extends StatelessWidget {
  final TBMineLogic logic = Get.put(TBMineLogic());

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, themeController) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Image.asset(
                themed.getBgImagePath(),
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 20.w,
                child: GestureDetector(
                  child: Image.asset(
                    Assets.commonCommonBackIcon,
                    width: 24.w,
                    color: themed.theme_c.textColor, // 你想要的颜色
                    colorBlendMode: BlendMode.srcIn, // 混合模式
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              Consumer<UserInfoProvider>(
                builder: (ctx, userInfo, child) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 45.w + MediaQuery.of(context).padding.top,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: themed.theme_c.bgColor),
                          child: userInfo.avatar.isNotEmpty
                              ? ClipOval(
                                  child: CachedImage(
                                    width: 40.w,
                                    height: 40.w,
                                    imageUrl: userInfo.avatar,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                        ),
                        SizedBox(
                          height: 12.w,
                        ),
                        Text(
                          userInfo.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 60.w,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MineItem(
                                  imagePath:
                                      "assets/images/mine/mine_info_icon.png",
                                  text: 'Info'.tr,
                                  onTap: () {
                                    // Get.toNamed("/mine/resource");
                                    TBRouterHelper.pathPage(
                                        TBRouterPath.mineResourcePath, null);
                                  },
                                ),
                                MineItem(
                                  imagePath:
                                      "assets/images/mine/mine_account_icon.png",
                                  text: 'Account'.tr,
                                  onTap: () {
                                    // Get.toNamed("/account");
                                    TBRouterHelper.pathPage(
                                        TBRouterPath.accountPath, null);
                                  },
                                ),
                                MineItem(
                                  imagePath:
                                      "assets/images/mine/mine_feedback_icon.png",
                                  text: 'Feedback'.tr,
                                  onTap: () {
                                    TBRouterHelper.pathPage(
                                        TBRouterPath.userFeedback, null);
                                  },
                                ),
                                GetBuilder<TBMineLogic>(
                                  builder: (controller) {
                                    return MineSwitchItem(
                                      imagePath:
                                          "assets/images/mine/mine_teen_mode.png",
                                      text: 'Teen Mode'.tr,
                                      onTap: (teenMode) {
                                        TBMineTeenView shareModal =
                                            TBMineTeenView();
                                        shareModal.showTeenModel(
                                            context, logic);
                                        //logic.openTeenMode();
                                      },
                                    );
                                  },
                                ),
                                GetBuilder<ThemeController>(
                                    builder: (controller) {
                                  return MineItem(
                                    imagePath: Assets.mineMineTheme,
                                    text: 'theme_skin'.tr,
                                    rightText: (controller.skinStr == '')
                                        ? '跟随系统'
                                        : controller.skinStr,
                                    onTap: () {
                                      List<BrnCommonActionSheetItem> actions =
                                          [];
                                      actions.add(BrnCommonActionSheetItem(
                                        '跟随系统',
                                        // desc: '辅助信息辅助信息辅助信息',
                                        actionStyle:
                                            BrnCommonActionSheetItemStyle
                                                .normal,
                                      ));
                                      actions.add(BrnCommonActionSheetItem(
                                        '浅色',
                                        // desc: '辅助信息辅助信息辅助信息',
                                        actionStyle:
                                            BrnCommonActionSheetItemStyle
                                                .normal,
                                      ));
                                      actions.add(BrnCommonActionSheetItem(
                                        '深色',
                                        // desc: '辅助信息辅助信息辅助信息',
                                        actionStyle:
                                            BrnCommonActionSheetItemStyle
                                                .normal,
                                      ));
                                      // actions.add(BrnCommonActionSheetItem(
                                      //   '粉色',
                                      //   // desc: '辅助信息辅助信息辅助信息',
                                      //   actionStyle:
                                      //       BrnCommonActionSheetItemStyle
                                      //           .normal,
                                      // ));
                                      // 展示actionSheet
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return BrnCommonActionSheet(
                                              title: "请选择主题皮肤",
                                              actions: actions,
                                              cancelTitle: "取消",
                                              clickCallBack: (int index,
                                                  BrnCommonActionSheetItem
                                                      actionEle) {
                                                String title = actionEle.title;

                                                switch (index) {
                                                  case 0:
                                                    BrnToast.show(
                                                        "选择跟随系统", context);

                                                    controller
                                                        .saveTheme('跟随系统');
                                                    break;
                                                  case 1:
                                                    BrnToast.show(
                                                        "选择浅色", context);
                                                    controller.saveTheme('浅色');

                                                    break;
                                                  case 2:
                                                    BrnToast.show(
                                                        "选择深色", context);
                                                    controller.saveTheme('深色');

                                                    break;
                                                  // case 3:
                                                  //   BrnToast.show(
                                                  //       "选择粉色", context);
                                                  //   controller.saveTheme('粉色');
                                                  //
                                                  //   break;
                                                  default:
                                                    BrnToast.show(
                                                        "默认跟随系统", context);
                                                    controller
                                                        .saveTheme('跟随系统');

                                                    break;
                                                }
                                                controller.update();
                                                themeController.update();
                                              },
                                            );
                                          });
                                    },
                                  );
                                }),
                                MineItem(
                                  imagePath:
                                      "assets/images/mine/mine_about_us.png",
                                  text: 'about_us'.tr,
                                  onTap: () {
                                    // Get.toNamed("/account");
                                    TBRouterHelper.pathPage(
                                        TBRouterPath.aboutUs, null);
                                  },
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Logout?'.tr),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    TBRouterHelper.back(null);
                                                  },
                                                  child: Text('Cancel'.tr,
                                                      style: TextStyle(
                                                          color: themed.theme_c
                                                              .themeOppoColor))),
                                              TextButton(
                                                  onPressed: () {
                                                    userInfo.logout();
                                                    // eventBus.fire(Logout());
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Log out successfully'
                                                                .tr);
                                                    // TBRouterHelper.pathOffAllPage(
                                                    //     TBRouterPath.loginPath,
                                                    //     null);
                                                    var params = {
                                                      'canBack': false,
                                                      'removeLoginCheck': true
                                                    };

                                                    TBRouterHelper.pathPage(
                                                        TBRouterPath.loginPath,
                                                        params);
                                                  },
                                                  child: Text('Confirm1'.tr,
                                                      style: TextStyle(
                                                          color: themed.theme_c
                                                              .themeOppoColor)))
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 48,
                                    margin: EdgeInsets.only(
                                        top: 12.w, left: 16.w, right: 16.w),
                                    decoration: BoxDecoration(
                                      color: themed.theme_c.buttonBgColor,
                                      borderRadius: BorderRadius.circular(24.0),
                                      // border: Border.all(color: TBDefVal.chatThemePinkColor),
                                    ),
                                    alignment: Alignment
                                        .center, // Ensure text is centered
                                    child: Text(
                                      'Logout'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // style: ButtonStyle(
                                  //     shape: MaterialStateProperty.all(
                                  //         RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(8.r))),
                                  //     backgroundColor:
                                  //         MaterialStateProperty.all(
                                  //             themed.theme_c.buttonBgColor),
                                  //     foregroundColor:
                                  //         MaterialStateProperty.all(
                                  //             themed.theme_c.buttonColor)),
                                ),
                                // GestureDetector(
                                //   child: Container(
                                //     alignment: Alignment.center,
                                //     height: 56.w,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(10.r)),
                                //     ),
                                //     child: Text(
                                //       'Logout'.tr,
                                //       style: TextStyle(
                                //           fontSize: 16.sp, color: Colors.red),
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     showDialog(
                                //         context: context,
                                //         builder: (context) {
                                //           return AlertDialog(
                                //             title: Text('Logout?'.tr),
                                //             actions: [
                                //               TextButton(
                                //                   onPressed: () {
                                //                     TBRouterHelper.back(null);
                                //                   },
                                //                   child: Text('Cancel'.tr,
                                //                       style: TextStyle(
                                //                           color: themed.theme_c
                                //                               .themeOppoColor))),
                                //               TextButton(
                                //                   onPressed: () {
                                //                     userInfo.logout();
                                //                     // eventBus.fire(Logout());
                                //                     Fluttertoast.showToast(
                                //                         msg:
                                //                             'Log out successfully'
                                //                                 .tr);
                                //                     // TBRouterHelper.pathOffAllPage(
                                //                     //     TBRouterPath.loginPath,
                                //                     //     null);
                                //                     var params = {
                                //                       'canBack': false,
                                //                       'removeLoginCheck': true
                                //                     };
                                //
                                //                     TBRouterHelper.pathPage(
                                //                         TBRouterPath.loginPath,
                                //                         params);
                                //                   },
                                //                   child: Text('Confirm'.tr,
                                //                       style: TextStyle(
                                //                           color: themed.theme_c
                                //                               .themeOppoColor)))
                                //             ],
                                //           );
                                //         });
                                //   },
                                // )
                                // Add more items here
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
