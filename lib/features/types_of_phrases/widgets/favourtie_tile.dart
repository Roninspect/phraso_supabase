// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/features/phrases/pages/favourite_phrase_page.dart';

class FavouriteTile extends ConsumerWidget {
  final String languageName;
  final String langid;
  const FavouriteTile({
    super.key,
    required this.languageName,
    required this.langid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 12.0).copyWith(bottom: 10),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FavouritePhrasePage(
            langName: languageName,
            langId: langid,
          ),
        )),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        leading: const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        tileColor: Colors.white,
        title: const Text("Favourites"),
      ),
    );
  }
}
