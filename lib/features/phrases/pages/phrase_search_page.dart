import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/common/curtom_back_button.dart';
import 'package:phraso/core/common/loader.dart';
import 'package:phraso/features/phrases/controller/phrases_controller.dart';
import 'package:phraso/features/phrases/providers/search_query_provider.dart';
import 'package:phraso/features/phrases/widgets/phrases_tile.dart';
import 'package:phraso/features/phrases/widgets/search_phrases_field.dart';
import 'package:phraso/models/double_argsModel.dart';

class PhraseSearchPage extends ConsumerWidget {
  final String langId;
  const PhraseSearchPage({
    super.key,
    required this.langId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(phraseSearchQueryNotifierProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: const SearchPhrasesField(),
          leading: const CustomBackButton(),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              query.isEmpty
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: ref
                          .watch(getPhraseSearchResultsProvider(PhraseArgsModel(
                              langId: langId, query: query.trim())))
                          .when(
                            data: (result) {
                              return result.isEmpty
                                  ? const Center(
                                      child: Text("No Result Found"),
                                    )
                                  : ListView.builder(
                                      itemCount: result.length,
                                      itemBuilder: (context, index) {
                                        final singleResult = result[index];
                                        return PhraseTile(
                                            phrasesModel: singleResult);
                                      },
                                    );
                            },
                            error: (error, stackTrace) {
                              return Center(
                                child: Text(error.toString()),
                              );
                            },
                            loading: () => Center(
                              child: loader(),
                            ),
                          ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
