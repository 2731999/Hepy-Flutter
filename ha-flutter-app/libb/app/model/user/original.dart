class OriginalPhotoModel {
  String? path;

  OriginalPhotoModel({this.path});

  factory OriginalPhotoModel.fromJson(Map<String, dynamic> json) =>
      OriginalPhotoModel(
        path: json["path"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "path": path,
      };
}
