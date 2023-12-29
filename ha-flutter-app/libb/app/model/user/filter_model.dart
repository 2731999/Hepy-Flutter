import 'package:hepy/app/model/user/age_range_model.dart';

class FilterModel {
  String? lookingFor;
  int? locationRadius;
  AgeRangeModel? ageRange = AgeRangeModel();

  FilterModel({
    this.lookingFor,
    this.locationRadius,
    this.ageRange,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
        lookingFor: json["lookingFor"] ?? '',
        locationRadius: json["locationRadius"] ?? 0,
        ageRange: json["ageRange"] != null
            ? AgeRangeModel.fromJson(json["ageRange"])
            : AgeRangeModel(),
      );

  Map<String, dynamic> toJson() => {
        "lookingFor": lookingFor,
        "locationRadius": locationRadius,
        "ageRange": ageRange?.toJson(),
      };
}
