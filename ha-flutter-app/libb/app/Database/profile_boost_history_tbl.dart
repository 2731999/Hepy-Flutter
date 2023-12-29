import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/profile_boost_history_model.dart';

class ProfileBoostHistoryTbl {
  ProfileBoostHistoryModel profileBoostHistoryModel =
      ProfileBoostHistoryModel();

  /// This method is insert data into Firebase db
  /// it will add user like dislike details
  Future<void> insertBoostHistoryData({required String uid}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    profileBoostHistoryModel.uid = uid;
    profileBoostHistoryModel.boostedAt = Timestamp.fromDate(
        DateTime.now());
    String id = firebaseFirestore
        .collection(StringsNameUtils.tblProfileBoostHistory)
        .doc()
        .id;
    await firebaseFirestore
        .collection(StringsNameUtils.tblProfileBoostHistory)
        .doc(id)
        .set(profileBoostHistoryModel.toMap(), SetOptions(merge: true));
    PreferenceUtils.setBoostUser = false;
  }
}
