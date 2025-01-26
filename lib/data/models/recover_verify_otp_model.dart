class RecoverVerifyOTP {
  String? status;
  RecoverVerifyOTPData? data;

  RecoverVerifyOTP({this.status, this.data});

  RecoverVerifyOTP.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? RecoverVerifyOTPData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RecoverVerifyOTPData {
  bool? acknowledged;
  int? modifiedCount;
  Null? upsertedId;
  int? upsertedCount;
  int? matchedCount;

  RecoverVerifyOTPData(
      {this.acknowledged,
        this.modifiedCount,
        this.upsertedId,
        this.upsertedCount,
        this.matchedCount});

  RecoverVerifyOTPData.fromJson(Map<String, dynamic> json) {
    acknowledged = json['acknowledged'];
    modifiedCount = json['modifiedCount'];
    upsertedId = json['upsertedId'];
    upsertedCount = json['upsertedCount'];
    matchedCount = json['matchedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acknowledged'] = acknowledged;
    data['modifiedCount'] = modifiedCount;
    data['upsertedId'] = upsertedId;
    data['upsertedCount'] = upsertedCount;
    data['matchedCount'] = matchedCount;
    return data;
  }
}
