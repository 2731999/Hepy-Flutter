import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/safe_on_tap.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/modules/like/controller/like_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class LikeView extends GetView<LikeController> {
  LikeView({Key? key}) : super(key: key);

  // todo temp change
  LikeController likeController = LikeController();

  @override
  Widget build(BuildContext context) {
    likeController.getCurrentPlan();
    // todo temp comment
    if (LikeController.isNeedToCallApi) {
      likeController.getLikedYouUserCards();
      LikeController.isNeedToCallApi = false;
    }
    return Scaffold(
      body: Obx(
        () => likeController.isLoading.value
            ? Container(
                color: AppColor.colorWhite.toColor(),
                child: const Center(child: CircularProgressIndicator()),
              )
            : Container(
                alignment: Alignment.center,
                color: AppColor.colorWhite.toColor(),
                // todo add swipe refresh
                child: RefreshIndicator(
                  onRefresh: () => likeController.getLikedYouUserCards(),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              WidgetHelper().sizeBox(height: 48),
                              Image.asset(
                                ImagePathUtils.like_you_image,
                                width: 187,
                                height: 48,
                              ),
                              WidgetHelper().sizeBox(height: 24),
                              if (likeController.currentPlan.value != 3)
                                WidgetHelper().simpleTextWithPrimaryColor(
                                  textColor: AppColor.colorText.toColor(),
                                  text: StringsNameUtils.likedYouContent,
                                  fontSize: 16,
                                ),
                              if (likeController.currentPlan.value != 3)
                                WidgetHelper().sizeBox(height: 24),
                            ],
                          ),
                          likedYouGridData(likeController.lstLikedUser)
                        ],
                      ),
                      if (likeController.currentPlan.value != 3)
                        Container(
                          margin: const EdgeInsets.only(bottom: 48),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: WidgetHelper().fillColorButton(
                              ontap: () {
                                if (likeController.currentPlan.value != 3) {
                                  HomeView homeView = HomeView();
                                  homeView.showSubscriptionDialog(
                                      context, false, false, true);
                                }
                              },
                              text:
                                  StringsNameUtils.seeWhoLikesYou.toUpperCase(),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  likedYouGridData(List<UserCardsModel> lstLikedYouUserCards) {
    return Expanded(
      child: GridView.builder(
        // todo change scroll type
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: likeController.currentPlan.value != 3
            ? lstLikedYouUserCards.length >= 10
                ? 10
                : lstLikedYouUserCards.length
            : lstLikedYouUserCards.length,
        itemBuilder: (context, index) {
          return singleLikeCardView(index, lstLikedYouUserCards);
        },
      ),
    );
  }

  singleLikeCardView(int index, List<UserCardsModel> lstLikedYouUserCards) {
    return InkWell(
      onTap: () async {
        if (likeController.currentPlan.value == 3) {
          var value = await Get.toNamed(Routes.USERCARDSDETAILS,
              arguments: [lstLikedYouUserCards[index]]);

          UserCardsModel beforeDelete = lstLikedYouUserCards[index];

          likeController.setDisLikeAndMatchDataToDb(
              userCardsModel: value[1], userLikedStatus: value[0]);

          if (value[0] == 1 || value[0] == 2) {
            showProfileMatchDialog(beforeDelete, Get.context!, value[0]);
          }
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 200,
              height: 700,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      likeController.lstLikedUser.value[index].photos![0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (likeController.currentPlan.value != 3)
            Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: 195.0,
                    height: 195.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
              ),
            ),
          if (likeController.currentPlan.value == 3)
            Align(
              alignment: Alignment.bottomLeft,
              child: SafeOnTap(
                onSafeTap: () {
                  likeController.setDisLikeAndMatchDataToDb(
                      userCardsModel: lstLikedYouUserCards[index],
                      userLikedStatus: 3);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 16),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      ImagePathUtils.dislike_card_image,
                    ),
                  ),
                ),
              ),
            ),
          if (likeController.currentPlan.value == 3)
            Align(
              alignment: Alignment.bottomRight,
              child: SafeOnTap(
                onSafeTap: () async {
                  UserCardsModel beforeDelete = lstLikedYouUserCards[index];

                  likeController.setDisLikeAndMatchDataToDb(
                      userCardsModel: lstLikedYouUserCards[index],
                      userLikedStatus: 1);

                  showProfileMatchDialog(beforeDelete, Get.context!, 1);
                },
                intervalMs: 1000,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, right: 16),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(ImagePathUtils.like_card_image),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showProfileMatchDialog(
    UserCardsModel? userCardsModel,
    BuildContext context,
    int likingStatus,
  ) {
    profileMatchDialog(
        matchedName: userCardsModel?.initials,
        matchUrl: userCardsModel?.thumbnail,
        myPic: PreferenceUtils.getStartModelData?.thumbnail,
        context: context,
        userCardModel: userCardsModel,
        likingStatus: likingStatus);
    profileMatchNotification(uid: userCardsModel?.uid);
  }

  profileMatchDialog(
      {required String? matchedName,
      required String? matchUrl,
      required String? myPic,
      required BuildContext context,
      required UserCardsModel? userCardModel,
      required int likingStatus}) {
    WidgetHelper().profileMatchDialog(
        context, matchedName, matchUrl, myPic, userCardModel, likingStatus);
  }

  /// This method is send notification for superLike
  void profileMatchNotification({required String? uid}) async {
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    debugPrint('deleteAccount ===>  token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {
      'userId': uid,
    };
    apiProvider
        .post(
            apiurl: ApiUrl.matchNotification,
            header: header,
            body: requestParams)
        .then(
      (value) {
        if (value.statusCode == 200) {
        } else if (value.statusCode == 404) {
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      },
    );
  }

  void updateLikeView() {
    Get.forceAppUpdate();
  }
}
