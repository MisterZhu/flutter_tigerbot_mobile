import 'package:TigerChat/constant/tb_colors.dart';
import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../util/tb_utils.dart';

typedef PageChanged = void Function(int index);

class PhotoPreview extends StatefulWidget {
  final List galleryItems; //图片列表
  final int defaultImage; //默认第几张
  final PageChanged pageChanged; //切换图片回调
  final Axis direction; //图片查看方向
  // final Decoration decoration; //背景设计

  PhotoPreview(
      {required this.galleryItems,
      this.defaultImage = 1,
      required this.pageChanged,
      this.direction = Axis.horizontal})
      : assert(galleryItems != null);

  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  late int tempSelect;

  @override
  void initState() {
    // TODO: implement initState
    tempSelect = widget.defaultImage + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.galleryItems[index]),
                    );
                  },
                  scrollDirection: widget.direction,
                  itemCount: widget.galleryItems.length,
                  // backgroundDecoration:
                  //     widget.decoration ?? BoxDecoration(color: Colors.white),
                  pageController:
                      PageController(initialPage: widget.defaultImage),
                  onPageChanged: (index) => setState(() {
                        tempSelect = index + 1;
                        if (widget.pageChanged != null) {
                          widget.pageChanged(index);
                        }
                      }))),
          Positioned(
            right: 2,
            top: MediaQuery.of(context).padding.top,
            child: InkWell(
                onTap: () {
                  TBRouterHelper.back(null);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      Icon(Icons.close_rounded, color: TBColors.color_FFF1F0),
                )),
          ),
          Positioned(
            left: TBDefVal.screenWidth.w / 2 - 100.w,
            bottom: 100.h,
            child: InkWell(
              onTap: () {
                TBUtils.saveImage(widget.galleryItems[0]);
              },
              child: Container(
                width: 200.w, // 设置按钮宽度
                height: 50.w, // 设置按钮高度
                decoration: BoxDecoration(
                  color: Colors.transparent, // 设置按钮背景颜色为透明
                  borderRadius: BorderRadius.circular(25.0.w), // 设置按钮圆角
                  border: Border.all(
                    color: TBDefVal.chatThemePinkColor, // 设置边框颜色
                    width: 1.w, // 设置边框宽度
                  ),
                ),
                child: Center(
                  child: Text(
                    '保存图片',
                    style: TextStyle(
                      color: TBDefVal.chatThemePinkColor,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
