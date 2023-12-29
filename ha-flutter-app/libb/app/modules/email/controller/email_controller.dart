import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class EmailController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  RxList<UserNewModel> lstAllUsers = <UserNewModel>[].obs;
  RxBool isLoader = false.obs;

  bool isValidEmailAddress(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool emailValidation() {
    if (emailController.value.text.trim().isEmpty) {
      WidgetHelper().showMessage(msg: StringsNameUtils.emailEmptyMessage);
      return false;
    }
    if (!isValidEmailAddress(emailController.value.text.toLowerCase())) {
      WidgetHelper().showMessage(msg: StringsNameUtils.emailValidMessage);
      return false;
    }
    return true;
  }

  insertDataToDB(WelcomeController welcomeController, BuildContext context) {
    if (emailValidation()) {
      getAllUserList(welcomeController, context);
    }
  }

  getAllUserList(
      WelcomeController welcomeController, BuildContext context) async {
    isLoader.value = true;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    lstAllUsers.clear();
    return await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .get()
        .then((value) {
      List.from(value.docs.map((user) =>
          {lstAllUsers.value.add(UserNewModel.fromJsonMap(user.data()))}));
      bool isEmailFound = false;
      for (var element in lstAllUsers) {
        if (element.email == emailController.value.text.trim().toLowerCase()) {
          isEmailFound = true;
          break;
        }
      }
      if (isEmailFound) {
        WidgetHelper().showMessage(msg: StringsNameUtils.emailAlreadyExist);
        isLoader.value = false;
      } else {
        UserTbl().addEmailAddress(
            emailController.value.text.trim().toLowerCase(), CommonUtils().auth.currentUser!);
        CommonUtils().auth.currentUser?.updateEmail(emailController.value.text.trim());
        debugPrint("updated Email addres ===> ${CommonUtils().auth.currentUser?.email}");
        createSubscription();
        welcomeController.managesSignupFlow(context:context);
      }
    });
  }

  createSubscription() async {
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    debugPrint("IdToken ===> $token");
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    apiProvider
        .post(
            apiurl: ApiUrl.createSubscription,
            header: header,
            body: requestParams)
        .then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }

  navigateToHomeScreen() {
    Get.offAllNamed(Routes.DASHBOARD);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_ADDMOREPHOTOS);
  }
}
