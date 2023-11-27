import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/features/languages/repository/language_repository.dart';
import 'package:phraso/models/following_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../models/language_model.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, bool>((ref) {
  return LanguageController(
      languageRepository: ref.watch(languageRepositroyProvider));
});

final getAllLanguageProvider =
    FutureProvider.family<List<LanguageModel>, BuildContext>(
        (ref, BuildContext context) {
  return ref.watch(languageControllerProvider.notifier).getAllLanguage();
});

final getFollowingLanguageProvider =
    FutureProvider<List<FollowingModel>>((ref) {
  return ref.watch(languageRepositroyProvider).getFollowingLanguage(
      uid: supabase.Supabase.instance.client.auth.currentUser!.id);
});

final getSearchResultsProvider = FutureProvider.autoDispose
    .family<List<LanguageModel>, String>((ref, query) async {
  final link = ref.keepAlive();
  Timer? timer;

  ref.onCancel(() {
    // start a 30 second timer
    timer = Timer(const Duration(minutes: 5), () {
      // dispose on timeout
      link.close();
    });
  });
  ref.onResume(() {
    timer?.cancel();
  });
  return ref
      .watch(languageControllerProvider.notifier)
      .getSearchResults(query: query);
});

// final getlanguageByIdProvider =
//     StreamProvider.family<LanguageModel, String>((ref, String langId) {
//   return ref.watch(languageControllerProvider).getlanguageById(langId: langId);
// });

final isFollowingAlreadyProvider =
    FutureProvider.family<bool, String>((ref, String langId) {
  return ref
      .watch(languageControllerProvider.notifier)
      .isFollowingAlready(langId: langId);
});

//* Language Controller Class

class LanguageController extends StateNotifier<bool> {
  final LanguageRepository _languageRepository;
  LanguageController({required LanguageRepository languageRepository})
      : _languageRepository = languageRepository,
        super(false);

  final uid = supabase.Supabase.instance.client.auth.currentUser!.id;

  Future<List<LanguageModel>> getAllLanguage() async {
    return await _languageRepository.getAllLanguage();
  }

  Future<void> followLanguage(
      {required String langId,
      required BuildContext context,
      required WidgetRef ref}) async {
    state = true;
    final res =
        await _languageRepository.followLanguage(uid: uid, langId: langId);
    state = false;
    res.fold((l) {
      print(l.message);
      return showSnackbar(context: context, text: l.message);
    }, (r) {
      ref.refresh(getFollowingLanguageProvider);
      ref.refresh(isFollowingAlreadyProvider(langId));
    });
  }

  // Future<List<LanguageModel>> getFollowingLanguage() {
  //   return _languageRepository.getFollowingLanguage(uid: uid);
  // }

  // Stream<LanguageModel> getlanguageById({required String langId}) {
  //   return _languageRepository.getlanguageById(langId: langId);
  // }

  Future<bool> isFollowingAlready({required String langId}) {
    return _languageRepository.isFollowingAlready(uid: uid, langId: langId);
  }

  Future<void> deleteTheFollowing(
      {required String langId,
      required BuildContext context,
      required WidgetRef ref}) async {
    state = true;
    final res =
        await _languageRepository.deleteTheFollowing(uid: uid, langId: langId);
    state = false;
    res.fold((l) => showSnackbar(context: context, text: "Some Error Occured"),
        (r) {
      ref.refresh(getFollowingLanguageProvider);
      ref.refresh(isFollowingAlreadyProvider(langId));
    });
  }

  Future<List<LanguageModel>> getSearchResults({required String query}) async {
    try {
      return await _languageRepository.getSearchResults(query: query);
    } catch (e) {
      throw e.toString();
    }
  }
}
