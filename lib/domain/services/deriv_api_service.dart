import 'dart:async';

import 'package:flutter/material.dart';
import 'package:price_tracker_challenge/domain/models/constants.dart';
import 'package:price_tracker_challenge/domain/models/deriv_api_response_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class DerivAPIService {
  void onReceive(dynamic event);
}

class DerivAPIServiceImpl extends DerivAPIService {
  // Instantiate helper class
  DerivAPIResponseHelper helper = DerivAPIResponseHelper();

  // Setup Streams
  final _webSocketChannel = WebSocketChannel.connect(
    Uri.parse("wss://ws.binaryws.com/websockets/v3?app_id=1089"),
  );
  //setup response model stream controllers
  final StreamController<DerivAPIResponseModel> _responseCtrlr =
      StreamController<DerivAPIResponseModel>.broadcast();

  // getter access the stream from other classes
  Stream<DerivAPIResponseModel> get responseStream =>
      _responseCtrlr.stream.asBroadcastStream();

  @override
  void onReceive(dynamic event) {
    // Parse json response into an actual Dart model to be used by UI
    DerivAPIResponseModel response = helper.generateModelFromResponse(event);
    // Pass down the Dart model down the sink
    _responseCtrlr.sink.add(response);
  }

  void setStreamListeners() {
    _webSocketChannel.stream.listen(onReceive);
  }

  // Requests to the socket sever
  fetchTicks(String tickId) {
    debugPrint('fetching tick with ID: $tickId');
    _webSocketChannel.sink
        .add('{"ticks": "$tickId", "subscribe": 1, "req_id":2}');
  }

  fetchActiveSymbols() {
    _webSocketChannel.sink
        .add('{"active_symbols":"brief","product_type":"basic"}');
  }

  disposeTickStream(String tickId) {
    debugPrint('forgetting tick with ID: $tickId');
    _webSocketChannel.sink.add('{"forget": "$tickId"}');
  }
}
