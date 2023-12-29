import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/model/uploadphoto/user_upload_photo_model.dart';
import 'package:hepy/app/modules/add_language/controller/add_language_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

import '../../../Utils/string_name_utils.dart';
import '../../aboutme/controller/about_me_controller.dart';
import '../../add_more_photos/controller/add_more_photos_controller.dart';

class EditProfileController extends GetxController {
  RxBool isHomeSelected = false.obs;
  RxBool isLikeSelected = false.obs;
  RxBool isChatSelected = false.obs;
  RxBool isLoader = false.obs;

  RxInt tabIndex = 0.obs;

  RxBool isLoading = false.obs;
  RxString firstImagePath = ''.obs;
  RxString secondImagePath = ''.obs;
  RxString thirdImagePath = ''.obs;
  RxString forthImagePath = ''.obs;
  RxString fifthImagePath = ''.obs;
  RxString sixthImagePath = ''.obs;
  RxList<UserUploadPhotoModel> lstUserPhotos = <UserUploadPhotoModel>[].obs;

  RxList<AboutMeSelectionModel> aboutMeExerciseSelectionList =
      <AboutMeSelectionModel>[].obs;

  RxList<AboutMeSelectionModel> aboutMeSelectionModel =
      <AboutMeSelectionModel>[].obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }

  logoutUser() {
    CommonUtils()
        .auth
        .signOut()
        .then((value) => {Get.offAllNamed(Routes.WELCOME)});
  }

  /// This method is get the user photos in database,
  /// if user has a photo then get it and display it.
  Future<List<UserUploadPhotoModel>> getUploadedPhotosByUID(
      {required bool isShowProgress, int photoNo = -1}) async {
    isLoading.value = isShowProgress;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblUserUploadedPhotos)
        .where('uid', isEqualTo: CommonUtils().auth.currentUser!.uid)
        .orderBy('sortOrder')
        .get()
        .then((value) {
      List.from(value.docs.map((doc) {
        lstUserPhotos.add(
            UserUploadPhotoModel.fromSnapshot(doc, doc.id, photoNo: photoNo));
      }));
    });
    isLoading.value = false;
    return lstUserPhotos;
  }

  getData(
      AddMorePhotosController addMorePhotosController,
      AboutMeController aboutMeController,
      AddLanguageController addLanguageController) async {
    isLoading.value = true;
    addMorePhotosController.showProgressIndexList.clear();
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    addMorePhotosController.showProgressIndexList.add(false);
    await addMorePhotosController.getUploadedPhotosByUID(isShowProgress: true);
    await aboutMeController.getHeightAndSetIt();
    // await aboutMeController.getAboutMeData();
    await addLanguageController.getLanguageAndSetIt();

    debugPrint(
        'isShowHideProgress getData ${jsonEncode(addMorePhotosController.showProgressIndexList.value)}');
    isLoading.value = false;
  }

  replaceOldToNewPhoto(BuildContext context, String token, String newPhotoPath,
      String oldPhotoId, String oldPhotoPath, String newPhotoId) async {
    debugPrint('Photo path ===> $newPhotoPath token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    requestParams = {'photoPath': newPhotoPath};

    if (oldPhotoId.isNotEmpty) {
      CommonUtils().startLoading(context);
      apiProvider
          .put(
              apiurl: '${ApiUrl.replacePhoto}/$oldPhotoId',
              header: header,
              body: requestParams)
          .then((value) {
        if (value.statusCode == 200) {
          CommonUtils().stopLoading(context);
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
      });
    }
  }

  replaceOldToNewPhoto1(BuildContext context, String token, String oldPhotoPath,
      String newPhotoId) async {
    debugPrint('Photo path ===> $oldPhotoPath token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    requestParams = {'photoPath': oldPhotoPath};

    if (newPhotoId.isNotEmpty) {
      CommonUtils().startLoading(context);
      apiProvider
          .put(
              apiurl: '${ApiUrl.replacePhoto}/$newPhotoId',
              header: header,
              body: requestParams)
          .then((value) {
        if (value.statusCode == 200) {
          CommonUtils().stopLoading(context);
          // var response = jsonDecode(value.body);
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
      });
    }
  }
}

class AboutMeSelectionModel {
  String? value;
  String? isSelected;

  AboutMeSelectionModel({this.value, this.isSelected});
}
