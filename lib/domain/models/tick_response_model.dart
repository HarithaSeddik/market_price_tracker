import 'package:price_tracker_challenge/domain/models/constants.dart';

class TickResponseModel extends DerivAPIResponseModel {
  EchoReq? echoReq;
  String? msgType;
  Subscription? subscription;
  Tick? tick;
  Error? error;

  TickResponseModel(
      {this.echoReq, this.msgType, this.subscription, this.tick, this.error});

  TickResponseModel.fromJson(Map<String, dynamic> json) {
    echoReq = json['echo_req'] != null
        ? new EchoReq.fromJson(json['echo_req'])
        : null;
    msgType = json['msg_type'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
    tick = json['tick'] != null ? new Tick.fromJson(json['tick']) : null;
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.echoReq != null) {
      data['echo_req'] = this.echoReq!.toJson();
    }
    data['msg_type'] = this.msgType;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    if (this.tick != null) {
      data['tick'] = this.tick!.toJson();
    }
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }

    return data;
  }

  @override
  DerivAPIResponseType get responseType => DerivAPIResponseType.tick;
}

class EchoReq {
  int? subscribe;
  String? ticks;

  EchoReq({this.subscribe, this.ticks});

  EchoReq.fromJson(Map<String, dynamic> json) {
    subscribe = json['subscribe'];
    ticks = json['ticks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscribe'] = this.subscribe;
    data['ticks'] = this.ticks;
    return data;
  }
}

class Subscription {
  String? id;

  Subscription({this.id});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Tick {
  double? ask;
  double? bid;
  int? epoch;
  String? id;
  int? pipSize;
  double? quote;
  String? symbol;

  Tick(
      {this.ask,
      this.bid,
      this.epoch,
      this.id,
      this.pipSize,
      this.quote,
      this.symbol});

  Tick.fromJson(Map<String, dynamic> json) {
    ask = double.parse(json['ask'].toString());
    bid = double.parse(json['bid'].toString());
    epoch = json['epoch'];
    id = json['id'];
    pipSize = json['pip_size'];
    quote = double.parse(json['quote'].toString());
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ask'] = this.ask;
    data['bid'] = this.bid;
    data['epoch'] = this.epoch;
    data['id'] = this.id;
    data['pip_size'] = this.pipSize;
    data['quote'] = this.quote;
    data['symbol'] = this.symbol;
    return data;
  }
}

class Error {
  String? code;
  Details? details;
  String? message;

  Error({this.code, this.details, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Details {
  String? field;

  Details({this.field});

  Details.fromJson(Map<String, dynamic> json) {
    field = json['field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    return data;
  }
}
