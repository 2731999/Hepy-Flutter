import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hepy/app/model/conversation/last_message_model.dart';
import 'package:hepy/app/model/conversation/p1_model.dart';

class Conversations {
  P1Model? p1;
  P1Model? p2;
  Timestamp? matchedAt;
  String? id;
  LastMessageModel? lastMessage;

  Conversations({this.p1, this.p2, this.matchedAt, this.id, this.lastMessage});

  Conversations.fromJson(Map<String, dynamic> json) {
    p1 = json['p1'] != null ? P1Model.fromJson(json['p1']) : null;
    p2 = json['p2'] != null ? P1Model.fromJson(json['p2']) : null;
    matchedAt = json['matchedAt'] is Timestamp
        ? json['matchedAt']
        : Timestamp(
            json['matchedAt']['_seconds'], json['matchedAt']['_nanoseconds']);
    id = json['id'];
    lastMessage = json['lastMessage'] != null
        ? LastMessageModel.fromJson(json['lastMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (p1 != null) {
      data['p1'] = p1!.toJson();
    }
    if (p2 != null) {
      data['p2'] = p2!.toJson();
    }
    if (matchedAt != null) {
      data['matchedAt'] = matchedAt;
    }
    data['id'] = id;
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    return data;
  }
}
