import 'conversations.dart';

class MatchAndConversationModelNew {
  List<Conversations>? matches;
  List<Conversations>? conversations;

  MatchAndConversationModelNew({this.matches, this.conversations});

  MatchAndConversationModelNew.fromJson(Map<String, dynamic> json) {
    if (json['matches'] != null) {
      matches = <Conversations>[];
      json['matches'].forEach((matchData) {
        matches!.add(Conversations.fromJson(matchData));
      });
    }

    if (json['conversations'] != null) {
      conversations = <Conversations>[];
      json['conversations'].forEach((conversationData) {
        conversations!.add(Conversations.fromJson(conversationData));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (matches != null) {
      data['matches'] =
          matches!.map((matchesData) => matchesData.toJson()).toList();
    }
    if (conversations != null) {
      data['conversations'] = conversations!
          .map((conversationsData) => conversationsData.toJson())
          .toList();
    }
    return data;
  }
}
