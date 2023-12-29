class DemographicModel{
  String? exercise;
  String? drinking;
  String? educationLevel;
  String? zodiac;
  dynamic height;
  String? kids;
  String? politics;
  String? smoking;
  String? religion;

  DemographicModel(
      {this.exercise,
        this.drinking,
        this.educationLevel,
        this.zodiac,
        this.height,
        this.kids,
        this.politics,
        this.smoking,
        this.religion});

  DemographicModel.fromJson(Map<String, dynamic> json) {
    exercise = json['exercise'];
    drinking = json['drinking'];
    educationLevel = json['educationLevel'];
    zodiac = json['zodiac'];
    height = json['height'];
    kids = json['kids'];
    politics = json['politics'];
    smoking = json['smoking'];
    religion = json['religion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exercise'] = exercise;
    data['drinking'] = drinking;
    data['educationLevel'] = educationLevel;
    data['zodiac'] = zodiac;
    data['height'] = height;
    data['kids'] = kids;
    data['politics'] = politics;
    data['smoking'] = smoking;
    data['religion'] = religion;
    return data;
  }
}