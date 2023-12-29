class PlanModel{
  int? id;
  String? name;
  bool? paidPlan;

  PlanModel({this.id, this.name, this.paidPlan});

  PlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    paidPlan = json['paidPlan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['paidPlan'] = paidPlan;
    return data;
  }
}