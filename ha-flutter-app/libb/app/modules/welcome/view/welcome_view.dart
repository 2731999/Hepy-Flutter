// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

import '../../../Utils/app_size.dart';
import '../../../Utils/common_utils.dart';

class WelcomeView extends GetView<WelcomeController> {
  WelcomeController welcomeController = Get.put(WelcomeController());

  WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => welcomeController.isLoader.value
            ? WidgetHelper().loaderWithWhiteBg()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImagePathUtils.main_cover_image),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hepyImageView(),
                    contentView(context, welcomeController),
                  ],
                ),
              ),
      ),
    );
  }
}

//Happy Image widget
Widget hepyImageView() {
  return Expanded(
    child: Center(
      child: WidgetHelper().splashIcon(
          150.0, 250.0, ImagePathUtils.splash_image, BoxFit.contain),
    ),
  );
}

//SignIn Create Account and details view
Widget contentView(context, WelcomeController welcomeController) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        signInControl(context, welcomeController),
        createAccountControl(context, welcomeController),
        typographyControl(context)
      ],
    ),
  );
}

//SignIn control
Widget signInControl(context, WelcomeController welcomeController) {
  return WidgetHelper().withoutColorButton(
      text: StringsNameUtils.signIn,
      height: 45,
      margin: const EdgeInsets.only(bottom: 15),
      ontap: () {
        welcomeController.navigateToSignInScreen();
      });
}

//Create Account Controller
Widget createAccountControl(context, WelcomeController welcomeController) {
  return WidgetHelper().fillColorButton(
      text: StringsNameUtils.createAccount,
      height: 45,
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      ontap: () {
        // navigateToCreateAccountScreen();
        WidgetHelper().showBottomSheetDialog(
            controller: signupViews(context:context, welcomeController:welcomeController),
            bottomSheetHeight:
                MediaQuery.of(context).size.height * AppSize.bottomSize);
      });
}

//Create Typography view
Widget typographyControl(context) {
  return WidgetHelper().typographyText(
      firstLineText: StringsNameUtils.welcomeTypographyLineOne,
      firstLinkText: StringsNameUtils.welcomeTypographyLineOneLink,
      secondLineText: StringsNameUtils.welcomeTypographyLineSecond,
      secondLinkText: StringsNameUtils.welcomeTypographyLineSecondLink,
      margin: const EdgeInsets.only(top: 30, bottom: 20));
}

/// signup view
Widget signupViews({required BuildContext context, required WelcomeController welcomeController, AuthCredential? appleLinkCredential}) {
  return Obx(
    () => Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      margin: const EdgeInsets.only(top: 50, right: 20, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 300,
              child: WidgetHelper()
                  .titleTextView(titleText: StringsNameUtils.enterPhoneNumber)),
          WidgetHelper().sizeBox(height: 16),
          SizedBox(
            width: 300,
            height: 42,
            child: WidgetHelper().simpleText(
                text: StringsNameUtils.crateAccountMessageText,
                textAlign: TextAlign.center,
                fontSize: 16),
          ),
          WidgetHelper().sizeBox(height: 46),
          Row(
            children: <Widget>[
              WidgetHelper().sizeBox(width: 22),
              InkWell(
                onTap: () {
                  welcomeController.loadCountries();
                  WidgetHelper().showBottomSheetDialog(
                      controller:
                          showCountrySelectionView(context, welcomeController),
                      bottomSheetHeight: MediaQuery.of(context).size.height *
                          AppSize.bottomSize);
                },
                child: SizedBox(
                  width: 90,
                  child: WidgetHelper().textField(
                      keyboardType: TextInputType.number,
                      isEnabled: false,
                      hint: welcomeController.selectedCountryCode.value,
                      textColor: AppColor.colorGray.toColor(),
                      hintColor: AppColor.colorGray.toColor(),
                      underlineColor: AppColor.colorGray.toColor(),
                      textSize: 24),
                ),
              ),
              WidgetHelper().sizeBox(width: 10),
              Expanded(
                child: WidgetHelper().textField(
                    keyboardType: TextInputType.number,
                    controller: welcomeController.phoneNumberTextEditor.value,
                    hint: StringsNameUtils.phoneNumber,
                    textColor: AppColor.colorText.toColor(),
                    hintColor: AppColor.colorText.toColor(),
                    underlineColor: AppColor.colorText.toColor(),
                    textSize: 24),
              ),
              WidgetHelper().sizeBox(width: 22),
            ],
          ),
          WidgetHelper().sizeBox(height: 28),
          SizedBox(
            width: 300,
            child: WidgetHelper().fillColorButton(
                text: StringsNameUtils.continues,
                height: 48,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  welcomeController.countryCodeWithPhone.value =
                      '${welcomeController.selectedCountryCode.value}${welcomeController.phoneNumberTextEditor.value.text}';
                  welcomeController.navigateToOtpScreen(
                      otpView(context:context, welcomeController:welcomeController,appleLinkCredential:appleLinkCredential), context);
                }),
          ),
          WidgetHelper().sizeBox(height: 24),
          SizedBox(
            width: 300,
            child: WidgetHelper().cancelColorButton(
                text: StringsNameUtils.cancel,
                height: 48,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  welcomeController.phoneNumberTextEditor.value.text = "";
                  welcomeController.countryCodeWithPhone.value = "";
                  Get.back();
                }),
          )
        ],
      ),
    ),
  );
}

showCountrySelectionView(context, WelcomeController welcomeController) {
  return Obx(
    () => Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Image.asset(
                    ImagePathUtils.arrow_black_image,
                    width: 24,
                    height: 24,
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: Center(
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        text: StringsNameUtils.selectCountryCode,
                        textAlign: TextAlign.center,
                        textColor: AppColor.colorText.toColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          WidgetHelper().sizeBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                welcomeController.filterSearchResults(value);
              },
              controller: welcomeController.searchController.value,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColor.colorGray.toColor()),
                hintText: StringsNameUtils.searchYourCountry,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: welcomeController.items.length,
                itemBuilder: (context, index) {
                  var country = welcomeController.items[index].name;
                  var countryCode = welcomeController.items[index].dialCode;
                  return countryItemView(
                      country!, countryCode!, welcomeController);
                }),
          )
        ],
      ),
    ),
  );
}

Widget countryItemView(
    String country, String countryCode, WelcomeController welcomeController) {
  return InkWell(
    onTap: () {
      welcomeController.selectedCountryCode.value = countryCode;
      Get.back();
    },
    child: Container(
      margin: const EdgeInsets.only(top: 7, right: 15, left: 15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                    text: country,
                    textAlign: TextAlign.start,
                    textColor: AppColor.colorText.toColor(),
                  ),
                ),
                WidgetHelper().simpleTextWithPrimaryColor(
                  text: countryCode,
                  textAlign: TextAlign.end,
                  textColor: AppColor.colorText.toColor(),
                ),
              ],
            ),
          ),
          WidgetHelper().sizeBox(height: 5),
          Divider(
            thickness: 0.5,
            color: AppColor.colorGray.toColor(),
          )
        ],
      ),
    ),
  );
}

/// otp view
Widget otpView({required BuildContext context, required WelcomeController welcomeController, AuthCredential? appleLinkCredential} ) {
  return Obx(
    () => SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: WidgetHelper().commonPaddingOrMargin(),
        margin: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 300,
                height: 30,
                child: WidgetHelper()
                    .titleTextView(titleText: StringsNameUtils.otpTitle)),
            WidgetHelper().sizeBox(height: 16),
            SizedBox(
              width: 300,
              height: 48,
              child: WidgetHelper().simpleText(
                  text: StringsNameUtils.otpContents,
                  textAlign: TextAlign.center),
            ),
            WidgetHelper().sizeBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      text: StringsNameUtils.resendOTP,
                      textAlign: TextAlign.center,
                      textColor: AppColor.colorPrimary.toColor(),
                      isEnabled: welcomeController.isResend.value),
                  onTap: () {
                    if (welcomeController.isResend.value) {
                      welcomeController.resendOtp(context);
                    }
                  },
                ),
                Visibility(
                  visible: !welcomeController.isResend.value,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    width: 50,
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        textColor: AppColor.colorPrimary.toColor(),
                        text:
                            '00:${welcomeController.second.toString().padLeft(2, '0')}'),
                  ),
                ),
              ],
            ),
            WidgetHelper().sizeBox(height: 42),
            SizedBox(
                width: 275, child: WidgetHelper().otpView(welcomeController)),
            WidgetHelper().sizeBox(height: 16),
            WidgetHelper().fillColorButton(
                text: StringsNameUtils.continues,
                height: 48,
                width: 280,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  if(Get.isSnackbarOpen){
                     Get.back();
                  }
                  welcomeController.matchOtp(context:context,appleLinkCredential: appleLinkCredential);
                }),
            WidgetHelper().sizeBox(height: 14),
            WidgetHelper().cancelColorButton(
                text: StringsNameUtils.cancel,
                height: 48,
                width: 280,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  welcomeController.resendOtpStopTimer();
                  Get.back();
                })
          ],
        ),
      ),
    ),
  );
}
