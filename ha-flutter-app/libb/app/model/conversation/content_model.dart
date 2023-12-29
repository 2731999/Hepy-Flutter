class ContentModel {
  String? text = '';
  String? photo = '';
  bool? photoViewed = false;

  ContentModel({this.text, this.photo,this.photoViewed});

  ContentModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    photo = json['photo'];
    photoViewed = json['photoViewed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['photo'] = photo;
    data['photoViewed'] = photoViewed;
    return data;
  }
}
