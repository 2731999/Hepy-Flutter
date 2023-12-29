import 'package:hepy/app/modules/setting/controller/setting_controller.dart';

import '../start/current_subscription_plan_model.dart';

class UpgradeAndDowngradePlan {
  bool success = false;
  bool? canBoostProfile;
  CurrentSubscriptionPlanModel? currentSubscriptionPlanModel;

  UpgradeAndDowngradePlan(
      this.canBoostProfile, this.currentSubscriptionPlanModel,
      [this.success = false]);

  UpgradeAndDowngradePlan.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    canBoostProfile = json['canBoostProfile'];
    currentSubscriptionPlanModel = json['currentSubscriptionPlan'] != null
        ? CurrentSubscriptionPlanModel.fromJson(json['currentSubscriptionPlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['canBoostProfile'] = canBoostProfile;
    if (currentSubscriptionPlanModel != null) {
      data['currentSubscriptionPlan'] = currentSubscriptionPlanModel!.toJson();
    }
    return data;
  }
}
