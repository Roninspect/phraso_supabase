import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phraso/features/languages/provider/search_query_provider.dart';

class LanguageSearchField extends ConsumerStatefulWidget {
  const LanguageSearchField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LanguageSearchFieldState();
}

class _LanguageSearchFieldState extends ConsumerState<LanguageSearchField> {
  FocusNode focusNode = FocusNode();
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextField(
        autofocus: true,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: (value) {
          if (value.length >= 3) {
            if (_debounce != null) {
              _debounce!.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 800), () {
              ref
                  .read(searchQueryNotifierProvider.notifier)
                  .inputQuery(query: value);
            });
          }
        },
        onSubmitted: (value) {
          ref
              .read(searchQueryNotifierProvider.notifier)
              .inputQuery(query: value);
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Search 'Portuguese'",
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
