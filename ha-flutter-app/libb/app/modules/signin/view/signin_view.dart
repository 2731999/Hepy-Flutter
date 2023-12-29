import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/setting/controller/setting_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/app_size.dart';
import '../../../Utils/image_path_utils.dart';
import '../../../Utils/preference_utils.dart';
import '../../welcome/controller/welcome_controller.dart';
import '../../welcome/view/welcome_view.dart';
import '../controller/signin_controller.dart';

class SignInView extends GetView<SignInController> {
  SignInController mSignInController = Get.put(SignInController());
  WelcomeController welcomeController = Get.put(WelcomeController());

  SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Obx(
        () => Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
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
                    contentView(context, mSignInController),
                  ],
                ),

                // Max Size
              ),
            ),
            WidgetHelper().showAppBarOnlyBackArrow(
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
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
  Widget contentView(context, SignInController mSignInController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                StringsNameUtils.signInWithPhoneNumber,
                style: TextStyle(
                    color: AppColor.colorOffWhite.toColor(), fontSize: 14),
              ),
              Row(
                children: <Widget>[
                  WidgetHelper().sizeBox(width: 50),
                  InkWell(
                    onTap: () {
                      welcomeController.loadCountries();
                      WidgetHelper().showBottomSheetDialog(
                          controller: showCountrySelectionView(
                              context, welcomeController),
                          bottomSheetHeight:
                              MediaQuery.of(context).size.height *
                                  AppSize.bottomSize);
                    },
                    child: SizedBox(
                      width: 90,
                      child: WidgetHelper().textField(
                          keyboardType: TextInputType.number,
                          isEnabled: false,
                          hint: welcomeController.selectedCountryCode.value,
                          textColor: AppColor.colorWhite.toColor(),
                          hintColor: AppColor.colorWhite.toColor(),
                          underlineColor: AppColor.colorWhite.toColor(),
                          textSize: 24),
                    ),
                  ),
                  WidgetHelper().sizeBox(width: 10),
                  Expanded(
                    child: WidgetHelper().textField(
                        keyboardType: TextInputType.number,
                        controller:
                            welcomeController.phoneNumberTextEditor.value,
                        hint: StringsNameUtils.phoneNumber,
                        textColor: AppColor.colorWhite.toColor(),
                        hintColor: AppColor.colorWhite.toColor(),
                        underlineColor: AppColor.colorWhite.toColor(),
                        textSize: 24),
                  ),
                  WidgetHelper().sizeBox(width: 50),
                ],
              ),
              singInClick(context, mSignInController),
              WidgetHelper().sizeBox(height: 32, width: 10),
              Text(
                StringsNameUtils.signInWith,
                style: TextStyle(color: AppColor.colorWhite.toColor()),
              ),
              WidgetHelper().sizeBox(height: 16, width: 30),
              Row(
                children: <Widget>[
                  WidgetHelper().sizeBox(height: 22, width: 60),
                  Platform.isAndroid
                      ? googleClick(context, mSignInController)
                      : appleClick(context, mSignInController),
                  WidgetHelper().sizeBox(height: 22, width: 15),
                  facebookClick(context, mSignInController),
                  WidgetHelper().sizeBox(height: 22, width: 60),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              troubleSingInClick(context, mSignInController),
              hyperText(context),
            ],
          ),
        ],
      ),
    );
  }

  // Sign In Controller
  Widget singInClick(context, SignInController mSignInController) {
    return WidgetHelper().fillColorButton(
        text: StringsNameUtils.continues,
        height: 45,
        margin: const EdgeInsets.only(top: 10),
        ontap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, "");
          welcomeController.countryCodeWithPhone.value =
              '${welcomeController.selectedCountryCode.value}${welcomeController.phoneNumberTextEditor.value.text}';
          welcomeController.navigateToOtpScreen(
              otpView(context:context, welcomeController:welcomeController), context);
        });
  }

  // Sign In Controller
  Widget troubleSingInClick(context, SignInController mSignInController) {
    return InkWell(
      onTap: () {
        mSignInController.navigateToEmailScreen(emailView(context), context);
      },
      child: Text(
        StringsNameUtils.troubleSignIn,
        style: TextStyle(
            color: AppColor.colorPrimary.toColor(),
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  Widget facebookClick(context, SignInController mSignInController) {
    return Expanded(
        child: WidgetHelper().imageButton(
            image: ImagePathUtils.fb_image,
            height: 50,
            scaleType: BoxFit.contain,
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            onClick: () {
              PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, "");
              welcomeController.loginType = 1;
              mSignInController.signInWithFacebook(context).then((value) => {});
            }));
  }

  Widget appleClick(context, SignInController mSignInController) {
    return Expanded(
      child: WidgetHelper().imageButton(
        image: ImagePathUtils.apple_logo_image,
        height: 50,
        scaleType: BoxFit.contain,
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        onClick: () {
          PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, "");
          welcomeController.loginType = 3;
          mSignInController.signInWithApple(context: context);
        },
      ),
    );
  }

  Widget googleClick(context, SignInController mSignInController) {
    return Expanded(
        child: WidgetHelper().imageButton(
            image: ImagePathUtils.google_image,
            height: 50,
            scaleType: BoxFit.contain,
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            onClick: () {
              PreferenceUtils.setStringValue(PreferenceUtils.ID_TOKEN, "");
              welcomeController.loginType = 2;
              mSignInController.initiateGmailLogin(context);
            }));
  }

  //Create Typography view
  Widget typographyControl(context) {
    return WidgetHelper().typographyText(
        firstLineText: StringsNameUtils.signInTypographyLineOne,
        firstLinkText: StringsNameUtils.signInTypographyLineOneLink,
        secondLineText: StringsNameUtils.welcomeTypographyLineSecond,
        secondLinkText: StringsNameUtils.welcomeTypographyLineSecondLink,
        margin: const EdgeInsets.only(top: 30, bottom: 20));
  }

  Widget hyperText(context) {
    SettingController settingController = SettingController();
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40, top: 36, bottom: 20),
      child: Text.rich(
        softWrap: true,
        textAlign: TextAlign.center,
        TextSpan(
            style: const TextStyle(
              fontSize: 16,
            ),
            children: [
              const TextSpan(text: StringsNameUtils.signInTypographyLineOne),
              TextSpan(
                  style: TextStyle(color: AppColor.colorPrimary.toColor()),
                  //make link blue and underline
                  text: StringsNameUtils.signInTypographyLineOneLink,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      settingController.goToWebView(
                          StringsNameUtils.termsOfServices, PreferenceUtils.getAppConfig.termsOfServiceUrl);
                    }),
              const TextSpan(
                text: StringsNameUtils.welcomeTypographyLineSecond,
              ),
              TextSpan(
                  style: TextStyle(color: AppColor.colorPrimary.toColor()),
                  //make link blue and underline
                  text: StringsNameUtils.welcomeTypographyLineSecondLink,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      settingController.goToWebView(
                          StringsNameUtils.welcomeTypographyLineSecondLink,PreferenceUtils.getAppConfig.privacyPolicyUrl);
                    }),
            ]),
      ),
    );
  }

  /// email view
  Widget emailView(context) {
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
                  .titleTextView(titleText: StringsNameUtils.enterEmailAddress),
            ),
            WidgetHelper().sizeBox(height: 16),
            SizedBox(
              width: 300,
              height: 42,
              child: WidgetHelper().simpleText(
                  text: StringsNameUtils.emailSubTitle,
                  textAlign: TextAlign.center,
                  fontSize: 16),
            ),
            WidgetHelper().sizeBox(height: 46),
            WidgetHelper().textField(
                keyboardType: TextInputType.emailAddress,
                controller: mSignInController.emailAddressTextEditor.value,
                hint: StringsNameUtils.hitEmailAddress,
                textColor: AppColor.colorText.toColor(),
                hintColor: AppColor.colorText.toColor(),
                underlineColor: AppColor.colorText.toColor(),
                textSize: 15),
            WidgetHelper().sizeBox(height: 20),
            SizedBox(
              width: 300,
              child: WidgetHelper().fillColorButton(
                  text: StringsNameUtils.continues,
                  height: 48,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ontap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    mSignInController.navigateToEmailCheckScreen(
                        emailCheckView(context), context);
                  }),
            ),
            SizedBox(
              width: 300,
              child: WidgetHelper().cancelColorButton(
                  text: StringsNameUtils.cancel,
                  height: 48,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ontap: () {
                    Get.back();
                    mSignInController.emailAddressTextEditor.value.text = "";
                  }),
            )
          ],
        ),
      ),
    );
  }

  /// email view
  Widget emailCheckView(context) {
    return Container(
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
                .titleTextView(titleText: StringsNameUtils.checkEmailAddress),
          ),
          WidgetHelper().sizeBox(height: 16),
          SizedBox(
            width: 300,
            child: WidgetHelper().simpleText(
                text: StringsNameUtils.checkEmailSubTitle,
                textAlign: TextAlign.center,
                fontSize: 16),
          ),
          WidgetHelper().sizeBox(height: 46),
          SizedBox(
            width: 300,
            child: WidgetHelper().simpleTextWithPrimaryColor(
              text: StringsNameUtils.dintReceiveLink,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              textColor: AppColor.colorGray.toColor(),
              textAlign: TextAlign.center,
            ),
          ),
          WidgetHelper().sizeBox(height: 28),
          SizedBox(
            width: 300,
            child: WidgetHelper().cancelColorButton(
                text: StringsNameUtils.btnTextUseDifferentEmail,
                height: 48,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  Get.back();
                  mSignInController.navigateToEmailScreen(
                      emailView(context), context);
                }),
          ),
          SizedBox(
            width: 300,
            child: WidgetHelper().cancelColorButton(
                text: StringsNameUtils.btnTextClose,
                height: 48,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  Get.back();
                }),
          )
        ],
      ),
    );
  }

  /// apple signIn user consent dialog
  Widget userConsent(context) {
    return Container(
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
                .titleTextView(titleText: StringsNameUtils.signInWithApple),
          ),
          WidgetHelper().sizeBox(height: 16),
          SizedBox(
            width: 300,
            child: WidgetHelper().simpleText(
                text: StringsNameUtils.signInWithAppleConsentMessage,
                textAlign: TextAlign.center,
                fontSize: 16),
          ),
          WidgetHelper().sizeBox(height: 46),
          SizedBox(
            width: 300,
            child: WidgetHelper().cancelColorButton(
                text: StringsNameUtils.yes,
                height: 48,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  Get.back();
                  mSignInController.reAuthenticateAppleUser(context);
                }),
          ),
          SizedBox(
            width: 300,
            child: WidgetHelper().cancelColorButton(
                text: StringsNameUtils.no,
                height: 48,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                ontap: () {
                  Get.back();
                }),
          )
        ],
      ),
    );
  }
}
