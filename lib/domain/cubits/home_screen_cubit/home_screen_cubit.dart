import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:price_tracker_challenge/domain/models/constants.dart';
import 'package:price_tracker_challenge/domain/models/symbol_response_model.dart';
import 'package:price_tracker_challenge/domain/services/deriv_api_service.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  // Pass service dependency through constructor for easier unit testing
  HomeScreenCubit(this.api) : super(HomeScreenInitial());
  late final StreamSubscription _responseStream;
  final DerivAPIServiceImpl api;

  // Initialize the HomeScreen
  init() {
    _addListeners();
    //Start loading
    emit(HomeScreenLoading());
    api.fetchActiveSymbols();
  }

  void _addListeners() {
    _responseStream = api.responseStream.listen(_onResponseReceived);
  }

  // Stream of Dart models of our JSON response
  _onResponseReceived(DerivAPIResponseModel responseModel) {
    switch (responseModel.responseType) {
      case DerivAPIResponseType.activeSymbols:
        SymbolResponseModel response = responseModel as SymbolResponseModel;
        final fetchedSymbols = response.activeSymbols;
        if (fetchedSymbols == null) return;
        final activeMarketValues = ['Select a Market'];

        // Filter the market values into a list of nonrepeating market display names
        activeMarketValues.addAll(fetchedSymbols
            .map((symbol) => symbol.marketDisplayName!)
            .toSet()
            .toList());
        emit(
          HomeScreenLoaded(
            marketDropDownValue: 'Select a Market',
            symbolDropDownValue: 'Select an Asset',
            activeMarketValues: activeMarketValues,
            availableSymbolValues: const ['Select an Asset'],
            fetchedActiveSymbols: fetchedSymbols,
          ),
        );
        break;
      case DerivAPIResponseType.forget:
      case DerivAPIResponseType.tick:
    }
  }

  void onMarketDropdownChanged(String? value) {
    final loadedState = state as HomeScreenLoaded;
    // if value hasn't changed, do nothing
    if (value == loadedState.marketDropDownValue) return;
    //Filter the 'active symbols' based on the selected market value
    final filteredSymbols = loadedState.fetchedActiveSymbols.where((symbol) {
      return symbol.marketDisplayName == value;
    }).toList();
    // Map symbol model into string list for dropdown menu
    final availableSymbolValues = filteredSymbols
        .map<String>((filteredSymbol) => filteredSymbol.displayName!)
        .toList();

    //Make sure we remove the initial options
    final activeMarketValues = loadedState.activeMarketValues;
    activeMarketValues.removeWhere((val) => val.contains('Select a Market'));
    //update and emit the state
    emit(loadedState.copyWith(
      marketDropDownValue: value,
      symbolDropDownValue: availableSymbolValues[0],
      availableSymbolValues: availableSymbolValues,
      activeMarketValues: activeMarketValues,
    ));
  }

  ActiveSymbol? onSymbolsDropdownChanged(String? value) {
    final loadedState = state as HomeScreenLoaded;
    // if value hasn't changed, do nothing
    if (value == loadedState.symbolDropDownValue) return null;
    //Make sure we remove the initial options
    final availableSymbolValues = loadedState.availableSymbolValues;
    availableSymbolValues.removeWhere((val) => val.contains('Select an Asset'));

    emit(loadedState.copyWith(
      symbolDropDownValue: value,
      availableSymbolValues: availableSymbolValues,
    ));
    return loadedState.fetchedActiveSymbols
        .firstWhere((symbol) => symbol.displayName == value);
  }

  // Don't forget to close stream subscriptions
  @override
  Future<void> close() {
    _responseStream.cancel();
    return super.close();
  }
}
