import 'package:flutter/material.dart';

class CustomShareView extends StatelessWidget {

  final List buttonTitles = ["微信好友","朋友圈","新浪微博"];
  final List buttonImages = ["chat_input_message.png", "chat_input_message.png",
    "chat_input_message.png"];

  static showShareView(BuildContext context) {
    showModalBottomSheet(context: context,
        backgroundColor: Colors.white.withAlpha(0),
        elevation: 2,
        builder: (BuildContext context){
          return ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              height: 250,
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 14, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("分享到", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(51, 51, 51, 1)
                          ),),
                          GestureDetector(
                            onTap: (){
                              CustomShareView()._dismiss(context);
                            },
                            child: Image.asset("assets/images/chat/chat_input_clear.png"),
                          ),
                        ],
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(CustomShareView().buttonTitles.length, (index){
                        return Container(
                          child: CustomShareView()._buttonWidget(context, CustomShareView().buttonTitles[index],
                              CustomShareView().buttonImages[index], index),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        });

  }

  _buttonWidget(BuildContext context, String title, String imageName, int index) {
    return GestureDetector(
      onTap: (){
        switch (index) {
          case 0://微信好友
            print("微信好友");
            _dismiss(context);
            break;
          case 1://朋友圈
            print("朋友圈");
            _dismiss(context);
            break;
          case 2://新浪微博
            print("新浪微博");
            _dismiss(context);
            break;
          default:
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/chat/$imageName"),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(title, style:TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(51, 51, 51, 1)
            )),
          )
        ],
      ),
    );
  }

  _dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // 返回一个空的Container作为视图
  }
}

