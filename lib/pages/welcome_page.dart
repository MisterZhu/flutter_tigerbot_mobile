import 'package:TigerChat/pages/chat/widgets/content_bottom.dart';
import 'package:TigerChat/pages/chat/widgets/content_top.dart';
import 'package:flutter/material.dart';

/// 首页
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _textButton(String text, void Function() onPressed) {
    return TextButton(
      style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: Colors.white, width: 3)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          backgroundColor: MaterialStateProperty.all(Colors.black),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      child: Text(text),
      onPressed: onPressed,
    );
  }

  Widget get _content {
    return Container(
      child: Column(
        children: [
          Text(
            "TigerChat",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "For a better world",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _textButton("申请内测", () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          //         return LoginPage();
          //       }));
          //     }),
          //     SizedBox(
          //       width: 20,
          //     ),
          //     _textButton("邀请码", () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          //         return LoginPage();
          //       }));
          //     }),
          //   ],
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ContentTop(), _content, ContentBottom()],
        ));
  }
}
