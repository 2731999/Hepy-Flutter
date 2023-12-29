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
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/uploadphoto/user_upload_photo_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class SignupPhotosController extends GetxController {
  RxString firstImagePath = ''.obs;
  RxString secondImagePath = ''.obs;
  RxString uploadFirstProgress = ''.obs;
  RxString uploadSecondProgress = ''.obs;
  RxBool isSetFirstPic = false.obs;
  RxBool isShowFirstProgress = false.obs;
  RxBool isShowSecondProgress = false.obs;
  RxBool isAllPhotoUploaded = false.obs;
  File? firstImage, secondImage;
  String? firstFileNameAndPath = '';
  String? secondFileNameAndPath = '';
  String? photoId = '';
  UploadTask? uploadTask;
  RxList<UserUploadPhotoModel> lstUserPhotos = <UserUploadPhotoModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint("ready called");
    super.onReady();
  }

  /// This method is open Camera and capture image from camera
  /// Result of capture is store in image path variable
  openCamera(
      {required String imagePath,
      required bool isFirstPic,
      String photoId = ''}) async {
    if (imagePath.endsWith(".png") ||
        imagePath.endsWith(".jpeg") ||
        imagePath.endsWith(".jpg")) {
      setImageFromCameraAndGallery(imagePath, isFirstPic, photoId);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
    }
  }

  /// This method is open Gallery and select image from gallery
  /// Result of selection is store in image path variable
  openGallery(
      {required String imagePath,
      required bool isFirstPic,
      String photoId = ''}) async {
    Get.back();
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value!.path.endsWith(".png") ||
          value.path.endsWith("jpeg") ||
          value.path.endsWith(".jpg")) {
        imagePath = value.path;
        setImageFromCameraAndGallery(imagePath, isFirstPic, photoId);
      } else {
        WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
      }
    });
  }

  /// when we select image from gallery or camera
  /// this method will update that image into image view
  /// if image size grater then 4mb then it will show error message
  setImageFromCameraAndGallery(
      String imagePath, bool isFirstPic, String photoId) {
    if (CommonUtils().getFileSize(imagePath) <= 4) {
      if (isFirstPic) {
        // firstImagePath.value = imagePath;
        firstImage = File(imagePath);
        setModifiedPath(firstImage!, isFirstPic);
        if (!isShowFirstProgress.value) uploadFirstImage(isFirstPic, photoId);
      } else {
        // secondImagePath.value = imagePath;
        secondImage = File(imagePath);
        setModifiedPath(secondImage!, isFirstPic);
        if (!isShowSecondProgress.value) uploadSecondImage(isFirstPic, photoId);
      }
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.maxFileSizeError);
    }
  }

  /// This method is rename file name and path based on our need
  /// we need image path for Uid/imageName.png
  setModifiedPath(File file, bool isFirst) {
    if (isFirst) {
      return firstFileNameAndPath = path.basename(file.path);
    } else {
      return secondFileNameAndPath = path.basename(file.path);
    }
  }

  /// This method is upload first image on
  /// fire store database
  /// we will get the path of uploaded image and hit api call
  /// we separate both method because we need to upload image in sync.
  uploadFirstImage(bool isFirstPic, String photoId) async {
    isShowFirstProgress.value = true;

    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();

    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref('user-photos/')
        .child(auth.currentUser!.uid)
        .child(firstFileNameAndPath!);
    //Now We have to check status of UploadTask
    uploadTask = reference.putFile(firstImage!);

    uploadTask?.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          isShowFirstProgress.value = true;
          /*final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          uploadFirstProgress.value = '${(progress).toStringAsFixed(2)} %';*/
          break;
        case TaskState.canceled:
          isShowFirstProgress.value = false;
          break;
        case TaskState.error:
          isShowFirstProgress.value = false;
          break;
        case TaskState.success:
          uploadImageToServer(
              taskSnapshot.ref.fullPath, token!, isFirstPic, photoId);
          uploadTask = null;
          break;
        case TaskState.paused:
          break;
      }
    });
  }

  /// This method is upload second image on
  /// fire store database
  /// we will get the path of uploaded image and hit api call
  uploadSecondImage(bool isFirstPic, String photoId) async {
    isShowSecondProgress.value = true;

    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();

    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref('user-photos/')
        .child(auth.currentUser!.uid)
        .child(secondFileNameAndPath!);
    //Now We have to check status of UploadTask
    uploadTask = reference.putFile(secondImage!);

    uploadTask?.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          isShowSecondProgress.value = true;
          /*final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          uploadSecondProgress.value = '${(progress).toStringAsFixed(2)} %';*/
          break;
        case TaskState.paused:
          break;
        case TaskState.canceled:
          isShowSecondProgress.value = false;
          break;
        case TaskState.error:
          isShowSecondProgress.value = false;
          break;
        case TaskState.success:
          uploadImageToServer(
              taskSnapshot.ref.fullPath, token!, isFirstPic, photoId);
          uploadTask = null;
          break;
      }
    });
  }

  /// This method is upload selected photo on server and display
  /// images from url.
  /// if both images uploaded on server and set it into image view
  /// then enabled continue button
  uploadImageToServer(
      String photoPath, String token, bool isFirstPic, String photoId) {
    debugPrint('Photo path ===> $photoPath token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {'photoPath': photoPath};
    if (photoId.isEmpty) {
      apiProvider
          .post(
              apiurl: ApiUrl.uploadPhotoPath,
              header: header,
              body: requestParams)
          .then((value) {
        if (value.statusCode == 200) {
          var response = jsonDecode(value.body);
          UserUploadPhotoModel userUploadPhotoModel =
              UserUploadPhotoModel.fromJson(response);

          // isFirstPic
          //     ? firstImagePath.value = userUploadPhotoModel.thumb!.url!
          //     : secondImagePath.value = userUploadPhotoModel.thumb!.url!;
          checkBothPicUploadedOrNot();
          if (isFirstPic) {
            isShowFirstProgress.value = false;
          } else {
            isShowSecondProgress.value = false;
          }
          getUploadedPhotosByUID(false);
        } else if (value.statusCode == 404) {
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      });
    } else {
      apiProvider
          .put(
              apiurl: '${ApiUrl.replacePhoto}/$photoId',
              header: header,
              body: requestParams)
          .then((value) {
        if (value.statusCode == 200) {
          var response = jsonDecode(value.body);
          UserUploadPhotoModel userUploadPhotoModel =
              UserUploadPhotoModel.fromJson(response);
          // isFirstPic
          //     ? firstImagePath.value = userUploadPhotoModel.thumb!.url!
          //     : secondImagePath.value = userUploadPhotoModel.thumb!.url!;
          checkBothPicUploadedOrNot();
          if (isFirstPic) {
            isShowFirstProgress.value = false;
          } else {
            isShowSecondProgress.value = false;
          }
          getUploadedPhotosByUID(false);
        } else if (value.statusCode == 404) {
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      });
    }
  }

  /// This method is get the user photos in database,
  /// if user has a photo then get it and display it.
  getUploadedPhotosByUID(bool isShowLoading) async {
    if (isShowLoading) {
      isLoading.value = true;
    }
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    lstUserPhotos.value.clear();
    await firebaseFirestore
        .collection(StringsNameUtils.tblUserUploadedPhotos)
        .where('uid', isEqualTo: CommonUtils().auth.currentUser!.uid)
        .orderBy('sortOrder')
        .get()
        .then((value) {
      List.from(value.docs.map((doc) {
        lstUserPhotos.value.add(UserUploadPhotoModel.fromSnapshot(doc, doc.id));
        lstUserPhotos.refresh();
      }));
      isLoading.value = false;
    });
  }

  /// when all photos are uploaded then enable continue button
  checkBothPicUploadedOrNot() {
    if (firstImagePath.value.isNotEmpty && secondImagePath.value.isNotEmpty) {
      isAllPhotoUploaded.value = true;
    }
  }

  /// this method is update data in firebase db
  /// and navigate to next screen
  insertPhotosToDB() {
    UserTbl().addPhotos(currentUser: CommonUtils().auth.currentUser!);
    navigateToVerifyYourSelfScreen();
  }

  navigateToVerifyYourSelfScreen() {
    Get.offNamed(Routes.VERIFYYOURSELF, arguments: [false]);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_LANGUAGE);
  }
}
