import 'dart:typed_data';

import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:dio/dio.dart';

abstract class TBResponse {
  late int code;

  late String msg;

  late bool success;
}

class TBHttpResponse<T> extends TBResponse {
  late T? data;

  TBHttpResponse();

  TBHttpResponse.fromJson(Map json) {
    this.code = json["code"] ?? 0;
    this.msg = json["msg"] ?? "";
    this.data = json["data"];
    this.success = (this.code == 200);
  }

  static error({String msg = ""}) {
    TBHttpResponse response = TBHttpResponse();
    response.success = false;
    if (msg != null) {
      response.msg = msg ?? "";
    } else {
      response.msg = 'failed. Please try again later!'.tr;
    }
    return response;
  }
}

class TBStreamResponse extends TBResponse {
  late Stream<Uint8List> stream;

  TBStreamResponse.fromBody(ResponseBody body) {
    this.code = body.statusCode;
    this.msg = body.statusMessage ?? "";
    this.stream = body.stream;
    this.success = (this.code == 200);
  }
}
