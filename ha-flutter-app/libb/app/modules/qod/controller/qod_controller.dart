import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Database/daily_answer.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/qod/qod_model.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class QODController extends GetxController {
  RxString question = ''.obs;
  RxString firstOption = ''.obs;
  RxString secondOption = ''.obs;
  RxBool isLoading = false.obs;
  late QODModel qodModel;

// todo temp change
  @override
  void onInit() {
    super.onInit();
    questionOfDayAPICall();
  }

  // todo temp change
  Future<void> questionOfDayAPICall() async {
    isLoading.value = true;
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    debugPrint("IdToken ===> $token");
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    apiProvider.get(apiurl: ApiUrl.qod, header: header).then((value) {
      isLoading.value = false;
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        debugPrint("QOD ===> ${response}");
        qodModel = QODModel.fromJson(response);
        question.value = qodModel.question!;
        if (qodModel.answers != null && qodModel.answers!.isNotEmpty) {
          firstOption.value = qodModel.answers![0];
          secondOption.value = qodModel.answers![1];
        }
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }

  insertAnswerInToDatabase(
      {required String answer, required BuildContext context}) {
    DailyAnswerTbl().insertDataToDailyAnswer(
        uid: CommonUtils().auth.currentUser!.uid,
        qid: qodModel.id!,
        answer: answer);

    UserTbl().addTodaysQuestions(
        qodModel.id!, answer, CommonUtils().auth.currentUser!, context);
  }
}
