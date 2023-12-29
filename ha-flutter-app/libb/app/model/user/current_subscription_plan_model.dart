import 'package:hepy/app/model/oldpurchase/old_play_store_purchase.dart';

class CurrentSubscriptionPlanModel {
  int? id;
  String? name;
  bool? paidPlan;
  OldPlayStorePurchase? playStorePurchaseData;

  CurrentSubscriptionPlanModel(
      {this.id, this.name, this.paidPlan, this.playStorePurchaseData});

  factory CurrentSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionPlanModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        paidPlan: json['paidPlan'] ?? false,
        playStorePurchaseData: json['playStorePurchaseData'] != null
            ? OldPlayStorePurchase.fromJson(json['playStorePurchaseData'])
            : null);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "paidPlan": paidPlan,
        "playStorePurchaseData": playStorePurchaseData?.toJson()
      };
}
