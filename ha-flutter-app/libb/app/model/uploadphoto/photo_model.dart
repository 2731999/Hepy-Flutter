class PhotoModel {
  String? path;
  String? url;

  PhotoModel({
    this.path,
    this.url,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        path: json["path"] ?? '',
        url: json["url"] ?? '',
      );

  PhotoModel.fromSnapshot(snapshot)
      : path = snapshot['path'],
        url = snapshot['url'];

  Map<String, dynamic> toJson() => {"path": path, "url": url};
}
