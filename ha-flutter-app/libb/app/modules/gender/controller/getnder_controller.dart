import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/enum/gender.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class GenderController extends GetxController {
  RxBool isMaleSelected = false.obs;
  RxBool isFemaleSelected = false.obs;
  RxBool isOtherSelected = false.obs;
  RxString selectedGender = ''.obs;
  RxBool isLoading = false.obs;

  /// This method is used when user clicked on male button
  /// if button is click then set selected color and it's value
  maleClicked() {
    isMaleSelected.value = true;
    isFemaleSelected.value = false;
    isOtherSelected.value = false;
    selectedGender.value = Gender.Male.name;
  }

  /// This method is used when user clicked on female button
  /// if button is click then set selected color and it's value
  femaleClicked() {
    isMaleSelected.value = false;
    isFemaleSelected.value = true;
    isOtherSelected.value = false;
    selectedGender.value = Gender.Female.name;
  }

  /// This method is used when user clicked on male button
  /// if button is click then set selected color and it's value
  otherClicked() {
    isMaleSelected.value = false;
    isFemaleSelected.value = false;
    isOtherSelected.value = true;
    selectedGender.value = Gender.Other.name;
  }

  bool genderValidation() {
    if (selectedGender.isNotEmpty) return true;
    return false;
  }

  /// this method is insert Gender data into db.
  /// first it will check all field is validate or not,
  /// if field is not validate then it will gives error as toast,
  /// once all fields are validate then insert it into database.
  insertGenderToDB(String dob) {
    if (genderValidation()) {
      UserTbl().addGender(
        dob,
        CommonUtils().auth.currentUser!,
      );
      navigateToLookingForScreen();
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.genderValidationError);
    }
  }

  navigateToLookingForScreen() {
    Get.toNamed(Routes.LOOKING_FOR,preventDuplicates: true);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(false,Routes.BACK_GENDER);
  }

  getDataAndSetIt() {
    isLoading.value = true;
    UserNewModel? model = PreferenceUtils.getNewModelData;
    if (model != null && model.gender != null) {
      switch (model.gender?.toLowerCase()) {
        case 'male':
          isMaleSelected.value = true;
          selectedGender.value = Gender.Male.name;
          break;
        case 'female':
          isFemaleSelected.value = true;
          selectedGender.value = Gender.Female.name;
          break;
        case 'other':
          isOtherSelected.value = true;
          selectedGender.value = Gender.Other.name;
          break;
      }
    }
    isLoading.value = false;
  }
}
