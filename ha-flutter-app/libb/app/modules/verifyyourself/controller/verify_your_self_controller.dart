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
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/model/verified_user_photo/verified_user_photo_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class VerifyYourSelfController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isVerificationCompleted = false.obs;
  RxString dbImage = ''.obs;
  RxList<UserUploadPhotoModel> lstUserPhotos = <UserUploadPhotoModel>[].obs;
  UploadTask? uploadTask;
  RxBool checkIsVerify = false.obs;

  /// This method is get the user photos in database,
  /// if user has a photo then get it and display it.
  getUploadedPhotosByUID() async {
    isLoading.value = true;
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
      }));
      UserNewModel? model = PreferenceUtils.getNewModelData;
      bool? temp = false;
      if (model?.isVerified != null) {
        temp = model?.isVerified;
      }
      isVerificationCompleted.value = temp!;
    });
    isLoading.value = false;
  }

  /// This method is open Camera and capture image from camera
  /// Result of capture is store in image path variable
  openFrontCamera(BuildContext context) async {
    await ImagePicker()
        .pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front)
        .then((value) {
      debugPrint("debugPrint ===> ${value!.path}");
      uploadSelfie(context, value.path);
    });
  }

  /// This method is upload first image on
  /// fire store database
  /// we will get the path of uploaded image and hit api call
  /// we separate both method because we need to upload image in sync.
  uploadSelfie(BuildContext context, String pathVal) async {
    CommonUtils().startLoading(context);

    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();

    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref('user-selfies/')
        .child(auth.currentUser!.uid)
        .child(path.basename(File(pathVal).path));
    //Now We have to check status of UploadTask
    uploadTask = reference.putFile(File(pathVal));

    uploadTask?.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // CommonUtils().stopLoading(context);
          /*final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          uploadFirstProgress.value = '${(progress).toStringAsFixed(2)} %';*/
          break;
        case TaskState.canceled:
          // CommonUtils().stopLoading(context);
          break;
        case TaskState.error:
          // CommonUtils().stopLoading(context);
          break;
        case TaskState.success:
          uploadTask = null;
          uploadImageToServer(taskSnapshot.ref.fullPath, token!, context);
          break;
        case TaskState.paused:
          break;
      }
    });
  }

  /// This method is upload selected photo on server and display
  /// images from url.
  /// if both images uploaded on server and set it into image view
  /// then enabled continue button
  uploadImageToServer(String photoPath, String token, BuildContext context) {
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
        .post(apiurl: ApiUrl.verifySelfie, header: header, body: requestParams)
        .then((value) {
      debugPrint("Verify your self ====> ${value.statusCode}");
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        CommonUtils().stopLoading(context);
        VerifiedUserPhotoModel userPhotoModel =
            VerifiedUserPhotoModel.fromJson(response);
        insertDataToDB(userPhotoModel.success!);
        debugPrint("Verify your self ====> $response");
        WidgetHelper().verifyUserDialog(
            context, this, userPhotoModel.success!, checkIsVerify.value, 200);
      } else if (value.statusCode == 404) {
        CommonUtils().stopLoading(context);
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        CommonUtils().stopLoading(context);
        WidgetHelper()
            .verifyUserDialog(context, this, false, checkIsVerify.value, 403);
      } else if (value.statusCode == 401) {
        CommonUtils().stopLoading(context);
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }

  /// this method is insert user data into db.
  /// first it will check all field is validate or not,
  /// if field is not validate then it will gives error as toast,
  /// once all fields are validate then insert it into database.
  insertDataToDB(bool isUserVerified) {
    UserTbl().verifiedPhoto(
        currentUser: CommonUtils().auth.currentUser!,
        isUserVerified: isUserVerified,
        checkIsVerify: checkIsVerify.value);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_SIGNUPPHOTOS);
  }

  navigateToAddMorePhotoScreen() {
    Get.offNamed(Routes.ADDMOREPHOTOS);
  }

  Future<void> isVerifiedPhotoUpdate(String uid, bool value) =>
      FirebaseFirestore.instance
          .collection(StringsNameUtils.tblUsers)
          .doc(uid)
          .update({'isVerified': value});
}
