class RecoverVerifyEmail {
  String? status;
  RecoverVerifyEmailData? recoverVerifyEmailData;

  RecoverVerifyEmail({this.status, this.recoverVerifyEmailData});

  RecoverVerifyEmail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    recoverVerifyEmailData = json['data'] != null
        ? RecoverVerifyEmailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (recoverVerifyEmailData != null) {
      data['data'] = recoverVerifyEmailData!.toJson();
    }
    return data;
  }
}

class RecoverVerifyEmailData {
  List<String>? accepted;
  List<String>? rejected; // Changed from List<Null> to List<String>
  List<String>? ehlo;
  int? envelopeTime;
  int? messageTime;
  int? messageSize;
  String? response;
  Envelope? envelope;
  String? messageId;

  RecoverVerifyEmailData(
      {this.accepted,
        this.rejected,
        this.ehlo,
        this.envelopeTime,
        this.messageTime,
        this.messageSize,
        this.response,
        this.envelope,
        this.messageId});

  RecoverVerifyEmailData.fromJson(Map<String, dynamic> json) {
    accepted = json['accepted'] != null ? List<String>.from(json['accepted']) : null;
    rejected = json['rejected'] != null ? List<String>.from(json['rejected']) : null; // Fixed
    ehlo = json['ehlo'] != null ? List<String>.from(json['ehlo']) : null;
    envelopeTime = json['envelopeTime'];
    messageTime = json['messageTime'];
    messageSize = json['messageSize'];
    response = json['response'];
    envelope = json['envelope'] != null
        ? Envelope.fromJson(json['envelope'])
        : null;
    messageId = json['messageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accepted'] = accepted;
    if (rejected != null) {
      data['rejected'] = rejected; // Fixed
    }
    data['ehlo'] = ehlo;
    data['envelopeTime'] = envelopeTime;
    data['messageTime'] = messageTime;
    data['messageSize'] = messageSize;
    data['response'] = response;
    if (envelope != null) {
      data['envelope'] = envelope!.toJson();
    }
    data['messageId'] = messageId;
    return data;
  }
}

class Envelope {
  String? from;
  List<String>? to;

  Envelope({this.from, this.to});

  Envelope.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'] != null ? List<String>.from(json['to']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
