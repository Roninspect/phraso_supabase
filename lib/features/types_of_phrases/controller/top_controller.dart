import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/features/types_of_phrases/repository/top_repsoitory.dart';

import '../../../models/top_model.dart';

final typesOfPhrasesControllerProvider =
    Provider<TypesOfPhrasesController>((ref) {
  return TypesOfPhrasesController(
      typesOfPhrasesRepository: ref.watch(typesOfPhrasesRepositoryProvider));
});

final getTypesofPhrasesListProvider =
    FutureProvider.autoDispose<List<TypesOfPhrasesmodel>>((ref) {
  ref.onCancel(() => debugPrint('cancel'));
  ref.onResume(() => debugPrint('resume)'));
  ref.onDispose(() => debugPrint('dispose'));
  final link = ref.keepAlive();
  Timer? timer;

  ref.onCancel(() {
    // start a 30 second timer
    timer = Timer(const Duration(hours: 1), () {
      // dispose on timeout
      link.close();
    });
  });
  ref.onResume(() {
    timer?.cancel();
  });
  return ref.watch(typesOfPhrasesControllerProvider).getTypesofPhrasesList();
});

class TypesOfPhrasesController {
  final TypesOfPhrasesRepository _typesOfPhrasesRepository;
  TypesOfPhrasesController(
      {required TypesOfPhrasesRepository typesOfPhrasesRepository})
      : _typesOfPhrasesRepository = typesOfPhrasesRepository;

  Future<List<TypesOfPhrasesmodel>> getTypesofPhrasesList() {
    return _typesOfPhrasesRepository.getTypesofPhrasesList();
  }
}
