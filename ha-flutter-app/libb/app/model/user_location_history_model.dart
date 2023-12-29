import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocationHistoryModel {
  String? uid;
  double? lat;
  double? lang;
  String? name;
  String? timezoneOffset;
  Timestamp? createdAt;

  UserLocationHistoryModel(
      {this.uid, this.lat, this.lang,this.name, this.timezoneOffset, this.createdAt});

  ///receiving data from server
  factory UserLocationHistoryModel.fromMap(map) {
    return UserLocationHistoryModel(
      uid: map['uid'],
      lat: map['lat'],
      lang: map['lang'],
      name: map['name'],
      timezoneOffset: map['timezoneOffset'],
      createdAt: map['createdAt'],
    );
  }

  /// sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'lat': lat,
      'lang': lang,
      'name': name,
      'timezoneOffset': timezoneOffset,
      'createdAt': createdAt,
    };
  }
}
