// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:phraso/core/common/alert_dialog.dart';
import 'package:phraso/core/common/custom_snackbar.dart';
import 'package:phraso/core/helper/async_value_helper.dart';
import 'package:phraso/features/languages/controller/language_controller.dart';
import 'package:phraso/features/languages/widgets/flag_Listview.dart';
import 'package:phraso/models/language_model.dart';
import 'package:phraso/router/router.dart';

class LanguageTile extends ConsumerWidget {
  final LanguageModel language;

  const LanguageTile({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(languageControllerProvider);
    final isFollowing = ref.watch(isFollowingAlreadyProvider(language.id));
    void followLanguage() {
      ref
          .read(languageControllerProvider.notifier)
          .followLanguage(langId: language.id, context: context, ref: ref);
    }

    void deleteFollowing() {
      ref
          .watch(languageControllerProvider.notifier)
          .deleteTheFollowing(langId: language.id, context: context, ref: ref);
    }

    return GestureDetector(
      onTap: () {
        final String languageName = language.languageName;
        context.pushNamed(AppRoutes.types_of_phrases.name,
            pathParameters: {"languageName": languageName}, extra: language);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(int.parse(language.color)),
            border: Border.all(width: 2.5),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(4, 4))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 190,
                    child: Text(
                      language.languageName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(int.parse(language.textColor))),
                    ),
                  ),
                  SizedBox(
                    width: 127,
                    child: Text(
                      "Phrases",
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(int.parse(language.textColor))),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isLoading
                      ? Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffFFBD12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black, offset: Offset(2, 2))
                              ]),
                          height: 35,
                          width: 71,
                          child: const Center(
                            child: Text(
                              "Loading",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ))
                      : isFollowing.when(
                          data: (isfollowings) {
                            if (!isfollowings) {
                              return InkWell(
                                onTap: () => followLanguage(),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xffFFBD12),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(2, 2))
                                        ]),
                                    height: 34,
                                    width: 71,
                                    child: const Center(
                                      child: Text(
                                        "Follow",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              );
                            } else {
                              return InkWell(
                                onTap: () => alertDialogBoxForLanguage(
                                  languageName: language.languageName,
                                  context: context,
                                  ifYes: () {
                                    deleteFollowing();
                                    context.pop();
                                  },
                                  ifNo: () => context.pop(),
                                ),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xffFFBD12),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(2, 2))
                                        ]),
                                    height: 35,
                                    width: 71,
                                    child: const Center(
                                      child: Text(
                                        "Following",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              );
                            }
                          },
                          error: (error, stackTrace) => showSnackbar(
                              context: context, text: "something went wrong"),
                          loading: () => Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFBD12),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(2, 2))
                                  ]),
                              height: 35,
                              width: 71,
                              child: const Center(
                                child: Text(
                                  "Loading",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),

                  const SizedBox(height: 10),

                  // //* langugae Listvew builder
                  FlagListViewBuilder(
                    languageModel: language,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
