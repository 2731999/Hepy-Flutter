import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Database/user_location_history_tbl.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/start/current_subscription_plan_model.dart';
import 'package:hepy/app/model/start/start_model.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:provider/provider.dart';

import '../../../model/country_model.dart';

class WelcomeController extends GetxController {
  Rx<TextEditingController> phoneNumberTextEditor = TextEditingController().obs;
  Rx<TextEditingController> countryTextEditor = TextEditingController().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxBool isLoader = false.obs;

  RxList<Country> lstCountryCode = <Country>[].obs;
  RxList<Country> items = <Country>[].obs;
  RxString selectedCountryCode = '+91'.obs;

  RxInt start = 0.obs;
  RxString otpCode = ''.obs;
  RxString countryCodeWithPhone = ''.obs;

  RxString arguments = ''.obs;
  RxBool isResend = false.obs;
  RxInt maxSecond = 40.obs;
  RxInt second = 0.obs;
  static Timer? timer;

  final count = 0.obs;

  RxString firebaseVerificationId = ''.obs;
  RxInt firebaseResendToken = 0.obs;
  int loginType = 0; // Phone:0, Facebook:1, Google:2, Apple:3

  @override
  void onInit() {
    isLoader.value = true;
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.context != null && CommonUtils().auth.currentUser != null) {
      managesSignupFlow(context: Get.context!);
    }else{
      isLoader.value = false;
    }
    super.onReady();
  }

  /*
    This method is validate mobile number,
    mobile number length in between 9-15
    if number is empty it will display empty message
    else it will display mobile validation message
  */
  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{9,15}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      WidgetHelper().showMessage(msg: StringsNameUtils.emptyMobileNoMessage);
      return false;
    } else if (!regExp.hasMatch(value)) {
      WidgetHelper()
          .showMessage(msg: StringsNameUtils.mobileNoValidationMessage);
      return false;
    }
    return true;
  }

  /*
    This method navigate user to otp screen,
    it will first check validation of mobile number,
    if mobile number is validate then user will navigate to otp screen
   */
  void navigateToOtpScreen(Widget widget, context) {
    //   if (countryCodeWithPhone != null) {
    if (validateMobile(phoneNumberTextEditor.value.text)) {
      /* if (Get.isBottomSheetOpen!) {
          Get.back();
        }*/
      isResend.value = false;
      WidgetHelper().showBottomSheetDialog(
          controller: widget,
          enableDrag: false,
          bottomSheetHeight: MediaQuery.of(context).size.height * 0.93);
      signInWithPhoneNumber(context);
    }
    /*} else {
      WidgetHelper().showMessage(msg: StringsNameUtils.emptyMobileNoMessage);
    }*/
  }

  /// This method is start Otp Countdown time
  /// Otp countdown timer is 30 seconds
  /// if timer second is 0 then stop the timer
  resendOtpStartTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second.value > 0) {
        second.value -= 1;
      } else {
        resendOtpStopTimer();
        isResend.value = true;
      }
    });
  }

  ///This method is cancel the timer
  resendOtpStopTimer() {
    timer?.cancel();
  }

  @override
  void onClose() {}

  void onIncrement() => count.value++;

  /// User sign in with mobile number
  /// start resend otp timer
  void signInWithPhoneNumber(context) async {
    // CommonUtils().startLoading(context);
    second.value = maxSecond.value;
    resendOtpStartTimer();
    debugPrint("phone number ${countryCodeWithPhone.value}");
    await CommonUtils().auth.verifyPhoneNumber(
        phoneNumber: countryCodeWithPhone.value,
        verificationCompleted: (PhoneAuthCredential credential) async {
          isLoader.value = false;
          debugPrint("2");
          resendOtpStopTimer();
          // CommonUtils().stopLoading(context);
        },
        verificationFailed: (FirebaseException e) {
          isLoader.value = false;
          WidgetHelper().showMessage(msg: e.message);
          debugPrint("3");
          resendOtpStopTimer();
          //CommonUtils().stopLoading(context);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Create a PhoneAuthCredential with the code
          isLoader.value = false;
          firebaseVerificationId.value = verificationId;
          if (resendToken != null) {
            firebaseResendToken.value = resendToken;
          }
          debugPrint("4");
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  ///This is match the otp which is entered by the user,
  /// This method is create a credential based on otp and authid,
  /// when we get success we add data in firestore database.
  void matchOtp(
      {required BuildContext context,
      AuthCredential? appleLinkCredential}) async {
    CommonUtils().startLoading(context);
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId.value, smsCode: otpCode.value);
    // Sign the user in (or link) with the credential
    try {
      final auth = FirebaseAuth.instance;
      User? user = (await auth.signInWithCredential(phoneAuthCredential)).user;
      debugPrint("provider ===> ${user!.providerData}");
      bool isNavigate = false;
      if (user.phoneNumber != null) {
        UserTbl()
            .checkUserIsExistOrNotFromMobileNo(
                countryCodeWithPhone.value, user.uid)
            .then((isUserFound) async {
          var idToken =
              PreferenceUtils.getStringValue(PreferenceUtils.ID_TOKEN);
          if (idToken != null && idToken.isNotEmpty) {
            AuthCredential credential;

            if (loginType == 3) {
              if (appleLinkCredential != null) {
                try {
                  await user
                      .linkWithCredential(appleLinkCredential)
                      .then((result) {
                    if (!isNavigate) {
                      if (isUserFound) {
                        managesSignupFlow(context: context);
                      } else {
                        UserTbl().insertDataToDatabase(
                            user, countryCodeWithPhone.value);
                        navigateToLocationScreen();
                      }
                    }
                  });
                } on FirebaseAuthException catch (e) {
                  debugPrint("========== Linking Error =======");
                  debugPrint("Apple Credential ====> $appleLinkCredential");
                  debugPrint("Exception ====> $e");
                }
              }
            } else {
              if (loginType == 1) {
                credential = FacebookAuthProvider.credential(idToken);
              } else {
                credential = GoogleAuthProvider.credential(idToken: idToken);
              }
              try {
                await user.linkWithCredential(credential);
                if (!isNavigate) {
                  if (isUserFound) {
                    managesSignupFlow(context: context);
                  } else {
                    UserTbl()
                        .insertDataToDatabase(user, countryCodeWithPhone.value);
                    navigateToLocationScreen();
                  }
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "provider-already-linked") {
                  String providerId;
                  if (loginType == 2) {
                    providerId = "google.com";
                  } else {
                    providerId = "facebook.com";
                  }

                  /// if provider is already exist then unlink previous provider and
                  /// link with new provider.
                  CommonUtils().unLinkProvider(providerId).then((value) {
                    matchOtp(context: context);
                  });
                }
              }
            }
          } else {
            if (isUserFound) {
              // askLocationPermissionToGetCardData(context);
              managesSignupFlow(context: context);
            } else {
              UserTbl().insertDataToDatabase(user!, countryCodeWithPhone.value);
              navigateToLocationScreen();
            }
          }
        });
        // timer is active then cancel it.
        // if (timer!.isActive) timer?.cancel();
      }
      isLoader.value = false;
    } on Exception catch (e) {
      CommonUtils().stopLoading(context);
      WidgetHelper().showMessage(msg: StringsNameUtils.otpNotMatched);
    }
  }

  /// after some time user can able to resend OTP.
  void resendOtp(context) {
    debugPrint("resend otp ====> ${isResend.value}");
    if (isResend.value) {
      signInWithPhoneNumber(context);
      isResend.value = false;
      WidgetHelper().showMessage(msg: StringsNameUtils.otpResendSuccessfully);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.otpResendError);
    }
  }

  void managesSignupFlow({required BuildContext context}) async {
    if (CommonUtils().auth.currentUser != null) {
      UserTbl tbl = UserTbl();
      UserNewModel model = await tbl.getCurrentNewUserByUID(
          FirebaseFirestore.instance, CommonUtils().auth.currentUser!.uid);
      PreferenceUtils.setUserModelData = model;
      if (CommonUtils().auth.currentUser != null) {
        askLocationPermission(context);
      }
    } else {
      Get.toNamed(Routes.WELCOME);
    }
    isLoader.value = false;
  }

  navigateToSignupScreen(int signupStatus) {
    switch (signupStatus) {
      case 0:
        Get.offAllNamed(Routes.LOCATION);
        break;
      case 1:
        Get.offAllNamed(Routes.NAME);
        break;
      case 2:
        Get.offAllNamed(Routes.DOB);
        break;
      case 3:
        Get.offAllNamed(Routes.GENDER);
        break;
      case 4:
        Get.offAllNamed(Routes.LOOKING_FOR);
        break;
      case 5:
        Get.offAllNamed(Routes.ABOUT_ME);
        break;
      case 6:
        Get.offAllNamed(Routes.LANGUAGE);
        break;
      case 7:
        Get.offAllNamed(Routes.SIGNUPPHOTOS);
        break;
      case 8:
        Get.offAllNamed(Routes.VERIFYYOURSELF, arguments: [false]);
        break;
      case 9:
        Get.offAllNamed(Routes.ADDMOREPHOTOS);
        break;
      case 10:
        Get.offAllNamed(Routes.EMAIL);
        break;
      case 11:
        Get.offAllNamed(Routes.DASHBOARD);
        break;
      default:
        Get.toNamed(Routes.WELCOME);
        break;
    }
  }

  void loadCountries() {
    List<Map<String, dynamic>> jsonList = CommonUtils().countryList;
    lstCountryCode.clear();
    for (int i = 0; jsonList.length > i; i++) {
      lstCountryCode.add(Country.fromJson(jsonList[i]));
    }
    items.addAll(lstCountryCode);
  }

  void filterSearchResults(String query) {
    RxList<Country> dummySearchList = <Country>[].obs;
    dummySearchList.addAll(lstCountryCode);
    if (query.isNotEmpty) {
      RxList<Country> dummyListData = <Country>[].obs;
      if (dummySearchList.isNotEmpty) {
        for (var item in dummySearchList) {
          String name = item.name!;
          String code = item.dialCode!;
          if (name.toLowerCase().contains(query.toLowerCase()) ||
              code.toLowerCase().contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        }
      }
      items.clear();
      items.addAll(dummyListData);
      return;
    } else {
      items.clear();
      items.addAll(lstCountryCode);
    }
  }

  navigateToSignInScreen() {
    Get.toNamed(Routes.SIGNIN);
  }

  navigateToLocationScreen() {
    Get.offAllNamed(Routes.LOCATION);
  }

  askLocationPermission(BuildContext context) async {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied) {
      getLocationData(context);
    } else {
      try {
        await Geolocator.requestPermission().then((value) async {
          if (value == LocationPermission.deniedForever ||
              value == LocationPermission.denied) {
            Get.back();
            WidgetHelper()
                .showMessage(msg: StringsNameUtils.locationPermissionMessage);
          } else if (value != LocationPermission.denied) {
            getLocationData(context);
          }
        });
      } on Exception catch (e) {
        debugPrint("Exception");
      }
    }
  }

  askLocationPermissionToGetCardData(BuildContext context) async {
    final permission = await Geolocator.checkPermission();
    final provider = Provider.of<CardProvider>(context, listen: false);
    if (permission != LocationPermission.denied) {
      provider.userCardsAPICall(false);
    } else {
      try {
        await Geolocator.requestPermission().then((value) async {
          if (value == LocationPermission.deniedForever ||
              value == LocationPermission.denied) {
            Get.back();
            WidgetHelper()
                .showMessage(msg: StringsNameUtils.locationPermissionMessage);
          } else if (value != LocationPermission.denied) {
            provider.userCardsAPICall(false);
          }
        });
      } on Exception catch (e) {
        debugPrint("Exception");
      }
    }
  }

  getLocationData(BuildContext context) async {
    isLoader.value = true;
    Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: false,
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var lang = position.longitude;
    final place =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var city = place.first.locality!;

    try {
      UserLocationHistoryTbl().insertDataToLocationHistoryTbl(
          CommonUtils().auth.currentUser!, lat, lang,city);
      startAPICall(lat, lang, city, context);
    } on Exception catch (e) {
      e.toString();
    }
  }

  // todo temp change
  Future<void>startAPICall(
      double lat, double lang, String cityName, BuildContext context) async {
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    debugPrint("IdToken ===> $token");
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    Map<String, dynamic>? location = <String, dynamic>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    location = {'lat': lat, 'lang': lang, 'name': cityName};

    requestParams = {
      'location': location,
      'timezone_offset': DateTime.now().timeZoneOffset.toString()
    };

    apiProvider
        .post(apiurl: ApiUrl.start, header: header, body: requestParams)
        .then((value) async {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        StartModel startModel = StartModel.fromJson(response);
        PreferenceUtils.setStartModelData = startModel;
        if (startModel.currentSubscriptionPlan != null) {
          PreferenceUtils.setLikePerDay =
              startModel.currentSubscriptionPlan!.likesPerDay ?? 0;
          PreferenceUtils.setTodayLike =
              startModel.currentSubscriptionPlan!.todaysLikes ?? 0;
          PreferenceUtils.setBoostUser = startModel.canBoostProfile ?? false;
        }
        manageDataBasedOnSubscriptionType(startModel.currentSubscriptionPlan);
        debugPrint("Start Api Data ====> $response");
        UserTbl userTbl = UserTbl();
        userTbl.updateFirebaseToken();
        switch (startModel.redirectTo) {
          case "sign-up":
            navigateToSignupScreen(startModel.signupStatus!);
            break;
          case "home":
            final permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.deniedForever ||
                permission == LocationPermission.denied) {
              askLocationPermissionToGetCardData(context);
            } else {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.userCardsAPICall(false);
            }
            Get.offAllNamed(Routes.DASHBOARD);
            break;
          case "banned":
            Get.offAllNamed(Routes.BANNED_SCREEN);
            break;
          case "qod":
            Get.offAllNamed(Routes.QOD);
            break;
        }
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        debugPrint("error =====> ${value.body}");
      }
      // CommonUtils().stopLoading(context);
    });
  }

  manageDataBasedOnSubscriptionType(CurrentSubscriptionPlanModel? currentSubscriptionPlanModel) {
    switch (currentSubscriptionPlanModel?.plan?.id) {
      case 1:
        PreferenceUtils.setSuperLike = false;
        PreferenceUtils.setRewindData = false;
        PreferenceUtils.setSuperLikeCount =0;
        break;
      case 2:
        // PreferenceUtils.setSwipePerMonth =
        //     startModel.currentSubscriptionPlan?.swipesPerMonth;
        // PreferenceUtils.setMothSwipe =
        //     startModel.currentSubscriptionPlan?.monthsSwipes;
        PreferenceUtils.setSuperLikeCount =
            currentSubscriptionPlanModel?.superLikesUsed;
        manageSuperLike(2);
        PreferenceUtils.setRewindData = false;
        break;
      case 3:
        PreferenceUtils.setSuperLikeCount =
            currentSubscriptionPlanModel?.superLikesUsed;
        manageSuperLike(3);
        PreferenceUtils.setRewindData = true;
        break;
    }
  }

  manageSuperLike(int planId) {
    switch (planId) {
      case 2:
        if (PreferenceUtils.getSuperLikeCount == 1) {
          PreferenceUtils.setSuperLike = false;
        } else {
          PreferenceUtils.setSuperLike = true;
        }
        break;
      case 3:
        if (PreferenceUtils.getSuperLikeCount == 3) {
          PreferenceUtils.setSuperLike = false;
        } else {
          PreferenceUtils.setSuperLike = true;
        }
        break;
    }
  }
}
