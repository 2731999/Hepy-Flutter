class AgeRangeModel{
  int? max;
  int? min;

  AgeRangeModel({this.max, this.min});

  factory AgeRangeModel.fromJson(Map<String, dynamic> json) => AgeRangeModel(
    max: json["max"] ?? 0,
    min: json["min"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "min": min,
    "max": max,
  };
}