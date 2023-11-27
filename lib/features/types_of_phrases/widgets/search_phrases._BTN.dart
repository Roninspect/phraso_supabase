// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:phraso/router/router.dart';

class SearchPhrases extends ConsumerStatefulWidget {
  final String languageName;
  const SearchPhrases({
    super.key,
    required this.languageName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPhrasesState();
}

class _SearchPhrasesState extends ConsumerState<SearchPhrases> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        onTap: () => context.pushNamed(AppRoutes.phraseSearch.name,
            pathParameters: {'languageName': widget.languageName}),
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: Icon(Ionicons.search),
          fillColor: Colors.white,
          filled: true,
          hintText: "Search Phrases",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
