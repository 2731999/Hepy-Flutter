
import 'package:hepy/app/model/user/original.dart';
import 'package:hepy/app/model/user/photo_model.dart';

class SelfieModel {
  OriginalPhotoModel? originalModel;
  PhotoModel? photoModel;

  SelfieModel({this.originalModel, this.photoModel});

  factory SelfieModel.fromJson(Map<String, dynamic> json) => SelfieModel(
        originalModel: json["original"] != null
            ? OriginalPhotoModel.fromJson(json["original"])
            : null,
        photoModel: json["photo"] != null
            ? PhotoModel.fromJson(json["photo"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "original": originalModel?.toJson(),
        "photo": photoModel?.toJson(),
      };
}
