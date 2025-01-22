import 'package:TigerChat/constant/tb_export_common.dart';
import 'package:get/get.dart';

import '../../../util/request/http_request.dart';
import '../../../util/request/response/TBResponse.dart';
import '../../../util/request/tb_url.dart';
import '../../../util/tb_loading_utils.dart';
import '../../../util/tb_utils.dart';
import 'feedback_state.dart';

class FeedbackLogic extends GetxController {
  final FeedbackState state = FeedbackState();

  /// 提交反馈
  feedbackRequest() {
    if (state.inputController.text.isEmpty) {
      TBLoadingUtils.info(text: '请输入反馈内容');
      return;
    }
    TBLoadingUtils.show();
    TBUtils.getCurrentContext(completionHandler: (context) async {
      TBHttpResponse response = await TBHttpRequest.post(
              TBUrl.kIssuesUrl, context,
              params: {"type": "report", "content": state.inputController.text})
          as TBHttpResponse;
      if (response.code == 0) {
        TBLoadingUtils.hide();
        TBLoadingUtils.success(text: "反馈提交成功");
        TBRouterHelper.back(null);
      } else {
        TBLoadingUtils.hide();
      }
    });
  }
}
