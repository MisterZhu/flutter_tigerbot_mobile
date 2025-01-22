/// 网络请求
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/tb_config.dart';
import '../../constant/tb_default_value.dart';
import '../../constant/tb_export_common.dart';
import '../provider/user_info_provider.dart';
import '../tb_loading_utils.dart';
import '../tb_utils.dart';

class SCHttpManager {
  factory SCHttpManager() => _getInstance();

  static SCHttpManager get instance => _getInstance();

  static SCHttpManager? _instance;

  late Dio _dio;

  late BaseOptions _baseOptions;

  late Map<String, dynamic> _headers;

  Dio get dio => _dio;

  BaseOptions get baseOptions => _baseOptions;

  Map<String, dynamic> get headers => _headers;

  SCHttpManager._internal() {
    _init();
  }
// 添加一个静态方法用于初始化
  static Future<void> init() async {
    SCHttpManager instance = _getInstance();
    await instance._init();
  }

  Future<void> _init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    String? token = sharedPreferences.getString(TBDefVal.kToken);
    if (token != null) {
      _headers['token'] = token;
    }

    print('----------- token: $token');

    _baseOptions = BaseOptions(
      baseUrl: TBConfig.BASE_URL,
      connectTimeout: Duration(milliseconds: TBDefVal.timeOut),
      receiveTimeout: Duration(milliseconds: TBDefVal.timeOut),
      sendTimeout: Duration(milliseconds: TBDefVal.timeOut),
      headers: _headers,
    );

    _dio = Dio(_baseOptions);
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  static SCHttpManager _getInstance() {
    _instance ??= SCHttpManager._internal();
    return _instance!;
  }

  void updateHeaders(Map<String, dynamic> headers) {
    _headers = headers;
    _baseOptions.headers = _headers;
    _dio.options = _baseOptions;
  }

  /// 通用的GET请求
  Future get(
      {required String url,
      dynamic params,
      Map<String, dynamic>? headers,
      Function(dynamic value)? success,
      Function(dynamic value)? failure}) async {
    Options options = Options(headers: headers);
    late Response response;
    late Object exception;
    bool status = false;
    try {
      response = await _dio!.get(url,
          queryParameters: params, options: headers == null ? null : options);
      status = true;
    } catch (e) {
      status = false;
      exception = e;
    } finally {
      print('--------------finally');

      // print('----------- response: $response');

      if (status) {
        print('----------- status');

        var data = doResponse(response);
        print('----------- dataonse: $data');

        success?.call(data);
      } else {
        print('----------- else');

        var data = doError(exception);
        print('----------- data: $data');

        var code = data['code'];
        // if (code != 401) {
        //   failure?.call(data);
        // }
        failure?.call(data);
      }
    }

    return Future(() => status);
  }

  /// 通用的POST请求
  Future post(
      {required String url,
      dynamic params,
      bool? isQuery,
      Map<String, dynamic>? headers,
      Function(dynamic value)? success,
      Function(dynamic value)? failure}) async {
    Options options = Options(headers: headers);
    late Response response;
    late Object exception;
    bool status = false;
    bool query = isQuery ?? false;
    print('------------------------------POST请求URL: $url');
    print('------------------------------POST请求参数: $params');

    try {
      response = await _dio!.post(url,
          queryParameters: query ? params : {},
          data: params,
          options: headers == null ? null : options);
      status = true;
    } catch (e) {
      status = false;
      exception = e;
    } finally {
      if (status) {
        var data = doResponse(response);
        checkLogin(url: url, headers: response.headers.map, data: data);
        success?.call(data);
      } else {
        var data = doError(exception);
        print('----------- post data: $data');

        var code = data['code'];
        if (code != 401) {
          Fluttertoast.showToast(
            msg: data['message'] ?? '',
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
          );
          failure?.call(data);
        }
      }
    }
    return Future(() => status);
  }

  /// 通用的PUT请求
  put(
      {required String url,
      dynamic params,
      Map<String, dynamic>? headers,
      Function(dynamic value)? success,
      Function(dynamic value)? failure}) async {
    Options options = Options(headers: headers);
    late Response response;
    late Object exception;
    bool status = false;

    try {
      response = await _dio!.put(url,
          queryParameters: params,
          data: params,
          options: headers == null ? null : options);
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

  /// 通用的DELETE请求
  delete(
      {required String url,
      dynamic params,
      Map<String, dynamic>? headers,
      Function(dynamic value)? success,
      Function(dynamic value)? failure}) async {
    Options options = Options(headers: headers);
    late Response response;
    late Object exception;
    bool status = false;

    try {
      response = await _dio!.delete(url,
          queryParameters: params,
          data: params,
          options: headers == null ? null : options);
      status = true;
    } catch (e) {
      print('----------- response: $e');

      status = false;
      exception = e;
    } finally {
      print('----------- response: $response');
      print('----------- response status: $status');

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

  /// 校验登录
  checkLogin({required String url, dynamic headers, dynamic data}) {
    // if (url == SCUrl.kPhoneCodeLoginUrl || url == SCUrl.kPhoneCodeLoginWithNameUrl) {
    //   String token = '';
    //
    //   var list = headers['authorization'];
    //   if (list != null) {
    //     int count = list.length;
    //     if (count > 0) {
    //       token = list[0];
    //       _headers!['Authorization'] = token;
    //       SCHttpManager.instance._baseOptions?.headers = _headers;
    //     }
    //   }
    //   if (data['userInfoV'] != null) {
    //     var userData = data['userInfoV'];
    //     userData['token'] = token;
    //     if (token != '') {
    //       SCScaffoldManager.instance.cacheUserIsLogin(true);
    //     }
    //     SCScaffoldManager.instance.cacheUserData(userData);
    //   }
    // }
  }
}

/// 处理dio请求成功后,网络数据解包
doResponse(Response response) {
  if (response.statusCode == 200) {
    TBLoadingUtils.hide();
    // log('成功：${response.data}');

    return response.data;
  } else {
    TBLoadingUtils.hide();
    log('失败：${response.data}');
    return response.data;
  }
}

/// 处理dio请求异常
doError(e) {
  TBLoadingUtils.hide();

  /// 错误码
  int code = 0;

  /// message
  String message = TBDefVal.errorMessage;
  print("-------------error doError ");

  if (e is DioException) {
    DioException error = e;

    if (e.error is SocketException) {
      code = 500;
      message = TBDefVal.netErrorMessage;
    } else {
      code = error.response?.statusCode ?? 500;
      print("-------------error code : $code");
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
            accountExpired();
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

/// token失效
accountExpired() {
  log('登陆已失效，清空用户数据，刷新本地缓存用户数据');
  //退出登录， 弹出登录框
  TBUtils.getCurrentContext(completionHandler: (context) async {
    UserInfoProvider userInfoProvider = Provider.of(context, listen: false);
    userInfoProvider.logout();
    Navigator.of(context).pushNamed(TBRouterPath.loginPath);
  });
}
