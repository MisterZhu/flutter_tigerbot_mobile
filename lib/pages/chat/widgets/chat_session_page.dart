import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import '../../../constant/tb_export_common.dart';
import '../../../util/dialog/sc_base_dialog.dart';
import '../../../util/dialog/sc_dialog_utils.dart';
import '../../../util/provider/user_info_provider.dart';
import '../../../widgets/cached_image.dart';
import '../logic/tb_chat_detail_logic.dart';
import '../model/tb_assistants_model.dart';

class ChatSessionPage extends StatefulWidget {
  final TBChatDetailLogic logicDet;

  /// 点击返回
  final Function? doSelect;

  ChatSessionPage({
    required this.logicDet,
    this.doSelect,
  });

  @override
  _ChatSessionPageState createState() => _ChatSessionPageState();
}

class _ChatSessionPageState extends State<ChatSessionPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: themed.theme_c.themePinkColor, // 这里设置背景色
        child: Column(
          children: [
            //屏幕 距顶距离
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 12.w, bottom: 12.w),
              child: GestureDetector(
                onTap: () {
                  // TBRouterHelper.back(null);
                  TBRouterHelper.pathPage(TBRouterPath.minePath, null);
                },
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.w),
                          border: Border.all(
                              color: themed.theme_c.bgColorMild, width: 2.w),
                        ),
                        child: Consumer<UserInfoProvider>(
                            builder: (context, userInfo, child) {
                          return ClipOval(
                            child: userInfo.avatar.isEmpty
                                ? SizedBox()
                                : CachedImage(
                                    width: 64.w,
                                    height: 64.w,
                                    imageUrl: userInfo.avatar,
                                    fit: BoxFit.cover,
                                  ),
                          );
                        })),
                    SizedBox(
                      width: 8.w,
                    ),
                    Consumer<UserInfoProvider>(
                        builder: (context, userInfo, child) {
                      return Text(
                        "Hi, ${userInfo.name} 👋 ",
                        style: TextStyle(
                            color: themed.theme_c.textColor, fontSize: 16.sp),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 5.w),
              // 调整这里的值来设置左右边距
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '会话列表',
                    style: TextStyle(
                        color: themed.theme_c.textColor, fontSize: 14.sp),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        widget.logicDet.isEdit = !widget.logicDet.isEdit;
                        widget.logicDet.update([TBDefVal.kChatSession]);
                      },
                      child: Icon(
                        widget.logicDet.isEdit ? Icons.close : Icons.edit_note,
                        color: themed.theme_c.themeOppoColor,
                        size: 24.w,
                      )),
                  SizedBox(
                    width: 4.0,
                  ),
                  // + icon
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: (widget.logicDet.secondSeAry != null &&
                        widget.logicDet.secondSeAry.isNotEmpty)
                    ? widget.logicDet.secondSeAry.map(_buildGroup).toList()
                    : [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(),
                            childCount: 1,
                          ),
                        ),
                      ],
              ),
            ),
            Container(
              height: 48,
              margin: EdgeInsets.only(top: 12.w, left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color: themed.theme_c.buttonBgColor,
                borderRadius: BorderRadius.circular(24.0),
                // border: Border.all(color: TBDefVal.chatThemePinkColor),
              ),
              child: TextButton(
                onPressed: () {
                  // Handle button click when sessionAry is empty
                  print('Button Clicked');
                  widget.logicDet.createSession();
                  TBRouterHelper.back(null);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: themed.theme_c.buttonColor,
                      size: 20.w,
                    ), // + icon
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      '新建对话',
                      style: TextStyle(
                          color: themed.theme_c.buttonColor, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 12),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(TBSessionData itemData) {
    return SliverStickyHeader(
      header: HeaderWidget(itemData.groupName),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => _buildItemByUser(itemData.sessions[i]),
          childCount: itemData.sessions.length,
        ),
      ),
    );
  }

  Widget _buildItemByUser(TBSessionModel model) {
    String imagePath;
    if (model.pluginConfig?.documentAnalysis?.enabled ?? false) {
      imagePath = themed.getFileIconPath();
    } else {
      imagePath = themed.getMessageIconPath();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0.w), // 设置左右边距
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // 设置圆角
        child: InkWell(
          onTap: () {
            widget.logicDet.onlineSearch =
                model.pluginConfig?.onlineSearch?.enabled ?? false;
            widget.logicDet.changeSession(model.id ?? '');
            TBRouterHelper.back(null);
          },
          child: Container(
            color: model.isSelect ?? false
                ? themed.theme_c.bgColorMild // 选中时的背景色
                : Colors.transparent, // 未选中时的背景色
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.w),
              dense: true,
              visualDensity: VisualDensity(horizontal: -3.0, vertical: -3.0),
              // minLeadingWidth: 10,
              title: Container(
                // padding: EdgeInsets.symmetric(horizontal: 0.w,vertical: 0.w),
                // color: Colors.green,
                child: Row(
                  children: [
                    /*
                    String imagePath;

if (model.pluginConfig?.onlineSearch?.enabled ?? false) {
  imagePath = 'assets/images/chat/chat_search_earth_s.png';
} else if (model.pluginConfig?.documentAnalysis?.enabled ?? false) {
  imagePath = 'assets/images/chat/chat_search_document_s.png';
} else {
  imagePath = 'assets/images/chat/chat_search_msg_s.png';
}
                    * */

                    Image.asset(
                      imagePath,
                      width: 20.w,
                      fit: BoxFit.cover,
                      // color: themed.theme_c.buttonBgColor, // 条件判断
                      // colorBlendMode: BlendMode.srcIn, // 条件判断
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 200.0, // 设置Text的最大宽度
                      ),
                      child: Text(
                        model.displayName ?? '',
                        overflow: TextOverflow.ellipsis, // 超出部分省略号显示
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.sp,
                          // height: 1,
                          // fontWeight: FontWeight.w500,
                          color: themed.theme_c.textColorMild,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    if (widget.logicDet.isEdit) Spacer(), // 添加一个Spacer来撑开空间
                    if (widget.logicDet.isEdit)
                      GestureDetector(
                        onTap: () {
                          // 处理删除图标点击事件
                          print('删除图标点击事件');
                          SCDialogUtils.instance.showMiddleDialog(
                            context: context,
                            title: "温馨提示",
                            content: '确定删除该会话？',
                            customWidgetButtons: [
                              defaultCustomButton(context,
                                  text: '取消',
                                  textColor: themed.theme_c.alertCancelColor,
                                  fontWeight: FontWeight.w400),
                              defaultCustomButton(context,
                                  text: '确定',
                                  textColor: themed.theme_c.alertSureColor,
                                  fontWeight: FontWeight.w400, onTap: () async {
                                widget.logicDet
                                    .sureDeleteSession(model.id ?? '');
                              }),
                            ],
                          );
                        },
                        child:
                            // Icon(
                            //   Icons.delete,
                            //   color: Colors.grey,
                            // ),
                            Image.asset(
                          'assets/images/chat/chat_session_delete.png',
                          width: 20.w,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String groupName;

  HeaderWidget(this.groupName);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      color: themed.theme_c.themePinkColor,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      alignment: Alignment.centerLeft,
      child: Text(
        groupName,
        style: TextStyle(
          fontSize: 12.sp,
          // height: 1.5,
          fontWeight: FontWeight.w500,
          color: themed.theme_c.textColor,
        ),
      ),
    );
  }
}
