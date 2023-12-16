// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/colors/colors.dart';
import 'package:phraso/core/common/curtom_back_button.dart';
import 'package:phraso/core/constants/spacings.dart';
import 'package:phraso/features/types_of_phrases/widgets/favourtie_tile.dart';
import 'package:phraso/features/types_of_phrases/widgets/search_phrases._BTN.dart';

import 'package:phraso/features/types_of_phrases/widgets/types_listview.dart';
import 'package:phraso/models/language_model.dart';

class TypesOfPhrases extends ConsumerWidget {
  final LanguageModel language;
  final String languageName;

  const TypesOfPhrases({
    Key? key,
    required this.language,
    required this.languageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              toolbarHeight: 50,
              floating: false,
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: const CustomBackButton(),
              backgroundColor: Color(int.parse(language.color)),
              expandedHeight: 260,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool isCollapsed =
                      constraints.maxHeight - kToolbarHeight - 60 <= 0;

                  return FlexibleSpaceBar(
                    title: isCollapsed ? Text("$languageName Phrases") : null,
                    background: SizedBox(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            cacheKey: language.id,
                            imageUrl: language.background,
                            fit: BoxFit.cover,
                            color: Colors.black54,
                            colorBlendMode: BlendMode.darken,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0)
                                .copyWith(left: 20, top: 130),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${language.languageName} Phrases",
                                  style: const TextStyle(
                                      fontSize: 35, color: sliverTextColor),
                                ),
                                Text(
                                  "${language.numberOfPhrases} phrases",
                                  style: const TextStyle(
                                      fontSize: 21, color: sliverTextColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            blockSpacing,
            SearchPhrases(languageName: languageName, langId: language.id),
            blockSpacing,
            Padding(
                padding: const EdgeInsets.all(8.0).copyWith(left: 20),
                child: const Text("Types of Phrases",
                    style: TextStyle(fontSize: 20))),
            smallSpacing,

            //** favourite tile spereted from main listview */
            FavouriteTile(languageName: languageName, langid: language.id),

            //** Main type Listview builder */
            TypesListView(
              languageName: languageName,
              langId: language.id,
            ),
          ],
        ),
      ),
    );
  }
}
