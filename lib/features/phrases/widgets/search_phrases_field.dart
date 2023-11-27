// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:phraso/features/phrases/providers/search_query_provider.dart';

class SearchPhrasesField extends ConsumerStatefulWidget {
  const SearchPhrasesField({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchPhrasesFieldState();
}

class _SearchPhrasesFieldState extends ConsumerState<SearchPhrasesField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        ref
            .read(phraseSearchQueryNotifierProvider.notifier)
            .inputQuery(query: value.trim());
      },
      decoration: InputDecoration(
        suffixIcon: const Icon(Ionicons.search),
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
    );
  }
}
