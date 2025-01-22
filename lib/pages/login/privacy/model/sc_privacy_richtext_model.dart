
/// 用户协议和隐私政策弹窗page-勾选协议的富文本model

class SCPrivacyRichTextModel {
  SCPrivacyRichTextModel({
    /// 协议富文本类型, 0-间隔,1-image,2-普通文本
    int? type,

    /// 标题
    String? title,

    /// 图片url,一般为本地图片路径
    String? imageUrl,

    /// 点击跳转的url
    String? url,

    /// 标题文本颜色
    String? color,
  }) {
    _type = type;
    _title = title;
    _imageUrl = imageUrl;
    _url = url;
    _color = color;
  }

  SCPrivacyRichTextModel.fromJson(dynamic json) {
    _type = json['type'];
    _title = json['title'];
    _imageUrl = json['imageUrl'];
    _url = json['url'];
    _color = json['color'];
  }
  int? _type;
  String? _title;
  String? _imageUrl;
  String? _url;
  String? _color;
  SCPrivacyRichTextModel copyWith({
    int? type,
    String? title,
    String? imageUrl,
    String? url,
    String? color,
  }) =>
      SCPrivacyRichTextModel(
        type: type ?? _type,
        title: title ?? _title,
        imageUrl: imageUrl ?? _imageUrl,
        url: url ?? _url,
        color: color ?? _color,
      );
  num? get type => _type;
  String? get title => _title;
  String? get imageUrl => _imageUrl;
  String? get url => _url;
  String? get color => _color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['title'] = _title;
    map['imageUrl'] = _imageUrl;
    map['url'] = _url;
    map['color'] = _color;
    return map;
  }
}
