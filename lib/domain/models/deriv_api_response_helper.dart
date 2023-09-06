import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:price_tracker_challenge/domain/models/constants.dart';
import 'package:price_tracker_challenge/domain/models/tick_response_model.dart';
import 'package:price_tracker_challenge/domain/models/symbol_response_model.dart';
import 'package:price_tracker_challenge/domain/models/forget_response_model.dart';

class DerivAPIResponseHelper {
  DerivAPIResponseModel generateModelFromResponse(dynamic response) {
    final jsonResponse = json.decode(response);
    DerivAPIResponseType responseType =
        DerivAPIResponseType.fromValue(jsonResponse['msg_type']);
    switch (responseType) {
      case DerivAPIResponseType.activeSymbols:
        return SymbolResponseModel.fromJson(jsonResponse);
      case DerivAPIResponseType.tick:
        return TickResponseModel.fromJson(jsonResponse);
      case DerivAPIResponseType.forget:
        return ForgetResponseModel.fromJson(jsonResponse);
      default:
        debugPrint('[FROM ResponseHelper] Unknown response received');
        throw (NullThrownError);
    }
  }
}
