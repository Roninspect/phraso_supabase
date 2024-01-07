import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:phraso/core/colors/colors.dart';

import 'package:phraso/core/constants/spacings.dart';
import 'package:phraso/core/helper/connection_notifier.dart';

import 'package:phraso/features/auth/provider/user_data_notifer.dart';
import 'package:phraso/features/languages/data/local/local_language_repository.dart';
import 'package:phraso/features/languages/widgets/following_listview.dart';

import 'package:phraso/features/languages/widgets/language_listview.dart';
import 'package:phraso/features/languages/widgets/language_search_BTN.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class Languagepage extends ConsumerStatefulWidget {
  const Languagepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguagepageState();
}

class _LanguagepageState extends ConsumerState<Languagepage>
    with AutomaticKeepAliveClientMixin<Languagepage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        toolbarHeight: MediaQuery.of(context).size.height * 0.02,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async =>
                    await supabase.Supabase.instance.client.auth.signOut(),
                child: ref.watch(getLocalVersionProvider).when(
                      data: (version) {
                        print(version);
                        return Text(
                          version.langVersion.toString(),
                          style:
                              const TextStyle(fontSize: 20, color: greyColor),
                        );
                      },
                      error: (error, stackTrace) {
                        print(stackTrace);
                        return Text(
                          error.toString(),
                        );
                      },
                      loading: () => CircularProgressIndicator(),
                    ),
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 20),
              ),
              blockSpacing,

              //* language searching

              const LanguageSearchButton(),
              blockSpacing,

              //* following languages
              const FollowingListview(),
              blockSpacing,

              //* ALl languages
              const Text("All languages", style: TextStyle(fontSize: 20)),
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
