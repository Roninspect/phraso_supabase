class CounterModel {
  String id;
  num languagesCount;
  num phrasesCount;
  num typesCount;
  CounterModel({
    required this.id,
    required this.languagesCount,
    required this.phrasesCount,
    required this.typesCount,
  });

  CounterModel copyWith({
    String? id,
    num? languagesCount,
    num? phrasesCount,
    num? typesCount,
  }) {
    return CounterModel(
      id: id ?? this.id,
      languagesCount: languagesCount ?? this.languagesCount,
      phrasesCount: phrasesCount ?? this.phrasesCount,
      typesCount: typesCount ?? this.typesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'languagesCount': languagesCount,
      'phrasesCount': phrasesCount,
      'typesCount': typesCount,
    };
  }

  factory CounterModel.fromMap(Map<String, dynamic> map) {
    return CounterModel(
      id: map['id'] as String,
      languagesCount: map['languagesCount'] as num,
      phrasesCount: map['phrasesCount'] as num,
      typesCount: map['typesCount'] as num,
    );
  }
}
