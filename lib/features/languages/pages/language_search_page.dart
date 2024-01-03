import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/common/curtom_back_button.dart';
import 'package:phraso/features/languages/widgets/language_tile.dart';
import 'package:phraso/core/common/loader.dart';
import 'package:phraso/features/languages/controller/language_controller.dart';
import 'package:phraso/features/languages/provider/search_query_provider.dart';
import 'package:phraso/features/languages/widgets/language_search_field.dart';

class LanguageSearchPage extends ConsumerWidget {
  const LanguageSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryNotifierProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: const LanguageSearchField(),
        leading: const CustomBackButton(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search Results: $query",
              style: const TextStyle(fontSize: 20),
            ),
            query.isEmpty
                ? const SizedBox.shrink()
                : Expanded(
                    child: ref.watch(getSearchResultsProvider(query)).when(
                          data: (result) {
                            return result.isEmpty
                                ? const Center(
                                    child: Text("No result Found"),
                                  )
                                : ListView.builder(
                                    itemCount: result.length,
                                    itemBuilder: (context, index) {
                                      final singleResult = result[index];
                                      return LanguageTile(
                                          language: singleResult);
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
    );
  }
}
