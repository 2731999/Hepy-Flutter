class OriginalModel{
  String? path;

  OriginalModel({
    this.path,
  });

  factory OriginalModel.fromJson(Map<String, dynamic> json) => OriginalModel(
    path: json["path"],
  );

  OriginalModel.fromSnapshot(snapshot):
      path = snapshot['path'];

  Map<String, dynamic> toJson() => {
    "path": path,
  };
}