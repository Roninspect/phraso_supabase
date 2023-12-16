// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phraso/models/language_model.dart';

class FlagListViewBuilder extends ConsumerWidget {
  final LanguageModel languageModel;
  const FlagListViewBuilder({
    super.key,
    required this.languageModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 140,
      height: 52,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: languageModel.flags.length,
        reverse: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 5),
        itemBuilder: (context, index) => Center(
          child: CircleAvatar(
            radius: 17,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: CachedNetworkImageProvider(
                cacheKey: languageModel.flags[index].flag_url,
                  languageModel.flags[index].flag_url),
            ),
          ),
        ),
      ),
    );
  }
}
