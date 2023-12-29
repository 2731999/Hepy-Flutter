import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/add_more_photos/controller/add_more_photos_controller.dart';
import 'package:hepy/app/modules/signup_photos/controller/signup_photos_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../widgets/widget_helper.dart';
import 'app_color.dart';
import 'common_utils.dart';
import 'image_path_utils.dart';

class DialogsUtils {
  static openCameraAndGallerySelectionDialog(
      BuildContext context,
      String imagePath,
      int imageNo,
      String photoId,
      AddMorePhotosController addMorePhotosController) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        children: [
          WidgetHelper()
              .titleTextView(titleText: StringsNameUtils.selectPhotos),
          WidgetHelper().sizeBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  Get.back();
                  var value = await Get.toNamed(Routes.SELFIE_CAMERA);
                  openCamera(
                      imagePath: value[0],
                      imageNo: imageNo,
                      photoId: photoId,
                      addMorePhotosController: addMorePhotosController);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        text: StringsNameUtils.camera,
                        textColor: AppColor.colorText.toColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              WidgetHelper().sizeBox(height: 5),
              Divider(
                color: AppColor.colorGray.toColor(),
              ),
              WidgetHelper().sizeBox(height: 10),
              InkWell(
                onTap: () {
                  openGallery(
                      imagePath: imagePath,
                      imageNo: imageNo,
                      photoId: photoId,
                      addMorePhotosController: addMorePhotosController);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        text: StringsNameUtils.gallery,
                        textColor: AppColor.colorText.toColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              WidgetHelper().sizeBox(height: 5),
              Divider(
                color: AppColor.colorGray.toColor(),
              ),
              WidgetHelper().sizeBox(height: 16),
            ],
          )
        ],
      ),
    );
  }

  /// This method is open Camera and capture image from camera
  /// Result of capture is store in image path variable
  static openCamera(
      {required String imagePath,
      required int imageNo,
      String photoId = '',
      required AddMorePhotosController addMorePhotosController}) async {
    if (imagePath.endsWith(".png") ||
        imagePath.endsWith(".jpeg") ||
        imagePath.endsWith(".jpg")) {
      setImageFromCameraAndGallery(
          imagePath: imagePath,
          photoNo: imageNo,
          photoId: photoId,
          addMorePhotosController: addMorePhotosController);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
    }
  }

  /// This method is open Gallery and select image from gallery
  /// Result of selection is store in image path variable
  static openGallery(
      {required String imagePath,
      required int imageNo,
      String photoId = '',
      required AddMorePhotosController addMorePhotosController}) async {
    Get.back();
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value!.path.endsWith(".png") ||
          value.path.endsWith(".jpeg") ||
          value.path.endsWith(".jpg")) {
        imagePath = value.path;
        setImageFromCameraAndGallery(
            imagePath: imagePath,
            photoNo: imageNo,
            photoId: photoId,
            addMorePhotosController: addMorePhotosController);
      } else {
        WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
      }
    });
  }

  /// when we select image from gallery or camera
  /// this method will update that image into image view
  /// if image size grater then 4mb then it will show error message
  static setImageFromCameraAndGallery(
      {required String imagePath,
      required int photoNo,
      String photoId = '',
      required AddMorePhotosController addMorePhotosController}) {
    if (CommonUtils().getFileSize(imagePath) <= 4) {
      File? file = File(imagePath);
      addMorePhotosController.uploadVerifyImage(
          photoNo: photoNo,
          imagePath: setModifiedPath(file, photoNo),
          file: file,
          photoId: photoId);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.maxFileSizeError);
    }
  }

  static setModifiedPath(File file, int photoNo) {
    return path.basename(file.path);
  }

  static openDeleteImageDialog(
      BuildContext context,
      String photoPath,
      String photoId,
      bool verified,
      AddMorePhotosController addMorePhotosController) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        children: [
          Image.asset(
            ImagePathUtils.warning_image,
            fit: BoxFit.contain,
            height: 96,
            width: 96,
          ),
          WidgetHelper().sizeBox(height: 24),
          WidgetHelper().titleTextView(
              titleText: verified
                  ? StringsNameUtils.deleteVerifiedPhotoTitle
                  : StringsNameUtils.deletePhotoTitle),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().simpleText(
              text: verified
                  ? StringsNameUtils.deleteVerifiedPhotoMessage
                  : StringsNameUtils.deletePhotoMessage),
          WidgetHelper().sizeBox(height: 24),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.delete,
              height: 45,
              ontap: () {
                Get.back();
                addMorePhotosController.deleteImageToServer(
                    context, photoPath, photoId);
              }),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.cancel,
              height: 45,
              ontap: () => Get.back()),
          WidgetHelper().sizeBox(height: 16),
        ],
      ),
    );
  }

  static openReplaceImageDialog(
      BuildContext context,
      String photoPath,
      String photoId,
      int imageNo,
      bool verified,
      AddMorePhotosController addMorePhotosController) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        children: [
          Image.asset(
            ImagePathUtils.warning_image,
            fit: BoxFit.contain,
            height: 96,
            width: 96,
          ),
          WidgetHelper().sizeBox(height: 24),
          WidgetHelper().titleTextView(
              titleText: verified
                  ? StringsNameUtils.replaceVerifiedPhotoTitle
                  : StringsNameUtils.replacePhotoTitle),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().simpleText(
              text: verified
                  ? StringsNameUtils.replaceVerifiedPhotoMessage
                  : StringsNameUtils.replacePhotoMessage),
          WidgetHelper().sizeBox(height: 24),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.replacePhoto,
              height: 45,
              ontap: () {
                Get.back();
                WidgetHelper().showBottomSheetDialog(
                    controller:
                        DialogsUtils.openCameraAndGallerySelectionDialog(
                            context,
                            photoPath,
                            imageNo,
                            photoId,
                            addMorePhotosController),
                    bottomSheetHeight:
                        MediaQuery.of(context).size.height * 0.35);
              }),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.cancel,
              height: 45,
              ontap: () => Get.back()),
          WidgetHelper().sizeBox(height: 16),
        ],
      ),
    );
  }

  static commonDialog(
      {context, required String image, onCancel, onOk, title, msg}) {
    WidgetHelper().showBottomSheetDialog(
        controller: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              image.isNotEmpty
                  ? Image.asset(
                image,
                fit: BoxFit.contain,
                height: 96,
                width: 96,
              )
                  : const SizedBox(
                height: 0,
              ),
              WidgetHelper().titleTextView(titleText: title),
              WidgetHelper().sizeBox(height: 16),
              WidgetHelper().simpleText(text: msg),
              WidgetHelper().sizeBox(height: 24),
              WidgetHelper().cancelColorButton(
                text: StringsNameUtils.yes,
                height: 45,
                ontap: onOk,
              ),
              WidgetHelper().sizeBox(height: 16),
              WidgetHelper().cancelColorButton(
                  text: StringsNameUtils.no, height: 45, ontap: onCancel),
              WidgetHelper().sizeBox(height: 16),
            ],
          ),
        ),
        bottomSheetHeight: 0);
  }
}
