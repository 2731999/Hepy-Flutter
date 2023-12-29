class AboutMeModel {
  String? height = "";
  String? exercise = "";
  String? zodiac = "";
  String? educationLevel = "";
  String? drinking = "";
  String? smoking = "";
  String? kids = "";
  String? religion = "";
  String? politics = "";

  AboutMeModel(
      {this.height,
      this.exercise,
      this.zodiac,
      this.educationLevel,
      this.drinking,
      this.smoking,
      this.kids,
      this.religion,
      this.politics});

  //receiving data from server
  factory AboutMeModel.fromMap(map) {
    return AboutMeModel(
        height: map['height'],
        exercise: map['exercise'],
        zodiac: map['zodiac'],
        educationLevel: map['educationLevel'],
        drinking: map['drinking'],
        smoking: map['smoking'],
        kids: map['kids'],
        religion: map['religion'],
        politics: map['politics']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'exercise': exercise,
      'zodiac': zodiac,
      'educationLevel': educationLevel,
      'drinking': drinking,
      'smoking': smoking,
      'kids': kids,
      'religion': religion,
      'politics': politics
    };
  }
}
