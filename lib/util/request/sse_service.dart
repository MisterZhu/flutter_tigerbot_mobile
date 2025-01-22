import 'dart:async';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';

class SSEService {
  StreamController<SSEModel> _controller =
      StreamController<SSEModel>.broadcast();

  Stream<SSEModel> get stream => _controller.stream;

  Future<void> subscribeToSSE({
    required SSERequestType method,
    required String url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final sseStream = SSEClient.subscribeToSSE(
        method: method,
        url: url,
        header: headers,
        body: body,
      );

      sseStream.listen(
        (event) {
          _controller.add(event);
        },
        onError: (error) {
          _controller.addError(error);
        },
        onDone: () {
          _controller.close();
        },
      );
    } catch (e) {
      _controller.addError(e);
    }
  }

  void dispose() {
    _controller.close();
  }
}
