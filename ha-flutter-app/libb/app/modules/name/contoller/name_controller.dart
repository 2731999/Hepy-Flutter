import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class NameController extends GetxController {
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  RxString firstNameError = ''.obs;

  /// this method is validate first name and last name
  /// validation rules:
  /// 1. first name and last name can not be empty
  /// 2. first name and last name length at least 3
  bool validationField() {
    if (firstNameController.value.text.trim().isEmpty) {
      WidgetHelper().showMessage(msg: StringsNameUtils.firstNameEmptyMessage);
      return false;
    }

    if (firstNameController.value.text.trim().length < 3) {
      WidgetHelper()
          .showMessage(msg: StringsNameUtils.smallFirstNameErrorMessage);
      return false;
    }

    if (lastNameController.value.text.trim().isEmpty) {
      WidgetHelper().showMessage(msg: StringsNameUtils.lastNameEmptyMessage);
      return false;
    }

    if (lastNameController.value.text.trim().length < 3) {
      WidgetHelper()
          .showMessage(msg: StringsNameUtils.smallLastNameErrorMessage);
      return false;
    }
    return true;
  }

  /// this method is insert user data into db.
  /// first it will check all field is validate or not,
  /// if field is not validate then it will gives error as toast,
  /// once all fields are validate then insert it into database.
  insertDataToDB() {
    if (validationField()) {
      UserTbl().addFirstNameAndLastName(
          CommonUtils().auth.currentUser!,
          firstNameController.value.text.trim(),
          lastNameController.value.text.trim());
      navigateToDobScreen();
    }
  }

  navigateToDobScreen() {
    firstNameController.value.clear();
    lastNameController.value.clear();
    Get.offAllNamed(Routes.DOB);
  }
}
