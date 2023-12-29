import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hepy/app/model/uploadphoto/user_upload_photo_model.dart';
import 'package:hepy/app/model/user/current_location_model.dart';
import 'package:hepy/app/model/user/current_subscription_plan_model.dart';
import 'package:hepy/app/model/user/demographics_model.dart';
import 'package:hepy/app/model/user/filter_model.dart';
import 'package:hepy/app/model/user/selfie_model.dart';
import 'package:hepy/app/model/user/todays_question_model.dart';
import 'package:hepy/app/model/user/user_settings.dart';

class UserNewModel {
  String? lastName;
  List<String>? lstLanguage = [];
  String? gender;
  bool? isVerified;
  String? displayName;
  String? displayNameSearch;
  String? initials;
  FilterModel? filters = FilterModel();
  int? signupStatus;
  CurrentLocationModel? currentLocation = CurrentLocationModel();
  Timestamp? createdAt;
  String? firstName;
  String? uid;
  String? phone;
  Timestamp? dob;
  String? status;
  DemographicsModel? demographics = DemographicsModel();
  Timestamp? updatedAt;
  String? email;
  Timestamp? profileBoostedTill;
  CurrentSubscriptionPlanModel? currentSubscriptionPlan =
      CurrentSubscriptionPlanModel();
  SelfieModel? selfie = SelfieModel();
  TodaysQuestionModel? todaysQuestion = TodaysQuestionModel();
  List<UserUploadPhotoModel> lstUserPhotos = [];
  UserSettingsModel? userSettings = UserSettingsModel();
  String? uuid = '';

  UserNewModel({
    this.lastName,
    this.lstLanguage,
    this.gender,
    this.isVerified,
    this.displayName,
    this.displayNameSearch,
    this.initials,
    this.filters,
    this.signupStatus,
    this.currentLocation,
    this.createdAt,
    this.firstName,
    this.uid,
    this.phone,
    this.dob,
    this.status,
    this.demographics,
    this.updatedAt,
    this.email,
    this.profileBoostedTill,
    this.currentSubscriptionPlan,
    this.selfie,
    this.todaysQuestion,
    this.userSettings,
    this.uuid,
  });

  factory UserNewModel.fromJsonMap(Map<String, dynamic> json) => UserNewModel(
        lastName: json["lastName"] ?? '',
        lstLanguage: json["languages"] != null
            ? List<String>.from(json["languages"].map((x) => x))
            : <String>[],
        gender: json["gender"] ?? '',
        isVerified: json["isVerified"] ?? false,
        displayName: json["displayName"] ?? '',
        displayNameSearch: json["displayNameSearch"] ?? '',
        initials: json["initials"] ?? '',
        filters: json["filters"] != null
            ? FilterModel.fromJson(json["filters"])
            : FilterModel(),
        userSettings: json["userSettings"] != null
            ? UserSettingsModel.fromJson(json["userSettings"])
            : UserSettingsModel(),
        signupStatus: json["signupStatus"] ?? 0,
        currentLocation: json["currentLocation"] != null
            ? CurrentLocationModel.fromJson(json["currentLocation"])
            : null,
        createdAt: json["createdAt"],
        firstName: json["firstName"] ?? '',
        uid: json["uid"] ?? '',
        phone: json["phone"] ?? '',
        dob: json["dob"],
        status: json["status"] ?? '',
        demographics: json["demographics"] != null
            ? DemographicsModel.fromJson(json["demographics"])
            : null,
        updatedAt: json["updatedAt"],
        email: json["email"] ?? '',
        profileBoostedTill: json["profileBoostedTill"],
        currentSubscriptionPlan: json["currentSubscriptionPlan"] != null
            ? CurrentSubscriptionPlanModel.fromJson(
                json["currentSubscriptionPlan"])
            : null,
        selfie: json["selfie"] != null
            ? SelfieModel.fromJson(json["selfie"])
            : null,
        todaysQuestion: json["todaysQuestion"] != null
            ? TodaysQuestionModel.fromJson(json["todaysQuestion"])
            : null,
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "lastName": lastName,
        "languages": lstLanguage != null
            ? List<dynamic>.from(lstLanguage!.map((x) => x))
            : null,
        "gender": gender,
        "isVerified": isVerified,
        "displayName": displayName,
        "displayNameSearch": displayNameSearch,
        "initials": initials,
        "filters": filters?.toJson(),
        "signupStatus": signupStatus,
        "currentLocation": currentLocation?.toJson(),
        "createdAt": createdAt,
        "firstName": firstName,
        "uid": uid,
        "phone": phone,
        "dob": dob,
        "status": status,
        "demographics": demographics?.toJson(),
        "updatedAt": updatedAt,
        "email": email,
        "profileBoostedTill": profileBoostedTill,
        "currentSubscriptionPlan": currentSubscriptionPlan?.toJson(),
        "selfie": selfie?.toJson(),
        "todaysQuestion": todaysQuestion?.toJson(),
        "userSettings": userSettings?.toJson(),
        "uuid": uuid,
      };
}
