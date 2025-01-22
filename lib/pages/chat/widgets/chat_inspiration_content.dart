import 'dart:async';
import 'dart:convert';

import 'package:TigerChat/util/provider/chat_provider.dart';
import 'package:TigerChat/util/request/http_request.dart';
import 'package:TigerChat/util/request/response/TBResponse.dart';
import 'package:TigerChat/widgets/common_config.dart';
import 'package:TigerChat/widgets/rectangle_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../util/request/tb_url.dart';
import '../../../util/tb_loading_utils.dart';
import '../../../util/tb_utils.dart';

class ChatInspirationContent extends StatefulWidget {
  ChatInspirationContent({super.key});

  @override
  State<ChatInspirationContent> createState() => _ChatInspirationContentState();
}

class _ChatInspirationContentState extends State<ChatInspirationContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List _tabs = [];

  List<Map>? _datas;

  List? _types;

  @override
  void initState() {
    super.initState();
    TBLoadingUtils.show();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TBHttpResponse response = await TBHttpRequest.post(
              TBUrl.kKeyViewUrl, context, params: {"key": "cases"})
          as TBHttpResponse;
      if (response.success) {
        TBLoadingUtils.hide();
        print("隐藏加载快");

        Map<String, dynamic> map = jsonDecode(response.data);
        _datas = map.values.map((e) {
          var key = TBUtils.isChineseLan() ? "type_cn" : "type_en";
          var type = e[key];
          var data = e["data"];
          return {type: data};
        }).toList();

        _types = _datas?.map((e) => e.keys.first).toList();

        if (_types != null) {
          setState(() {
            _tabs = _types!;
            _tabController = TabController(length: _types!.length, vsync: this);
          });
        }
      }else{
        TBLoadingUtils.hide();
      }
    });

    // getLocalJson("cases").then((value) {
    //   _datas = value.values.map((e) {
    //     var type = e["type"];
    //     var data = e["data"];
    //     return {type: data};
    //   }).toList();
    //
    //   _types = _datas?.map((e) => e.keys.first).toList();
    //
    //   if (_types != null) {
    //     setState(() {
    //       _tabs = _types!;
    //       _tabController = TabController(length: _types!.length, vsync: this);
    //     });
    //   }
    // });
    _tabs = [];
  }

  Future<Map<String, dynamic>> getLocalJson(String jsonName) async {
    Map<String, dynamic> map = jsonDecode(
        await rootBundle.loadString("assets/data/" + jsonName + ".json"));
    return map;
  }

  List<Widget> tabs() {
    List<Widget> widgets = [];
    for (var i = 0; i < _tabs.length; i++) {
      String text = _tabs[i];
      Widget w = Container(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Color(
              customColor(i),
            ),
          ),
          child: AutoSizeText(
            text,
            style: TextStyle(fontSize: 12), // 设置最小的字体大小
            maxLines: 1, // 文本的最大行数
          ));
      widgets.add(w);
    }
    return widgets;
  }

  List<Widget> tabViews() {
    return _tabs.map((e) {
      int i = _tabs.indexOf(e);
      var d = _datas?[i];
      var values = d?.values;
      var data = values?.first;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.w,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.1),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var currentData = data[index];
              return GestureDetector(
                onTap: () {
                  ChatProvider chatProvider =
                      Provider.of<ChatProvider>(context, listen: false);
                  var text = currentData[
                  TBUtils.isChineseLan() ? "question_cn" : "question_en"];
                  chatProvider.editText = text;
                  Get.back();
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(customColor(index)),
                        border: Border.all(color: Color(0xffFF98AC)),
                        borderRadius: BorderRadius.circular(10.w)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 12.w, left: 16.w),
                          child: Text(
                            currentData[
                            TBUtils.isChineseLan() ? "title" : "title_en"],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 6.w, left: 16.w, right: 8.w),
                            child: Text(
                              currentData[TBUtils.isChineseLan()
                                  ? "question_cn"
                                  : "question_en"],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  height: 1.8,
                                  color: Color(0xff6B6B6B),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            }),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _tabs.length == 0
        ? Container()
        : Column(
            children: [
              SizedBox(
                height: 20.w,
              ),
              Container(
                height: 30.w,
                child: TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: RectangleIndicator(
                      paintingStyle: PaintingStyle.stroke,
                      rectangleColor: Color(0xffFF98AC),
                      // padding: EdgeInsets.symmetric(horizontal: 10.w),
                      radius: 15.w),
                  controller: _tabController,
                  labelColor: Color(0xffFF98AC),
                  unselectedLabelColor: Colors.black,
                  tabs: tabs(),
                ),
              ),
              SizedBox(
                height: 15.w,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabViews(),
                ),
              )
            ],
          );
  }
}
