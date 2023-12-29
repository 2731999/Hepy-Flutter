import 'package:cloud_firestore/cloud_firestore.dart';

class QOAModel {
  String? uid;
  String? qid;
  String? answer;
  Timestamp? createdAt;

  QOAModel({this.uid, this.qid, this.answer, this.createdAt});

  factory QOAModel.fromMap(map) {
    return QOAModel(
      uid: map['uid'],
      qid: map['qid'],
      answer: map['answer'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'qid': qid,
      'answer': answer,
      'createdAt': createdAt,
    };
  }
}
