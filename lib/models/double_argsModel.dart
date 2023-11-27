// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArgsModel {
  final String langId;
  final int typeId;
  ArgsModel({
    required this.langId,
    required this.typeId,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ArgsModel && o.langId == langId && o.typeId == typeId;
  }

  @override
  int get hashCode => langId.hashCode ^ typeId.hashCode;
}

class PhraseArgsModel {
  final String langId;
  final String query;
  PhraseArgsModel({required this.langId, required this.query});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PhraseArgsModel && o.langId == langId && o.query == query;
  }

  @override
  int get hashCode => langId.hashCode ^ langId.hashCode;
}

class IsFavAlreadyArgsModel {
  final String langId;
  final int phraseId;
  IsFavAlreadyArgsModel({
    required this.langId,
    required this.phraseId,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is IsFavAlreadyArgsModel &&
        o.langId == langId &&
        o.phraseId == phraseId;
  }

  @override
  int get hashCode => langId.hashCode ^ phraseId.hashCode;
}
