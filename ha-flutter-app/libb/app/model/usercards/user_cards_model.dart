import 'package:hepy/app/model/usercards/demographic_model.dart';

class UserCardsModel {
  int? age;
  DemographicModel? demographics;
  String? displayName;
  String? firstName;
  String? lastName;
  int? distance;
  String? initials;
  List<String>? languages;
  int? liked;
  List<String>? photos;
  String? thumbnail;
  String? uid;
  String? gender;
  bool? verified = false;

  UserCardsModel(
      {this.age,
      this.demographics,
      this.displayName,
      this.firstName,
      this.lastName,
      this.distance,
      this.initials,
      this.languages,
      this.liked,
      this.photos,
      this.thumbnail,
      this.uid,
      this.gender,
      this.verified});

  UserCardsModel.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    demographics = json['demographics'] != null
        ? DemographicModel.fromJson(json['demographics'])
        : null;
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    distance = json['distance'];
    initials = json['initials'];
    languages =
        json['languages'] == null ? [] : json['languages'].cast<String>();
    liked = json['liked'];
    photos = json['photos'].cast<String>();
    thumbnail = json['thumbnail'];
    uid = json['uid'];
    gender = json['gender'];
    verified = json['verified'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['age'] = age;
    if (demographics != null) {
      data['demographics'] = demographics!.toJson();
    }
    data['displayName'] = displayName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['distance'] = distance;
    data['initials'] = initials;
    data['languages'] = languages;
    data['liked'] = liked;
    data['photos'] = photos;
    data['thumbnail'] = thumbnail;
    data['uid'] = uid;
    data['gender'] = gender;
    data['verified'] = verified;
    return data;
  }
}
