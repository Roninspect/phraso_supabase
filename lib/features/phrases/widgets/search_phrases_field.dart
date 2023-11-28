// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

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
  Timer? _debounce;
  TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: queryController,
      autofocus: true,

      //* value >= 3 will search it on every typed key
      onChanged: (value) {
        if (value.length >= 3) {
          if (_debounce != null) {
            _debounce!.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 800), () {
            ref
                .read(phraseSearchQueryNotifierProvider.notifier)
                .inputQuery(query: value.trim());
          });
        }
      },

      //* incase user taps on submit key in keyboard
      onSubmitted: (value) {
        ref
            .read(phraseSearchQueryNotifierProvider.notifier)
            .inputQuery(query: value.trim());
      },
      decoration: InputDecoration(
        //* when user taps on search icon
        suffixIcon: IconButton(
            onPressed: () {
              ref
                  .read(phraseSearchQueryNotifierProvider.notifier)
                  .inputQuery(query: queryController.text.trim());
            },
            icon: const Icon(Ionicons.search)),
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
