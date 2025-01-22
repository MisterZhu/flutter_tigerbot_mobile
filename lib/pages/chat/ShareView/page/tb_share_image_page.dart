import 'package:TigerChat/constant/tb_default_value.dart';
import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../constant/tb_colors.dart';
import '../../../../util/provider/user_info_provider.dart';
import '../../../../widgets/cached_image.dart';
import '../../logic/tb_chat_detail_logic.dart';
import '../../model/chat_model.dart';
import '../../model/chat_request_file_model.dart';
import '../../model/chat_request_model.dart';
import '../../model/chat_response_model.dart';
import '../../widgets/cell/chat_request_file_cell.dart';
import '../logic/tb_share_image_logic.dart';
import '../view/tb_share_request_cell.dart';
import '../view/tb_share_request_file.dart';
import '../view/tb_share_response_cell.dart';

class TBShareImagePage extends StatelessWidget {
  final TBShareImageLogic logic = Get.find<TBShareImageLogic>();
  final TBChatDetailLogic logicDet = Get.put(TBChatDetailLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w * logic.zoomRatio,
      height: 520.h,
      // color: Colors.white,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themed.theme_c.shareBgColor33, // 结束颜色
            themed.theme_c.shareBgColor, //
            themed.theme_c.shareBgColor, // 起始颜色，使用16进制颜色值
          ],
          stops: [0.0, 0.18, 1.0], // 渐变的位置
        ),
      ),
      child: Stack(
        children: [
          // 位于 Stack 上方的固定 Container
          Positioned(
            top: 0,
            // 距离顶部的距离
            left: 0,
            // 距离左侧的距离
            right: 0,
            // 距离右侧的距离
            height: 80.0.h,
            // Container 的高度
            child: Container(
              width: 375.w * logic.zoomRatio,
              height: 80.0.h, // 顶部高度
              color: Colors.transparent, // 顶部背景颜色
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/chat/chat_tiger.png',
                    width: 64.w * logic.zoomRatio, // 图片宽度
                    height: 64.w * logic.zoomRatio, // 图片高度
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 18.0.w * logic.zoomRatio), // 图标和文本之间的间距
                  Text(
                    'TigerBot',
                    style: TextStyle(
                      fontSize: 27.0 * logic.zoomRatio, // 文本大小
                      color: themed.theme_c.textColor, // 文本颜色
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 80.0.h,
            // 距离顶部的距离，这里设置为固定 Container 的高度
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(top: 10.0.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  reverse: false,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: logic.scrollController,
                  itemCount: logic.dataSource.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatModel chatModel = logic.dataSource[index];
                    if (chatModel.runtimeType == ChatRequestModel) {
                      ChatRequestModel requestModel =
                          chatModel as ChatRequestModel;
                      print("ChatRequestModel = ${chatModel.content}");
                      return TBShareRequestCell(
                        chatModel,
                        deleteHandle: () {
                          print("点击了删除");
                        },
                        onStateChanged: (ChatRequestModel chatRequest) {
                          print("点击了勾选");
                        },
                        key: ValueKey(requestModel.content),
                      );
                    } else if (chatModel.runtimeType == ChatResponseModel) {
                      ChatResponseModel responseModel =
                          chatModel as ChatResponseModel;
                      print("ChatResponseModel = ${chatModel.content}");

                      return TBShareResponseCell(
                        responseModel,
                        foldHandle: (fold) {},
                        likeHandle: (like) {},
                        unlikeHandle: (unlike) {},
                        deleteHandle: () {},
                        regenerateHandle: (content) {},
                        mulChoiceHandle: () {},
                        selectAllHandle: () {},
                        key: ObjectKey(responseModel.stream),
                      );
                    } else if (chatModel.runtimeType == ChatRequestFileModel) {
                      print("ChatRequestFileModel = ${chatModel.content}");

                      ChatRequestFileModel requestModel =
                          chatModel as ChatRequestFileModel;
                      return TBShareRequestFile(
                        requestModel,
                        deleteHandle: () {
                          // showDeleteDialog(chatModel);
                        },
                        onStateChanged: (ChatRequestFileModel chatRequest) {
                          print("点击了勾选3");
                          // ChatProvider chatProvider =
                          // Provider.of<ChatProvider>(context, listen: false);
                          // chatProvider.choiceAll = false;
                          // logicDet.dataSource[index] = chatRequest;
                        },
                        key: ValueKey(requestModel.content),
                      );
                    } else {
                      return SizedBox(
                        height: 1.0,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 375.w * logic.zoomRatio,
              height: 192.w * logic.zoomRatio,
              padding: EdgeInsets.only(
                  left: 20.0.w * logic.zoomRatio,
                  right: 20.0.w * logic.zoomRatio),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themed.theme_c.shareBgColor00, // 结束颜色
                    themed.theme_c.shareBgColor44, // 结束颜色
                    themed.theme_c.shareBgColor33, // 起始颜色，使用16进制颜色值
                  ],
                  stops: [0.0, 0.15, 1.0], // 渐变的位置
                ),
              ),
              child: Center(
                child: bottomImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomImage() {
    return Column(
      children: [
        SizedBox(
          height: 28.0.w * logic.zoomRatio,
        ),
        Text(
          'Tell you everything i know'.tr,
          style: TextStyle(
            fontSize: 22 * logic.zoomRatio,
            fontWeight: FontWeight.w700,
            color: themed.theme_c.textColor,
            shadows: [
              Shadow(
                blurRadius: 1.0,
                color: themed.theme_c.textColorMild,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 48.0.w * logic.zoomRatio,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 顶部对齐
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Consumer<UserInfoProvider>(
                      builder: (ctx, userInfo, child) {
                        return ClipOval(
                          child: CachedImage(
                            width: 22.w,
                            height: 22.w,
                            imageUrl: userInfo.avatar,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.0 * logic.zoomRatio), // 可以添加间距

                    Consumer<UserInfoProvider>(
                      builder: (ctx, userInfo, child) {
                        return Text(
                          userInfo.name,
                          style: TextStyle(
                              fontSize:
                                  TBDefVal.chatRegularFont * logic.zoomRatio,
                              fontWeight: FontWeight.w400,
                              color: themed.theme_c.textColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 左侧部分
            // 右侧部分
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // 子组件顶部对齐
                children: [
                  Container(
                    width: 75.w, // 设置固定宽度，根据需要调整宽度值
                    child: Text(
                      "Instant download experience".tr,
                      style: TextStyle(
                        fontSize: TBDefVal.chatRegularFont * logic.zoomRatio,
                        fontWeight: FontWeight.w400,
                        color: themed.theme_c.textColor,
                      ),
                      textAlign: TextAlign.right, // 设置文本右对齐
                      maxLines: 5, // 设置最大行数
                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                    ),
                  ),
                  SizedBox(
                    width: 10.0.w * logic.zoomRatio,
                  ),
                  Container(
                    width: 1, // 设置竖线的宽度
                    height: 64.w * logic.zoomRatio, // 设置竖线的高度
                    color: themed.theme_c.textColor, // 设置竖线的颜色为白色
                  ),
                  SizedBox(
                    width: 10.0.w * logic.zoomRatio,
                  ),
                  Image.asset(
                    "assets/images/chat/tigerbot_qrcode.png",
                    width: 64.w * logic.zoomRatio, // 图片宽度
                    height: 64.w * logic.zoomRatio, // 图片高度
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
