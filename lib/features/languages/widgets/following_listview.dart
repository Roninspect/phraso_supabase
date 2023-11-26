import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/language_tile.dart';
import '../../../core/helper/async_value_helper.dart';
import '../controller/language_controller.dart';

class FollowingListview extends ConsumerWidget {
  const FollowingListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 120,
      child: AsyncValueWidget(
        value: ref.watch(getFollowingLanguageProvider),
        data: (followings) {
          if (followings.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: followings.length,
              itemBuilder: (context, index) {
                final langId = followings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: LanguageTile(language: langId.languages),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Not Following Any Language"),
            );
          }
        },
      ),
    );
  }
}
