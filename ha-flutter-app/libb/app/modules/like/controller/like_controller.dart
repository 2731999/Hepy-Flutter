import 'dart:convert';

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
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class LikeController extends GetxController {
  RxInt currentPlan = 0.obs;
  RxList<UserCardsModel> lstLikedUser = <UserCardsModel>[].obs;
  RxBool isLoading = false.obs;
  RxInt touchIndex = 1.obs;
  static bool isNeedToCallApi = false;

  /// This method is get current subscription plan ID
  /// 1 = standard, 2 = gold and 3 = platinum
  void getCurrentPlan() {
    currentPlan.value =
        PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id ??
            1;
  }

  //Todo temp change
  /// This method is get all the card who likes current users
  Future<void> getLikedYouUserCards() async {
    isLoading.value = true;
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
        debugPrint("UserCard ===> ${response}");
        lstLikedUser.clear();
        for (var user in response) {
          lstLikedUser.add(UserCardsModel.fromJson(user));
        }
        var lstCards = lstLikedUser.reversed.toList();
        count = lstCards.length;
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
      isLoading.value = false;
    });
  }

  //todo temp change
  Future<void> setDisLikeAndMatchDataToDb(
      {required UserCardsModel userCardsModel,
      required int userLikedStatus}) async {
    UserLikeDisLikeTbl().insertLikeAndDislikeData(
        thisUserId: CommonUtils().auth.currentUser!.uid,
        otherUserId: userCardsModel.uid!,
        likingStatus: userLikedStatus,
        userCardsModel: userCardsModel,
        previousCardId: '',
        previousConversationId: '',
        isFromHomeScreen: false);
    lstLikedUser.remove(userCardsModel);
    lstLikedUser.refresh();
  }

  Future<Conversations?> getConversationData({
    bool isFromHomeScreen = false,
    required UserCardsModel userCardsModel,
    String previousConversationId = '',
    required int likingStatus,
  }) async {
    Conversations? conversationModel = await UserLikeDisLikeTbl()
        .insertDataIntoConversation(
            isFromHomeScreen: isFromHomeScreen,
            userCardsModel: userCardsModel,
            previousConversationId: previousConversationId,
            likingStatus: likingStatus);

    return conversationModel;
  }

// todo temp change
  @override
  void onInit() {
    // getLikedYouUserCards();
    super.onInit();
  }

  // todo temp change
  @override
  void dispose() {
    super.dispose();
  }
}
