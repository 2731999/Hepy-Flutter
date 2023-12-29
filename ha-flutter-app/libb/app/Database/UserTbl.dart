import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/enum/user_signup_status.dart';
import 'package:hepy/app/model/user/current_location_model.dart';
import 'package:hepy/app/model/user/demographics_model.dart';
import 'package:hepy/app/model/user/filter_model.dart';
import 'package:hepy/app/model/user/todays_question_model.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/model/user/user_settings.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserTbl {
  UserNewModel userNewModel = UserNewModel();

  /// This method is insert data into user directory based of firebase UID
  /// if uid is not there then create new user,
  /// if uid is exist then replace the user.
  /// we only pass current user.
  void insertDataToDatabase(User currentUser, String phoneNumber) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    var uuid = Uuid();

    Map<String, dynamic> userSettings = {
      'deviceToken': firebaseToken!,
      'tokenDate': Timestamp.fromDate(DateTime.now())
    };

    //writting all the value
    userNewModel.uid = user.uid;
    userNewModel.uuid = uuid.v4();
    userNewModel.createdAt = Timestamp.fromDate(DateTime.now());
    debugPrint('TimeStamp ===> ${Timestamp.fromDate(DateTime.now())}');
    userNewModel.signupStatus = UserSignupStatus.account.index;
    userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
    userNewModel.phone = phoneNumber;
    userNewModel.userSettings = UserSettingsModel.fromJson(userSettings);
    PreferenceUtils.setSignUpStatus = UserSignupStatus.account.index.toString();
    await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .doc(user.uid)
        .set(userNewModel.toJson());
  }

  updateFirebaseToken({bool isRemovedToken = false}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String? firebaseToken = await FirebaseMessaging.instance.getToken();

    firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .doc(CommonUtils().auth.currentUser?.uid)
        .update({
      'userSettings.deviceToken': isRemovedToken ? '' : firebaseToken,
      'userSettings.tokenDate': Timestamp.fromDate(DateTime.now())
    });
  }

  ///This method is first get existing user from database,
  ///then add location data in existing user and update database.
  void insertUserLocationInToDatabase(
    User currentUser,
    String street,
    String city,
    String country,
    double lat,
    double lang,
  ) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    ///Add lat lang
    Map<String, double> latLang = {
      "lat": lat,
      "lang": lang,
    };

    ///Add current location
    Map<String, dynamic> location = {
      "coords": latLang,
      "name": city,
      "timezoneOffset": DateTime.now().timeZoneOffset.toString(),
    };

    ///This method get current user and set data into model
    /// we add more data related location
    /// and update current user details.
    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.currentLocation = CurrentLocationModel.fromJson(location);
      userNewModel.signupStatus = UserSignupStatus.location.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.location.index.toString();

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  ///This method is first get existing user from database,
  ///add firstName, LastName etc.. and update Users table.
  void addFirstNameAndLastName(
    User currentUser,
    String? firstName,
    String? lastName,
  ) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    var initial = '${firstName![0]} ${lastName![0]}';
    var displayName = '$firstName $lastName';
    var displayNameSearch = '${firstName.toUpperCase()} ${lastName.toUpperCase()}';

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.firstName = firstName;
      userNewModel.lastName = lastName;
      userNewModel.initials = initial;
      userNewModel.displayName = displayName;
      userNewModel.displayNameSearch = displayNameSearch;
      userNewModel.signupStatus = UserSignupStatus.name.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus = UserSignupStatus.name.index.toString();

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  ///This method is first get existing user from database,
  ///add DOB and update Users table.
  void addDob(Timestamp dob, User currentUser) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.dob = dob;
      userNewModel.signupStatus = UserSignupStatus.dob.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus = UserSignupStatus.dob.index.toString();

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  ///This method is first get existing user from database,
  ///add Gender and update Users table.
  void addGender(String gender, User currentUser) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.gender = gender;
      userNewModel.signupStatus = UserSignupStatus.gender.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.gender.index.toString();

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  ///This method is first get existing user from database,
  ///add Filters and update Users table.
  void addLookingFor(
      String lookingFor, User currentUser, BuildContext context) async {
    CommonUtils().startLoading(context);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    Map<String, dynamic> ageRange = {"min": 18, "max": 30};

    ///Add LookingFor
    Map<String, dynamic> lookingForMap = {
      "lookingFor": lookingFor,
      "ageRange": ageRange,
      "locationRadius": 15000
    };

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.filters = FilterModel.fromJson(lookingForMap);
      userNewModel.signupStatus = UserSignupStatus.lookingFor.index;
      userNewModel.userSettings?.messageDisappear = "24h";
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.lookingFor.index.toString();
      PreferenceUtils.setUserModelData = userNewModel;

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));

      CommonUtils().stopLoading(context);
      Get.offNamed(Routes.ABOUT_ME);
    });
  }

  void addAboutMe(
      {required String aboutMeKey,
      required String aboutMeValue,
      required User currentUser}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    ///Add demographic
    Map<String, dynamic> demographicMap = {
      aboutMeKey: aboutMeValue,
    };

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      Map<String, dynamic>? before = userNewModel.demographics?.toJson();
      if (before != null) {
        before.remove(aboutMeKey);
        demographicMap.addAll(before);
      }
      userNewModel.demographics = DemographicsModel.fromJson(demographicMap);
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setUserModelData = userNewModel;
      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  void updateAboutMeSignupStatus({required User currentUser}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.signupStatus = UserSignupStatus.about.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus = UserSignupStatus.about.index.toString();
      PreferenceUtils.setUserModelData = userNewModel;
      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  void addSelectedLanguage(
      {required RxList<String> lstSelectedLanguage,
      required User currentUser,
      required bool isFromLanguage}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.lstLanguage = lstSelectedLanguage.value;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      if (isFromLanguage) {
        userNewModel.signupStatus = UserSignupStatus.language.index;
        PreferenceUtils.setSignUpStatus =
            UserSignupStatus.language.index.toString();
      }

      PreferenceUtils.setUserModelData = userNewModel;
      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  void addPhotos({required User currentUser}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.signupStatus = UserSignupStatus.mandatoryPhotos.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.mandatoryPhotos.index.toString();
      PreferenceUtils.setUserModelData = userNewModel;

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  void verifiedPhoto(
      {required User currentUser,
      required bool isUserVerified,
      required bool checkIsVerify}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      userNewModel.isVerified = isUserVerified;
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.mandatoryPhotos.index.toString();
      PreferenceUtils.setUserModelData = userNewModel;

      if (!checkIsVerify) {
        userNewModel.signupStatus = UserSignupStatus.verify.index;
      }

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  void updateAddMorePhotosSignupStatus({required User currentUser}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.signupStatus = UserSignupStatus.morePhotos.index;
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.morePhotos.index.toString();
      PreferenceUtils.setUserModelData = userNewModel;

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  void addEmailAddress(String email, User currentUser) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.email = email.toLowerCase();
      userNewModel.signupStatus = UserSignupStatus.signedUp.index;
      userNewModel.status = 'active';
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());
      PreferenceUtils.setSignUpStatus =
          UserSignupStatus.signedUp.index.toString();
      PreferenceUtils.setUserModelData = userNewModel;

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  /// This method is add today's question in user table
  Future<void> addTodaysQuestions(String questionId, String answer,
      User currentUser, BuildContext context) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    Map<String, String> todaysQuesion = {
      'questionId': questionId,
      'answer': answer
    };

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.todaysQuestion = TodaysQuestionModel.fromJson(todaysQuesion);
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true))
          .then((value) {
        navigateToHomeScreen(context);
      });
    });
  }

  navigateToHomeScreen(BuildContext context) async {
    WelcomeController welcomeController = WelcomeController();
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      welcomeController.askLocationPermissionToGetCardData(context);
    } else {
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.userCardsAPICall(false);
    }
    Get.offAllNamed(Routes.DASHBOARD);
  }

  /// This method is add today's question in user table
  void boostProfileTiming(User currentUser) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = currentUser;

    getCurrentNewUserByUID(firebaseFirestore, currentUser.uid)
        .then((userNewModel) async {
      userNewModel.profileBoostedTill =
          Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 30)));
      userNewModel.updatedAt = Timestamp.fromDate(DateTime.now());

      await firebaseFirestore
          .collection(StringsNameUtils.tblUsers)
          .doc(user.uid)
          .set(userNewModel.toJson(), SetOptions(merge: true));
    });
  }

  Future<UserNewModel> getCurrentNewUserByUID(
      FirebaseFirestore firebaseFirestore, String userUid) async {
    await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .doc(userUid)
        .get()
        .then((value) {
      if (value.exists) {
        debugPrint("User Data: ===> ${value.data()}");
        if (value.data() != null) {
          userNewModel = UserNewModel.fromJsonMap(value.data()!);
          PreferenceUtils.setUserModelData = userNewModel;
        }
      }
    });
    return userNewModel;
  }

  Future<String?> getCurrentUserMessageDisappearByUid(String uid) async {
    String? messageDisappear = "24h";
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data() != null) {
          userNewModel = UserNewModel.fromJsonMap(value.data()!);
          messageDisappear = userNewModel.userSettings?.messageDisappear;
        }
      }
    });
    return messageDisappear;
  }

  Future<int?> getPlanIdByUid(String uid) async {
    int? planId = 1;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data() != null) {
          userNewModel = UserNewModel.fromJsonMap(value.data()!);
          planId = userNewModel.currentSubscriptionPlan?.id;
        }
      }
    });
    return planId;
  }

  Future<String?> getUuidToPurchaseIOSPlan(String? uid) async{
    String? uuid = '';
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data() != null) {
          userNewModel = UserNewModel.fromJsonMap(value.data()!);
          uuid = userNewModel.uuid;
        }
      }
    });
    return uuid;
  }

  Future<bool> checkUserIsExistOrNotFromMobileNo(
      String phoneNo, String userId) async {
    bool match = false;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List<UserNewModel> lstAllUser = <UserNewModel>[];
    await firebaseFirestore
        .collection(StringsNameUtils.tblUsers)
        .get()
        .then((value) {
      List.from(value.docs.map((user) {
        lstAllUser.add(UserNewModel.fromJsonMap(user.data()));
        // debugPrint("UserData ===> ${user.data()}");
      }));
      for (var element in lstAllUser) {
        if (element.phone == phoneNo && element.uid == userId) {
          return match = true;
        }
      }
    });
    return match;
  }
}
