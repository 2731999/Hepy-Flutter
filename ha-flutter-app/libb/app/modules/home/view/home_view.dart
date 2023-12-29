import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/user_like_dislike_tbl.dart';
import 'package:hepy/app/Utils/Inapppurchase/in_app_purchase_details.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/home/controller/home_controller.dart';
import 'package:hepy/app/notification/notification.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app/widgets/swipecards/swipe_card.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);
  HomeController homeController = HomeController();

  @override
  State<HomeView> createState() => _HomeViewState();

  showSubscriptionDialogView(BuildContext context, bool isFromSetting,
      bool isOnlyForGold, bool isOnlyForPlatinum) async {
    InAppPurchaseDetails inAppPurchaseDetails = InAppPurchaseDetails();
    final goldPlanPrice = await inAppPurchaseDetails.initStoreInfo(
        productId: Platform.isAndroid
            ? PreferenceUtils.getAppConfig.goldPlanPlayStoreId
            : PreferenceUtils.getAppConfig.goldPlanAppStoreId);
    final platinumPlanPrice = await inAppPurchaseDetails.initStoreInfo(
        productId: Platform.isAndroid
            ? PreferenceUtils.getAppConfig.platinumPlanPlayStoreId
            : PreferenceUtils.getAppConfig.platinumPlanAppStoreId);
    return WidgetHelper().subscriptionDialog(
        context: context,
        planId: PreferenceUtils
            .getStartModelData?.currentSubscriptionPlan?.plan?.id,
        isStandardPlanSelected: 1 ==
            PreferenceUtils
                .getStartModelData?.currentSubscriptionPlan?.plan?.id,
        isGoldPlanSelected: 2 ==
            PreferenceUtils
                .getStartModelData?.currentSubscriptionPlan?.plan?.id,
        isPlatinumPlanSelected: 3 ==
            PreferenceUtils
                .getStartModelData?.currentSubscriptionPlan?.plan?.id,
        goldPlanPriceWithCurrency: goldPlanPrice[0],
        platinumPriceWithCurrency: platinumPlanPrice[0],
        goldPlanPrice: goldPlanPrice[1],
        platinumPlanPrice: platinumPlanPrice[1],
        currencySymbol: goldPlanPrice[2],
        isFromSetting: isFromSetting,
        isOnlyForPlatinum: isOnlyForPlatinum,
        isOnlyForGold: isOnlyForGold);
  }

  showSubscriptionDialog(BuildContext context, bool isFromSetting,
      bool isOnlyForGold, bool isOnlyForPlatinum) {
    showSubscriptionDialogView(
        context, isFromSetting, isOnlyForGold, isOnlyForPlatinum);
  }
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  _changeData(String msg) => setState(() => notificationData = msg);

  _changeBody(String msg) => setState(() => notificationBody = msg);

  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  void initState() {
    widget.homeController.requestBatteryOptimisationPermission();

    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "Notification Data ===> $notificationData Title ===> $notificationTitle  Body ===> $notificationBody");
    final provider = Provider.of<CardProvider>(context);
    final lstUserCards = provider.lstUserCards;
    final isShowUserDetails = provider.isShowUserDetails;
    final isLoading = provider.isLoading;
    return Scaffold(
      backgroundColor: AppColor.colorWhite.toColor(),
      body: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10),
        height: MediaQuery.of(context).size.height,
        child: isLoading
            ? Container(
                color: AppColor.colorWhite.toColor(),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : lstUserCards.isNotEmpty
                ? Stack(
                    children: [
                      Stack(
                        children: lstUserCards
                            .map((userCardModel) => SwipeCard(
                                userCardsModel: userCardModel,
                                isFront: lstUserCards.last == userCardModel))
                            .toList(),
                      ),
                      !isShowUserDetails
                          ? swipeCardControlView(
                              context: context, provider: provider)
                          : Container(),
                    ],
                  )
                : provider.isFromRefreshValue
                    ? noMoreProfileView(provider)
                    : showRefreshView(provider),
      ),
    );
  }

  swipeCardControlView(
      {required BuildContext context, required CardProvider provider}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            refreshView(provider: provider),
            disLikeView(provider: provider),
            superLikeView(provider: provider),
            likeView(provider: provider),
            boosterView(provider: provider),
          ],
        ),
      ),
    );
  }

  refreshView({required CardProvider provider}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (PreferenceUtils.isRewindData) {
            if (provider.lstRewindCard.isNotEmpty &&
                !provider.isRewindClicked) {
              provider.isRewindClicked = true;
              provider.previousCardId = PreferenceUtils.getPreviousCardId;
              provider.previousConversationId =
                  PreferenceUtils.getPreviousConversationId;
              UserLikeDisLikeTbl().removeLikeDetailWhileRewind(
                  PreferenceUtils.getPreviousCardId);
              UserLikeDisLikeTbl().removeConversationWhileRewind(
                  PreferenceUtils.getPreviousConversationId);
              provider.addRewindToMainList();
            }
          } else {
            widget.showSubscriptionDialog(context, false, false, true);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 40,
            height: 40,
            child: PreferenceUtils.isRewindData
                ? provider.lstRewindCard.isEmpty
                    ? Image.asset(
                        ImagePathUtils.refresh_card_image,
                        color: AppColor.colorDisabled.toColor(),
                      )
                    : Image.asset(
                        ImagePathUtils.refresh_card_image,
                      )
                : Image.asset(
                    ImagePathUtils.refresh_card_image,
                  ),
          ),
        ),
      ),
    );
  }

  disLikeView({required CardProvider provider}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (provider.userCardsModel != null && !provider.isDisLikeClicked) {
            provider.isDisLikeClicked = true;
            provider.manageDrag(
                isClicked: true,
                xPosition: -101,
                yPosition: 0,
                userCardModel: provider.userCardsModel!,
                context: context,
                isFromHomeScreen: true);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              (provider.isDisLike)
                  ? ImagePathUtils.dislike_fill_card_image
                  : ImagePathUtils.dislike_card_image,
            ),
          ),
        ),
      ),
    );
  }

  superLikeView({required CardProvider provider}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (provider.userCardsModel != null && PreferenceUtils.isSuperLike) {
            if (!provider.isSuperLikeClicked) {
              provider.isSuperLikeClicked = true;
              provider.manageDrag(
                  isClicked: true,
                  xPosition: 0,
                  yPosition: -50,
                  userCardModel: provider.userCardsModel!,
                  context: context,
                  isFromHomeScreen: true);
            }
          } else {
            if (PreferenceUtils.getSuperLikeCount! < 1) {
              widget.showSubscriptionDialog(context, false, true, true);
            } else if (PreferenceUtils.getSuperLikeCount! < 3) {
              widget.showSubscriptionDialog(context, false, false, true);
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 40,
            height: 40,
            child: PreferenceUtils.getSuperLikeCount! < 3
                ? Image.asset(
                    (provider.isSuperLike)
                        ? ImagePathUtils.superlike_fill_card_image
                        : ImagePathUtils.superlike_card_image,
                  )
                : Image.asset(
                    ImagePathUtils.superlike_card_image,
                    color: AppColor.colorDisabled.toColor(),
                  ),
          ),
        ),
      ),
    );
  }

  likeView({required CardProvider provider}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (provider.userCardsModel != null && !provider.isLikeClicked) {
            provider.isLikeClicked = true;
            provider.manageDrag(
                isClicked: true,
                xPosition: 101,
                yPosition: 0,
                userCardModel: provider.userCardsModel!,
                context: context,
                isFromHomeScreen: true);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              (provider.isLike)
                  ? ImagePathUtils.like_fill_card_image
                  : ImagePathUtils.like_card_image,
            ),
          ),
        ),
      ),
    );
  }

  boosterView({required CardProvider provider}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (PreferenceUtils
                  .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
              3) {
            if (PreferenceUtils.isBoostUser && !provider.isBoosterClciked) {
              provider.isBoosterClciked = true;
              widget.homeController.insertBoostTimeToDb(provider);
            }
          } else {
            widget.showSubscriptionDialog(context, false, false, true);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: !PreferenceUtils.isBoostUser &&
                  PreferenceUtils.getStartModelData?.currentSubscriptionPlan
                          ?.plan?.id ==
                      3
              ? SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    ImagePathUtils.booster_card_image,
                    color: AppColor.colorDisabled.toColor(),
                  ),
                )
              : SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    ImagePathUtils.booster_card_image,
                  ),
                ),
        ),
      ),
    );
  }

  noMoreProfileView(CardProvider provider) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            WidgetHelper().titleTextView(
                titleText: StringsNameUtils.noMoreProfilesAvailable),
            const SizedBox(height: 50),
            showRefreshView(provider)
          ],
        ),
      ),
    );
  }

  showRefreshView(CardProvider provider) {
    return Center(
      child: InkWell(
        onTap: () {
          provider.userCardsAPICall(true);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 50,
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColor.colorPrimary.toColor(), width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          child: Center(
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Image.asset(
                  width: 20,
                  height: 20,
                  ImagePathUtils.rewind_image,
                  fit: BoxFit.contain,
                  color: AppColor.colorPrimary.toColor(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      StringsNameUtils.findMorePeople,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.colorPrimary.toColor(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
