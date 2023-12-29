import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/enum/lookingfor.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:http/http.dart';

class LookingForController extends GetxController {
  RxBool isMenSelected = false.obs;
  RxBool isWomenSelected = false.obs;
  RxBool isEveryoneSelected = false.obs;
  RxString selectedLookingFor = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  /// This method is used when user clicked on male button
  /// if button is click then set selected color and it's value
  menClicked() {
    isMenSelected.value = true;
    isWomenSelected.value = false;
    isEveryoneSelected.value = false;
    selectedLookingFor.value = LookingFor.Men.name;
  }

  /// This method is used when user clicked on female button
  /// if button is click then set selected color and it's value
  womenClicked() {
    isMenSelected.value = false;
    isWomenSelected.value = true;
    isEveryoneSelected.value = false;
    selectedLookingFor.value = LookingFor.Women.name;
  }

  /// This method is used when user clicked on male button
  /// if button is click then set selected color and it's value
  everyoneClicked() {
    isMenSelected.value = false;
    isWomenSelected.value = false;
    isEveryoneSelected.value = true;
    selectedLookingFor.value = LookingFor.Everyone.name;
  }

  bool lookingForValidation() {
    if (selectedLookingFor.isNotEmpty) return true;
    return false;
  }

  /// this method is insert Gender data into db.
  /// first it will check all field is validate or not,
  /// if field is not validate then it will gives error as toast,
  /// once all fields are validate then insert it into database.
  insertLookingForToDB(String lookingFor, BuildContext context) {
    if (lookingForValidation()) {
      UserTbl()
          .addLookingFor(lookingFor, CommonUtils().auth.currentUser!, context);
      // navigateToAboutMe();
    } else {
      WidgetHelper()
          .showMessage(msg: StringsNameUtils.lookingForValidationError);
    }
  }

  navigateToAboutMe() {
    Get.toNamed(Routes.ABOUT_ME, preventDuplicates: true);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_GENDER);
  }

  getDataAndSetIt() {
    UserNewModel? model = PreferenceUtils.getNewModelData;
    if (model != null && model.filters != null) {
      switch (model.filters?.lookingFor) {
        case 'Men':
          isMenSelected.value = true;
          selectedLookingFor.value = LookingFor.Men.name;
          break;
        case 'Women':
          isWomenSelected.value = true;
          selectedLookingFor.value = LookingFor.Women.name;
          break;
        case 'Everyone':
          isEveryoneSelected.value = true;
          selectedLookingFor.value = LookingFor.Everyone.name;
          break;
      }
    }
  }
}
