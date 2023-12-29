import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/Inapppurchase/in_app_purchase_details.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/enum/lookingfor.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../Utils/string_name_utils.dart';

class SettingController extends GetxController {
  RxBool isVerified = false.obs;
  RxBool isUpdateLikeView = false.obs;
  double minDistanceKm = 1;
  double maxDistanceKm = 10000;
  RxInt distanceKm = 5.obs;

  RxInt startAge = 18.obs;
  RxInt endAge = 60.obs;

  RxString retainFor = '24h'.obs;
  RxString planeName = ''.obs;
  RxString planePrice = ''.obs;
  var planeNameAndAmount;

  List<String> lookingForList = [
    LookingFor.Men.name,
    LookingFor.Women.name,
    LookingFor.Everyone.name
  ];

  List<String> retainForList = ["24h", "1 Week", "Never"];
  RxString selectedLookingForValue = LookingFor.Men.name.obs;

  @override
  void onInit() async {}

  Future<dynamic> getCurrentPlanNameAndPrice({required int planId}) async {
    late String planeName;
    late String planeAmount;
    InAppPurchaseDetails inAppPurchaseDetails = InAppPurchaseDetails();
    switch (planId) {
      case 1:
        planeName = StringsNameUtils.standardPlane;
        planeAmount = StringsNameUtils.free;
        break;
      case 2:
        planeName = StringsNameUtils.goldPlan;
        final amount = await inAppPurchaseDetails.initStoreInfo(
            productId: Platform.isAndroid
                ? PreferenceUtils.getAppConfig.goldPlanPlayStoreId
                : PreferenceUtils.getAppConfig.goldPlanAppStoreId);
        planeAmount = amount[0];
        break;
      case 3:
        planeName = StringsNameUtils.platinumPlan;
        final amount = await inAppPurchaseDetails.initStoreInfo(
            productId: Platform.isAndroid
                ? PreferenceUtils.getAppConfig.platinumPlanPlayStoreId
                : PreferenceUtils.getAppConfig.platinumPlanAppStoreId);
        planeAmount = amount[0];
        break;
    }
    return [planeName, planeAmount];
  }

  Future<void> updateDistance(String uid, int value) =>
      FirebaseFirestore.instance
          .collection(StringsNameUtils.tblUsers)
          .doc(uid)
          .update({'filters.locationRadius': value});

  Future<void> updateLookingFor(String uid, String value) =>
      FirebaseFirestore.instance
          .collection(StringsNameUtils.tblUsers)
          .doc(uid)
          .update({'filters.lookingFor': value});

  Future<void> ageRangeUpdate(String uid, int min, int max) =>
      FirebaseFirestore.instance
          .collection(StringsNameUtils.tblUsers)
          .doc(uid)
          .update({'filters.ageRange.min': min, 'filters.ageRange.max': max});

  Future<void> retainForUpdate(String uid, String value) =>
      FirebaseFirestore.instance
          .collection(StringsNameUtils.tblUsers)
          .doc(uid)
          .update({'userSettings.messageDisappear': value});

  Future<void> isVerifiedPhotoUpdate(String uid, bool value) =>
      FirebaseFirestore.instance
          .collection(StringsNameUtils.tblUsers)
          .doc(uid)
          .update({'isVerified': value});

  goToWebView(title, link) {
    Get.toNamed(Routes.COMMON_WEBVIEW, arguments: [title, link]);
  }

  void getDataAndSetIt() {
    UserNewModel? model = PreferenceUtils.getNewModelData;
    if (model != null && model.filters != null) {
      startAge.value = model.filters?.ageRange?.min ?? 18;
      endAge.value = model.filters?.ageRange?.max ?? 60;
      if (60 < endAge.value) {
        endAge.value = 60;
      }
      distanceKm.value = model.filters?.locationRadius ?? 0;
      isVerified.value = model.isVerified ?? false;
      print("getDataAndSetIt isVerified :  ${model.isVerified}");
    }

    if (model != null && model.filters != null) {
      switch (model.filters?.lookingFor) {
        case 'Men':
          selectedLookingForValue.value = LookingFor.Men.name;
          break;
        case 'Women':
          selectedLookingForValue.value = LookingFor.Women.name;
          break;
        case 'Everyone':
          selectedLookingForValue.value = LookingFor.Everyone.name;
          break;
      }
    }

    if (model != null && model.userSettings != null) {
      retainFor.value = model.userSettings?.messageDisappear ?? retainFor.value;
      print("getDataAndSetIt  retainFor.value :  ${retainFor.value}");
    }
  }

  /// This method is remove selected from database based on photo id
  void deleteAccount(BuildContext context) async {
    CommonUtils().startLoading(context);
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    debugPrint('deleteAccount ===>  token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    apiProvider
        .delete(apiurl: ApiUrl.deleteAccount, header: header, body: {}).then(
      (value) {
        if (value.statusCode == 200) {
          CommonUtils().stopLoading(context);
          CommonUtils().logoutUser(context);
        } else if (value.statusCode == 404) {
          CommonUtils().stopLoading(context);
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          CommonUtils().stopLoading(context);
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          CommonUtils().stopLoading(context);
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      },
    );
  }
}
