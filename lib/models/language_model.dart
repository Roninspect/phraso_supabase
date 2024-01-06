// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:phraso/models/flags.dart';

class LanguageModel {
  String id;
  String languageName;
  List<Flags> flags;
  String background;
  String color;
  String textColor;
  LanguageModel({
    required this.id,
    required this.languageName,
    required this.flags,
    required this.background,
    required this.color,
    required this.textColor,
  });

  LanguageModel copyWith({
    String? id,
    String? languageName,
    List<Flags>? flags,
    String? background,
    String? color,
    String? textColor,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      languageName: languageName ?? this.languageName,
      flags: flags ?? this.flags,
      background: background ?? this.background,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'languageName': languageName,
      // 'flags': flags.map((x) => x.toMap()).toList(),
      'background': background,
      'color': color,
      'textColor': textColor,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      id: map['id'] as String,
      languageName: map['languageName'] as String,
      flags: map['flags'] == null
          ? []
          : List<Flags>.from(
              (map['flags'] as List<dynamic>).map<Flags>(
                (x) => Flags.fromMap(x as Map<String, dynamic>),
              ),
            ),
      background: map['background'] as String,
      color: map['color'] as String,
      textColor: map['textColor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) =>
      LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LanguageModel(id: $id, languageName: $languageName, flags: $flags, background: $background, color: $color, textColor: $textColor)';
  }

  @override
  bool operator ==(covariant LanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.languageName == languageName &&
        listEquals(other.flags, flags) &&
        other.background == background &&
        other.color == color &&
        other.textColor == textColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        languageName.hashCode ^
        flags.hashCode ^
        background.hashCode ^
        color.hashCode ^
        textColor.hashCode;
  }
}
