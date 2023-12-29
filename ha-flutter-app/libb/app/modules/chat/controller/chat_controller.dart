import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/user_like_dislike_tbl.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';
import 'package:hepy/app/model/conversation/match_and_conversation_model_new.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/modules/like/controller/like_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class ChatController extends GetxController {
  RxInt likedCount = 0.obs;
  RxList<Conversations> lstUsersMatch = <Conversations>[].obs;
  RxList<Conversations> lstConversation = <Conversations>[].obs;
  RxBool isLoader = false.obs;
  LikeController likeController = LikeController();
  static bool isNeedToChatCallApi = false;

  // todo temp add
  @override
  void onInit() {
    // getAllLikedUsers();
    super.onInit();
  }

  Future<void> getAllLikedUsers() async {
    isLoader.value = true;
    getMatchConversationUser();
    /*await UserLikeDisLikeTbl().getLikedUserCount().then((value) {
      List<dynamic> lstData = value;
      if (lstData.isNotEmpty) {
        lstUsersMatch.value = lstData[0];
        lstConversation.value = lstData[1];
        getLikedYouUserCards();
      }
    });*/
  }

  Future<void> getMatchConversationUser() async {
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    debugPrint("IdToken ===> $token");
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    apiProvider
        .get(apiurl: ApiUrl.matchUserAndConversation, header: header)
        .then((value) {
      if (value.statusCode == 200) {
        Map<String,dynamic> response = jsonDecode(value.body);
        log("MatchAndConversation ===> $response");
        MatchAndConversationModelNew matchAndConversationModelNew = MatchAndConversationModelNew.fromJson(response);
        // qodModel = QODModel.fromJson(response);
        if(matchAndConversationModelNew.matches != null){
          lstUsersMatch.value = matchAndConversationModelNew.matches!;
        }
        if(matchAndConversationModelNew.conversations != null){
          lstConversation.value = matchAndConversationModelNew.conversations!;
        }

        getLikedYouUserCards();
      }
    });
  }

  //todo temp change
  Future<void> getLikedYouUserCards() async {
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    debugPrint("IdToken ===> $token");
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    int count = -1;
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    apiProvider.get(apiurl: ApiUrl.likedYouUser, header: header).then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        List<UserCardsModel> lstLikedUser = [];
        for (var user in response) {
          lstLikedUser.add(UserCardsModel.fromJson(user));
        }
        count = lstLikedUser.length;
        likedCount.value = count;
        isLoader.value = false;
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        isLoader.value = false;
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        isLoader.value = false;
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        isLoader.value = false;
      } else {
        isLoader.value = false;
      }
    });
  }

  Future<ConversationModel> getConversationFromId(String conversationId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    late ConversationModel conversationModel;
    await firebaseFirestore
        .collection(StringsNameUtils.tblConversation)
        .doc(conversationId)
        .get()
        .then((value) {
      conversationModel =
          ConversationModel.fromJson(conversationId, value.data()!);
    });
    return conversationModel;
  }
}
