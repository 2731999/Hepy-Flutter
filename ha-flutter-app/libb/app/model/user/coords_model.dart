class CoordsModel {
  double? lang = 0.0;
  double? lat = 0.0;

  CoordsModel({this.lang, this.lat});

  factory CoordsModel.fromJson(Map<String, dynamic> json) => CoordsModel(
        lang: json["lang"].toDouble() ?? 0.0,
        lat: json["lat"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "lang": lang,
        "lat": lat,
      };
}
