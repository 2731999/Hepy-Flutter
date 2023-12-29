import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/user_location_history_model.dart';

class UserLocationHistoryTbl {
  UserLocationHistoryModel userLocationHistoryModel =
      UserLocationHistoryModel();

  /// This method is firstly check is there any user exist in table,
  /// if user is exist then get user id and increment by 1 and add rest of data
  void insertDataToLocationHistoryTbl(
      User currentUser, double lat, double lang, String name) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    //writting all the value
    userLocationHistoryModel.uid = user.uid;
    userLocationHistoryModel.createdAt = Timestamp.fromDate(
        DateTime.now());
    userLocationHistoryModel.lat = lat;
    userLocationHistoryModel.lang = lang;
    userLocationHistoryModel.name = name;
    userLocationHistoryModel.timezoneOffset =
        DateTime.now().timeZoneOffset.toString();

    String id =
        firebaseFirestore.collection(StringsNameUtils.tblUserLocationHistory).doc().id;

    await firebaseFirestore
        .collection(StringsNameUtils.tblUserLocationHistory)
        .doc(id)
        .set(userLocationHistoryModel.toMap());
  }

  /// this method is check user is exist or not
  /// it will return location history model object
  Future<UserLocationHistoryModel> getLocationHistory(
      FirebaseFirestore firebaseFirestore, User currentUser) async {
    var userLocationHistory = await firebaseFirestore
        .collection(StringsNameUtils.tblUserLocationHistory)
        .doc(currentUser.uid)
        .get();
    if (userLocationHistory.exists) {
      userLocationHistoryModel =
          UserLocationHistoryModel.fromMap(userLocationHistory.data());
    }
    return userLocationHistoryModel;
  }
}
