import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';
import 'package:hepy/app/model/conversation/messages_model.dart';
import 'package:hepy/app/model/conversation/p1_model.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/model/userlikedislike/user_like_dillike_model.dart';
import 'package:pinput/pinput.dart';

class UserLikeDisLikeTbl {
  UserLikeDisLikeModel userLikeDisLikeModel = UserLikeDisLikeModel();
  Conversations conversationModel = Conversations();

  /// This method is insert data into Firebase db
  /// it will add user like dislike details
  Future<void> insertLikeAndDislikeData(
      {required String thisUserId,
      required String otherUserId,
      required int likingStatus,
      required UserCardsModel userCardsModel,
      String previousCardId = '',
      String previousConversationId = '',
      required isFromHomeScreen}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    userLikeDisLikeModel.thisUser = thisUserId;
    userLikeDisLikeModel.otherUser = otherUserId;
    userLikeDisLikeModel.likingStatus = likingStatus;
    userLikeDisLikeModel.createdAt = Timestamp.fromDate(DateTime.now());
    String id;
    if (previousCardId.isNotEmpty && isFromHomeScreen) {
      id = previousCardId;
    } else {
      id = firebaseFirestore
          .collection(StringsNameUtils.tblUserLikeDislike)
          .doc()
          .id;

      /// when user came from home screen then only save into preference
      /// for rewind functionality
      if (isFromHomeScreen) {
        PreferenceUtils.setPreviousCardId = id;
      }
    }

    List<UserLikeDisLikeModel> lstUserLikeDisLike = <UserLikeDisLikeModel>[];
    // todo temp query change
    await firebaseFirestore
        .collection(StringsNameUtils.tblUserLikeDislike)
        .where("thisUser", isEqualTo: CommonUtils().auth.currentUser!.uid)
        .get()
        .then((value) {
      List.from(value.docs.map((userLikeDisLikeModel) {
        lstUserLikeDisLike
            .add(UserLikeDisLikeModel.fromJsonMap(userLikeDisLikeModel.data()));
      }));
    });

    bool isUserExist = false;
    for (var userLikeDislike in lstUserLikeDisLike) {
      if (userLikeDislike.thisUser == thisUserId &&
          userLikeDislike.otherUser == otherUserId &&
          userLikeDislike.likingStatus == likingStatus) {
        isUserExist = true;
        break;
      } else {
        isUserExist = false;
      }
    }

    // todo temp remove await
    if (!isUserExist) {
      firebaseFirestore
          .collection(StringsNameUtils.tblUserLikeDislike)
          .doc(id)
          .set(userLikeDisLikeModel.toJson(), SetOptions(merge: true));

      //todo temp change
      //if (!isFromHomeScreen) getLikedUserCount();
    }
  }

  Future<Conversations?> insertDataIntoConversation({
    required bool isFromHomeScreen,
    required UserCardsModel userCardsModel,
    String previousConversationId = '',
    required int likingStatus,
  }) async {
    if (isFromHomeScreen) {
      if (userCardsModel.liked != null &&
          (userCardsModel.liked == 1 || userCardsModel.liked == 2)) {
        conversationModel = await insertConversationData(
            userCardsModel: userCardsModel,
            previousConversationId: previousConversationId);
      }
    } else {
      if (likingStatus != 3) {
        conversationModel =
            await insertConversationData(userCardsModel: userCardsModel);
      }
    }
    return conversationModel;
  }

  /// this method is add data into conversion table
  /// when other user is like or super like our profile
  /// then create conversation entry.
  Future<Conversations> insertConversationData(
      {required UserCardsModel userCardsModel,
      String previousConversationId = ''}) async {
    /// p1 means current user
    Map<String, dynamic> p1 = {
      'blockedAt': Timestamp.now(),
      'isBlocked': false,
      'uid': PreferenceUtils.getStartModelData?.uid,
      'name': PreferenceUtils.getStartModelData?.initials,
      'thumbUrl': PreferenceUtils.getStartModelData?.thumbnail
    };

    /// p2 means Other user
    Map<String, dynamic> p2 = {
      'blockedAt': Timestamp.now(),
      'isBlocked': false,
      'uid': userCardsModel.uid,
      'name': userCardsModel.initials,
      'thumbUrl': userCardsModel.thumbnail
    };

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String id;
    if (previousConversationId.isNotEmpty) {
      id = previousConversationId;
    } else {
      id = firebaseFirestore
          .collection(StringsNameUtils.tblConversation)
          .doc()
          .id;
      PreferenceUtils.setPreviousConversationId = id;
    }

    var isDataExist = false;
    await firebaseFirestore
        .collection(StringsNameUtils.tblConversation)
        .where("p1.uid", isEqualTo: PreferenceUtils.getStartModelData?.uid)
        .where("p2.uid", isEqualTo: userCardsModel.uid)
        .get()
        .then((value) {
      List.from(value.docs.map((conversation) {
        Conversations conversations = Conversations.fromJson(conversation.data());
        conversationModel = conversations;
        isDataExist = true;
      }));
    });

    if (!isDataExist) {
      conversationModel.id = id;
      conversationModel.p1 = P1Model.fromJson(p1);
      conversationModel.p2 = P1Model.fromJson(p2);
      conversationModel.matchedAt = Timestamp.fromDate(DateTime.now());

      await firebaseFirestore
          .collection(StringsNameUtils.tblConversation)
          .doc(id)
          .set(conversationModel.toJson(), SetOptions(merge: true));
    }

    return conversationModel;
  }

  /// while platinum user rewind the card, we will remove like, dislike or super like
  /// entry from database.
  removeLikeDetailWhileRewind(String previousCardId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblUserLikeDislike)
        .doc(previousCardId)
        .delete();
  }

  /// while platinum user rewind the card, and user has a match, then also remove match
  /// entry from conversation collection.
  removeConversationWhileRewind(String previousConversationId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblConversation)
        .doc(previousConversationId)
        .delete();
  }
}
