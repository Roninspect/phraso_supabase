// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Flags {
  final String id;
  final String name;
  final String lang_id;
  final String flag_url;
  Flags({
    required this.id,
    required this.name,
    required this.lang_id,
    required this.flag_url,
  });

  Flags copyWith({
    String? id,
    String? name,
    String? lang_id,
    String? flag_url,
  }) {
    return Flags(
      id: id ?? this.id,
      name: name ?? this.name,
      lang_id: lang_id ?? this.lang_id,
      flag_url: flag_url ?? this.flag_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lang_id': lang_id,
      'flag_url': flag_url,
    };
  }

  factory Flags.fromMap(Map<String, dynamic> map) {
    return Flags(
      id: map['id'] as String,
      name: map['name'] as String,
      lang_id: map['lang_id'] as String,
      flag_url: map['flag_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Flags.fromJson(String source) =>
      Flags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Flags(id: $id, name: $name, lang_id: $lang_id, flag_url: $flag_url)';
  }

  @override
  bool operator ==(covariant Flags other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lang_id == lang_id &&
        other.flag_url == flag_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ lang_id.hashCode ^ flag_url.hashCode;
  }
}
