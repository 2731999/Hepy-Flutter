import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/add_more_photos/controller/add_more_photos_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class AddMorePhotosView extends GetView<AddMorePhotosController> {
  AddMorePhotosController addMorePhotosController = AddMorePhotosController();

  AddMorePhotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    addMorePhotosController.getUploadedPhotosByUID(isShowProgress: true);
    return Obx(
      () => addMorePhotosController.isLoading.value
          ? Container(
              color: AppColor.colorWhite.toColor(),
              child: const Center(child: CircularProgressIndicator()),
            )
          : WillPopScope(
              onWillPop: () {
                return addMorePhotosController.navigateToBackScreen();
              },
              child: Scaffold(
                appBar: WidgetHelper().showAppBar(
                  isShowBackButton: true,
                  onTap: () => addMorePhotosController.navigateToBackScreen(),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 332,
                          child: WidgetHelper().titleTextView(
                              titleText: StringsNameUtils.addMorePhotosTitle,
                              fontSize: 36),
                        ),
                        WidgetHelper().sizeBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: emptyImageView(
                                context: context,
                                imagePath: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? addMorePhotosController
                                        .firstImagePath.value
                                    : 2 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[2].thumb!.url!
                                        : addMorePhotosController
                                            .firstImagePath.value,
                                imageNo: 1,
                                isShowProgress: addMorePhotosController
                                    .isShowFirstProgress.value,
                                photoId: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : 2 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[2].id
                                        : '',
                              ),
                            ),
                            Expanded(
                              child: emptyImageView(
                                context: context,
                                imagePath: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? addMorePhotosController
                                        .secondImagePath.value
                                    : 3 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[3].thumb!.url!
                                        : addMorePhotosController
                                            .secondImagePath.value,
                                imageNo: 2,
                                isShowProgress: addMorePhotosController
                                    .isShowSecondProgress.value,
                                photoId: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : 3 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[3].id
                                        : '',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: emptyImageView(
                                context: context,
                                imagePath: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? addMorePhotosController
                                        .thirdImagePath.value
                                    : 4 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[4].thumb!.url!
                                        : addMorePhotosController
                                            .thirdImagePath.value,
                                imageNo: 3,
                                isShowProgress: addMorePhotosController
                                    .isShowThirdProgress.value,
                                photoId: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : 4 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[4].id
                                        : '',
                              ),
                            ),
                            Expanded(
                              child: emptyImageView(
                                context: context,
                                imagePath: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? addMorePhotosController
                                        .forthImagePath.value
                                    : 5 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[5].thumb!.url!
                                        : addMorePhotosController
                                            .forthImagePath.value,
                                imageNo: 4,
                                isShowProgress: addMorePhotosController
                                    .isShowForthProgress.value,
                                photoId: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : 5 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[5].id
                                        : '',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: emptyImageView(
                                context: context,
                                imagePath: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? addMorePhotosController
                                        .fifthImagePath.value
                                    : 6 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[6].thumb!.url!
                                        : addMorePhotosController
                                            .fifthImagePath.value,
                                imageNo: 5,
                                isShowProgress: addMorePhotosController
                                    .isShowFifthProgress.value,
                                photoId: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : 6 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[6].id
                                        : '',
                              ),
                            ),
                            Expanded(
                              child: emptyImageView(
                                context: context,
                                imagePath: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? addMorePhotosController
                                        .sixthImagePath.value
                                    : 7 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[7].thumb!.url!
                                        : addMorePhotosController
                                            .sixthImagePath.value,
                                imageNo: 6,
                                isShowProgress: addMorePhotosController
                                    .isShowSixthProgress.value,
                                photoId: addMorePhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : 7 <
                                            addMorePhotosController
                                                .lstUserPhotos.length
                                        ? addMorePhotosController
                                            .lstUserPhotos.value[7].id
                                        : '',
                              ),
                            ),
                          ],
                        ),
                        WidgetHelper().sizeBox(height: 33),
                        SizedBox(
                          width: 275,
                          child: WidgetHelper().fillColorButton(
                            ontap: () =>
                                addMorePhotosController.updateSignupStatus(),
                            text: StringsNameUtils.continues,
                            margin: const EdgeInsets.only(top: 15, bottom: 15),
                            height: 45,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  emptyImageView(
      {required BuildContext context,
      required String imagePath,
      required int imageNo,
      required bool isShowProgress,
      String? photoId = ''}) {
    return InkWell(
      onTap: () {
        if (photoId!.isEmpty) {
          WidgetHelper().showBottomSheetDialog(
              controller: openCameraAndGallerySelectionDialog(
                context,
                imagePath,
                imageNo,
              ),
              bottomSheetHeight: 0.0);
        } else {
          WidgetHelper().showBottomSheetDialog(
              controller: openDeleteImageDialog(context, imagePath, photoId),
              bottomSheetHeight: 0.0);
        }
      },
      child: imagePath.isEmpty
          ? Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 130,
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColor.colorGray.toColor(), width: 2),
              ),
              child: Center(
                child: isShowProgress
                    ? CircularProgressIndicator(
                        color: AppColor.colorPrimary.toColor(),
                      )
                    : WidgetHelper().simpleTextWithPrimaryColor(
                        textColor: AppColor.colorPrimary.toColor(),
                        text: "+",
                        fontSize: 36,
                      ),
              ),
            )
          : Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.70,
                  height: 130,
                  margin: const EdgeInsets.all(19),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColor.colorPrimary.toColor(), width: 2),
                  ),
                  child: Center(
                    child: isShowProgress
                        ? CircularProgressIndicator(
                            color: AppColor.colorPrimary.toColor(),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.cover),
                            ),
                          ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            ImagePathUtils.delete_image,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  openCameraAndGallerySelectionDialog(
      BuildContext context, String imagePath, int imageNo) {
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
                onTap: () async{
                  Get.back();
                  var value = await Get.toNamed(Routes.SELFIE_CAMERA);
                  addMorePhotosController.openCamera(
                      imagePath: value[0], imageNo: imageNo);
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
                  addMorePhotosController.openGallery(
                      imagePath: imagePath, imageNo: imageNo);
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
            ],
          )
        ],
      ),
    );
  }

  openDeleteImageDialog(
      BuildContext context, String photoPath, String photoId) {
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
          WidgetHelper()
              .titleTextView(titleText: StringsNameUtils.deletePhotoTitle),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().simpleText(text: StringsNameUtils.deletePhotoMessage),
          WidgetHelper().sizeBox(height: 24),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.delete,
              height: 45,
              ontap: () {
                Get.back();
                addMorePhotosController.deleteImageToServer(context,photoPath, photoId);
              }),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.cancel,
              height: 45,
              ontap: () => Get.back()),
          WidgetHelper().sizeBox(height: 32),
        ],
      ),
    );
  }
}
