import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:price_tracker_challenge/domain/models/constants.dart';
import 'package:price_tracker_challenge/domain/models/symbol_response_model.dart';
import 'package:price_tracker_challenge/domain/models/tick_response_model.dart';
import 'package:price_tracker_challenge/domain/services/deriv_api_service.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  TickerCubit(this.api) : super(TickerInitial());
  final DerivAPIServiceImpl api;
  late final StreamSubscription _responseStream;
  init() {
    // Start listening to the 'response' stream after initialization
    _addListeners();
  }

  void _addListeners() {
    _responseStream = api.responseStream.listen(_onResponseReceived);
  }

  // We receive Dart models of our responses, where we handle the business logic and store models in the state layer
  _onResponseReceived(DerivAPIResponseModel responseModel) {
    switch (responseModel.responseType) {
      case DerivAPIResponseType.activeSymbols:
      case DerivAPIResponseType.tick:
        TickResponseModel response = responseModel as TickResponseModel;
        if (response.error != null) {
          emit(TickerError(response));
          return;
        }
        // first time this ticker's price is fetched
        if (state is! TickerLoaded) {
          emit(TickerPriceConstant(response));
        } else {
          final loadedTickState = state as TickerLoaded;
          // Get the old and new quota
          final double? newPrice = response.tick?.quote;
          double? oldPrice = loadedTickState.ticker.tick?.quote;

          if (newPrice == null || oldPrice == null) return;
          newPrice == oldPrice
              ? emit(TickerPriceConstant(response))
              : newPrice > oldPrice
                  ? emit(TickerPriceIncreased(response))
                  : emit(TickerPriceDecreased(response));
          return;
        }
        break;
      case DerivAPIResponseType.forget:
    }
  }

// subscribe to a symbol with specific ID
  void subscribeTicker(ActiveSymbol? symbol) {
    if (symbol == null) return;
    emit(TickerLoading());
    final String? tickSymbol = symbol.symbol;
    if (tickSymbol == null) return;
    api.fetchTicks(tickSymbol);
  }

  // unsubscribe to a symbol with specific ID
  void unsubscribeTicker() {
    if (state is TickerLoaded) {
      TickerLoaded loadedTickerState = state as TickerLoaded;
      String? tickerId = loadedTickerState.ticker.subscription?.id;
      if (tickerId == null) return;
      api.disposeTickStream(tickerId);
    }
  }

  // Don't forget to dispose of stream subscriptions
  @override
  Future<void> close() {
    _responseStream.cancel();
    return super.close();
  }
}
