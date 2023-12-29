class TodaysQuestionModel {
  String? answer;
  String? questionId;

  TodaysQuestionModel({this.answer, this.questionId});

  factory TodaysQuestionModel.fromJson(Map<String, dynamic> json) =>
      TodaysQuestionModel(
        answer: json["answer"] ?? '',
        questionId: json["questionId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
        "questionId": questionId,
      };
}
