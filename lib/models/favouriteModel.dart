// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:phraso/models/phrases_model.dart';

class FavouriteModel {
  String? id;
  int phraseId;
  String langId;
  String uid;
  PhrasesModel? phrases;
  FavouriteModel({
    this.id,
    required this.phraseId,
    required this.langId,
    required this.uid,
    this.phrases,
  });

  FavouriteModel copyWith({
    String? id,
    int? phraseId,
    String? langId,
    String? uid,
    PhrasesModel? phrases,
  }) {
    return FavouriteModel(
      id: id ?? this.id,
      phraseId: phraseId ?? this.phraseId,
      langId: langId ?? this.langId,
      uid: uid ?? this.uid,
      phrases: phrases ?? this.phrases,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phraseId': phraseId,
      'langId': langId,
      'uid': uid,
    };
  }

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      id: map['id'] != null ? map['id'] as String : null,
      phraseId: map['phraseId'] as int,
      langId: map['langId'] as String,
      uid: map['uid'] as String,
      phrases: map['phrases'] != null
          ? PhrasesModel.fromMap(map['phrases'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteModel.fromJson(String source) =>
      FavouriteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FavouriteModel(id: $id, phraseId: $phraseId, langId: $langId, uid: $uid, phrases: $phrases)';
  }

  @override
  bool operator ==(covariant FavouriteModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.phraseId == phraseId &&
        other.langId == langId &&
        other.uid == uid &&
        other.phrases == phrases;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phraseId.hashCode ^
        langId.hashCode ^
        uid.hashCode ^
        phrases.hashCode;
  }
}
