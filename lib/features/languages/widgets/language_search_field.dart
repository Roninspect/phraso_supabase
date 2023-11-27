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
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: (value) {
          if (_debounce != null) {
            _debounce!.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 800), () {
            ref
                .read(searchQueryNotifierProvider.notifier)
                .inputQuery(query: value);
          });
        },
        onEditingComplete: () {},
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "(country name, language name)",
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
