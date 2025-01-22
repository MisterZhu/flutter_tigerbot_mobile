import 'dart:convert';
import 'dart:io';

import 'package:TigerChat/util/provider/user_info_provider.dart';
import 'package:TigerChat/util/request/response/TBResponse.dart';
import 'package:TigerChat/util/tb_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import '../../constant/tb_config.dart';
import '../../constant/tb_default_value.dart';
import '../router/tb_router_helper.dart';
import 'tb_url.dart';
import '../router/tb_router_path.dart';
import '../tb_loading_utils.dart';

class TBHttpRequest {
  static Dio? _dioInstance;

  static Dio? getDioInstance(BuildContext context) {
    if (_dioInstance == null) {
      BaseOptions options = BaseOptions(
          receiveDataWhenStatusError: true, baseUrl: TBConfig.BASE_URL);

      _dioInstance = Dio(options);

      Interceptor dInter = InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
        final params =
            (options.method == "get") ? options.queryParameters : options.data;
        SharedPreferences.getInstance()
            .then((SharedPreferences sharedPreferences) {
          String? token = sharedPreferences.getString(TBDefVal.kToken);
          if (token != null) {
            options.headers["token"] = token;
          }
          options.headers["Content-Type"] = "application/json;charset=UTF-8";
          print(
              "拦截了请求 :{{ \n methods: ${options.method} \n uri: ${options.uri} \n params: $params \n headers: ${options.headers} \n }}");
          handler.next(options);
        });
      }, onResponse: (Response response, ResponseInterceptorHandler handler) {
        print("拦截了响应 ${response.data}");
        handler.next(response);
      }, onError:
          (DioException exception, ErrorInterceptorHandler handler) async {
        print("拦截了错误 $exception");
        handler.next(exception);

        int? code = exception.response?.statusCode;
        print("拦截了错误 code $code");
        String? msgg = exception.message;
        print("拦截了错误 message $msgg");
        if (code == 401) {
          //退出登录， 弹出登录框
          // UserInfoProvider userInfoProvider =
          //     Provider.of(context, listen: false);
          // userInfoProvider.logout();
          // Navigator.of(context).pushNamed(TBRouterPath.loginPath);
          TBRouterHelper.pathOffAllPage(TBRouterPath.loginPath, null);
        } else if (code == 403) {
          print("------------拦截了错误 response ${exception.response?.data}");
          if (exception.response?.data is ResponseBody) {
            final body = exception.response?.data as ResponseBody;
            try {
              // 使用dio提供的方法将响应体解析为字符串
              final errorString = await utf8.decodeStream(body.stream);
              print("------------拦截了错误 body $errorString");
              // 解析JSON格式的错误信息
              try {
                final errorData = json.decode(errorString);
                final errorCode = errorData['code'];
                final errorMessage = errorData['msg'];
                Fluttertoast.showToast(
                  msg: errorMessage,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 3,
                );
              } catch (e) {
                print("Error parsing JSON: $e");
              }
            } catch (e) {
              print("Error reading ResponseBody: $e");
            }
          }
        } else if (code == 402) {
          if (exception.response != null) {
            if (exception.response?.data is ResponseBody) {
              bool hasExecuted = false; // 增加一个标志
              final body = exception.response?.data as ResponseBody;
              final decodedStream = body.stream
                  .map((uint8List) => String.fromCharCodes(uint8List));
              decodedStream.listen((String data) {
                print('Received: $data');
                if (!hasExecuted && data.contains('"code":4102') ||
                    data.contains('"code":4103')) {
                  hasExecuted = true; // 设置标志为 true，防止再次执行
                  TBUtils().showTeenModelState((data.contains('"code":4102'))
                      ? '今日对话轮次已达到50次，休息一下吧~'
                      : '青少年模式限制每日晚22时至次日早6时无法开启对话哦，休息一下吧~');
                } else if (data.contains('"code":2006')) {}
              }, onDone: () {
                print('Stream is done.');
              });
            } else {
              Map data = exception.response?.data;
              String msg = data["msg"] ?? exception.message ?? "exception";
              Fluttertoast.showToast(msg: msg);
              print('------ error msg: ${data["msg"] ?? ''}');
            }
          }
        }
      });

      List<Interceptor> inters = [dInter];
      _dioInstance?.interceptors.addAll(inters);
    }

    return _dioInstance;
  }

  static Future<TBResponse> request<T>(String url, BuildContext context,
      {String method = 'get',
      Map<String, dynamic>? params,
      Options? options,
      Interceptor? inter}) async {
    if (method == "get") {
      try {
        Response? response = await getDioInstance(context)
            ?.get<T>(url, queryParameters: params, options: options);
        print("response ${response?.data}");
        return TBHttpResponse.fromJson(response?.data);
      } on DioException catch (e) {
        print("response e $e");
        TBLoadingUtils.hide();

        return Future.error(e);
      }
    } else if (method == "post") {
      try {
        Response? response = await getDioInstance(context)
            ?.post<T>(url, data: params, options: options);
        if (options?.responseType == ResponseType.stream) {
          if (response?.statusCode == 200) {
            // 请求成功，处理数据
            print("response1 ${response?.data}");
            // ...
          } else {
            print('Server error1: ${response?.statusCode}');
          }
          return TBStreamResponse.fromBody(response?.data);
        } else {
          // if (response?.statusCode == 200) {
          //   // 请求成功，处理数据
          //   print("response2 ${response?.data}");
          //   // ...
          // }else{
          //   print('Server error2: ${response?.statusCode}');
          // }
          TBHttpResponse httpResponse =
              TBHttpResponse.fromJson(response?.data ?? {});
          print("response ${response?.data}");

          return httpResponse;
        }
      } on DioException catch (e) {
        print('Error sending request1: $e');

        if (e.response != null) {
          print('-------Server error: ${e.response?.data}');
          Fluttertoast.showToast(
              msg: e.response?.data['msg'] ?? '', gravity: ToastGravity.CENTER);
        } else {
          print('-------Error sending request2: $e');
        }
        TBLoadingUtils.hide();

        return Future.error(e);
      }
    } else {
      try {
        Response? response = await getDioInstance(context)
            ?.delete<T>(url, queryParameters: params, options: options);
        print("response ${response?.data}");
        return TBHttpResponse.fromJson(response?.data);
      } on DioException catch (e) {
        print("response e $e");
        TBLoadingUtils.hide();

        return Future.error(e);
      }
    }
  }

  static Future<TBResponse> get<T>(String url, BuildContext context,
      {Map<String, dynamic>? params, Interceptor? inter}) async {
    {
      return TBHttpRequest.request(url, context, params: params, inter: inter);
    }
  }

  static Future<TBResponse> post<T>(String url, BuildContext context,
      {Map<String, dynamic>? params, Interceptor? inter}) async {
    {
      return TBHttpRequest.request(url, context,
          method: "post", params: params, inter: inter);
    }
  }

  static Future<TBResponse> delete<T>(String url, BuildContext context,
      {Map<String, dynamic>? params, Interceptor? inter}) async {
    {
      return TBHttpRequest.request(url, context,
          method: "delete", params: params, inter: inter);
    }
  }

  static Future<TBResponse> postStream<T>(String url, BuildContext context,
      {Map<String, dynamic>? params, Interceptor? inter}) async {
    {
      Options options = Options(responseType: ResponseType.stream);
      return TBHttpRequest.request(url, context,
          method: "post", params: params, options: options, inter: inter);
    }
  }

  static Future uploadFile(
      {required String baseUrl,
      required String fileName,
      required String filePath,
      Function(dynamic value)? success,
      Function(dynamic value)? failure}) async {
    late Response response;
    bool status = false;
    late Object exception;
    try {
      BaseOptions options = BaseOptions(
          receiveDataWhenStatusError: true, baseUrl: TBConfig.BASE_URL);
      FormData formData = FormData.fromMap({
        'content': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
      };
      String? token = sharedPreferences.getString(TBDefVal.kToken);
      if (token != null) {
        headers["token"] = token;
      }
      print(options.headers);
      response = await Dio().post(
        baseUrl,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      status = true;
    } catch (e) {
      status = false;
      exception = e;
    } finally {
      if (status) {
        var data = doResponse(response);
        success?.call(data);
      } else {
        var data = doError(exception);
        var code = data['code'];
        if (code != 401) {
          failure?.call(data);
        }
      }
    }
  }

  static Future uploadAudioFile(
      {required String filePath,
      Function(dynamic value)? success,
      Function(dynamic value)? failure}) async {
    late Response response;
    bool status = false;
    late Object exception;

    try {
      // 使用path库获取文件名
      String fileName = path.basename(filePath);
      print('fileName = $fileName');
      FormData formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      print(
          'fileName = ${MultipartFile.fromFile(filePath, filename: fileName)}');
      response = await Dio().post(
        TBUrl.kASRCloudUrl,
        data: formData,
      );
      status = true;
    } catch (e) {
      status = false;
      exception = e;
    } finally {
      if (status) {
        var data = doResponse(response);
        success?.call(data);
      } else {
        var data = doError(exception);
        var code = data['code'];
        if (code != 401) {
          failure?.call(data);
        }
      }
    }
  }

  /// 处理dio请求成功后,网络数据解包
  static doResponse(Response response) {
    if (response.statusCode == 200) {
      TBLoadingUtils.hide();
      return response.data;
    } else {
      TBLoadingUtils.hide();
      print('失败：${response.data}');
      return response.data;
    }
  }

  /// 处理dio请求异常
  static doError(e) {
    TBLoadingUtils.hide();

    /// 错误码
    int code = 0;

    /// message
    String message = TBDefVal.errorMessage;

    if (e is DioException) {
      DioException error = e;
      if (e.error is SocketException) {
        code = 500;
        message = TBDefVal.netErrorMessage;
      } else {
        code = error.response?.statusCode ?? 500;
        switch (error.response?.statusCode) {
          case 201:
            {}
            break;
          case 300:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;
          case 400:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;

          case 401:
            {
              /// 登录失效
              TBUtils.getCurrentContext(completionHandler: (context) async {
                UserInfoProvider userInfoProvider =
                    Provider.of(context, listen: false);
                userInfoProvider.logout();
                Navigator.of(context).pushNamed(TBRouterPath.loginPath);
              });
            }
            break;
          case 402:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;
          case 403:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;

          case 404:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;

          case 405:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;

          case 500:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;
          case 503:
            {
              if (error.response?.data is Map) {
                var errorData = error.response?.data;
                message = errorData['msg'] ?? TBDefVal.errorMessage;
              } else {
                message =
                    error.response?.data.toString() ?? TBDefVal.errorMessage;
              }
            }
            break;
        }
      }
    } else {
      code = 500;
      message = TBDefVal.errorMessage;
    }

    var params = {
      'code': code,
      'message': message,
    };
    return params;
  }
}
