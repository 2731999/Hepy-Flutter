import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingsModel {
  String? messageDisappear;
  String? deviceToken;
  Timestamp? tokenDate;

  UserSettingsModel({this.messageDisappear, this.deviceToken, this.tokenDate});

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      UserSettingsModel(
          messageDisappear: json["messageDisappear"],
          deviceToken: json['deviceToken'],
          tokenDate: json['tokenDate']);

  Map<String, dynamic> toJson() => {
        "messageDisappear": messageDisappear,
        "deviceToken": deviceToken,
        "tokenDate": tokenDate,
      };
}
