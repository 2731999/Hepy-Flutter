import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {
  String? sender = '';
  String? receiver = '';
  int? messageType = 0;
  String? content = '';
  bool? isSenderBlocked = false;
  Timestamp? createdAt = Timestamp(0, 0);
  Timestamp? expiringAtForSender = Timestamp(0, 0);
  Timestamp? expiringAtForReceiver = Timestamp(0, 0);

  LastMessageModel(
      {this.sender,
      this.receiver,
      this.messageType,
      this.content,
      this.isSenderBlocked,
      this.createdAt,
      this.expiringAtForSender,
      this.expiringAtForReceiver});

  LastMessageModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    receiver = json['receiver'];
    messageType = json['messageType'];
    content = json['content'];
    isSenderBlocked = json['isSenderBlocked'];
    createdAt = json['createdAt'] is Timestamp
        ? json['createdAt']
        : Timestamp(
            json['createdAt']['_seconds'], json['createdAt']['_nanoseconds']);
    expiringAtForSender = json['expiringAtForSender'] is Timestamp
        ? json['expiringAtForSender']
        : Timestamp(json['expiringAtForSender']['_seconds'],
            json['expiringAtForSender']['_nanoseconds']);
    expiringAtForReceiver = json['expiringAtForReceiver'] is Timestamp
        ? json['expiringAtForReceiver']
        : Timestamp(json['expiringAtForReceiver']['_seconds'],
            json['expiringAtForReceiver']['_nanoseconds']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['messageType'] = messageType;
    data['content'] = content;
    data['isSenderBlocked'] = isSenderBlocked;
    data['createdAt'] = createdAt;
    data['expiringAtForSender'] = expiringAtForSender;
    data['expiringAtForReceiver'] = expiringAtForReceiver;
    return data;
  }
}
