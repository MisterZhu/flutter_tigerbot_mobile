import 'package:TigerChat/constant/tb_default_value.dart';
import 'package:get/get.dart';

/// 用户协议和隐私政策的GetXController

class TBPrivacyLogic extends GetxController {
  /// 标题
  String title = '';

  /// 正文
  String content = '';

  /// 描述
  String description = '';

  /// 同意
  String agreeString = '同意';

  /// 用户协议
  String userAgreement = '';

  /// 用户协议url
  String userAgreementUrl = '';

  /// 和
  String andString = '和';

  /// 隐私政策
  String privacyPolicy = '隐私政策';

  /// 隐私政策url
  String privacyPolicyUrl = '';

  /// 是否同意相关协议，默认不同意
  bool isAgree = false;

  @override
  onInit() {
    super.onInit();
    title = '用户协议和隐私政策';
    content =
        '尊敬的用户：\n        您好！感谢您信任${TBDefVal.appName}APP，为了更好的保障您的个人权益，在您使用我们的产品和服务前，请仔细读并理解《用户协议》和《隐私政策》的相关条款，其中重点条款内容已为您加粗标注，以便您了解自己的权利。为了提供更好的服务功能，我们会根据您的授权，收集和使用对应的必要信息，同时您有权拒绝授权。我们深知个人信息及隐私的重要性，如涉及到您个人敏感信息，只有在您确认同意后，我们才会进行收集。同时，未经您授权同意，我们不会将您的信息直接获取、共享于第三方或用于其他用途。';
    description = "${TBDefVal.appName}APP用户协议和隐私政策已于2022年9月更新";
  }

  /// 更新勾选协议状态
  updateAgreementState() {
    isAgree = !isAgree;
    update();
  }
}
