part of 'home_screen_cubit.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final String marketDropDownValue;
  final String symbolDropDownValue;
  // items for dropdown menu, filtered from list Active Symbols
  final List<String> activeMarketValues;
  // items for dropdown menu, filtered from list Active Symbols
  final List<String> availableSymbolValues;
  final List<ActiveSymbol> fetchedActiveSymbols;
  HomeScreenLoaded({
    required this.marketDropDownValue,
    required this.symbolDropDownValue,
    required this.activeMarketValues,
    required this.availableSymbolValues,
    required this.fetchedActiveSymbols,
  });

  HomeScreenLoaded copyWith({
    String? marketDropDownValue,
    String? symbolDropDownValue,
    List<String>? activeMarketValues,
    List<String>? availableSymbolValues,
    List<ActiveSymbol>? fetchedActiveSymbols,
  }) {
    return HomeScreenLoaded(
      marketDropDownValue: marketDropDownValue ?? this.marketDropDownValue,
      symbolDropDownValue: symbolDropDownValue ?? this.symbolDropDownValue,
      activeMarketValues: activeMarketValues ?? this.activeMarketValues,
      availableSymbolValues:
          availableSymbolValues ?? this.availableSymbolValues,
      fetchedActiveSymbols: fetchedActiveSymbols ?? this.fetchedActiveSymbols,
    );
  }
}
