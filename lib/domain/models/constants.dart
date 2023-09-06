class DerivAPIResponseType {
  final String value;
  const DerivAPIResponseType._(this.value);

  factory DerivAPIResponseType.fromValue(String value) {
    final result = values[value];
    if (result == null) {
      throw StateError(
          'Invalid value $value for bit flag enum DerivAPIResponseType');
    }
    return result;
  }

  static bool containsValue(String value) => values.containsKey(value);

  static const DerivAPIResponseType activeSymbols =
      DerivAPIResponseType._("active_symbols");
  static const DerivAPIResponseType tick = DerivAPIResponseType._("tick");
  static const DerivAPIResponseType forget = DerivAPIResponseType._("forget");

  static const Map<String, DerivAPIResponseType> values = {
    "active_symbols": activeSymbols,
    "tick": tick,
    "forget": forget,
  };

  @override
  String toString() {
    return 'DerivAPIResponseType{value: $value}';
  }
}

abstract class DerivAPIResponseModel {
  DerivAPIResponseType get responseType;
}
