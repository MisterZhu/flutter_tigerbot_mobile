import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/tb_default_value.dart';

class UserInfoProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _name = "";

  String _token = "";

  String _avatar = "";

  String _mobile = "";

  String _account = "";

  String _uuid = "";

  String _intro = "";
  String _wechat = "";
  String _wechatName = "";

  bool get isLogin => _token.isNotEmpty;

  String get account => _account;

  set account(String account) {
    _account = account;
    notifyListeners();
  }

  String get uuid => _uuid;

  set uuid(String uuid) {
    _uuid = uuid;
    notifyListeners();
  }

  String get intro => _intro;

  set intro(String intro) {
    _intro = intro;
    notifyListeners();
  }

  String get wechat => _wechat;

  set wechat(String wechat) {
    _wechat = wechat;
    notifyListeners();
  }

  String get wechatName => _wechatName;

  set wechatName(String wechatName) {
    _wechatName = wechatName;
    notifyListeners();
  }

  String get name => _name;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String get token => _token;

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  String get avatar => _avatar;

  set avatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  String get mobile => _mobile;

  set mobile(String mobile) {
    _mobile = mobile;
    notifyListeners();
  }

  bool _isSearchMode = false; // 搜索模式

  bool get isSearchMode => _isSearchMode;

  set searchMode(bool searchMode) {
    _isSearchMode = searchMode;
    notifyListeners();
  }

  bool _isMulConversation = false; // 搜索模式

  bool get isMulConversation => _isMulConversation;

  set mulConversation(bool mulConversation) {
    _isMulConversation = mulConversation;
    notifyListeners();
  }

  login(Map data, {bool isLocalSave = false}) {
    this.token = data["token"];
    this.name = data["user"]["name"];
    this.avatar = data["user"]["avatar"];
    this.mobile = data["user"]["mobile"];
    this.intro = data["user"]["intro"];
    this.uuid = data["user"]["uuid"];
    this.account = data["user"]["account"];
    this.wechat = data["user"]["wechat"];
    this.wechatName = data["user"]["wechatName"];

    bool isSearchMode = data["isSearchMode"] ?? false;
    this.searchMode = isSearchMode;

    bool isMulRounds = data["isMulRounds"] ?? false;
    // this.mulRounds = isMulRounds;

    if (isLocalSave) {
      localSave();
    }
  }

  localSave() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    Map info = {
      "token": token,
      "user": {"name": name, "avatar": avatar, "mobile": mobile},
      "isSearchMode": isSearchMode,
      // "isMulRounds": isMulRounds
    };
    String infoStr = json.encode(info);

    prefs.setString(TBDefVal.kUserInfo, infoStr).then((value) {});
    if (token.isNotEmpty) {
      prefs.setString(TBDefVal.kToken, token);
    }
    if (mobile.isNotEmpty) {
      prefs.setString(TBDefVal.kMobile, mobile);
    }
  }

  SharedPreferences? sharedPreferences;

  logout() async {
    this.token = "";
    this.name = "";
    this.avatar = "";
    this.mobile = "";
    this.searchMode = false;
    // this.mulRounds = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(TBDefVal.kUserInfo);
    prefs.remove(TBDefVal.kToken);
  }

  Future<void> updateAvatar(String newAvatarUrl) async {
    this.avatar = newAvatarUrl;
    notifyListeners();
    localSave();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(BoolProperty('count', _count));
  }
}
