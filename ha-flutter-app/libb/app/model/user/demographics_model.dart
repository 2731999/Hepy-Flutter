class DemographicsModel {
  String? drinking;
  String? educationLevel;
  String? exercise;
  dynamic height;
  String? kids;
  String? politics;
  String? religion;
  String? smoking;
  String? zodiac;

  DemographicsModel({
    this.drinking,
    this.educationLevel,
    this.exercise,
    this.height,
    this.kids,
    this.politics,
    this.religion,
    this.smoking,
    this.zodiac,
  });

  factory DemographicsModel.fromJson(Map<String, dynamic> json) =>
      DemographicsModel(
        drinking: json["drinking"] ?? '',
        educationLevel: json["educationLevel"] ?? '',
        exercise: json["exercise"] ?? '',
        height: json["height"],
        kids: json["kids"] ?? '',
        politics: json["politics"] ?? '',
        religion: json["religion"] ?? '',
        smoking: json["smoking"] ?? '',
        zodiac: json["zodiac"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "drinking": drinking,
        "educationLevel": educationLevel,
        "exercise": exercise,
        "height": height,
        "kids": kids,
        "politics": politics,
        "religion": religion,
        "smoking": smoking,
        "zodiac": zodiac,
      };
}
