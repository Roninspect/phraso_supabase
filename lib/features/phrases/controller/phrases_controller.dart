import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/features/phrases/repository/phrases_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../models/double_argsModel.dart';
import '../../../models/favouriteModel.dart';
import '../../../models/phrases_model.dart';

final phrasesControllerProvider =
    StateNotifierProvider<PhrasesContrller, bool>((ref) {
  return PhrasesContrller(
      phrasesRepository: ref.watch(phrasesRepositoryProvider));
});

final getPhrasesByIdsProvider = FutureProvider.family
    .autoDispose<List<PhrasesModel>, ArgsModel>((ref, vendocode) {
  String langId = vendocode.langId;
  int typeId = vendocode.typeId;
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
  return ref.watch(phrasesControllerProvider.notifier).getPhrasesByIds(
        langId: langId,
        typeId: typeId,
      );
});

final isfavAlreadyProvider =
    FutureProvider.family<bool, IsFavAlreadyArgsModel>((ref, vendocode) {
  String langId = vendocode.langId;
  int phraseId = vendocode.phraseId;

  return ref.watch(phrasesControllerProvider.notifier).isfavAlready(
        langId: langId,
        phraseId: phraseId,
      );
});

final getFavourtiesProvider = FutureProvider.family
    .autoDispose<List<FavouriteModel>, String>((ref, langId) {
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
  return ref.watch(phrasesControllerProvider.notifier).getFavourties(
        langId: langId,
      );
});

class PhrasesContrller extends StateNotifier<bool> {
  final PhrasesRepository _phrasesRepository;
  PhrasesContrller({required PhrasesRepository phrasesRepository})
      : _phrasesRepository = phrasesRepository,
        super(false);

  Future<List<PhrasesModel>> getPhrasesByIds(
      {required String langId, required int typeId}) {
    return _phrasesRepository.getPhrasesByIds(langId: langId, typeId: typeId);
  }

  Future<void> favourtiePhrase(
      {required int phraseId,
      required String langId,
      required WidgetRef ref,
      required BuildContext context}) async {
    final newFavourite = FavouriteModel(
        phraseId: phraseId,
        langId: langId,
        uid: supabase.Supabase.instance.client.auth.currentUser!.id);
    state = true;
    final res =
        await _phrasesRepository.favourtiePhrase(favouriteModel: newFavourite);
    state = false;
    res.fold((l) {
      showSnackbar(context: context, text: l.message);
    }, (r) {
      ref.refresh(isfavAlreadyProvider(
          IsFavAlreadyArgsModel(langId: langId, phraseId: phraseId)));
      ref.refresh(getFavourtiesProvider(langId));
    });
  }

  //** getting favourite phrase */

  Future<List<FavouriteModel>> getFavourties({
    required String langId,
  }) {
    return _phrasesRepository.getFavourties(
      uid: supabase.Supabase.instance.client.auth.currentUser!.id,
      langId: langId,
    );
  }

  Future<bool> isfavAlready({
    required String langId,
    required int phraseId,
  }) {
    return _phrasesRepository.isfavAlready(
      uid: supabase.Supabase.instance.client.auth.currentUser!.id,
      langId: langId,
      phraseId: phraseId,
    );
  }

  // //* removing from favourite */

  void removeFromFavourite(
      {required int phraseId,
      required String langId,
      required WidgetRef ref,
      required BuildContext context}) async {
    state = true;
    final res = await _phrasesRepository.removeFromFavourite(
      phraseId: phraseId,
      uid: supabase.Supabase.instance.client.auth.currentUser!.id,
      langId: langId,
    );

    state = false;

    res.fold((l) => showSnackbar(context: context, text: l.message), (r) {
      ref.refresh(isfavAlreadyProvider(
          IsFavAlreadyArgsModel(langId: langId, phraseId: phraseId)));
      ref.refresh(getFavourtiesProvider(langId));
    });
  }
}
