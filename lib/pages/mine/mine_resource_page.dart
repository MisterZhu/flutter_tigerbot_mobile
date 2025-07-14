import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:TigerChat/pages/mine/widgets/mine_resource_content.dart';
import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/request/response/TBResponse.dart';
import 'package:TigerChat/util/tb_loading_utils.dart';
import 'package:TigerChat/widgets/cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../util/request/sc_http_manager.dart';
import '../../util/request/sc_upload_utils.dart';
import '../../util/request/http_request.dart';

class MineResourcePage extends StatefulWidget {
  MineResourcePage({super.key});

  @override
  State<MineResourcePage> createState() => _MineResourcePageState();
}

class _MineResourcePageState extends State<MineResourcePage> {
  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TBHttpResponse response =
          await TBHttpRequest.post(TBUrl.kUserInfoUrl, context)
              as TBHttpResponse;
      // print("response: ${response}");
      if (response.success) {
        // print("response.data: ${response.data}");
      }
    });
  }

  showModal(BuildContext context) {
    // List<BrnCommonActionSheetItem> actions = [];
    // actions.add(BrnCommonActionSheetItem(
    //   '拍照',
    //   actionStyle: BrnCommonActionSheetItemStyle.normal,
    // ));
    // actions.add(BrnCommonActionSheetItem(
    //   '相册中选取',
    //   actionStyle: BrnCommonActionSheetItemStyle.normal,
    // ));
    //
    // showModalBottomSheet(
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     builder: (BuildContext context) {
    //       return BrnCommonActionSheet(
    //         actions: actions,
    //         cancelTitle: "取消",
    //         clickCallBack: (int index, BrnCommonActionSheetItem actionEle) {
    //           // if (index == 0) {
    //           //   _picker.pickImage(source: ImageSource.camera);
    //           // } else {
    //           //   _picker.pickImage(source: ImageSource.gallery);
    //           // }
    //           if (index == 0) {
    //             _pickImage(ImageSource.camera);
    //           } else {
    //             _pickImage(ImageSource.gallery);
    //           }
    //         },
    //       );
    //     });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? imageFile = await _picker.pickImage(source: source);
    String imagePath = imageFile?.path ?? '';
    if (imagePath != '' && imagePath.isNotEmpty) {
      TBLoadingUtils.show();
      SCUploadUtils.uploadHeadPic(
          imagePath: imagePath,
          successHandler: (value) {
            TBLoadingUtils.hide();
            Map<String, dynamic> data = value['data'];
            String avatarUrl = data['data'];
            print('------------------------data : $avatarUrl');
            if (avatarUrl != null && avatarUrl.isNotEmpty) {
              _saveUserAvatar(avatarUrl);
            }
          },
          failureHandler: (value) {
            TBLoadingUtils.hide();
            TBLoadingUtils.failure(text: value['msg']);
          });
    }
  }

  Future<void> _saveUserAvatar(String avatarUrl) async {
    UserInfoProvider userInfo =
        Provider.of<UserInfoProvider>(context, listen: false);

    var params = {
      "params": {
        "user": {
          "account": userInfo.account,
          "name": userInfo.name,
          "avatar": avatarUrl,
          "intro": userInfo.intro,
        },
      },
      "authorization": {
        "token": userInfo.token,
        "uid": userInfo.uuid,
      },
    };
    print('--------------CreateSession--begin');
    await SCHttpManager.instance.post(
        url: TBUrl.kSaveIntroUrl,
        params: params,
        success: (value) {
          Map<String, dynamic> data = value['data'];
          data["token"] = userInfo.token;
          userInfo.login(data, isLocalSave: true);
          TBLoadingUtils.success(text: value['msg']);
        },
        failure: (err) {
          TBLoadingUtils.failure(text: err['msg']);
        });
  }

  // /// 效验 session
  // Future<void> verifySession() async {
  //   if (requestStr.isEmpty) {
  //     print('--------------requestStr--begin');
  //     return;
  //   }
  //   var params = {
  //     "pluginConfig": {
  //       "documentAnalysis": {
  //         "enabled": documentAnalysis,
  //       },
  //       "onlineSearch": {
  //         "enabled": onlineSearch,
  //       },
  //       "imageGeneration": {
  //         "enabled": imageGeneration,
  //       },
  //     },
  //     "displayName": requestStr,
  //     "description": '',
  //     "assistant": assistant
  //   };
  //   print('--------------CreateSession--begin');
  //
  //   await SCHttpManager.instance.post(
  //       url: TBUrl.kCreateSession,
  //       params: params,
  //       success: (value) {
  //         final model = TBSessionModel.fromJson(value);
  //         print('----------- sessionid: ${model.id}');
  //         session = model.id ?? '';
  //         requestSessionList();
  //       },
  //       failure: (err) {});
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themed.theme_c.bgColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Image.asset(
                    Assets.commonCommonBackIcon,
                    width: 24.w,
                    color: themed.theme_c.textColor, // 你想要的颜色
                    colorBlendMode: BlendMode.srcIn, // 混合模式
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Info1'.tr,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: themed.theme_c.textColor),
              ),
              Spacer(),
              SizedBox(
                width: 52.w,
              )
            ],
          ),
          SizedBox(
            height: 30.w,
          ),
          GestureDetector(
            onTap: () {
              showModal(context);
            },
            child: Stack(children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: themed.theme_c.bgColor),
                child: Consumer<UserInfoProvider>(
                    builder: (context, userInfo, child) {
                  return ClipOval(
                    child: CachedImage(
                      imageUrl: userInfo.avatar,
                      fit: BoxFit.cover,
                    ),
                  );
                }),
              ),
              // Positioned(
              //     bottom: 0,
              //     right: 0,
              //     child: Image.asset(
              //       "assets/images/mine/mine_camera_icon.png",
              //       width: 24.w,
              //     ))
            ]),
          ),
          SizedBox(
            height: 60.w,
          ),
          Expanded(child: MineResourceContent())
        ],
      ),
    );
  }
}
