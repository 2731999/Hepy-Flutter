import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hepy/app/model/conversation/last_message_model.dart';
import 'package:hepy/app/model/conversation/messages_model.dart';
import 'package:hepy/app/model/conversation/p1_model.dart';

class ConversationModel {
  String? id;
  P1Model? p1;
  P1Model? p2;
  Timestamp? matchAt;
  LastMessageModel? lastMessageModel;

  // MessagesModel? messages;

  ConversationModel(
      {this.id,
      this.p1,
      this.p2,
      this.matchAt,
      this.lastMessageModel,
      /*this.messages*/
      });

  ConversationModel.fromJson(this.id, Map<String, dynamic> json) {
    id = json['id'];
    p1 = json['p1'] != null ? P1Model.fromJson(json['p1']) : null;
    p2 = json['p2'] != null ? P1Model.fromJson(json['p2']) : null;
    matchAt = json['matchedAt'] ?? Timestamp(0, 0);
    lastMessageModel = json['lastMessage'] != null
        ? LastMessageModel.fromJson(json['lastMessage'])
        : null;
    /*messages = json['messages'] != null
        ? MessagesModel.fromJson(json['messages'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (p1 != null) {
      data['p1'] = p1!.toJson();
    }
    if (p2 != null) {
      data['p2'] = p2!.toJson();
    }
    if (matchAt != null) {
      data['matchedAt'] = matchAt;
    }
    if (lastMessageModel != null) {
      data['lastMessage'] = lastMessageModel!.toJson();
    }
    /*if (messages != null) {
      data['messages'] = messages!.toJson();
    }*/
    return data;
  }
}
