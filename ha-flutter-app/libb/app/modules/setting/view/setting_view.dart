import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/Inapppurchase/in_app_purchase_details.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/dialogs_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/modules/like/view/like_view.dart';
import 'package:hepy/app/modules/setting/controller/setting_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../Database/UserTbl.dart';
import '../../../Utils/common_utils.dart';

class SettingView extends GetView<SettingController> {
  SettingController settingController = SettingController();

  SettingView({Key? key}) : super(key: key);

  Future<bool> _onWillPop() async {
    updateData();
    return Future.value(true);
  }

  void updateData() {
    final user = CommonUtils().auth.currentUser!;
    settingController.ageRangeUpdate(user.uid, settingController.startAge.value,
        settingController.endAge.value);

    settingController.updateDistance(
        user.uid, settingController.distanceKm.value);

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserTbl().getCurrentNewUserByUID(firebaseFirestore, user.uid);
    if(settingController.isUpdateLikeView.value){
      LikeView likeView = LikeView();
      likeView.updateLikeView();
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    settingController.getDataAndSetIt();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: WidgetHelper().showAppBarText(
            onDone: () {
              updateData();
            },
            title: StringsNameUtils.settings),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              discoveryView(context),
              const SizedBox(
                height: 10,
              ),
              chatMsgView(context),
              verificationView(context),
              subscriptionView(context),
              contactUsView(context),
              termPoliciesView(context),
              const SizedBox(
                height: 40,
              ),
              logOutView(context),
              const SizedBox(
                height: 40,
              ),
              deleteAccountView(context),
              const SizedBox(
                height: 40,
              ),

              Center(
                child: Text(
                  "App version 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColor.colorGray.toColor(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //Flexible(child: languagesView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget discoveryView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            StringsNameUtils.discovery,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20,
                color: AppColor.colorText.toColor(),
                fontWeight: FontWeight.bold),
          ),
        ),
        Obx(
          () => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temporary comment distance preference view
                /*Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringsNameUtils.distancePref,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Text(
                        "${settingController.distanceKm.value} KM",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.colorGray.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                Slider(
                    value: settingController.distanceKm.toDouble(),
                    min: settingController.minDistanceKm,
                    max: settingController.maxDistanceKm,
                    divisions: settingController.maxDistanceKm.toInt(),
                    activeColor: AppColor.colorPrimary.toColor(),
                    thumbColor: AppColor.colorWhite.toColor(),
                    inactiveColor: Colors.grey,
                    label: '${settingController.distanceKm.round()}',
                    onChanged: (double newValue) {
                      settingController.distanceKm.value = newValue.round();
                    },
                    semanticFormatterCallback: (double newValue) {
                      return '${newValue.round()}';
                    }),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),*/
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, bottom: 8, top: 15),
                  child: Text(
                    StringsNameUtils.lookingFor,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.colorText.toColor(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: lookingForView(
                      context,
                      settingController.selectedLookingForValue.value,
                      settingController.lookingForList),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringsNameUtils.age,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Text(
                        "${settingController.startAge.value} - ${settingController.endAge.value}",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.colorGray.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                RangeSlider(
                  activeColor: AppColor.colorPrimary.toColor(),
                  inactiveColor: Colors.grey,
                  values: RangeValues(
                      settingController.startAge.value.toDouble(),
                      settingController.endAge.value.toDouble()),
                  labels: RangeLabels(
                      settingController.startAge.value.toString(),
                      settingController.endAge.value.toString()),
                  onChanged: (value) {
                    if (value.start >= 18 && value.end >= 18) {
                      settingController.startAge.value = value.start.toInt();
                      settingController.endAge.value = value.end.toInt();
                    }
                  },
                  min: 18.0,
                  max: 60.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          "18",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "30",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "45",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Text(
                        "60+",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.colorText.toColor(),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMsgView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Text(
            StringsNameUtils.chatMsg,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                color: AppColor.colorText.toColor(),
                fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            if (PreferenceUtils
                    .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                3) {
              WidgetHelper().showBottomSheetDialog(
                  controller: chatMsgDialogView(context),
                  bottomSheetHeight: 0.0);
            } else {
              HomeView homeView = HomeView();
              homeView.showSubscriptionDialog(context, false, false, true);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      StringsNameUtils.retainFor,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.colorText.toColor(),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      settingController.retainFor.value,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.colorGray.toColor(),
                      ),
                    ),
                  ),
                  PreferenceUtils.getStartModelData?.currentSubscriptionPlan
                              ?.plan?.id ==
                          3
                      ? Image.asset(
                          width: 30,
                          height: 30,
                          ImagePathUtils.forward_arrow_image,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox(
                          height: 30,
                          width: 0,
                        )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Text(
            StringsNameUtils.chatSubMsg,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.colorGray.toColor(),
            ),
          ),
        ),
      ],
    );
  }

  Widget verificationView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
          child: Text(
            StringsNameUtils.verificationTitle,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                color: AppColor.colorText.toColor(),
                fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () async {
            if (!settingController.isVerified.value) {
              var value =
                  await Get.toNamed(Routes.VERIFYYOURSELF, arguments: [true]);
              if (value) {
                settingController.isVerified.value = value;
              }
            }
          },
          child: Obx(
            () => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        settingController.isVerified.value
                            ? StringsNameUtils.profileVerified
                            : StringsNameUtils.getVerified,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.colorText.toColor(),
                        ),
                      ),
                    ),
                    settingController.isVerified.value
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                          )
                        : Image.asset(
                            width: 30,
                            height: 30,
                            ImagePathUtils.forward_arrow_image,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !settingController.isVerified.value,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(
              StringsNameUtils.verificationSubMsg,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.colorGray.toColor(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget subscriptionView(BuildContext context) {
    getPlanDetails(
        planId: PreferenceUtils
            .getStartModelData!.currentSubscriptionPlan!.plan!.id!,
        isForceUpdate: false);
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Text(
              StringsNameUtils.subscriptionTitle,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.colorText.toColor(),
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
              onTap: () {
                HomeView homeView = HomeView();
                homeView.showSubscriptionDialog(context, true, false, false);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringsNameUtils.currentPlan,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Text(
                        '${settingController.planeName.value} - ${settingController.planePrice.value}',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.colorGray.toColor(),
                        ),
                      ),
                      Image.asset(
                        width: 30,
                        height: 30,
                        ImagePathUtils.forward_arrow_image,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              )),
          if (Platform.isIOS)
            InkWell(
                onTap: () {
                  InAppPurchaseDetails().restorePurchase();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            StringsNameUtils.restorePurchase,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.colorText.toColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  Widget contactUsView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
          child: Text(
            StringsNameUtils.contactUsTitle,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                color: AppColor.colorText.toColor(),
                fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            settingController.goToWebView(StringsNameUtils.helpAndSupport,
                PreferenceUtils.getAppConfig.contactUsUrl);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      StringsNameUtils.helpAndSupport,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.colorText.toColor(),
                      ),
                    ),
                  ),
                  Image.asset(
                    width: 30,
                    height: 30,
                    ImagePathUtils.forward_arrow_image,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget termPoliciesView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
          child: Text(
            StringsNameUtils.termsAndPoliciesTitle,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                color: AppColor.colorText.toColor(),
                fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  settingController.goToWebView(
                      StringsNameUtils.termsOfServices,
                      PreferenceUtils.getAppConfig.termsOfServiceUrl);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringsNameUtils.termsOfServices,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Image.asset(
                        width: 30,
                        height: 30,
                        ImagePathUtils.forward_arrow_image,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  settingController.goToWebView(StringsNameUtils.privacyPolicy,
                      PreferenceUtils.getAppConfig.privacyPolicyUrl);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringsNameUtils.privacyPolicy,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColor.colorText.toColor(),
                          ),
                        ),
                      ),
                      Image.asset(
                        width: 30,
                        height: 30,
                        ImagePathUtils.forward_arrow_image,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget logOutView(BuildContext context) {
    return InkWell(
      onTap: () {
        DialogsUtils.commonDialog(
            context: context,
            image: "",
            onCancel: () {
              Get.back();
            },
            onOk: () {
              CommonUtils().logoutUser(context);
            },
            title: StringsNameUtils.logout,
            msg: StringsNameUtils.logoutMessage);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  StringsNameUtils.logout,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColor.colorText.toColor(),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(
                width: 30,
                height: 30,
                ImagePathUtils.forward_arrow_image,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteAccountView(BuildContext context) {
    return InkWell(
      onTap: () {
        DialogsUtils.commonDialog(
            context: context,
            image: ImagePathUtils.warning_image,
            onCancel: () {
              Get.back();
            },
            onOk: () {
              settingController.deleteAccount(context);
            },
            title: StringsNameUtils.deleteAccount,
            msg: StringsNameUtils.deleteAccountMessage);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  StringsNameUtils.deleteAccount,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColor.colorPrimary.toColor(),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(
                width: 30,
                height: 30,
                ImagePathUtils.forward_arrow_image,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lookingForView(BuildContext context, String key, List<String> list) {
    return Obx(
      () => Wrap(
        direction: Axis.horizontal,
        children: list.map(
          (item) {
            return Container(
              margin: const EdgeInsets.only(left: 5),
              child: settingController.selectedLookingForValue.value == item
                  ? FilterChip(
                      label: Text(
                        item.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      selected: false,
                      padding: const EdgeInsets.all(8),
                      selectedColor: AppColor.colorPrimary.toColor(),
                      backgroundColor: AppColor.colorPrimary.toColor(),
                      shape: const StadiumBorder(side: BorderSide.none),
                      onSelected: (bool value) {
                        settingController.selectedLookingForValue.value = item;
                        settingController.updateLookingFor(
                            CommonUtils().auth.currentUser!.uid, item);
                      },
                    )
                  : FilterChip(
                      label: Text(
                        item.toUpperCase(),
                        style: TextStyle(
                            color: AppColor.colorGray.toColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      selected: false,
                      padding: const EdgeInsets.all(8),
                      backgroundColor: AppColor.colorWhite.toColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppColor.colorGray.toColor(),
                        ),
                      ),
                      onSelected: (bool value) {
                        settingController.selectedLookingForValue.value = item;
                        settingController.updateLookingFor(
                            CommonUtils().auth.currentUser!.uid, item);
                      },
                    ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget chatMsgDialogView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 332,
            child: WidgetHelper().titleTextView(
                titleText: StringsNameUtils.titleChatMessageRetain,
                fontSize: 36),
          ),
          WidgetHelper().sizeBox(height: 48),
          Obx(
            () => Wrap(
              direction: Axis.horizontal,
              children: settingController.retainForList.map(
                (item) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: WidgetHelper().genderController(
                        borderColor: settingController.retainFor.value == item
                            ? AppColor.colorPrimary.toColor()
                            : AppColor.colorGray.toColor(),
                        text: item,
                        onTap: () {
                          settingController.retainFor.value = item;
                          settingController.retainForUpdate(
                              CommonUtils().auth.currentUser!.uid, item);
                          Get.back();
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  getPlanDetails({required int planId, required bool isForceUpdate}) async {
    settingController.planeNameAndAmount =
        await settingController.getCurrentPlanNameAndPrice(planId: planId);
    settingController.planeName.value = settingController.planeNameAndAmount[0];
    settingController.planePrice.value =
        settingController.planeNameAndAmount[1];
    if (isForceUpdate) {
      Get.forceAppUpdate();
      settingController.isUpdateLikeView.value = true;
    }
  }
}
