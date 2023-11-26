// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phraso/core/common/alert_dialog.dart';
import 'package:phraso/features/phrases/controller/phrases_controller.dart';
import 'package:phraso/models/phrases_model.dart';
import '../../../core/helper/async_value_helper.dart';
import '../../../models/double_argsModel.dart';

class FavButton extends ConsumerWidget {
  final PhrasesModel phrasesModel;
  const FavButton({
    super.key,
    required this.phrasesModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(phrasesControllerProvider);
    void favouritePhrase() {
      ref.read(phrasesControllerProvider.notifier).favourtiePhrase(
          phraseId: phrasesModel.phraseId,
          ref: ref,
          langId: phrasesModel.langId,
          context: context);
    }

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AsyncValueWidget(
            value: ref.watch(isfavAlreadyProvider(IsFavAlreadyArgsModel(
                langId: phrasesModel.langId, phraseId: phrasesModel.phraseId))),
            data: (isFavourited) {
              if (isFavourited) {
                return InkWell(
                  onTap: () => alertDialogBoxForPhrase(
                    context: context,
                    phraseName: phrasesModel.translatedPhrases,
                    ifYes: () {
                      ref
                          .read(phrasesControllerProvider.notifier)
                          .removeFromFavourite(
                              context: context,
                              ref: ref,
                              phraseId: phrasesModel.phraseId,
                              langId: phrasesModel.langId);
                      context.pop();
                    },
                    ifNo: () => context.pop(),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 35,
                  ),
                );
              } else {
                return InkWell(
                  onTap: () => favouritePhrase(),
                  child: const Icon(
                    Icons.favorite_outline,
                    size: 35,
                  ),
                );
              }
            });
  }
}
