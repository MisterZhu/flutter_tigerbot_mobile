import '../../../constant/tb_export_common.dart';

class FeedbackState {
  //输入框控制器，一般用于获取文本、修改文本等
  TextEditingController inputController = TextEditingController();
//焦点节点，一般用于自动获取焦点，取消焦点以便隐藏键盘等
  FocusNode inputFocusNode = FocusNode();

  FeedbackState() {
    ///Initialize variables
  }
}
