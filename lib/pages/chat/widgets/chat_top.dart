import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../login/login_page.dart';

class ChatTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(builder: (key, userInfo, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(6))),
            child: GestureDetector(
              child: userInfo.avatar.isEmpty
                  ? Icon(Icons.person)
                  : Image.network(
                      userInfo.avatar,
                    ),
              onTap: () {
                if (userInfo.isLogin) {
                  // Get.toNamed("/mine");
                  TBRouterHelper.pathPage(TBRouterPath.minePath, null);

                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: LoginPage(),
                        );
                      });
                }
              },
            ),
          )
        ],
      );
    });
  }
}
