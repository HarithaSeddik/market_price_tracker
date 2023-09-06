import 'package:price_tracker_challenge/domain/models/constants.dart';

class ForgetResponseModel extends DerivAPIResponseModel {
  EchoReq? echoReq;
  int? forget;
  String? msgType;
  int? reqId;

  ForgetResponseModel({this.echoReq, this.forget, this.msgType, this.reqId});

  ForgetResponseModel.fromJson(Map<String, dynamic> json) {
    echoReq = json['echo_req'] != null
        ? new EchoReq.fromJson(json['echo_req'])
        : null;
    forget = json['forget'];
    msgType = json['msg_type'];
    reqId = json['req_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.echoReq != null) {
      data['echo_req'] = this.echoReq!.toJson();
    }
    data['forget'] = this.forget;
    data['msg_type'] = this.msgType;
    data['req_id'] = this.reqId;
    return data;
  }

  @override
  DerivAPIResponseType get responseType => DerivAPIResponseType.forget;
}

class EchoReq {
  String? forget;
  int? reqId;

  EchoReq({this.forget, this.reqId});

  EchoReq.fromJson(Map<String, dynamic> json) {
    forget = json['forget'];
    reqId = json['req_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forget'] = this.forget;
    data['req_id'] = this.reqId;
    return data;
  }
}
