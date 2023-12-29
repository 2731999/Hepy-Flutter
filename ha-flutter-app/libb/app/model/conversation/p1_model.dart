import 'package:cloud_firestore/cloud_firestore.dart';

class P1Model {
  String? uid;
  String? name;
  String? thumbUrl;
  bool? isBlocked = false;
  Timestamp? blockedAt = Timestamp(0, 0);

  P1Model({this.uid, this.name, this.thumbUrl, this.isBlocked, this.blockedAt});

  P1Model.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    thumbUrl = json['thumbUrl'];
    isBlocked = json['isBlocked'] ?? false;
    blockedAt = json['blockedAt'] is Timestamp
        ? json['blockedAt']
        : Timestamp(
            json['blockedAt']['_seconds'], json['blockedAt']['_nanoseconds']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['thumbUrl'] = thumbUrl;
    data['isBlocked'] = isBlocked;
    data['blockedAt'] = blockedAt;
    return data;
  }
}
