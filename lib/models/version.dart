// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Version {
  final String id;
  final int langVersion;
  final int typeVersion;
  final String phraseUpdated;
  Version({
    required this.id,
    required this.langVersion,
    required this.typeVersion,
    required this.phraseUpdated,
  });

  Version copyWith({
    String? id,
    int? langVersion,
    int? typeVersion,
    String? phraseUpdated,
  }) {
    return Version(
      id: id ?? this.id,
      langVersion: langVersion ?? this.langVersion,
      typeVersion: typeVersion ?? this.typeVersion,
      phraseUpdated: phraseUpdated ?? this.phraseUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lang_version': langVersion,
      'type_version': typeVersion,
      'phrase_updated': phraseUpdated,
    };
  }

  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      id: map['id'] as String,
      langVersion: map['lang_version'] as int,
      typeVersion: map['type_version'] as int,
      phraseUpdated: map['phrase_updated'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Version.fromJson(String source) =>
      Version.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Version(id: $id, langVersion: $langVersion, typeVersion: $typeVersion, phraseUpdated: $phraseUpdated)';
  }

  @override
  bool operator ==(covariant Version other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.langVersion == langVersion &&
        other.typeVersion == typeVersion &&
        other.phraseUpdated == phraseUpdated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        langVersion.hashCode ^
        typeVersion.hashCode ^
        phraseUpdated.hashCode;
  }
}
