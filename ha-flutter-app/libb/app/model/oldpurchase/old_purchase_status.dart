class OldPurchaseStatus {
  int? index;
  String? name;

  OldPurchaseStatus({this.index, this.name});

  factory OldPurchaseStatus.fromJson(Map<String, dynamic> json) {
    return OldPurchaseStatus(index: json['index'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
    };
  }
}
