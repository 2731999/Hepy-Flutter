import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hepy/app/model/uploadphoto/original_model.dart';
import 'package:hepy/app/model/uploadphoto/photo_model.dart';

class UserUploadPhotoModel {
  String? id;
  String? uid;
  OriginalModel? original;
  PhotoModel? photo;
  PhotoModel? thumb;
  int? sortOrder;
  int photoNo = -1;
  bool _isProgress = false;
  bool? isVerified = false;
  Timestamp? verifiedAt;

  bool get isProgress => _isProgress;

  set isProgress(bool value) {
    _isProgress = value;
  }

  UserUploadPhotoModel({
    this.id,
    this.uid,
    this.original,
    this.photo,
    this.thumb,
    this.verifiedAt,
    this.isVerified,
    this.sortOrder,
  });

  factory UserUploadPhotoModel.fromJson(Map<String, dynamic> json) =>
      UserUploadPhotoModel(
        id: json["id"],
        uid: json["uid"],
        original: OriginalModel.fromJson(json["original"]),
        photo: PhotoModel.fromJson(json["photo"]),
        thumb: PhotoModel.fromJson(json["thumb"]),
        verifiedAt: json["verifiedAt"] ?? Timestamp(0, 0),
        isVerified: json["verified"],
        sortOrder: json["sortOrder"],
      );

  UserUploadPhotoModel.fromSnapshot(snapshot, imageId, {this.photoNo = -1})
      : id = imageId,
        uid = snapshot.data()!['uid'],
        original = OriginalModel.fromSnapshot(snapshot.data()!['original']),
        photo = PhotoModel.fromSnapshot(snapshot.data()!['photo']),
        thumb = PhotoModel.fromSnapshot(snapshot.data()!['thumb']),
        isVerified = snapshot.data()!['verified'],
        verifiedAt = snapshot.data()!['verifiedAt'],
        sortOrder = snapshot.data()!['sortOrder'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "original": original?.toJson(),
        "photo": photo?.toJson(),
        "thumb": thumb?.toJson(),
        "sortOrder": sortOrder,
      };
}
