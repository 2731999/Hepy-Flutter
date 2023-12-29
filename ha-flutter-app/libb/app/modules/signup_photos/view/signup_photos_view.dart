import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/signup_photos/controller/signup_photos_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class SignupPhotosView extends GetView<SignupPhotosController> {
  SignupPhotosController signupPhotosController = SignupPhotosController();

  SignupPhotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    signupPhotosController.getUploadedPhotosByUID(true);
    return Obx(
      () => signupPhotosController.isLoading.value
          ? Container(
              color: AppColor.colorWhite.toColor(),
              child: const Center(child: CircularProgressIndicator()),
            )
          : WillPopScope(
              onWillPop: () {
                return signupPhotosController.navigateToBackScreen();
              },
              child: Scaffold(
                appBar: WidgetHelper().showAppBar(
                    isShowBackButton: true,
                    onTap: () => signupPhotosController.navigateToBackScreen()),
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
                            child: Wrap(
                              children: [
                                WidgetHelper().titleTextView(
                                    titleText:
                                        StringsNameUtils.signupPhotosTitle,
                                    fontSize: 36),
                              ],
                            )),
                        WidgetHelper().sizeBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // This is first image
                            emptyImageView(
                                context: context,
                                imagePath: signupPhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? signupPhotosController
                                        .firstImagePath.value
                                    : signupPhotosController
                                        .lstUserPhotos.value[0].thumb!.url!,
                                isFirstPic: true,
                                isShowProgress: signupPhotosController
                                    .isShowFirstProgress.value,
                                photoId: signupPhotosController
                                        .lstUserPhotos.value.isEmpty
                                    ? ''
                                    : signupPhotosController
                                        .lstUserPhotos.value[0].id!),
                            // This is second image
                            emptyImageView(
                              context: context,
                              imagePath: signupPhotosController
                                      .lstUserPhotos.value.isEmpty
                                  ? signupPhotosController.secondImagePath.value
                                  : 1 <
                                          signupPhotosController
                                              .lstUserPhotos.length
                                      ? signupPhotosController
                                          .lstUserPhotos.value[1].thumb!.url!
                                      : signupPhotosController
                                          .secondImagePath.value,
                              isFirstPic: false,
                              isShowProgress: signupPhotosController
                                  .isShowSecondProgress.value,
                              photoId: signupPhotosController
                                      .lstUserPhotos.value.isEmpty
                                  ? ''
                                  : 1 <
                                          signupPhotosController
                                              .lstUserPhotos.length
                                      ? signupPhotosController
                                          .lstUserPhotos.value[1].id!
                                      : '',
                            ),
                          ],
                        ),
                        WidgetHelper().sizeBox(height: 20),
                        WidgetHelper().simpleText(
                            text: StringsNameUtils.signupPhotoContent,
                            fontSize: 16),
                        WidgetHelper().sizeBox(height: 24),
                        SizedBox(
                          width: 275,
                          child: WidgetHelper().fillColorButton(
                            ontap: () => {
                              if (signupPhotosController
                                  .isAllPhotoUploaded.value)
                                {signupPhotosController.insertPhotosToDB()}
                            },
                            isEnabled:
                                signupPhotosController.isAllPhotoUploaded.value,
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
      required bool isFirstPic,
      required bool isShowProgress,
      String photoId = ''}) {
    if (isFirstPic) {
      signupPhotosController.firstImagePath.value = imagePath;
    } else {
      signupPhotosController.secondImagePath.value = imagePath;
    }
    signupPhotosController.checkBothPicUploadedOrNot();
    return InkWell(
      onTap: () {
        WidgetHelper().showBottomSheetDialog(
            controller: openCameraAndGallerySelectionDialog(
                context: context,
                imagePath: imagePath,
                isFirstPic: isFirstPic,
                photoId: photoId),
            bottomSheetHeight: 0.0);
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
                  width: MediaQuery.of(context).size.width / 3,
                  height: 130,
                  margin: const EdgeInsets.all(14),
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
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  margin: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          ImagePathUtils.edit_image,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  showProgressFirstImageContainer(BuildContext context) {
    return Visibility(
      visible: signupPhotosController.isShowFirstProgress.value,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 130,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.grey.withOpacity(0.7)),
        child: Center(
          child: WidgetHelper().simpleTextWithPrimaryColor(
              textColor: AppColor.colorWhite.toColor(),
              text: signupPhotosController.uploadFirstProgress.value,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  showProgressSecondImageContainer(BuildContext context) {
    return Visibility(
      visible: signupPhotosController.isShowSecondProgress.value,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 130,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.grey.withOpacity(0.7)),
        child: Center(
          child: WidgetHelper().simpleTextWithPrimaryColor(
              textColor: AppColor.colorWhite.toColor(),
              text: signupPhotosController.uploadSecondProgress.value,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  openCameraAndGallerySelectionDialog(
      {required BuildContext context,
      required String imagePath,
      required bool isFirstPic,
      String photoId = ''}) {
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
                  signupPhotosController.openCamera(
                      imagePath: value[0],
                      isFirstPic: isFirstPic,
                      photoId: photoId);
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
                  debugPrint("PhotoId ===> ${photoId}");
                  signupPhotosController.openGallery(
                      imagePath: imagePath,
                      isFirstPic: isFirstPic,
                      photoId: photoId);
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
}
