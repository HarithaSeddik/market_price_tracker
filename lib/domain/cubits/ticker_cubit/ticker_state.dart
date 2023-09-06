part of 'ticker_cubit.dart';

@immutable
abstract class TickerState {}

class TickerInitial extends TickerState {}

class TickerLoading extends TickerState {}

class TickerError extends TickerState {
  final TickResponseModel ticker;

  TickerError(this.ticker);
}

// If a ticker is successfully fetched
abstract class TickerLoaded extends TickerState {
  final TickResponseModel ticker;
  TickerLoaded(this.ticker);
}

class TickerPriceIncreased extends TickerLoaded {
  TickerPriceIncreased(super.ticker);
}

class TickerPriceDecreased extends TickerLoaded {
  TickerPriceDecreased(super.ticker);
}

class TickerPriceConstant extends TickerLoaded {
  TickerPriceConstant(super.ticker);
}
