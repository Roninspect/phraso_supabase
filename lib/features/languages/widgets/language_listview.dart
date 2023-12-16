import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_tile.dart';
import '../../../core/helper/async_value_helper.dart';
import '../../../models/language_model.dart';
import '../controller/language_controller.dart';

class AllLanguagelistView extends ConsumerWidget {
  const AllLanguagelistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(getAllLanguageProvider(context)),
      data: (languages) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final LanguageModel languageModel = languages[index];
            return Padding(
              padding: const EdgeInsets.all(12.0).copyWith(bottom: 2),
              child: LanguageTile(
                language: languageModel,
              ),
            );
          },
        );
      },
    );
  }
}
