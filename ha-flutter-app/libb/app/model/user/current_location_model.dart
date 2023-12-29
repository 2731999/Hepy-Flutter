import 'package:hepy/app/model/user/coords_model.dart';

class CurrentLocationModel {
  String? timezoneOffset;
  String? name;
  CoordsModel? coords =  CoordsModel();

  CurrentLocationModel({
    this.timezoneOffset,
    this.name,
    this.coords,
  });

  factory CurrentLocationModel.fromJson(Map<String, dynamic> json) =>
      CurrentLocationModel(
        timezoneOffset: json["timezoneOffset"] ?? '',
        name: json["name"] ?? '',
        coords: CoordsModel.fromJson(json["coords"]),
      );

  Map<String, dynamic> toJson() => {
        "timezoneOffset": timezoneOffset,
        "name": name,
        "coords": coords?.toJson(),
      };
}
