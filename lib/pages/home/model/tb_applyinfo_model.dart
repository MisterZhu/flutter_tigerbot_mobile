class TBApplyInfoModel {
  int? id;
  int? userId;
  int? applyStatus;
  String? msg;
  String? auditTime;
  String? createTime;
  bool? isDeleted;
  String? mobile;
  String? email;
  String? entity;
  String? useWay;
  int? apiStatus;
  String? apiExpireTime;

  TBApplyInfoModel(
      {this.id,
        this.userId,
        this.applyStatus,
        this.msg,
        this.auditTime,
        this.createTime,
        this.isDeleted,
        this.mobile,
        this.email,
        this.entity,
        this.useWay,
        this.apiStatus,
        this.apiExpireTime});

  TBApplyInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    applyStatus = json['applyStatus'];
    msg = json['msg'];
    auditTime = json['auditTime'];
    createTime = json['createTime'];
    isDeleted = json['isDeleted'];
    mobile = json['mobile'];
    email = json['email'];
    entity = json['entity'];
    useWay = json['useWay'];
    apiStatus = json['apiStatus'];
    apiExpireTime = json['apiExpireTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['applyStatus'] = this.applyStatus;
    data['msg'] = this.msg;
    data['auditTime'] = this.auditTime;
    data['createTime'] = this.createTime;
    data['isDeleted'] = this.isDeleted;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['entity'] = this.entity;
    data['useWay'] = this.useWay;
    data['apiStatus'] = this.apiStatus;
    data['apiExpireTime'] = this.apiExpireTime;
    return data;
  }
}
