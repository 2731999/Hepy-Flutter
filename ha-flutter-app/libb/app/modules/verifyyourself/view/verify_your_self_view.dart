import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/setting/controller/setting_controller.dart';
import 'package:hepy/app/modules/verifyyourself/controller/verify_your_self_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class VerifyYourSelfView extends GetView<VerifyYourSelfController> {
  VerifyYourSelfController verifyYourSelfController =
      VerifyYourSelfController();

  VerifyYourSelfView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      var getArguments = Get.arguments;
      verifyYourSelfController.checkIsVerify.value = getArguments[0];
    }

    verifyYourSelfController.getUploadedPhotosByUID();
    return Obx(
      () => verifyYourSelfController.isLoading.value
          ? Container(
              color: AppColor.colorWhite.toColor(),
              child: const Center(child: CircularProgressIndicator()),
            )
          : WillPopScope(
              onWillPop: () {
                if (verifyYourSelfController.checkIsVerify.value) {
                  return Future.value(true);
                }
                return verifyYourSelfController.navigateToBackScreen();
              },
              child: Scaffold(
                appBar: WidgetHelper().showAppBar(
                  isShowBackButton: true,
                  onTap: () => {
                    if (verifyYourSelfController.checkIsVerify.value)
                      Get.back()
                    else
                      verifyYourSelfController.navigateToBackScreen(),
                  },
                ),
                body: SingleChildScrollView(
                  child: verifyYourSelfController.isVerificationCompleted.value
                      ? verificationCompleted(
                          context, verifyYourSelfController.checkIsVerify.value)
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              top: 48, right: 20, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 332,
                                child: WidgetHelper().titleTextView(
                                    titleText:
                                        StringsNameUtils.verifyYourSelfTitle,
                                    fontSize: 36),
                              ),
                              WidgetHelper().sizeBox(height: 24),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 130,
                                margin: const EdgeInsets.all(14),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColor.colorPrimary.toColor(),
                                      width: 2),
                                ),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              verifyYourSelfController
                                                  .lstUserPhotos
                                                  .value[0]
                                                  .photo!
                                                  .url!),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                              WidgetHelper().sizeBox(height: 24),
                              SizedBox(
                                width: 322,
                                child: WidgetHelper().simpleText(
                                    text: StringsNameUtils.verifyContentMessage,
                                    textAlign: TextAlign.center),
                              ),
                              WidgetHelper().sizeBox(height: 24),
                              InkWell(
                                onTap: () => howItsWorkClick(context),
                                child: WidgetHelper()
                                    .simpleTextWithPrimaryColor(
                                        textColor:
                                            AppColor.colorPrimary.toColor(),
                                        text: StringsNameUtils.howItWork,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.bold),
                              ),
                              WidgetHelper().sizeBox(height: 9),
                              SizedBox(
                                width: 275,
                                child: WidgetHelper().fillColorButton(
                                  ontap: () async {
                                    var value =
                                        await Get.toNamed(Routes.SELFIE_CAMERA);
                                    verifyYourSelfController.uploadSelfie(
                                        context, value[0]);
                                  },
                                  text: StringsNameUtils.verifyYourSelf,
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  height: 45,
                                ),
                              ),
                              WidgetHelper().sizeBox(height: 6),
                              SizedBox(
                                width: 275,
                                child: WidgetHelper().cancelColorButton(
                                    text: StringsNameUtils.later,
                                    height: 48,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    ontap: () {
                                      if (verifyYourSelfController
                                          .checkIsVerify.value) {
                                        Get.back(result: [false]);
                                      } else {
                                        verifyYourSelfController
                                            .insertDataToDB(false);
                                        verifyYourSelfController
                                            .navigateToAddMorePhotoScreen();
                                      }
                                    }),
                              ),
                              WidgetHelper().sizeBox(height: 26),
                              WidgetHelper().simpleText(
                                  text: StringsNameUtils.verifyContent,
                                  textAlign: TextAlign.center),
                              WidgetHelper().sizeBox(height: 32),
                              InkWell(
                                onTap: (){
                                  SettingController settingController = SettingController();
                                  settingController.goToWebView(
                                      StringsNameUtils.contactSupport, PreferenceUtils.getAppConfig.contactUsUrl);
                                },
                                child: WidgetHelper().simpleTextWithPrimaryColor(
                                    textColor: AppColor.colorPrimary.toColor(),
                                    text: StringsNameUtils.contactSupport,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.bold),
                              ),
                              WidgetHelper().sizeBox(height: 32),
                            ],
                          ),
                        ),
                ),
              ),
            ),
    );
  }

  verificationCompleted(BuildContext context, getArguments) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 130,
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColor.colorPrimary.toColor(), width: 2),
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(verifyYourSelfController
                              .lstUserPhotos.value[0].photo!.url!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.80,
                height: 130,
                margin: const EdgeInsets.only(top: 10, left: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        ImagePathUtils.verified_image,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          WidgetHelper().sizeBox(height: 24),
          SizedBox(
            width: 332,
            child: WidgetHelper().titleTextView(
                titleText: StringsNameUtils.verificationCompleted,
                fontSize: 36),
          ),
          WidgetHelper().sizeBox(height: 24),
          SizedBox(
            width: 275,
            child: WidgetHelper().fillColorButton(
              ontap: () {
                print("getArguments $getArguments");
                if (getArguments) {
                  Get.back();
                } else {
                  verifyYourSelfController.navigateToAddMorePhotoScreen();
                }
              },
              text: StringsNameUtils.continues,
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              height: 45,
            ),
          ),
        ],
      ),
    );
  }

  /// HowIts work click
  howItsWorkClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: howItsWorkView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.50);
  }

  /// This method is show the bottom sheet dialog
  /// for how it's work.
  howItsWorkView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetHelper().titleTextView(titleText: StringsNameUtils.howItWork),
          WidgetHelper().sizeBox(height: 20),
          WidgetHelper().simpleText(
              text: StringsNameUtils.howIwWorkFirstMessage,
              textAlign: TextAlign.center),
          WidgetHelper().sizeBox(height: 20),
          WidgetHelper().simpleText(
              text: StringsNameUtils.howIwWorkSecondMessage,
              textAlign: TextAlign.center),
          WidgetHelper().sizeBox(height: 20),
          WidgetHelper().cancelColorButton(
              text: StringsNameUtils.close,
              height: 48,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              ontap: () {
                Get.back();
              }),
        ],
      ),
    );
  }
}
