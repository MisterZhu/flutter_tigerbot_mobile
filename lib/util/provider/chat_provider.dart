import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isStreamLoading = false;

  set streamLoading(bool streamLoading) {
    _isStreamLoading = streamLoading;
    notifyListeners();
  }

  bool get isStreamLoading => _isStreamLoading;

  List _session = [];

  sessionAddHuman(String text) {
    Map item = {"human": text};
    _session.add(item);
    notifyListeners();
  }

  sessionAddAssistant(String text) {
    Map? last = _session.lastOrNull;

    if (last != null && last["assistant"] == null) {
      last["assistant"] = text;

      if (_session.length == 4) {
        _session.removeAt(0);
      }
      notifyListeners();
    }
  }

  clearSession() {
    _session = [];
    notifyListeners();
  }

  get session {
    return _session.where((element) {
      return element["assistant"] != null;
    }).toList();
  }

  bool _isEditMode = false;

  set editMode(bool value) {
    _isEditMode = value;
    if (!value) {
      this.choiceAll = false;
    }
    notifyListeners();
  }

  bool get isEditMode => _isEditMode;

  // 全选一定进去编辑模式
  bool _isChoiceAll = false;

  set choiceAll(bool value) {
    _isChoiceAll = value;
    if (value) {
      this.editMode = true;
    }
    notifyListeners();
  }

  bool get isChoiceAll => _isChoiceAll;

  // requestCell 点击编辑
  String _editText = "";

  set editText(String value) {
    _editText = value;
    if (value.isNotEmpty) {
      notifyListeners();
    }
  }

  String get editText => _editText;

  // 是否隐藏chatBottom
  bool _hiddenChatBottom = false;

  set hiddenChatBottom(bool value) {
    _hiddenChatBottom = value;
    notifyListeners();
  }

  bool get hiddenChatBottom => _hiddenChatBottom;

  // 是否停止生成
  bool _stopGenerate = false;

  set stopGeneration(bool value) {
    print("stopGeneration $value");
    _stopGenerate = value;
    notifyListeners();
  }

  bool get isStopGeneration => _stopGenerate;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(BoolProperty('count', _count));
  }
}
