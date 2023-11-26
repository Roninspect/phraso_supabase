// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:phraso/models/language_model.dart';

class FollowingModel {
  String id;
  LanguageModel languages;
  FollowingModel({
    required this.id,
    required this.languages,
  });

  FollowingModel copyWith({
    String? id,
    LanguageModel? languages,
  }) {
    return FollowingModel(
      id: id ?? this.id,
      languages: languages ?? this.languages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'languages': languages.toMap(),
    };
  }

  factory FollowingModel.fromMap(Map<String, dynamic> map) {
    return FollowingModel(
      id: map['id'] as String,
      languages:
          LanguageModel.fromMap(map['languages'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowingModel.fromJson(String source) =>
      FollowingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FollowingModel(id: $id, languages: $languages)';

  @override
  bool operator ==(covariant FollowingModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.languages == languages;
  }

  @override
  int get hashCode => id.hashCode ^ languages.hashCode;
}
