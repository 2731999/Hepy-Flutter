import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hepy/app/model/conversation/content_model.dart';

class MessagesModel {
  String? sender = '';
  String? receiver = '';
  int? messageType = 0;
  ContentModel? content;
  bool? isSenderBlocked = false;
  Timestamp? createdAt = Timestamp(0, 0);
  Timestamp? expiringAtForSender = Timestamp(0, 0);
  Timestamp? expiringAtForReceiver = Timestamp(0, 0);

  MessagesModel(
      {this.sender,
      this.receiver,
      this.messageType,
      this.content,
      this.isSenderBlocked,
      this.createdAt,
      this.expiringAtForSender,
      this.expiringAtForReceiver});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    receiver = json['receiver'];
    messageType = json['messageType'];
    content =
        json['content'] != null ? ContentModel.fromJson(json['content']) : null;
    isSenderBlocked = json['isSenderBlocked'];
    createdAt = json['createdAt'];
    expiringAtForSender = json['expiringAtForSender'];
    expiringAtForReceiver = json['expiringAtForReceiver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['messageType'] = messageType;
    data['content'] = content!.toJson();
    data['isSenderBlocked'] = isSenderBlocked;
    data['createdAt'] = createdAt;
    data['expiringAtForSender'] = expiringAtForSender;
    data['expiringAtForReceiver'] = expiringAtForReceiver;
    return data;
  }
}
