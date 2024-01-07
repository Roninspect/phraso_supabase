import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/helper/connection_notifier.dart';
import 'package:phraso/core/shared/version_provider.dart';
import 'package:phraso/features/languages/repository/local/local_language_repository.dart';
import 'package:phraso/features/languages/repository/remote/remote_language_repository.dart';
import 'package:phraso/features/types_of_phrases/repository/local/top_local_repository.dart';
import 'package:phraso/features/types_of_phrases/repository/remote/remote_top_repsoitory.dart';

import '../../../models/top_model.dart';

final typesOfPhrasesControllerProvider =
    Provider<TypesOfPhrasesController>((ref) {
  return TypesOfPhrasesController(
      typesOfPhrasesRepository: ref.watch(typesOfPhrasesRepositoryProvider),
      localTopRepository: ref.watch(localTopRepositoryProvider),
      versionRepository: ref.watch(versionRepositoryProvider),
      ref: ref);
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
  final RemoteTypesOfPhrasesRepository _typesOfPhrasesRepository;
  final LocalTopRepository _localTopRepository;
  final VersionRepository _versionRepository;
  final Ref _ref;
  TypesOfPhrasesController(
      {required RemoteTypesOfPhrasesRepository typesOfPhrasesRepository,
      required LocalTopRepository localTopRepository,
      required Ref ref,
      required VersionRepository versionRepository})
      : _typesOfPhrasesRepository = typesOfPhrasesRepository,
        _localTopRepository = localTopRepository,
        _ref = ref,
        _versionRepository = versionRepository;

  Future<List<TypesOfPhrasesmodel>> getTypesofPhrasesList() async {
    ConnectivityStatus connectivityStatus =
        _ref.watch(connectionStateNotifierProvider);

    if (connectivityStatus == ConnectivityStatus.isConnected) {
      final remoteVersion = await _versionRepository.getRemoteVersion();
      final localVersion = await _versionRepository.getLocalVersion();
      if (remoteVersion.typeVersion != localVersion.typeVersion) {
        final remoteTOP =
            await _typesOfPhrasesRepository.getTypesofPhrasesList();
        await _versionRepository.updateTypeVersion(
            typeVersion: remoteVersion.typeVersion,
            versionId: remoteVersion.id);
        _ref.invalidate(getLocalVersionProvider);
        await Future.wait(remoteTOP.map((e) async {
          await _localTopRepository.insertTOP(top: e);
        }));
        return await _localTopRepository.getTypesofPhrasesList();
      } else {
        return await _localTopRepository.getTypesofPhrasesList();
      }
    } else {
      return await _localTopRepository.getTypesofPhrasesList();
    }
  }
}
