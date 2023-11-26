import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSearch extends ConsumerStatefulWidget {
  const LanguageSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguageSearchState();
}

class _LanguageSearchState extends ConsumerState<LanguageSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        onTap: () {},
        readOnly: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Search Preferred language",
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
