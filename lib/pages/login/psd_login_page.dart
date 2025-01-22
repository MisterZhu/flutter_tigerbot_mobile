import 'package:TigerChat/pages/login/widgets/login_psd_content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/tb_export_common.dart';

class PsdLoginPage extends StatefulWidget {
  @override
  _PsdLoginPageState createState() => _PsdLoginPageState();
}

class _PsdLoginPageState extends State<PsdLoginPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = null;
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(children: [
          Image.asset(themed.getBgImagePath(), fit: BoxFit.fitWidth),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Image.asset(
                      Assets.commonCommonBackIcon,
                      width: 24.w,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 36.w, left: 40.w, bottom: 60.h),
                  child: Text(
                    "密码登录",
                    // S.of(context).login,
                    style:
                        TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                LoginPsdContent()
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
