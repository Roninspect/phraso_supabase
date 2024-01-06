import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/core/helper/connection_notifier.dart';
import 'package:phraso/features/languages/data/local/local_language_repository.dart';
import 'package:phraso/features/languages/provider/search_query_provider.dart';
import 'package:phraso/features/languages/data/remote/language_repository.dart';
import 'package:phraso/models/following_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../models/language_model.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, bool>((ref) {
  return LanguageController(
    languageRepository: ref.watch(languageRepositroyProvider),
    localLanguageRepository: ref.watch(localLanguageRepositoryProvider),
    ref: ref,
  );
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
    timer = Timer(const Duration(minutes: 2), () {
      // dispose on timeout
      ref.invalidate(searchQueryNotifierProvider);
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
  final LocalLanguageRepository _localLanguageRepository;
  final Ref _ref;
  LanguageController(
      {required LanguageRepository languageRepository,
      required LocalLanguageRepository localLanguageRepository,
      required Ref ref})
      : _languageRepository = languageRepository,
        _localLanguageRepository = localLanguageRepository,
        _ref = ref,
        super(false);

  final uid = supabase.Supabase.instance.client.auth.currentUser!.id;

  Future<List<LanguageModel>> getAllLanguage() async {
    try {
      ConnectivityStatus connectivityStatus =
          _ref.watch(connectionStateNotifierProvider);

      if (connectivityStatus == ConnectivityStatus.isConnected) {
        final count = await _languageRepository.getlanguagesCount();

        final localCount = await _localLanguageRepository.getLanguageCount();

        if (count != localCount) {
          final remoteList = await _languageRepository.getAllLanguage();

          await Future.wait(remoteList.map((e) async {
            await _localLanguageRepository.insertSingleLanguage(language: e);
          }));
        }
        return await _localLanguageRepository.getAllLocalLanguages();
      } else {
        return await _localLanguageRepository.getAllLocalLanguages();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> followLanguage(
      {required String langId,
      required BuildContext context,
      required WidgetRef ref}) async {
    state = true;
    final res =
        await _languageRepository.followLanguage(uid: uid, langId: langId);
    state = false;
    res.fold((l) {}, (r) {
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
    res.fold((l) => null, (r) {
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
