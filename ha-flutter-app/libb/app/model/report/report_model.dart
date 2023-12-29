import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserModel {
  ReportedUserModel? reportedUser;
  ReportedByUserModel? reportedBy;

  Timestamp? createdAt;
  String? conversationId = '';
  String? actionTaken = '';

  ReportUserModel(
      {this.reportedUser,
      this.reportedBy,
      this.createdAt,
      this.conversationId,
      this.actionTaken});

  ReportUserModel.fromJson(Map<String, dynamic> json) {
    reportedUser = json['reportedUser'] != null
        ? ReportedUserModel.fromJson(json['reportedUser'])
        : ReportedUserModel(uid: "", name: "", thumbUrl: "");
    reportedBy = json['reportedBy'] != null
        ? ReportedByUserModel.fromJson(json['reportedBy'])
        : ReportedByUserModel(uid: "", name: "", thumbUrl: "");
    createdAt = json['createdAt'];
    conversationId = json['conversationId'];
    actionTaken = json['actionTaken']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reportedUser != null) {
      data['reportedUser'] = reportedUser!.toJson();
    }
    if (reportedBy != null) {
      data['reportedBy'] = reportedBy!.toJson();
    }
    data['createdAt'] = createdAt;
    data['conversationId'] = conversationId;
    data['actionTaken'] = actionTaken;
    return data;
  }
}

class ReportedUserModel {
  String? uid = '';
  String? name = '';
  String? thumbUrl = '';

  ReportedUserModel({this.uid, this.name, this.thumbUrl});

  ReportedUserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    thumbUrl = json['thumbUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['thumbUrl'] = thumbUrl;
    return data;
  }
}

class ReportedByUserModel {
  String? uid = '';
  String? name = '';
  String? thumbUrl = '';

  ReportedByUserModel({this.uid, this.name, this.thumbUrl});

  ReportedByUserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    thumbUrl = json['thumbUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['thumbUrl'] = thumbUrl;
    return data;
  }
}
