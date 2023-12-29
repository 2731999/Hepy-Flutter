import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileBoostHistoryModel{
  String? uid;
  Timestamp? boostedAt;

  ProfileBoostHistoryModel({this.uid, this.boostedAt});

  ///receiving data from server
  factory ProfileBoostHistoryModel.fromMap(map) {
    return ProfileBoostHistoryModel(
      uid: map['uid'],
      boostedAt: map['boostedAt']
    );
  }

  /// sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'boostedAt': boostedAt,
    };
  }
}