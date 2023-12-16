import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/core/constants/spacings.dart';

import 'language_tile.dart';
import '../../../core/helper/async_value_helper.dart';
import '../controller/language_controller.dart';

class FollowingListview extends ConsumerWidget {
  const FollowingListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(getFollowingLanguageProvider),
      data: (followings) {
        if (followings.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Following", style: TextStyle(fontSize: 20)),
              smallSpacing,
              SizedBox(
                height: 120,
                child: ListView.builder(
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
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
