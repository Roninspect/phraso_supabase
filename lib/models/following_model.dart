// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:phraso/models/language_model.dart';

class FollowingModel {
  String id;
  String uid;
  LanguageModel languages;
  FollowingModel({
    required this.id,
    required this.uid,
    required this.languages,
  });

  FollowingModel copyWith({
    String? id,
    String? uid,
    LanguageModel? languages,
  }) {
    return FollowingModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      languages: languages ?? this.languages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'languages': languages.toMap(),
    };
  }

  factory FollowingModel.fromMap(Map<String, dynamic> map) {
    return FollowingModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      languages:
          LanguageModel.fromMap(map['languages'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowingModel.fromJson(String source) =>
      FollowingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FollowingModel(id: $id, uid: $uid, languages: $languages)';

  @override
  bool operator ==(covariant FollowingModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uid == uid && other.languages == languages;
  }

  @override
  int get hashCode => id.hashCode ^ uid.hashCode ^ languages.hashCode;
}
