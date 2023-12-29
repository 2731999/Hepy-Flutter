import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/uploadphoto/user_upload_photo_model.dart';
import 'package:hepy/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:hepy/app/modules/verifyyourself/controller/verify_your_self_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddMorePhotosController extends GetxController {
  File? firstImage, secondImage, thirdImage, forthImage, fifthImage, sixthImage;
  String? firstFileName = '';
  String? secondFileName = '';
  String? thirdFileName = '';
  String? forthFileName = '';
  String? fifthFileName = '';
  String? sixthFileName = '';
  RxBool isShowFirstProgress = false.obs;
  RxBool isShowSecondProgress = false.obs;
  RxBool isShowThirdProgress = false.obs;
  RxBool isShowForthProgress = false.obs;
  RxBool isShowFifthProgress = false.obs;
  RxBool isShowSixthProgress = false.obs;
  RxBool isLoading = false.obs;
  RxString firstImagePath = ''.obs;
  RxString secondImagePath = ''.obs;
  RxString thirdImagePath = ''.obs;
  RxString forthImagePath = ''.obs;
  RxString fifthImagePath = ''.obs;
  RxString sixthImagePath = ''.obs;
  RxList<UserUploadPhotoModel> lstUserPhotos = <UserUploadPhotoModel>[].obs;
  RxList<bool> showProgressIndexList = <bool>[].obs;
  DashboardController dashboardController = DashboardController();
  VerifyYourSelfController verifyYourSelfController =
      VerifyYourSelfController();

  /// This method is open Camera and capture image from camera
  /// Result of capture is store in image path variable
  openCamera(
      {required String imagePath,
      required int imageNo,
      String photoId = ''}) async {
    if (imagePath.endsWith(".png") ||
        imagePath.endsWith(".jpeg") ||
        imagePath.endsWith(".jpg")) {
      setImageFromCameraAndGallery(imagePath: imagePath, photoNo: imageNo);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
    }
  }

  /// This method is open Gallery and select image from gallery
  /// Result of selection is store in image path variable
  openGallery(
      {required String imagePath,
      required int imageNo,
      String photoId = ''}) async {
    Get.back();
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value!.path.endsWith(".png") ||
          value.path.endsWith(".jpeg") ||
          value.path.endsWith(".jpg")) {
        imagePath = value.path;
        setImageFromCameraAndGallery(imagePath: imagePath, photoNo: imageNo);
      } else {
        WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
      }
    });
  }

  /// when we select image from gallery or camera
  /// this method will update that image into image view
  /// if image size grater then 4mb then it will show error message
  setImageFromCameraAndGallery(
      {required String imagePath, required int photoNo, String photoId = ''}) {
    if (CommonUtils().getFileSize(imagePath) <= 4) {
      switch (photoNo) {
        case 1:
          firstImage = File(imagePath);
          uploadImage(
              photoNo: photoNo,
              imagePath: setModifiedPath(firstImage!, photoNo),
              file: firstImage!);
          break;
        case 2:
          secondImage = File(imagePath);
          uploadImage(
              photoNo: photoNo,
              imagePath: setModifiedPath(secondImage!, photoNo),
              file: secondImage!);
          break;
        case 3:
          thirdImage = File(imagePath);
          uploadImage(
              photoNo: photoNo,
              imagePath: setModifiedPath(thirdImage!, photoNo),
              file: thirdImage!);
          break;
        case 4:
          forthImage = File(imagePath);
          uploadImage(
              photoNo: photoNo,
              imagePath: setModifiedPath(forthImage!, photoNo),
              file: forthImage!);
          break;
        case 5:
          fifthImage = File(imagePath);
          uploadImage(
              photoNo: photoNo,
              imagePath: setModifiedPath(fifthImage!, photoNo),
              file: fifthImage!);
          break;
        case 6:
          sixthImage = File(imagePath);
          uploadImage(
              photoNo: photoNo,
              imagePath: setModifiedPath(sixthImage!, photoNo),
              file: sixthImage!);
          break;
      }
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.maxFileSizeError);
    }
  }

  /// This method is rename file name and path based on our need
  /// we need image path for Uid/imageName.png
  setModifiedPath(File file, int photoNo) {
    switch (photoNo) {
      case 1:
        return firstFileName = path.basename(file.path);
      case 2:
        return secondFileName = path.basename(file.path);
      case 3:
        return thirdFileName = path.basename(file.path);
      case 4:
        return forthFileName = path.basename(file.path);
      case 5:
        return fifthFileName = path.basename(file.path);
      case 6:
        return sixthFileName = path.basename(file.path);
    }
  }

  uploadImage({
    required int photoNo,
    required String imagePath,
    required File file,
  }) async {
    UploadTask? uploadTask;
    showProgress(photoNo: photoNo);

    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();

    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref('user-photos/')
        .child(auth.currentUser!.uid)
        .child(imagePath);
    //Now We have to check status of UploadTask
    uploadTask = reference.putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.canceled:
          hideProgress(photoNo: photoNo);
          break;
        case TaskState.error:
          hideProgress(photoNo: photoNo);
          break;
        case TaskState.success:
          uploadImageToServer(taskSnapshot.ref.fullPath, token!, photoNo);
          uploadTask = null;
          break;
        case TaskState.paused:
          break;
      }
    });
  }

  showProgress({required int photoNo}) {
    switch (photoNo) {
      case 1:
        isShowFirstProgress.value = true;
        break;
      case 2:
        isShowSecondProgress.value = true;
        break;
      case 3:
        isShowThirdProgress.value = true;
        break;
      case 4:
        isShowForthProgress.value = true;
        break;
      case 5:
        isShowFifthProgress.value = true;
        break;
      case 6:
        isShowSixthProgress.value = true;
        break;
    }
  }

  hideProgress({required int photoNo}) {
    switch (photoNo) {
      case 1:
        isShowFirstProgress.value = false;
        break;
      case 2:
        isShowSecondProgress.value = false;
        break;
      case 3:
        isShowThirdProgress.value = false;
        break;
      case 4:
        isShowForthProgress.value = false;
        break;
      case 5:
        isShowFifthProgress.value = false;
        break;
      case 6:
        isShowSixthProgress.value = false;
        break;
    }
  }

  /// This method is upload selected photo on server and display
  /// images from url.
  /// if both images uploaded on server and set it into image view
  /// then enabled continue button
  uploadImageToServer(String photoPath, String token, int photoNo) {
    debugPrint('Photo path ===> $photoPath token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {'photoPath': photoPath};

    apiProvider
        .post(
            apiurl: ApiUrl.uploadPhotoPath, header: header, body: requestParams)
        .then((value) {
      if (value.statusCode == 200) {
        hideProgress(photoNo: photoNo);
        var response = jsonDecode(value.body);
        UserUploadPhotoModel userUploadPhotoModel =
            UserUploadPhotoModel.fromJson(response);
        // switch (photoNo) {
        //   case 1:
        //     firstImagePath.value = userUploadPhotoModel.thumb!.url!;
        //     break;
        //   case 2:
        //     secondImagePath.value = userUploadPhotoModel.thumb!.url!;
        //     break;
        //   case 3:
        //     thirdImagePath.value = userUploadPhotoModel.thumb!.url!;
        //     break;
        //   case 4:
        //     forthImagePath.value = userUploadPhotoModel.thumb!.url!;
        //     break;
        //   case 5:
        //     fifthImagePath.value = userUploadPhotoModel.thumb!.url!;
        //     break;
        //   case 6:
        //     sixthImagePath.value = userUploadPhotoModel.thumb!.url!;
        //     break;
        // }
        getUploadedPhotosByUID(isShowProgress: false, photoNo: photoNo);
      } else if (value.statusCode == 404) {
        hideProgress(photoNo: photoNo);
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        hideProgress(photoNo: photoNo);
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        hideProgress(photoNo: photoNo);
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }

  /// This method is remove selected from database based on photo id
  deleteImageToServer(
      BuildContext context, String photoPath, String photoId) async {
    CommonUtils().startLoading(context);
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();

    debugPrint('Photo path ===> $photoPath token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {'photoPath': photoPath};

    apiProvider
        .delete(
            apiurl: '${ApiUrl.replacePhoto}/$photoId',
            header: header,
            body: requestParams)
        .then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        getUploadedPhotosByUID(isShowProgress: false);
        CommonUtils().stopLoading(context);
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }

  /// This method is get the user photos in database,
  /// if user has a photo then get it and display it.
  getUploadedPhotosByUID(
      {required bool isShowProgress, int photoNo = -1}) async {
    isLoading.value = isShowProgress;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    lstUserPhotos.value.clear();
    await firebaseFirestore
        .collection(StringsNameUtils.tblUserUploadedPhotos)
        .where('uid', isEqualTo: CommonUtils().auth.currentUser!.uid)
        .orderBy('sortOrder')
        .get()
        .then((value) {
      lstUserPhotos.value.clear();
      List.from(value.docs.map((doc) {
        var data =
            UserUploadPhotoModel.fromSnapshot(doc, doc.id, photoNo: photoNo);
        lstUserPhotos.value.add(
            UserUploadPhotoModel.fromSnapshot(doc, doc.id, photoNo: photoNo));
        // if (data.isVerified == true) {
        //   lstUserPhotos.value[0] = data;
        // } else {
        //   lstUserPhotos.value.add(
        //       UserUploadPhotoModel.fromSnapshot(doc, doc.id, photoNo: photoNo));
        // }
        lstUserPhotos.refresh();
      }));
    });
    UserTbl()
        .getCurrentNewUserByUID(
            firebaseFirestore, CommonUtils().auth.currentUser!.uid)
        .then((userNewModel) async {
      var isVerify = false;
      String? thumbnail = "";
      debugPrint(
          "getCurrentNewUserByUID photo length: ===> ${lstUserPhotos.value.length}}");
      if (lstUserPhotos.value.isNotEmpty) {
        List.from(lstUserPhotos.value.map((photo) {
          thumbnail = lstUserPhotos.value[0].photo?.url;
          debugPrint(
              "getCurrentNewUserByUID photo isVerify: ===> ${photo.isVerified!}}");
          if (photo.isVerified!) {
            isVerify = true;
          }
        }));
      }
      var startModel = PreferenceUtils.getStartModelData;
      startModel?.thumbnail = thumbnail;
      PreferenceUtils.setStartModelData = startModel!;
      debugPrint("getCurrentNewUserByUID isVerify: ===> $isVerify}");
      userNewModel.isVerified = isVerify;
      verifyYourSelfController.isVerifiedPhotoUpdate(
          CommonUtils().auth.currentUser!.uid, isVerify);
      PreferenceUtils.setUserModelData = userNewModel;
    });
    isLoading.value = false;
  }

  updateSignupStatus() {
    UserTbl().updateAddMorePhotosSignupStatus(
        currentUser: CommonUtils().auth.currentUser!);
    navigateToEmailScreen();
  }

  navigateToEmailScreen() {
    Get.offNamed(Routes.EMAIL);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_VERIFYYOURSELF);
  }

  uploadVerifyImage(
      {required int photoNo,
      required String imagePath,
      required File file,
      String photoId = ''}) async {
    UploadTask? uploadTask;

    isShowHideProgress(true, photoNo);
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();

    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref('user-photos/')
        .child(auth.currentUser!.uid)
        .child(imagePath);
    //Now We have to check status of UploadTask
    uploadTask = reference.putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.canceled:
          isShowHideProgress(false, photoNo);
          break;
        case TaskState.error:
          isShowHideProgress(false, photoNo);
          break;
        case TaskState.success:
          uploadVerifyImageToServer(
              taskSnapshot.ref.fullPath, token!, photoNo, photoId);
          uploadTask = null;
          break;
        case TaskState.paused:
          break;
      }
    });
  }

  isShowHideProgress(bool isShow, photoNo) {
    showProgressIndexList.value[photoNo] = isShow;
    showProgressIndexList.refresh();
  }

  uploadVerifyImageToServer(
      String photoPath, String token, int photoNo, String photoId) {
    debugPrint('Photo path ===> $photoPath token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {'photoPath': photoPath};
    // apiurl: '${ApiUrl.replacePhoto}/$photoId',
    photoId.isEmpty
        ? apiProvider
            .post(
                apiurl: ApiUrl.uploadPhotoPath,
                header: header,
                body: requestParams)
            .then((value) {
            if (value.statusCode == 200) {
              isShowHideProgress(false, photoNo);
              var response = jsonDecode(value.body);
              UserUploadPhotoModel userUploadPhotoModel =
                  UserUploadPhotoModel.fromJson(response);
              getUploadedPhotosByUID(isShowProgress: false, photoNo: photoNo);
            } else if (value.statusCode == 404) {
              isShowHideProgress(false, photoNo);
              WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
            } else if (value.statusCode == 403) {
              isShowHideProgress(false, photoNo);
              WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
            } else if (value.statusCode == 401) {
              isShowHideProgress(false, photoNo);
              WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
            }
          })
        : apiProvider
            .put(
                apiurl: '${ApiUrl.replacePhoto}/$photoId',
                header: header,
                body: requestParams)
            .then((value) {
            if (value.statusCode == 200) {
              isShowHideProgress(false, photoNo);
              var response = jsonDecode(value.body);
              UserUploadPhotoModel userUploadPhotoModel =
                  UserUploadPhotoModel.fromJson(response);
              getUploadedPhotosByUID(isShowProgress: false, photoNo: photoNo);
            } else if (value.statusCode == 404) {
              isShowHideProgress(false, photoNo);
              WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
            } else if (value.statusCode == 403) {
              isShowHideProgress(false, photoNo);
              WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
            } else if (value.statusCode == 401) {
              isShowHideProgress(false, photoNo);
              WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
            }
          });
  }

  uploadPhotosIndex(
      {required bool isShowProgress,
      required List<UserUploadPhotoModel> list}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    isLoading.value = isShowProgress;
    var index = 0;
    for (var item in list) {
      index = index + 1;
      if (index == 1) {
        var startModel = PreferenceUtils.getStartModelData;
        startModel?.thumbnail = item.photo?.url;
        PreferenceUtils.setStartModelData = startModel!;
      }
      item.sortOrder = index;
      firebaseFirestore
          .collection(StringsNameUtils.tblUserUploadedPhotos)
          .doc(item.id)
          .set(item.toJson(), SetOptions(merge: true));
    }
    isLoading.value = false;
  }
}
