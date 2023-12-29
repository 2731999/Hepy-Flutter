class VerifiedUserPhotoModel {
  bool? success;

  VerifiedUserPhotoModel(this.success);

  VerifiedUserPhotoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}
