import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Database/user_like_dislike_tbl.dart';
import 'package:hepy/app/Utils/Inapppurchase/in_app_purchase_details.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:hepy/app/modules/like/controller/like_controller.dart';
import 'package:hepy/app/modules/setting/controller/setting_controller.dart';
import 'package:hepy/app/modules/verifyyourself/controller/verify_your_self_controller.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pinput/pinput.dart';

class WidgetHelper {
  DashboardController dashboardController = DashboardController();
  SettingController settingController = SettingController();

  Widget splashIcon(height, width, image, scaleType) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.asset(
        image,
        fit: scaleType,
      ),
    );
  }

  // this is without color buttn common method
  // where user can pass button text,click, height and width
  Widget withoutColorButton(
      {ontap, String? text, margin, double height = 50, double? width}) {
    return InkWell(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: height,
          width: width ?? Get.width / 1.5,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border:
                Border.all(color: AppColor.colorPrimary.toColor(), width: 2),
          ),
          child: Center(
            child: Text(
              text!,
              style: TextStyle(
                  color: AppColor.colorPrimary.toColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget cancelColorButton(
      {ontap, String? text, margin, double height = 50, double? width}) {
    return InkWell(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: height,
          width: width ?? Get.width / 1.5,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColor.colorGray.toColor(), width: 2),
          ),
          child: Center(
            child: Text(
              text!,
              style: TextStyle(
                  color: AppColor.colorGray.toColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Fill common button widget
  Widget fillColorButton(
      {ontap,
      String? text,
      margin,
      double height = 50,
      double? width,
      bool isEnabled = true}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: height,
        width: width ?? Get.width / 1.5,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: isEnabled
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColor.fillColorButtonGradientFirst.toColor(),
                    AppColor.fillColorButtonGradientSecond.toColor(),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.grey.withOpacity(0.5),
                    Colors.grey.withOpacity(0.5),
                  ],
                ),
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isEnabled
                    ? AppColor.colorWhite.toColor()
                    : AppColor.colorGray.toColor(),
                fontSize: 16),
          ),
        ),
      ),
    );
  }

  //This is simple text view with contains only text,
  // with normal text  color and font size
  Widget simpleText(
      {required text,
      TextAlign? textAlign = TextAlign.center,
      double fontSize = 16}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: AppColor.colorText.toColor(), fontSize: fontSize),
    );
  }

  Widget simpleTextWithPrimaryColor(
      {text,
      TextAlign? textAlign = TextAlign.start,
      FontWeight fontWeight = FontWeight.normal,
      TextOverflow overflow = TextOverflow.visible,
      double fontSize = 14,
      bool isEnabled = true,
      required Color textColor}) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: isEnabled ? textColor : AppColor.colorGray.toColor(),
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget simpleTextWithStrikeThrough(
      {text,
      TextAlign? textAlign = TextAlign.start,
      FontWeight fontWeight = FontWeight.normal,
      TextOverflow overflow = TextOverflow.visible,
      double fontSize = 14,
      bool isEnabled = true,
      required Color textColor}) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: isEnabled ? textColor : AppColor.colorGray.toColor(),
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.red,
        decorationThickness: 2.85,
        decorationStyle: TextDecorationStyle.solid,
      ),
    );
  }

  Widget textField(
      {TextEditingController? controller,
      String? hint,
      EdgeInsets? padding,
      FocusNode? focusNode,
      String? errorText,
      bool? isShowLabel = true,
      TextAlign? textAlign = TextAlign.start,
      Color? textColor = Colors.black,
      Color? hintColor = Colors.grey,
      Color underlineColor = Colors.black,
      bool? isEnabled = true,
      bool? isFocusable = false,
      double textSize = 14.0,
      TextInputType keyboardType = TextInputType.name,
      onTap}) {
    return Container(
      padding: padding,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLength: 50,
        textAlign: textAlign!,
        enabled: isEnabled,
        style: TextStyle(color: textColor, fontSize: textSize),
        keyboardType: keyboardType,
        autofocus: isFocusable!,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor),
          errorText: errorText,
          counterText: "",
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
        ),
      ),
    );
  }

  //This is typography view, which is contains in welcome and login screen,
  //according to text line if there is any link over there it will change it's
  //color.
  Widget typographyText(
      {firstLineText,
      firstLinkText,
      secondLineText,
      secondLinkText,
      margin,
      double? width}) {
    SettingController settingController = SettingController();
    return Container(
      margin: margin,
      width: width ?? Get.width / 1.3,
      child: RichText(
        softWrap: true,
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
              color: AppColor.colorText.toColor(),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.montserrat().fontFamily),
          children: <TextSpan>[
            TextSpan(text: firstLineText),
            TextSpan(
                text: firstLinkText,
                style: TextStyle(color: AppColor.colorPrimary.toColor()),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    settingController.goToWebView(
                        StringsNameUtils.termsOfServices,
                        PreferenceUtils.getAppConfig.termsOfServiceUrl);
                  }),
            TextSpan(text: secondLineText),
            TextSpan(
                text: secondLinkText,
                style: TextStyle(color: AppColor.colorPrimary.toColor()),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    settingController.goToWebView(secondLinkText,
                        PreferenceUtils.getAppConfig.privacyPolicyUrl);
                  }),
          ],
        ),
      ),
    );
  }

  //This is header text view with contains header text of view,
  // with header text  color and font size
  Widget titleTextView({required titleText, double fontSize = 24}) {
    return Text(
      titleText,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    );
  }

  Widget sizeBox({double? height, double? width}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  //progress loader view
  loaderWithOpacity() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  loaderWithWhiteBg() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  //common padding or margin view
  commonPaddingOrMargin() {
    return const EdgeInsets.only(top: 30, right: 15, left: 15);
  }

  /// This is OTP view widget, whe OTP get from message and user given autoread permission
  /// the it will directly set.
  Widget otpView(WelcomeController welcomeController) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: AppColor.colorText.toColor(),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: AppColor.colorPrimary.toColor(),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: AppColor.otpBottomCursorColor.toColor(),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      pinAnimationType: PinAnimationType.slide,
      cursor: cursor,
      preFilledWidget: preFilledWidget,
      length: 6,
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      showCursor: true,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
      onCompleted: (pin) => welcomeController.otpCode.value = pin,
    );
  }

  /// This is show error snack bar.
  showMessage({title, msg}) {
    return Get.snackbar(title ?? '', msg,
        duration: const Duration(seconds: 4),
        titleText: title == null ? const SizedBox() : Text(title),
        colorText: Colors.white,
        backgroundColor: AppColor.colorPrimary.toColor().withOpacity(0.5),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20));
  }

  /// Using this method we create bottom sheet dialog where
  /// we can jus pass view's widget.
  showBottomSheetDialog(
      {required Widget controller,
      required double bottomSheetHeight,
      bool enableDrag = true}) {
    return Get.bottomSheet(
      bottomSheetHeight == 0
          ? Wrap(
              children: [controller],
            )
          : SizedBox(
              height: bottomSheetHeight,
              child: controller,
            ),
      backgroundColor: AppColor.colorWhite.toColor(),
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30.0),
        ),
      ),
    );
  }

  ///This method is create simple Appbar with image.
  showAppBar({bool? isShowBackButton = false, onTap}) {
    return AppBar(
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            width: 84,
            ImagePathUtils.appbar_image,
            fit: BoxFit.contain,
            height: 40,
          ),
        ],
      ),
      automaticallyImplyLeading: isShowBackButton!,
      leading: isShowBackButton
          ? InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      ImagePathUtils.back_image,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            )
          : null,
      actions: isShowBackButton
          ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ]
          : null,
      elevation: .5,
      shadowColor: AppColor.colorGray.toColor(),
    );
  }

  ///This method is create home screen appBar.
  homeAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: AppColor.colorPrimary.toColor(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            width: 84,
            ImagePathUtils.appbar_image_white,
            fit: BoxFit.contain,
            height: 40,
          ),
        ],
      ),
      automaticallyImplyLeading: true,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              var value = await Get.toNamed(Routes.EDIT_PROFILE);
              if (value) {
                dashboardController.isProfileUpdate?.value =
                    PreferenceUtils.getStartModelData!.thumbnail!;
              }
            },
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColor.colorWhite.toColor(), width: 1),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(dashboardController
                                .isProfileUpdate!.value.isNotEmpty
                            ? dashboardController.isProfileUpdate!.value
                            : PreferenceUtils.getStartModelData!.thumbnail!),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            Get.toNamed(Routes.SETTINGS_SCREEN);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  ImagePathUtils.setting_image,
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
        )
      ],
      elevation: .5,
    );
  }

  chatMessageAppBr(
      {required String? userImage,
      required String? userName,
      bool? isShowReportMenu = false,
      onBack,
      onReport}) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: AppColor.colorPrimary.toColor(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColor.colorWhite.toColor(), width: 1),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(userImage!), fit: BoxFit.cover),
              ),
            ),
          ),
          WidgetHelper().sizeBox(width: 19),
          WidgetHelper().simpleTextWithPrimaryColor(
              textColor: AppColor.colorWhite.toColor(),
              text: userName,
              fontSize: 16,
              fontWeight: FontWeight.w700)
        ],
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: onBack,
            child: Image.asset(
              ImagePathUtils.back_image,
              height: 24,
              width: 24,
              color: AppColor.colorWhite.toColor(),
            ),
          ),
        ],
      ),
      actions: [
        if (isShowReportMenu!)
          InkWell(
            onTap: onReport,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    ImagePathUtils.report_image,
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          )
      ],
      elevation: .5,
    );
  }

  genderController(
      {double width = 275,
      double height = 50,
      Color borderColor = Colors.grey,
      String? text,
      onTap}) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          child: Center(
            child: Text(
              text!,
              style: TextStyle(fontWeight: FontWeight.w600, color: borderColor),
            ),
          ),
        ),
      ),
    );
  }

  showAppBarOnlyBackArrow({onTap}) {
    return Column(
      children: [
        WidgetHelper().sizeBox(height: 30),
        SizedBox(
          height: 80,
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    ImagePathUtils.back_image,
                    color: AppColor.colorWhite.toColor(),
                    height: 24,
                    width: 24,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Image button widget
  Widget imageButton(
      {onClick,
      String? image,
      margin,
      scaleType,
      double height = 100,
      double? width,
      bool isEnabled = true}) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: height,
        width: width ?? Get.width / 1.5,
        margin: margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColor.colorWhite.toColor()),
        child: Center(
            child: SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            image!,
            fit: scaleType,
          ),
        )),
      ),
    );
  }

  /// This is display verify user dialog and set verified user image
  verifyUserDialog(
      BuildContext context,
      VerifyYourSelfController verifyYourSelfController,
      bool isVerification,
      bool checkIsVerify,
      int statusCode) {
    var editItem = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 100,
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
                width: MediaQuery.of(context).size.width / 3,
                height: 100,
                margin: const EdgeInsets.only(top: 10, left: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    isVerification
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Image.asset(
                              ImagePathUtils.verified_image,
                              width: 25,
                              height: 25,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Image.asset(
                              ImagePathUtils.failed_image,
                              width: 27,
                              height: 27,
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
          WidgetHelper().sizeBox(height: 20),
          SizedBox(
            width: 284,
            child: WidgetHelper().titleTextView(
                titleText: isVerification
                    ? StringsNameUtils.verificationCompleted
                    : StringsNameUtils.verificationFailed,
                fontSize: 30),
          ),
          WidgetHelper().sizeBox(height: 16),
          WidgetHelper().simpleText(
              text: isVerification
                  ? StringsNameUtils.verificationCompletedMessage
                  : statusCode == 403
                      ? StringsNameUtils.verificationFailed403Message
                      : StringsNameUtils.verificationFailedMessage,
              textAlign: TextAlign.center),
          WidgetHelper().sizeBox(height: 40),
          WidgetHelper().fillColorButton(
            ontap: () {
              if (checkIsVerify) {
                verifyYourSelfController.isVerifiedPhotoUpdate(
                    CommonUtils().auth.currentUser!.uid, isVerification);
                UserTbl()
                    .getCurrentNewUserByUID(FirebaseFirestore.instance,
                        CommonUtils().auth.currentUser!.uid)
                    .then(
                  (value) {
                    if (isVerification) {
                      settingController.isVerified.value = isVerification;
                      Get.back(result: true);
                      Get.back(result: true);
                    } else {
                      Get.back(result: false);
                    }
                  },
                );
              } else {
                if (isVerification) {
                  verifyYourSelfController.navigateToAddMorePhotoScreen();
                } else {
                  Get.back();
                }
              }
            },
            text: StringsNameUtils.continues,
            height: 45,
          ),
          WidgetHelper().sizeBox(height: 20),
        ],
      ),
    );
    return showDialog(
        //like that
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return editItem;
        });
  }

  subscriptionDialog(
      {required BuildContext context,
      required int? planId,
      required isStandardPlanSelected,
      required isGoldPlanSelected,
      required isPlatinumPlanSelected,
      required goldPlanPriceWithCurrency,
      required platinumPriceWithCurrency,
      required goldPlanPrice,
      required platinumPlanPrice,
      required currencySymbol,
      required isFromSetting,
      required isOnlyForGold,
      required isOnlyForPlatinum}) {
    var dialog = AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Center(
                        child: WidgetHelper().simpleTextWithPrimaryColor(
                            textColor: AppColor.colorPrimary.toColor(),
                            text: isFromSetting
                                ? StringsNameUtils.choosePlan
                                : (isOnlyForGold)
                                    ? StringsNameUtils.upgradeToGoldOrPlatinum
                                    : StringsNameUtils.upgradeToPlatinum,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        ImagePathUtils.close_image,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  )
                ],
              ),
              if (isFromSetting && planId == 1)
                standardPlanView(isStandardPlan: isStandardPlanSelected),
              if (isOnlyForGold || isFromSetting)
                goldPlanView(
                    isGoldPlan: isGoldPlanSelected,
                    goldPlanPriceWithCurrency: goldPlanPriceWithCurrency,
                    goldPlanPrice: goldPlanPrice,
                    currencySymbol: currencySymbol),
              if (isOnlyForPlatinum || isFromSetting)
                platinumPlanView(
                    isPlatinumPlan: isPlatinumPlanSelected,
                    platinumPriceWithCurrency: platinumPriceWithCurrency,
                    platinumPlanPrice: platinumPlanPrice,
                    currencySymbol: currencySymbol),
              WidgetHelper().sizeBox(height: 16),
              InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.colorGray.toColor(),
                      text: StringsNameUtils.noThanks,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
    return showDialog(
        //like that
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: dialog,
          );
        });
  }

  profileMatchDialog(
      BuildContext context,
      String? matchedName,
      String? matchUrl,
      String? myPic,
      UserCardsModel? userCardsModel,
      int likingStatus) {
    var matchDialog = AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              WidgetHelper().sizeBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  ImagePathUtils.wow_its_a_match_image,
                  width: 243,
                  height: 120,
                ),
              ),
              WidgetHelper().sizeBox(height: 24),
              WidgetHelper().simpleTextWithPrimaryColor(
                  textColor: AppColor.colorText.toColor(),
                  text:
                      '${StringsNameUtils.matchDialogTitleContent1}$matchedName${StringsNameUtils.matchDialogTitleContent2}',
                  fontSize: 16),
              WidgetHelper().sizeBox(height: 48),
              Stack(
                children: [
                  Container(
                    width: Get.width / 2,
                    height: 170,
                    margin: const EdgeInsets.only(top: 19, right: 110),
                    padding: const EdgeInsets.all(5),
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
                              image: NetworkImage(matchUrl!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width / 2,
                    height: 170,
                    margin: const EdgeInsets.only(top: 19, left: 110),
                    padding: const EdgeInsets.all(5),
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
                              image: NetworkImage(myPic!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 76),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.colorPrimary.toColor(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (userCardsModel != null) {
                        LikeController likeController = LikeController();
                        Conversations? matchConversationModel =
                            await likeController.getConversationData(
                                userCardsModel: userCardsModel,
                                likingStatus: likingStatus);

                        Get.toNamed(Routes.CHAT_MESSAGE_SCREEN,
                            arguments: [matchConversationModel]);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        WidgetHelper().sizeBox(width: 12),
                        Image.asset(
                          ImagePathUtils.home_chat_image,
                          color: AppColor.colorWhite.toColor(),
                          width: 16,
                          height: 16,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: WidgetHelper().simpleTextWithPrimaryColor(
                                textColor: AppColor.colorWhite.toColor(),
                                text:
                                    StringsNameUtils.sendAMessage.toUpperCase(),
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              WidgetHelper().sizeBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: AppColor.colorPrimary.toColor()),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (userCardsModel != null) {
                        LikeController likeController = LikeController();
                        likeController.getConversationData(
                            userCardsModel: userCardsModel,
                            likingStatus: likingStatus);

                        Get.back();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        WidgetHelper().sizeBox(width: 12),
                        Image.asset(
                          ImagePathUtils.match_person_image,
                          width: 16,
                          height: 16,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: WidgetHelper().simpleTextWithPrimaryColor(
                                textColor: AppColor.colorPrimary.toColor(),
                                text:
                                    StringsNameUtils.keepSwiping.toUpperCase(),
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return showDialog(
        //like that
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(15),
            child: matchDialog,
          );
        });
  }

  standardPlanView({required bool isStandardPlan}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 16, left: 5, right: 5),
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: AppColor.colorDisabled.toColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 36),
                  child: Row(
                    children: [
                      Image.asset(
                        ImagePathUtils.selected_plan_checked_circle_image,
                        width: 20,
                        height: 20,
                      ),
                      WidgetHelper().sizeBox(width: 8),
                      Flexible(
                        child: WidgetHelper().simpleTextWithPrimaryColor(
                            textColor: AppColor.colorText.toColor(),
                            text: StringsNameUtils.standardSwipe,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        ImagePathUtils.selected_plan_checked_circle_image,
                        width: 20,
                        height: 20,
                      ),
                      WidgetHelper().sizeBox(width: 8),
                      Flexible(
                        child: WidgetHelper().simpleTextWithPrimaryColor(
                            textColor: AppColor.colorText.toColor(),
                            text: StringsNameUtils.standardMessageLimit,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 34),
                  child: Row(
                    children: [
                      Image.asset(
                        ImagePathUtils.selected_plan_checked_circle_image,
                        width: 20,
                        height: 20,
                      ),
                      WidgetHelper().sizeBox(width: 8),
                      Flexible(
                        child: WidgetHelper().simpleTextWithPrimaryColor(
                            textColor: AppColor.colorText.toColor(),
                            text: StringsNameUtils.standardMatchLimit,
                            fontSize: 16),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: Center(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                    color: AppColor.colorDisabled.toColor(), width: 1),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 6, left: 24, right: 24, bottom: 6),
                child: WidgetHelper().simpleTextWithPrimaryColor(
                    textColor: AppColor.colorText.toColor(),
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    text: StringsNameUtils.standardPlane),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          width: Get.width / 1.20,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColor.colorGray.toColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 6, left: 24, right: 24, bottom: 6),
                child: WidgetHelper().simpleTextWithPrimaryColor(
                    textColor: AppColor.colorWhite.toColor(),
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    text: isStandardPlan
                        ? StringsNameUtils.currentPlan
                        : StringsNameUtils.choosePlan),
              ),
            ),
          ),
        ),
      ],
    );
  }

  goldPlanView(
      {required bool isGoldPlan,
      required String goldPlanPriceWithCurrency,
      required double goldPlanPrice,
      required String currencySymbol}) {
    return InkWell(
      onTap: () async {
        InAppPurchaseDetails inAppPurchaseDetails = InAppPurchaseDetails();
        final productDetails = await inAppPurchaseDetails.initStoreInfo(
            productId: Platform.isAndroid
                ? PreferenceUtils.getAppConfig.goldPlanPlayStoreId
                : PreferenceUtils.getAppConfig.goldPlanAppStoreId);
        inAppPurchaseDetails.purchaseView(
            productDetails: productDetails[3],
            oldPlanId: PreferenceUtils
                .getStartModelData?.currentSubscriptionPlan?.plan?.id,
            newPlanId: 2);
      },
      child: Stack(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 30, bottom: 16, left: 5, right: 5),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColor.goldPlanColor.toColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: WidgetHelper().simpleTextWithPrimaryColor(
                                  textColor: AppColor.colorWhite.toColor(),
                                  text:
                                      '${StringsNameUtils.now}$goldPlanPriceWithCurrency${StringsNameUtils.mo}',
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Row(
                              children: [
                                Center(
                                  child: WidgetHelper()
                                      .simpleTextWithPrimaryColor(
                                          textColor:
                                              AppColor.colorWhite.toColor(),
                                          text: StringsNameUtils.was,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                Center(
                                  child: WidgetHelper()
                                      .simpleTextWithStrikeThrough(
                                          textColor:
                                              AppColor.colorWhite.toColor(),
                                          text: InAppPurchaseDetails()
                                              .planPriceCalculation(
                                                  planPrice: goldPlanPrice,
                                                  currencySymbol:
                                                      currencySymbol)[0],
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                Center(
                                  child: WidgetHelper()
                                      .simpleTextWithPrimaryColor(
                                          textColor:
                                              AppColor.colorWhite.toColor(),
                                          text: InAppPurchaseDetails()
                                              .planPriceCalculation(
                                                  planPrice: goldPlanPrice,
                                                  currencySymbol:
                                                      currencySymbol)[1],
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.goldPlanSwipe,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.goldPlanLike,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.goldMessageLimit,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 8, bottom: 34),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.goldSuperLikeLimit,
                              fontSize: 16),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Center(
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: AppColor.goldPlanColor.toColor(), width: 1),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 24, right: 24, bottom: 6),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.goldPlanColor.toColor(),
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      text: StringsNameUtils.goldPlan),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: Get.width / 1.20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: AppColor.unSelectedPlanButtonColor.toColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 24, right: 24, bottom: 6),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.colorWhite.toColor(),
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      text: isGoldPlan
                          ? StringsNameUtils.currentPlan
                          : StringsNameUtils.choosePlan),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  platinumPlanView(
      {required bool isPlatinumPlan,
      required String platinumPriceWithCurrency,
      required double platinumPlanPrice,
      required String currencySymbol}) {
    return InkWell(
      onTap: () async {
        InAppPurchaseDetails inAppPurchaseDetails = InAppPurchaseDetails();
        final productDetails = await inAppPurchaseDetails.initStoreInfo(
            productId: Platform.isAndroid
                ? PreferenceUtils.getAppConfig.platinumPlanPlayStoreId
                : PreferenceUtils.getAppConfig.platinumPlanAppStoreId);
        inAppPurchaseDetails.purchaseView(
            productDetails: productDetails[3],
            oldPlanId: PreferenceUtils
                .getStartModelData?.currentSubscriptionPlan?.plan?.id,
            newPlanId: 3);
      },
      child: Stack(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 30, bottom: 16, left: 5, right: 5),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColor.platinumPlanColor.toColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: WidgetHelper().simpleTextWithPrimaryColor(
                                  textColor: AppColor.colorWhite.toColor(),
                                  text:
                                      '${StringsNameUtils.now}$platinumPriceWithCurrency${StringsNameUtils.mo}',
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Row(
                              children: [
                                Center(
                                  child: WidgetHelper()
                                      .simpleTextWithPrimaryColor(
                                          textColor:
                                              AppColor.colorWhite.toColor(),
                                          text: StringsNameUtils.was,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                Center(
                                  child: WidgetHelper()
                                      .simpleTextWithStrikeThrough(
                                          textColor:
                                              AppColor.colorWhite.toColor(),
                                          text: InAppPurchaseDetails()
                                              .planPriceCalculation(
                                                  planPrice: platinumPlanPrice,
                                                  currencySymbol:
                                                      currencySymbol)[0],
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                Center(
                                  child: WidgetHelper()
                                      .simpleTextWithPrimaryColor(
                                          textColor:
                                              AppColor.colorWhite.toColor(),
                                          text: InAppPurchaseDetails()
                                              .planPriceCalculation(
                                                  planPrice: platinumPlanPrice,
                                                  currencySymbol:
                                                      currencySymbol)[1],
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumPlanSwipe,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumPlanLikes,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumMessageLimit,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumSuperLikeLimit,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumRewind,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumWhoLikesYou,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 8, bottom: 34),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePathUtils.unselected_plan_check_circle_image,
                          width: 20,
                          height: 20,
                        ),
                        WidgetHelper().sizeBox(width: 8),
                        Flexible(
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorWhite.toColor(),
                              text: StringsNameUtils.platinumProfileBooster,
                              fontSize: 16),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Center(
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: AppColor.platinumPlanColor.toColor(), width: 1),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 24, right: 24, bottom: 6),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.platinumPlanColor.toColor(),
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      text: StringsNameUtils.platinumPlan),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: Get.width / 1.20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: AppColor.platinumPlanBottomColor.toColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 24, right: 24, bottom: 6),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.colorWhite.toColor(),
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      text: isPlatinumPlan
                          ? StringsNameUtils.currentPlan
                          : StringsNameUtils.choosePlan),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAppBarText({onDone, title}) {
    return AppBar(
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.colorText.toColor()),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Center(
          child: Text(
            "   ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.colorWhite.toColor()),
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: onDone,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: Center(
              child: Text(
                "Done",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColor.colorPrimary.toColor()),
              ),
            ),
          ),
        )
      ],
      elevation: .5,
      shadowColor: AppColor.colorGray.toColor(),
    );
  }

  Widget primaryOutlinedButton({String? text, onPressed}) {
    return OutlinedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            splashFactory: NoSplash.splashFactory,
            side:
                BorderSide(width: 2.0, color: AppColor.colorPrimary.toColor()),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.00))),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            onPrimary: AppColor.colorPrimary.toColor(),
            textStyle: TextStyle(
                fontFamily: GoogleFonts.montserrat().fontFamily,
                fontWeight: FontWeight.bold)),
        onPressed: onPressed,
        child: Text(text!, textAlign: TextAlign.center));
  }
}
