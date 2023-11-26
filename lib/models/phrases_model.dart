// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PhrasesModel {
  int phraseId;
  String englishPhrases;
  String translatedPhrases;
  String color;
  String audioLink;
  String langId;
  int typeId;
  String pronunciation;
  PhrasesModel({
    required this.phraseId,
    required this.englishPhrases,
    required this.translatedPhrases,
    required this.color,
    required this.audioLink,
    required this.langId,
    required this.typeId,
    required this.pronunciation,
  });

  PhrasesModel copyWith({
    int? phraseId,
    String? englishPhrases,
    String? translatedPhrases,
    String? color,
    String? audioLink,
    String? langId,
    int? typeId,
    String? pronunciation,
  }) {
    return PhrasesModel(
      phraseId: phraseId ?? this.phraseId,
      englishPhrases: englishPhrases ?? this.englishPhrases,
      translatedPhrases: translatedPhrases ?? this.translatedPhrases,
      color: color ?? this.color,
      audioLink: audioLink ?? this.audioLink,
      langId: langId ?? this.langId,
      typeId: typeId ?? this.typeId,
      pronunciation: pronunciation ?? this.pronunciation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phraseId': phraseId,
      'englishPhrases': englishPhrases,
      'translatedPhrases': translatedPhrases,
      'color': color,
      'audioLink': audioLink,
      'langId': langId,
      'typeId': typeId,
      'pronunciation': pronunciation,
    };
  }

  factory PhrasesModel.fromMap(Map<String, dynamic> map) {
    return PhrasesModel(
      phraseId: map['phraseId'] as int,
      englishPhrases: map['englishPhrases'] as String,
      translatedPhrases: map['translatedPhrases'] as String,
      color: map['color'] as String,
      audioLink: map['audioLink'] as String,
      langId: map['langId'] as String,
      typeId: map['typeId'] as int,
      pronunciation: map['pronunciation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhrasesModel.fromJson(String source) =>
      PhrasesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhrasesModel(phraseId: $phraseId, englishPhrases: $englishPhrases, translatedPhrases: $translatedPhrases, color: $color, audioLink: $audioLink, langId: $langId, typeId: $typeId, pronunciation: $pronunciation)';
  }

  @override
  bool operator ==(covariant PhrasesModel other) {
    if (identical(this, other)) return true;

    return other.phraseId == phraseId &&
        other.englishPhrases == englishPhrases &&
        other.translatedPhrases == translatedPhrases &&
        other.color == color &&
        other.audioLink == audioLink &&
        other.langId == langId &&
        other.typeId == typeId &&
        other.pronunciation == pronunciation;
  }

  @override
  int get hashCode {
    return phraseId.hashCode ^
        englishPhrases.hashCode ^
        translatedPhrases.hashCode ^
        color.hashCode ^
        audioLink.hashCode ^
        langId.hashCode ^
        typeId.hashCode ^
        pronunciation.hashCode;
  }
}
