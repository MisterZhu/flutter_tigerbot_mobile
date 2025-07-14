import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/home/view/tb_applybeta_view.dart';
import 'package:TigerChat/pages/home/view/tb_launch_apply.dart';
import 'package:TigerChat/pages/home/view/tb_launch_review.dart';
import 'package:TigerChat/util/common_tools.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../util/tb_utils.dart';
import 'logic/tb_launch_logic.dart';

class HomeLaunchPage extends StatefulWidget {
  @override
  _HomeLaunchPageState createState() => _HomeLaunchPageState();
}

class _HomeLaunchPageState extends State<HomeLaunchPage> {
  final TBLaunchLogic logic = Get.put(TBLaunchLogic());

  @override
  void initState() {
    super.initState();
    print("111111");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(builder: (context, userInfo, child) {
      return Stack(
        children: [
          Container(
            color: Colors.white, // 默认背景颜色
            width: double.infinity,
            height: double.infinity,
          ),
          Image.asset(
            imagePath("home", "bg_launch"),
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Image.asset(imagePath("home", "logo_launch")),
              SizedBox(
                height: 30.h,
              ),
              bottomView(),
            ],
          ),
          Positioned(
            top: 40,
            right: 15,
            child: InkWell(
              onTap: () {
                // 处理点击事件
                TBRouterHelper.pathPage(TBRouterPath.minePath, null);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent, // 按钮背景颜色
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0.w),
                    child: TBUtils.imageWidget(
                      url: userInfo.avatar,
                      fit: BoxFit.cover,
                      width: 40.w,
                      height: 40.w,
                    ),
                    // Image.network(
                    //   userInfo.avatar,
                    //   fit: BoxFit.cover,
                    //   width: 40.w,
                    //   height: 40.w,
                    // ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  /// 皮肤
  Widget bottomView() {
    return GetBuilder<TBLaunchLogic>(builder: (state) {
      if (state.applyStatus == 0) {
        return TBLaunchApply(itemTapAction: (type) {
          if (type == 0) {
            TBApplyBetaModal shareModal = TBApplyBetaModal();
            shareModal.showShareModel(context, logic);
          } else {
            showInputDialog(context, logic);
          }

          /// 应用icon点击跳转
          //itemDetail(title);
        });
      } else if (state.applyStatus == 1) {
        return TBLaunchReview(
          applyState: 1,
          itemTapAction: (type) {
            showInputDialog(context, logic);
          },
        );
      } else if (state.applyStatus == 2) {
        return openChatView();
      } else if (state.applyStatus == 3) {
        return TBLaunchReview(
          applyState: 3,
          itemTapAction: (type) {
            showInputDialog(context, logic);
          },
        );
      } else {
        return SizedBox(
          height: 30.h,
        );
      }
    });
  }

  ///弹出邀请码输入框
  void showInputDialog(BuildContext context, TBLaunchLogic logic) {
    // BrnMiddleInputDialog(
    //   title: 'inviteCode'.tr,
    //   hintText: 'inviteTip'.tr,
    //   cancelText: 'Cancel'.tr,
    //   confirmText: 'Confirm1'.tr,
    //   maxLength: 1000,
    //   maxLines: 2,
    //   barrierDismissible: false,
    //   inputEditingController: TextEditingController()..text = '',
    //   textInputAction: TextInputAction.done,
    //   onConfirm: (value) {
    //     if (value.isEmpty) {
    //       Fluttertoast.showToast(
    //         msg: 'codeEmptyTip'.tr,
    //         gravity: ToastGravity.CENTER,
    //       );
    //       return;
    //     }
    //     logic.inviteCode = value;
    //     logic.requestInviteCode();
    //     TBRouterHelper.back(null);
    //   },
    //   onCancel: () {
    //     TBRouterHelper.back(null);
    //   },
    // ).show(context);
  }

  /// skin1
  Widget openChatView() {
    return Column(
      children: [
        Image.asset(
          imagePath("home", "title_launch"),
          width: 243.w,
        ),
        SizedBox(
          height: 60.h,
        ),
        GestureDetector(
          onTap: () {
            // print("userInfo.isLogin = ${userInfo.isLogin}");
            //
            // if (!userInfo.isLogin) {
            //   print('未登录');
            //   TBRouterHelper.pathPage(TBRouterPath.loginPath, null);
            //   return;
            // }
            TBRouterHelper.pathPage(TBRouterPath.chatDetPath, null);
          },
          child: Container(
            alignment: Alignment.center,
            width: 287.w,
            height: 44.w,
            child: Text(
              'open'.tr,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            decoration: BoxDecoration(
                color: Color(0xffFF98AC),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: []),
          ),
        )
      ],
    );
  }
// Future showInviteCodeView() async{
//   await
// }
}
