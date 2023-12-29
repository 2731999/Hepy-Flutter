import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/qod/qoa_model.dart';

class DailyAnswerTbl {
  QOAModel qoaModel = QOAModel();

  /// This method is insert data into Firebase db
  /// it will add answer of daily question in db, if question id
  /// is already exist then it will update it else create new answer
  void insertDataToDailyAnswer({
    required String uid,
    required String qid,
    required answer,
  }) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    qoaModel.uid = uid;
    qoaModel.qid = qid;
    qoaModel.answer = answer;
    qoaModel.createdAt = Timestamp.fromDate(DateTime.now());

    String id = firebaseFirestore
        .collection(StringsNameUtils.tblDailyAnswer)
        .doc()
        .id;

    await firebaseFirestore
        .collection(StringsNameUtils.tblDailyAnswer)
        .doc(id)
        .set(qoaModel.toMap(), SetOptions(merge: true));
  }
}
