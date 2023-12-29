import 'package:hepy/app/model/start/plan_model.dart';

class CurrentSubscriptionPlanModel{
  PlanModel? plan;
  int? likesPerDay;
  int? todaysLikes;
  int? messagesPerMatch;
  int? freeSuperLikes;
  int? superLikesUsed;
  bool? rewindPeople;
  bool? whoLikesYou;

  CurrentSubscriptionPlanModel(
      {this.plan,
        this.likesPerDay,
        this.todaysLikes,
        this.messagesPerMatch,
        this.freeSuperLikes,
        this.superLikesUsed,
        this.rewindPeople,
        this.whoLikesYou});

  CurrentSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    plan = json['plan'] != null ? PlanModel.fromJson(json['plan']) : null;
    likesPerDay = json['likesPerDay'];
    todaysLikes = json['todaysLikes'];
    messagesPerMatch = json['messagesPerMatch'];
    freeSuperLikes = json['freeSuperLikes'];
    superLikesUsed = json['superLikesUsed'];
    rewindPeople = json['rewindPeople'];
    whoLikesYou = json['whoLikesYou'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    data['likesPerDay'] = likesPerDay;
    data['todaysLikes'] = todaysLikes;
    data['messagesPerMatch'] = messagesPerMatch;
    data['freeSuperLikes'] = freeSuperLikes;
    data['superLikesUsed'] = superLikesUsed;
    data['rewindPeople'] = rewindPeople;
    data['whoLikesYou'] = whoLikesYou;
    return data;
  }


}