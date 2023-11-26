import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:phraso/core/colors/colors.dart';

import 'package:phraso/core/constants/spacings.dart';

import 'package:phraso/features/auth/provider/user_data_notifer.dart';
import 'package:phraso/features/languages/widgets/following_listview.dart';

import 'package:phraso/features/languages/widgets/language_listview.dart';
import 'package:phraso/features/languages/widgets/language_search.dart';

class Languagepage extends ConsumerWidget {
  const Languagepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName =
        ref.watch(userDataNotifierProvider.select((value) => value.username));

    final currentTime = DateTime.now();
    final currentHour = currentTime.hour;

    String greetingText;

    if (currentHour >= 4 && currentHour < 12) {
      greetingText = 'Good Morning,';
    } else if (currentHour >= 13 && currentHour < 19) {
      greetingText = 'Good Evening,';
    } else {
      greetingText = 'Good Night,';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        toolbarHeight: MediaQuery.of(context).size.height * 0.05,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingText,
                style: const TextStyle(fontSize: 20, color: greyColor),
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 20),
              ),
              blockSpacing,

              //* language searching

              const LanguageSearch(),
              blockSpacing,

              //* following languages

              const Text("Following", style: TextStyle(fontSize: 20)),

              smallSpacing,
              const FollowingListview(),
              blockSpacing,
              const Text("All language", style: TextStyle(fontSize: 20)),
              const AllLanguagelistView(),
              blockSpacing,
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5))],
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(
            side: BorderSide(
              width: 1.7,
            ),
          ),
          backgroundColor: orangeColor.withAlpha(245),
          elevation: 0,
          child:
              const Icon(MaterialCommunityIcons.translate, color: Colors.black),
          onPressed: () {},
        ),
      ),
    );
  }
}
