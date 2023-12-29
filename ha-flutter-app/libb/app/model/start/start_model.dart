import 'package:hepy/app/model/start/current_subscription_plan_model.dart';

class StartModel{
  String? uid;
  String? initials;
  String? displayName;
  String? firstName;
  String? thumbnail;
  bool? isVerified;
  int? signupStatus;
  String? gender;
  bool? canBoostProfile;
  CurrentSubscriptionPlanModel? currentSubscriptionPlan;
  String? redirectTo;

  StartModel(
      {this.uid,
        this.initials,
        this.displayName,
        this.thumbnail,
        this.firstName,
        this.isVerified,
        this.signupStatus,
        this.gender,
        this.canBoostProfile,
        this.currentSubscriptionPlan,
        this.redirectTo});

  StartModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    initials = json['initials'];
    displayName = json['displayName'];
    thumbnail = json['thumbnail'];
    firstName = json['firstName'];
    isVerified = json['isVerified'];
    signupStatus = json['signupStatus'];
    gender = json['gender'];
    canBoostProfile = json['canBoostProfile'];
    currentSubscriptionPlan = json['currentSubscriptionPlan'] != null
        ? CurrentSubscriptionPlanModel.fromJson(json['currentSubscriptionPlan'])
        : null;
    redirectTo = json['redirectTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['initials'] = initials;
    data['displayName'] = displayName;
    data['thumbnail'] = thumbnail;
    data['firstName'] = firstName;
    data['isVerified'] = isVerified;
    data['signupStatus'] = signupStatus;
    data['gender'] = gender;
    data['canBoostProfile'] = canBoostProfile;
    if (currentSubscriptionPlan != null) {
      data['currentSubscriptionPlan'] = currentSubscriptionPlan!.toJson();
    }
    data['redirectTo'] = redirectTo;
    return data;
  }
}