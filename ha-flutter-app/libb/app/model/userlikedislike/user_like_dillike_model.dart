import 'package:cloud_firestore/cloud_firestore.dart';

class UserLikeDisLikeModel{
  String? thisUser;
  String? otherUser;
  int? likingStatus;
  Timestamp? createdAt;

  UserLikeDisLikeModel({this.thisUser, this.otherUser, this.likingStatus, this.createdAt});

  factory UserLikeDisLikeModel.fromJsonMap(Map<String, dynamic> json)=>UserLikeDisLikeModel(
    thisUser: json["thisUser"] ?? '',
    otherUser: json["otherUser"] ?? '',
    likingStatus: json["likingStatus"] ?? 0,
    createdAt: json["createdAt"] ?? Timestamp(0, 0),
  );

  Map<String,dynamic> toJson() => {
    'thisUser': thisUser,
    'otherUser': otherUser,
    'likingStatus': likingStatus,
    'createdAt': createdAt,
  };
}