class QODModel{
  String? id;
  String? question;
  List<String>? answers;

  QODModel({this.id, this.question, this.answers});

  QODModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answers = json['answers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answers'] = answers;
    return data;
  }
}