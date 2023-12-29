import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:intl/intl.dart';

class DobController extends GetxController {
  Rx<TextEditingController> dayController = TextEditingController().obs;
  Rx<TextEditingController> monthController = TextEditingController().obs;
  Rx<TextEditingController> yearController = TextEditingController().obs;

  @override
  void onInit() {
    dayController.value.text = "DD";
    monthController.value.text = "MM";
    yearController.value.text = "YYYY";
  }

  /// This method is open date picker dialog
  /// set value in respective fields
  showDatePickerDialog(BuildContext? context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context!,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime.now().subtract(Duration(days: 36500)),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
    );

    if (newSelectedDate != null) {
      var day = DateFormat('dd').format(newSelectedDate);
      var month = DateFormat('MM').format(newSelectedDate);
      var year = DateFormat('yyyy').format(newSelectedDate);
      var dob = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(newSelectedDate);

      dayController.value.text = day;
      monthController.value.text = month;
      yearController.value.text = year;

      insertDOBToDB(Timestamp.fromDate(newSelectedDate.subtract(newSelectedDate.timeZoneOffset)));
    }
  }

  /// this method is insert DOB data into db.
  /// first it will check all field is validate or not,
  /// if field is not validate then it will gives error as toast,
  /// once all fields are validate then insert it into database.
  insertDOBToDB(Timestamp dob) {
    UserTbl().addDob(
      dob,
      CommonUtils().auth.currentUser!,
    );
  }

  navigateToBackScreen() {
    Get.back();
  }

  navigateToGenderScreen() {
    if (dayController.value.text != "DD" &&
        monthController.value.text != "MM" &&
        yearController.value.text != "YYYY") {
      Get.offAllNamed(Routes.GENDER);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.dobError);
    }
  }
}
